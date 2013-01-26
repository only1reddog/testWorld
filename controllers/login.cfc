component{
	public any function init(rcF,rcU){
		//get form and url vars
        local.rcForm=arguments.rcF;
        local.rcURL=arguments.rcU;
        local.controllerContent = arrayNew(1);
        local.controllerContent[1]={};
        local.temp = '';
	    local.errMsg='';
        //used locally, don't want to pass to layout so using 'this.'
        this.viewPath='#application.baseEPath#/views/forms/login.cfm';
        this.headerPath='';
       	local.metaTitle="Login";
        //set returnpath
        if(isDefined('local.rcURL.returnpath')){
        	this.returnpath = local.rcURL.returnpath;
        }

    	//if no user
        if(isDefined('rcF.username')){
        	if(!_userCheck(rcF)){
            	local.errMsg = '<p class="red">Sorry, that user could not be located. Please try again or contact your administrator.</p>';
            }
        }
        //Create form builder object
        local.fbObj = new com.formBuilder();
        
        //set up region 4
        //set div CSS ID
        local.controllerContent[1].cssID='defaultLoginRegion';
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
    
    /*<!---//////////////// _USERCHECK ////////////////////////// ---> */
    private boolean function _userCheck(rcF){
        user = '';

        //load user info
        local.obj = entityLoad('AppUser',{userName=rcF.username},true);
        if(!isNull(local.obj)){
            //found user
            _login(local.obj);
        }
        else{ //not found
            location("#application.baseEPath#/?login&msg=not found",false);
            return false;
        }

		return false;
    }
    
    /*<!---//////////////// _LOGIN ////////////////////////// ---> */
    private void function _login(userObj){
    	//role 0=admin, 1=editor, 2=user :: not really used right now, maybe in future (11/2012)
    	local.obj = arguments.userObj;
        
        //clear session variables
        structClear(session);
        
        //set session variables
        session.userObj = local.obj;
        session.userLoggedIn = 1;
        switch(session.userObj.getRole()){
        	case "0":
            	session.userRole='Administrator';
                break;
            case "1":
            	session.userRole='Editor';
                break;
            default:
            	session.userRole='User';
        }
        
        //redirect based on returnpath if exists
        if(isDefined('this.returnpath') && len(this.returnpath)){
        	location("#application.baseEPath#/?#this.returnpath#");
        }
        else{
            //redirect based on role;
            if(session.userObj.getRole() eq 2){
                location("#application.baseEPath#/?admin",false);
            }
            else if(session.userObj.getRole() eq 1 || session.userObj.getRole() eq 0){
                location("#application.baseEPath#/?admin",false);
            }
            else{
                location("#application.baseEPath#/?login",false);
            }
		}
	}
    
    /*<!---//////////////// _REGISTER ////////////////////////// ---> */
    private void function _register(rcForm,ldapQry){
    	local.rcF = arguments.rcForm;
        local.qry = arguments.ldapQry;
        
        local.obj = entityNew("AppUser");
        local.obj.setUsername(local.rcF.username);
        local.obj.setFirstName(local.qry.givenname);
        local.obj.setLastName(local.qry.sn);
        local.obj.setEmpEmail(local.qry.mail);
        local.obj.setRole(2); //user
        local.obj.setEmpNo(javaCast('int',local.qry.employeeID)); //make it an int to lose preceeding zeros, property is a char though
        local.obj.setDepartmentID(local.qry.department);
        local.obj.setIsActive(1);
        
        entitySave(local.obj);
        
        //login
        _login(local.obj);
    }
}