component{
	public any function init(rcF,rcU){
	}
	 
	public any function admin(rcU,rcF){
		//get form and url vars
        local.rcForm=arguments.rcF;
        local.rcURL=arguments.rcU;
        local.controllerContent = arrayNew(1);
        local.controllerContent[1]={};
        local.temp = '';
	    local.errMsg='';
        //used locally, don't want to pass to layout so using 'this.'
        this.viewPath='';
        this.headerPath='';
       	if(isDefined('url.sec')){
       		session.pagesSec = url.sec;
       	}
    	switch(session.pagesSec){
    		case "1":
		       	local.metaTitle="System Page Administration";
				break;
			case "2":
       			local.metaTitle="System Page Administration";
				break;
			default:
		       	local.metaTitle="Static Page Administration";
    	}
        
        //set up region 4
        //set div CSS ID
        local.controllerContent[1].cssID='defaultPageAdminRegion';
        //set the region
        local.controllerContent[1].regionID=4;
        //set the content
        if(isDefined('local.rcURL.r4') && isNumeric(local.rcURL.r3)){ //CRUD
        	switch(lcase(local.rcURL.r4)){
                case "process":
                	if(!adminProcess(local.rcForm)){
                        savecontent variable="local.temp"{
                            writeOutput(adminManage(rcF=local.rcForm));
                        }                    	
                    }
                    break;
                case "delete":
                	adminDelete(local.rcURL.r3);
                    break;
           		default:
                    savecontent variable="local.temp"{
                    	writeOutput(adminManage(local.rcURL.r3));
                    }
           	}
        }
        else if(isDefined('local.rcURL.r3') && isNumeric(local.rcURL.r3)){ //MANAGE
            savecontent variable="local.temp"{
                writeOutput(adminManage(local.rcURL.r3));
            }			
        }
        else{ //DISPLAY LIST
            savecontent variable="local.temp"{
				writeOutput(adminList());
            }
        }
        //had issues with variable name in the savecontent call so made a temp var
        local.controllerContent[1].txt = local.temp & local.errMsg;
        
    	return local;
	}

	/*<!--- /////   _ADMIN LIST  ///// --->*/
    private any function adminList(){
    	switch(session.pagesSec){
    		case "1":
				local.obj = entityLoad("StaticPages",{parentURL='admin',isDeleted=false},"orderby");
		        local.regionHead = "Admin Pages: All";
				break;
			case "2":
				local.obj = entityLoad("StaticPages",{parentURL='',isDeleted=false},"orderby");
		        local.regionHead = "System Pages: All";
				break;
			default:
				local.obj = entityLoad("StaticPages",{parentURL='index',isDeleted=false},"orderby");
		        local.regionHead = "Static Pages: All";
    	}
    	
        savecontent variable="local.temp"{
	        include "#application.baseEPath#/views/staticPages/admin_dsp_list.cfm";
        }
        
        return local.temp;
    }
    
	/*<!--- /////   _ADMIN DELETE  ///// --->*/
    private any function adminDelete(id){
        local.processMsg = 'Page deleted successfully.';
        try{
			local.obj = entityLoadByPk("StaticPages",arguments.id);

			// reorder the rest of the questions
            reorder(local.obj.getParentURL(),local.obj.getOrderby(),0);
            
            /* Don't really delete an entity, mark is as isDeleted=1*/
            local.obj.setIsDeleted(true);
  
			/*FILE INFO*/
			theFile = '#local.obj.getPageURL()#.html';
			sourceFile = expandPath('/#theFile#');
			destinationFile = expandPath('/archives/#theFile#.#dateformat(now(),'yyyymmdd')##timeformat(now(),'hhmmss')#');
			
			/* BACKUP EXISTING */
			if(fileExists(sourceFile)){
				fileMove(sourceFile,destinationFile);
			}

			/*CREATE MAIN NAV JS FILE*/
			js = new controllers.createMainNav(local.obj);	

  	        location("#application.baseEPath#/?staticPages/admin/&msg=#local.processMsg#",false);
        }
        catch(Any e){
	        local.processMsg = 'An error occurred. The page WAS NOT deleted.';
	        location("#application.baseEPath#/?staticPages/admin/&msg=#local.processMsg#",false);
        }
    }
    
	/*<!--- /////   _ADMIN PROCESS  ///// --->*/
    private any function adminProcess(rcF){
    	local.rcF = arguments.rcF;

        local.processMsg = 'Page updated successfully.';
		local.obj = entityLoadByPK("StaticPages",local.rcF.id);
		/*array to hold regions*/
		local. regions = arrayNew(1);
		/*create 5 empty spots so we can put regions in correct order*/
		arraySet(local.regions,1,5,"");

		/*get regions*/
		for(i=1; i LTE listLen(local.rcF.fieldnames); i++){
			if(lcase(listFirst(listGetAt(local.rcF.fieldnames,i),'_')) eq 'region'){
				thisField = listGetAt(local.rcF.fieldnames,i);
				thisRegID  = listGetAt(listGetAt(local.rcF.fieldnames,i),2,'_');
				thisOrderby = listLast(listGetAt(local.rcF.fieldnames,i),'_');
				thisVal = form[thisField];

				local.regObj = entityLoadByPK("PageRegion",thisRegID);
				if(isNumeric(thisOrderby)){ // orderby
					local.regObj.setOrderby(thisOrderby);
					/*place region into correct order in array*/
					local.regions[thisOrderby]=local.regObj;
					local.regObj.setRegionText(thisVal);
					if(isDefined('local.rcF["region_#thisOrderby#_box"]')){
						local.regObj.setIsActive(1);
					}
					else{
						local.regObj.setIsActive(0);
					}
				}
				else{ // title
					if(lcase(thisOrderBy) eq 'title'){
						local.regObj.setRegionName(thisVal);
					}
				}
			}
		}		

		/*add region array to page obj*/
		local.obj.setRegions(local.regions);
		
		/*get layout*/
		local.layoutObj = entityLoadByPK("Layouts",local.rcF.layoutid);
		local.obj.setPageLayout(local.layoutObj);

       	/*set page data*/
        local.obj.setMetaTitle(local.rcF.metaTitle);
        local.obj.setMetadesc(local.rcF.metadesc);
        local.obj.setMetakeywords(local.rcF.metakeywords);
        local.obj.setLinkText(local.rcF.linkText);
        local.obj.setPageName(local.rcF.pageName);
        local.obj.setPageURL(local.rcF.pageURL);
        local.obj.setParentURL(lcase(local.rcF.parentURL));
        local.obj.setIsActive(local.rcF.isActive);

        try{
	        entitySave(local.obj);
	        //reorder other entries
	        reorder(local.obj.getParentURL(),local.obj.getOrderby(),local.rcF.orderby);

			//set new orderby and save
	        local.obj.setOrderby(local.rcF.orderby);
	        entitySave(local.obj);
	        ormFlush();
        }        
        catch(Any e){
			writedump(e); abort;
        	return false;
        }
        
        try{ /*if this is a front end page, create html file*/
        //	if(lcase(local.rcF.parentURL) eq 'index'){
				/* GET CONTROLLER */
				/* this should work with sections. Just need to get controller somehow.
				rcU = {};
				request.rc = createObject('controllers.login').init(rcF,rcU)
				*/
				
	        	/* CREATE THE PAGE*/
	        	pageContent = createObject('com.Page').init('/layouts/#local.obj.getPageLayout().getLayoutName()#.cfm',local.obj);				
					
				/*FILE INFO*/
				theFile = '#local.rcF.pageURL#.html';
				sourceFile = expandPath('/#theFile#');
				destinationFile = expandPath('/archives/#theFile#.#dateformat(now(),'yyyymmdd')##timeformat(now(),'hhmmss')#');
			
				/* BACKUP EXISTING */
				if(fileExists(sourceFile)){
					fileMove(sourceFile,destinationFile);
				}

				/*CREATE NEW HTML FILE*/
				fileWrite(sourceFile,pageContent);        
				
				/*CREATE MAIN NAV JS FILE*/
				js = new controllers.createMainNav(local.obj);	
        //	}
        }catch(Any e){
        	writeDump(e); abort;
        }
        location("#application.baseEPath#/?staticPages/admin/&msg=#local.processMsg#",false);
    }
    
	/*<!--- /////   _ADMIN MANAGE  ///// --->*/
    private any function adminManage(id,rcF){
    	if(isDefined('arguments.id')){
	    	local.id = arguments.id;
        }
    	else if(isDefined('rcF.id')){
	    	local.id = rcF.id;
            local.rcF = arguments.rcF;
        }
        else{
	    	local.id = 0;
        }

        //isActive form values
		local.ary = arrayNew(1);
		local.ary[1]={optValue='1',optText='Yes (page is currently active)'};
		local.ary[2]={optValue='0',optText='No (page is NOT currently active)'};

        //Regions form values
		local.regionAry = arrayNew(1);
		local.regionAry[1]={optValue='1',optText='Yes, include this region on this page'};

		//Region heading
        local.regionHead = '';
                
        //Create form builder object
        local.fbObj = new com.formBuilder();

    	if(local.id){
        	local.obj = entityLoadByPk("StaticPages",local.id);
			for(i=1; i LTE arrayLen(local.obj.getRegions()); i++){
				r = "Region#i#";
				'#r#' = entityLoadByPk("PageRegion",local.obj.getRegions()[i].getId());
			}
        }
        else{
			local.layoutObj = entityLoadByPK("Layouts",1);
			topBannerRegion = entityLoadByPK("PageRegionType",1);
			leftColRegion = entityLoadByPK("PageRegionType",2);
			rightColRegion = entityLoadByPK("PageRegionType",3);
			defaultRegion = entityLoadByPK("PageRegionType",4);
			bottomBannerRegion = entityLoadByPK("PageRegionType",5);
        	Region1 = new com.PageRegion(isActive=true,regionText='This is the top area.',regionType=topBannerRegion,regionName="Top Banner");
        	Region2 = new com.PageRegion(isActive=true,regionText='This is the left column.',regionType=leftColRegion,regionName="Left Column");
        	Region3 = new com.PageRegion(isActive=true,regionText='This is the right column.',regionType=rightColRegion,regionName="Right Column");
	        Region4 = new com.PageRegion(isActive=true,regionText='This is the default content region.',regionType=defaultRegion,regionName="Default Content Region");
	        Region5 = new com.PageRegion(isActive=true,regionText='This is the bottom area.',regionType=bottomBannerRegion,regionName="Bottom Banner");
        	local.obj = new com.StaticPages(pageName="",pageURL="",parentURL="index",linkText="",orderby=1,metaTitle="",isActive=true,pageLayout=local.layoutObj);
        	local.obj.setRegions([Region1,Region2,Region3,Region4,Region5]);

            if(isDefined('local.rcF.metaTitle')){ //it came from form so reload form values
		        local.obj.setMetaTitle(local.rcF.metaTitle);
		        local.obj.setMetadesc(local.rcF.metadesc);
		        local.obj.setMetakeywords(local.rcF.metakeywords);
		        local.obj.setLinkText(local.rcF.linkText);
		        local.obj.setPageName(local.rcF.pageName);
		        local.obj.setPageURL(local.rcF.pageURL);
		        local.obj.setParentURL(local.rcF.parentURL);
		        local.obj.setOrderby(local.rcF.orderby);
		        local.obj.setIsActive(local.rcF.isActive);
                local.errMsg = 'Please check your information for errors and re-submit.';
            }
        	entitySave(local.obj);
        }

        //double check for an object
        if(isNull(local.obj)){
        	local.obj = entityNew("StaticPages");
        }

    	switch(session.pagesSec){
    		case "1":
				local.parSec = 'admin';
				break;
			case "2":
				local.parSec = '';
				break;
			default:
				local.parSec = 'index';
    	}

		//create query for orderby drop down menu
        local.orderbyArray = arrayNew(1);
        pageCount = ORMExecuteQuery("SELECT COUNT(*) FROM StaticPages as sp WHERE sp.isDeleted=:isDel AND parentURL=:par",{isDel=0, par=local.parSec},true);
        try{
            for(i=1; i LTE pageCount; i++){
	        	local.orderbyArray[i]={optValue=i,optText=i};            
            }
        } catch(Any e){
        	local.orderbyArray[1]={optValue='1',optText='1'};
        }
        //get Selected value
        if(isDefined('local.rcF.orderby')){
        	local.oSelectedID = local.rcF.orderby;
        }
        else if(!isNull(local.obj.getOrderby())){
        	local.oSelectedID = local.obj.getOrderby();
        }
        else{
        	local.oSelectedID = 0;
        }

		//create drop down menu for layouts
        local.layoutArray = arrayNew(1);
        layoutQry = ORMExecuteQuery("SELECT id, layoutName FROM Layouts WHERE isDeleted=0 AND isActive=1 ORDER BY layoutName");
        for(i=1; i LTE arrayLen(layoutQry); i++){
        	local.layoutArray[i]={optValue=layoutQry[i][1],optText=layoutQry[i][2]};
        }
        //get Selected value
        if(isDefined('local.rcF.layoutID')){
        	local.lSelectedID = local.rcF.layoutID;
        }
        else if(!isNull(local.obj.getPageLayout().getID())){
        	local.lSelectedID = local.obj.getPageLayout().getID();
        }
        else{
        	local.lSelectedID = 0;
        }

        local.regionHead = local.obj.getID() gt 0? "Page: #local.obj.getPageName()#": "Pages: Add a New Page";
        savecontent variable="local.temp"{
	        include "#application.baseEPath#/views/staticPages/admin_dsp_manage.cfm";
        }
        
        return local.temp;
    }
    
	/*<!--- /////   _REORDER  ///// --->*/
    private void function reorder(parent,oldPosition,newPosition){
    	local.parent = arguments.parent;
    	local.oldP = arguments.oldPosition;
        local.newP = arguments.newPosition;

		if( local.oldP EQ 0 ){
        	// new record: +1 to orderby to all positions past where new one is going
            hql="UPDATE StaticPages SET orderby = orderby+1 WHERE orderby >= #local.newP# and parentURL = '#local.parent#'";            
        }
        else if( local.newP EQ 0 ){
        	// delete a record: -1 to orderby to all positions past the one being deleted
            hql="UPDATE StaticPages SET orderby = orderby-1 WHERE orderby > #local.oldP# and parentURL = '#local.parent#'";
        }
        else if( local.oldP GTE local.newP ){
        	// move up in list: +1 to orderby for all records after newP and before oldP
            hql="UPDATE StaticPages SET orderby = orderby+1 WHERE orderby >= #local.newP# AND orderby < #local.oldP# and parentURL = '#local.parent#'";
        }
        else if( local.oldP LT local.newP ){
        	// move down in list: -1 to orderby for all records after oldP and before newP
            hql="UPDATE StaticPages SET orderby = orderby-1 WHERE orderby > #local.oldP# AND orderby <= #local.newP# and parentURL = '#local.parent#'";
        }
        ormExecuteQuery(hql);
    }
}