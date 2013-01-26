component{
	public any function init(rcF='',rcU=''){
		//get form and url vars
        local.rcForm=arguments.rcF;
        local.rcURL=arguments.rcU;
        local.controllerContent = arrayNew(1);
        local.controllerContent[1]={}; //add another for each region you want to override
        local.controllerContent[2]={}; //add another for each region you want to override
        local.temp = '';
	    local.errMsg='';
        //used locally, don't want to pass to layout so using 'this.'
        this.viewPath='';
        this.headerPath='';
       	local.metaTitle="Employees";
        
    	//if ID in url, set up employee
        if(isDefined('local.rcURL.r2')){
        	try{
            	//load info
                local.Obj = entityLoadByPK('Employee',local.rcURL.r2);
                //override page metatitle
	        	local.metaTitle=local.dObj.getFirstName();
                //display list to go in region 4 on page 
                this.viewPath='/#application.baseEPath#/views/employees/dsp_detail.cfm';
            }
            catch(Any e){ //catch non-numeric IDs
            	local.errMsg = '<p class="red">Sorry, that employee could not be located. Please contact your administrator.</p>';
            }
        }
        else{
        	try{
            	//load all employees info
                local.Obj = entityLoad('Employee',{isActive=true,isDeleted=false},'lastName ASC, firstName ASC');
                //list goes in region 4 on page
                this.viewPath='/#application.baseEPath#/views/employees/dsp_list.cfm';
            }
            catch(Any e){ //
            	local.errMsg = '<p class="red">Sorry, a technical error occurred. Please contact your administrator.</p>';
            }
        }
        
        //set up region 2 (more regions can be set up using local.controllerContent[n], just make sure to add them above too.)
        //set div CSS ID
        local.controllerContent[1].cssID='leftDepartmentRegion';
        //set the region
        local.controllerContent[1].regionID=2;
        //set the content
		depts = new controllers.department();
       	savecontent variable="local.temp"{
			writeOutput('<ul>');
			for(i=1; i LTE arrayLen(depts.obj); i++){
				writeOutput('<li><a href="/?department/#depts.obj[i].getID()#">#depts.obj[i].getDepartmentName()#</a></li>');
			}
			writeOutput('</ul>');
        }
        //had issues with variable name in the savecontent call so made a temp var
        local.controllerContent[1].txt = local.temp & local.errMsg;

        //set up region 4 (more regions can be set up using local.controllerContent[n], just make sure to add them above too.)
        //set div CSS ID
        local.controllerContent[2].cssID='defaultEmployeeRegion';
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
       	local.metaTitle="Employee Administration";

        //set up region 4
        //set div CSS ID
        local.controllerContent[1].cssID='defaultEmployeeAdminRegion';
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
		local.obj = entityLoad("Employee",{isDeleted=false},"lastName ASC, firstName ASC");
        local.regionHead = "Employees: All";
        savecontent variable="local.temp"{
	        include "#application.baseEPath#/views/employees/admin_dsp_list.cfm";
        }
        
        return local.temp;
    }
    
	/*<!--- /////   _ADMIN DELETE  ///// --->*/
    private any function adminDelete(id){
        local.processMsg = 'Employee deleted successfully.';
        try{
			local.obj = entityLoadByPk("Employee",arguments.id);
	        entityDelete(local.obj);
	        location("#application.baseEPath#/?employee/admin/&msg=#local.processMsg#",false);
        }
        catch(Any e){
	        local.processMsg = 'An error occurred. The employee WAS NOT deleted.';
	        location("#application.baseEPath#/?employee/admin/&msg=#local.processMsg#",false);
        }
    }
    
	/*<!--- /////   _ADMIN PROCESS  ///// --->*/
    private any function adminProcess(rcF){
    	local.rcF = arguments.rcF;
    
    	if(local.rcF.id){
            local.processMsg = 'Employee updated successfully.';
			local.obj = entityLoadByPK("Employee",local.rcF.id);
        }
        else{
            local.processMsg = 'Employee added successfully.';
			local.obj = entityNew("Employee");
       	}
        local.obj.setFirstName(local.rcF.firstName);
        local.obj.setLastName(local.rcF.lastName);
        local.obj.setIsActive(local.rcF.isActive);
		
        try{
	        entitySave(local.obj);
	        ormFlush();
	        
	        pageObj = entityLoadByPK("StaticPages","10");
			rcU = {};
			new controllers.createHTMLFile(pageObj,rcF,rcU);
	        
	        location("#application.baseEPath#/?employee/admin/&msg=#local.processMsg#",false);
        }
        catch(Any e){
			writeDump(e); abort;
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
		local.ary[1]={optValue='1',optText='Yes (employee is currently active)'};
		local.ary[2]={optValue='0',optText='No (employee is NOT currently active)'};

		//Region heading
        local.regionHead = '';
                
        //Create form builder object
        local.fbObj = new com.formBuilder();

    	if(local.id){
        	local.obj = entityLoadByPk("Employee",local.id);
        }
        else{
        	local.obj = entityNew("Employee");
            if(isDefined('local.rcF.firstName')){ //it came from form so reload form values
            	local.obj.setFirstName(local.rcF.firstName);
            	local.obj.setLastName(local.rcF.lastName);
                local.obj.setIsActive(local.rcF.isActive);
                local.errMsg = 'Please check your information for errors and re-submit.';
            }
        }
        
        //double check for an object
        if(isNull(local.obj)){
        	local.obj = entityNew("Employee");
        }

        local.regionHead = local.obj.getID() gt 0? "Employee: #local.obj.getFirstName()#": "Employees: Add a New Employee";
        savecontent variable="local.temp"{
	        include "#application.baseEPath#/views/employees/admin_dsp_manage.cfm";
        }
        
        return local.temp;
    }
}