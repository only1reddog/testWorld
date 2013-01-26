component{
	public any function init(rcF='',rcU=''){
		//get form and url vars
        local.rcForm=arguments.rcF;
        local.rcURL=arguments.rcU;
        local.controllerContent = arrayNew(1);
        local.controllerContent[1]={}; //add another for each region you want to override
        local.temp = '';
	    local.errMsg='';
        //used locally, don't want to pass to layout so using 'this.'
        this.viewPath='';
        this.headerPath='';
       	local.metaTitle="Departments";
        
    	//if userID in url, set up department
        if(isDefined('local.rcURL.r2')){
        	try{
            	//load info
                local.Obj = entityLoadByPK('Department',local.rcURL.r2);
                //override page metatitle
	        	local.metaTitle=local.Obj.getDepartmentName();
                //display list of users go in region 4 on page 
                this.viewPath='/#application.baseEPath#/views/departments/dsp_detail.cfm';
            }
            catch(Any e){ //catch non-numeric IDs
            	local.errMsg = '<p class="red">Sorry, that department could not be located. Please contact your administrator.</p>';
            }
        }
        else{
        	try{
            	//load all departments info
                local.Obj = entityLoad('Department',{isActive=true,isDeleted=false},'departmentName ASC');
                //list goes in region 4 on page
                this.viewPath='/#application.baseEPath#/views/departments/dsp_list.cfm';
            }
            catch(Any e){ //
            	local.errMsg = '<p class="red">Sorry, a technical error occurred. Please contact your administrator.</p>';
            }
        }
        
        //set up region 4 (more regions can be set up using local.controllerContent[n], just make sure to add them above too.)
        //set div CSS ID
        local.controllerContent[1].cssID='defaultDepartmentRegion';
        //set the region
        local.controllerContent[1].regionID=4;
        //set the content
       	savecontent variable="local.temp"{
            if(len(this.viewPath)){
	            include this.viewPath;
            }
        }
        //had issues with variable name in the savecontent call so made a temp var
        local.controllerContent[1].txt = local.temp & local.errMsg;
        
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
       	local.metaTitle="Department Administration";
        
        //set up region 4
        //set div CSS ID
        local.controllerContent[1].cssID='defaultDepartmentAdminRegion';
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
		local.obj = entityLoad("Department",{isDeleted=false},"departmentName ASC");
        local.regionHead = "Departments: All";
        savecontent variable="local.temp"{
	        include "#application.baseEPath#/views/departments/admin_dsp_list.cfm";
        }
        
        return local.temp;
    }
    
	/*<!--- /////   _ADMIN DELETE  ///// --->*/
    private any function adminDelete(id){
        local.processMsg = 'Department deleted successfully.';
        try{
			local.obj = entityLoadByPk("Department",arguments.id);
	        entityDelete(local.obj);
	        flushORM();
	        
	        //TODO update department page static HTML
	        
	        location("#application.baseEPath#/?department/admin/&msg=#local.processMsg#",false);
        }
        catch(Any e){
	        local.processMsg = 'An error occurred. The department WAS NOT deleted.';
	        location("#application.baseEPath#/?department/admin/&msg=#local.processMsg#",false);
        }
    }
    
	/*<!--- /////   _ADMIN PROCESS  ///// --->*/
    private any function adminProcess(rcF){
    	local.rcF = arguments.rcF;
    
    	if(local.rcF.id){
            local.processMsg = 'Department updated successfully.';
			local.obj = entityLoadByPK("Department",local.rcF.id);
        }
        else{
            local.processMsg = 'Department added successfully.';
			local.obj = entityNew("Department");
       	}
        local.obj.setDepartmentName(local.rcF.DepartmentName);
        local.obj.setIsActive(local.rcF.isActive);
		
        try{
	        entitySave(local.obj);
   	        ormFlush();

//TODO along with creating a deparment page, create a department details page based on department name... human_resources.html
//TODO add department and employees to donotrun.cfm so we get a constant staticPageID, then update here and in employee.cfc
	        pageObj = entityLoadByPK("StaticPages","9");
			rcU = {};
			new controllers.createHTMLFile(pageObj,rcF,rcU);
	        
	        location("#application.baseEPath#/?department/admin/&msg=#local.processMsg#",false);
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
		local.ary[1]={optValue='1',optText='Yes (department is currently active)'};
		local.ary[2]={optValue='0',optText='No (department is NOT currently active)'};

		//Region heading
        local.regionHead = '';
                
        //Create form builder object
        local.fbObj = new com.formBuilder();

    	if(local.id){
        	local.obj = entityLoadByPk("Department",local.id);
        }
        else{
        	local.obj = entityNew("Department");
            if(isDefined('local.rcF.departmentName')){ //it came from form so reload form values
            	local.obj.setDepartmentName(local.rcF.departmentName);
                local.obj.setIsActive(local.rcF.isActive);
                local.errMsg = 'Please check your information for errors and re-submit.';
            }
        }
        
        //double check for an object
        if(isNull(local.obj)){
        	local.obj = entityNew("Department");
        }

        local.regionHead = local.obj.getID() gt 0? "Department: #local.obj.getDepartmentName()#": "Departments: Add a New Department";
        savecontent variable="local.temp"{
	        include "#application.baseEPath#/views/departments/admin_dsp_manage.cfm";
        }
        
        return local.temp;
    }
}