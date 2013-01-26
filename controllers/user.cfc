component{
	public any function init(rcF,rcU){
		//get form and url vars
        local.rcForm=arguments.rcF;
        local.rcURL=arguments.rcU;
        local.controllerContent = arrayNew(1);
        local.controllerContent[1]={};
        local.controllerContent[2]={};
        local.temp = '';
	    local.errMsg='';
        //used locally, don't want to pass to layout so using 'this.'
        this.viewPath='';
        this.headerPath='';
       	local.metaTitle="Users";
        
    	//if userID in url, set up user
        if(isDefined('local.rcURL.r2')){
        	try{
            	//load user info
                local.uObj = entityLoadByPK('AppUser',local.rcURL.r2);
                //override page metatitle
	        	local.metaTitle=local.uObj.getFirstName() & ' ' & local.uObj.getLastName();
                //user meta info goes in region 1 on page
                this.headerPath='/#application.baseEPath#/views/users/dsp_detailIntro.cfm';
                //display list of users go in region 4 on page 
                this.viewPath='/#application.baseEPath#/views/users/dsp_detail.cfm';
            }
            catch(Any e){ //catch non-numeric user IDs
            	local.errMsg = '<p class="red">Sorry, that user could not be located. Please contact your administrator.</p>';
            }
        }
        else{
        	try{
            	//load all users info
                local.uObj = entityLoad('AppUser',{role=2,isActive=true,isDeleted=false},'lastName ASC, firstName ASC');
                //user list intro in region 1 on page
                this.headerPath='/#application.baseEPath#/views/users/dsp_listIntro.cfm';
                //user list goes in region 4 on page
                this.viewPath='/#application.baseEPath#/views/users/dsp_list.cfm';
            }
            catch(Any e){ //
            	local.errMsg = '<p class="red">Sorry, a technical error occurred. Please contact your administrator.</p>';
            }
        }
        
        //set up region 1
        //set div CSS ID
        local.controllerContent[1].cssID='headUserRegion';
        //set the region
        local.controllerContent[1].regionID=1;
        //set the content
       	savecontent variable="local.temp"{
            if(len(this.headerPath)){
	            include this.headerPath;
            }
        }
        //had issues with variable name in the savecontent call so made a temp var
        local.controllerContent[1].txt = local.temp;
        
        //set up region 4
        //set div CSS ID
        local.controllerContent[2].cssID='defaultUserRegion';
        //set the region
        local.controllerContent[2].regionID=4;
        //set the content
       	savecontent variable="local.temp"{
            if(len(this.viewPath)){
	            include this.viewPath;
            }
        }
        //had issues with variable name in the savecontent call so made a temp var
        local.controllerContent[2].txt = local.temp & local.errMsg;
        
    	return local;
    }
    
    
	/*<!--- /////   ADMIN  ///// --->*/
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
       	local.metaTitle="User Administration";
        
        //set up region 4
        //set div CSS ID
        local.controllerContent[1].cssID='defaultUserAdminRegion';
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
		local.obj = entityLoad("AppUser",{role=0,isDeleted=false},"lastName ASC, firstName ASC");
        local.regionHead = "Administrators: All";
        savecontent variable="local.temp"{
	        include "#application.baseEPath#/views/users/admin_dsp_list.cfm";
        }
        
        return local.temp;
    }
    
	/*<!--- /////   _ADMIN DELETE  ///// --->*/
    private any function adminDelete(id){
        local.processMsg = 'User deleted successfully.';
        try{
			local.obj = entityLoadByPk("AppUser",arguments.id);
	        entityDelete(local.obj);
	        location("#application.baseEPath#/?user/admin/&msg=#local.processMsg#",false);
        }
        catch(Any e){
	        local.processMsg = 'An error occurred. The user WAS NOT deleted.';
	        location("#application.baseEPath#/?user/admin/&msg=#local.processMsg#",false);
        }
    }
    
	/*<!--- /////   _ADMIN PROCESS  ///// --->*/
    private any function adminProcess(rcF){
    	local.rcF = arguments.rcF;
    
    	if(local.rcF.id){
            local.processMsg = 'Administrator updated successfully.';
			local.obj = entityLoadByPK("AppUser",local.rcF.id);
        }
        else{
            local.processMsg = 'Administrator added successfully.';
			local.obj = entityNew("AppUser");
            local.obj.setRole(0);
       	}
        local.obj.setFirstName(local.rcF.firstName);
        local.obj.setLastName(local.rcF.lastName);
        local.obj.setIsActive(local.rcF.isActive);
        local.obj.setUserName(local.rcF.userName);
        local.obj.setEmpEmail(local.rcF.empEmail);
		
        try{
	        entitySave(local.obj);
	        location("#application.baseEPath#/?user/admin/&msg=#local.processMsg#",false);
        }
        catch(Any e){
        	return false;
        }
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
		local.ary[1]={optValue='1',optText='Yes (administrator is currently active)'};
		local.ary[2]={optValue='0',optText='No (administrator is NOT currently active)'};

		//Region heading
        local.regionHead = '';
                
        //Create form builder object
        local.fbObj = new com.formBuilder();

    	if(local.id){
        	local.obj = entityLoadByPk("AppUser",local.id);
        }
        else{
        	local.obj = entityNew("AppUser");
            local.obj.setRole(2);
            if(isDefined('local.rcF.lastName')){ //it came from form so reload form values
            	local.obj.setFirstName(local.rcF.firstName);
            	local.obj.setLastName(local.rcF.lastName);
            	local.obj.setEmpNo(local.rcF.empNo);
            	local.obj.setEmpEmail(local.rcF.empEmail);
                local.obj.setIsActive(local.rcF.isActive);
                local.errMsg = 'Please check your information for errors and re-submit.';
            }
        }
        
        //double check for an object
        if(isNull(local.obj)){
        	local.obj = entityNew("AppUser");
            local.obj.setRole(2);
        }

        local.regionHead = local.obj.getID() gt 0? "Administrator: #local.obj.getFirstName()# #local.obj.getLastName()#": "Administrators: Add a New Administrator";
        savecontent variable="local.temp"{
	        include "#application.baseEPath#/views/users/admin_dsp_manage.cfm";
        }
        
        return local.temp;
    }
}