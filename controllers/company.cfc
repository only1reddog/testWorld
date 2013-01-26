component{
	public any function init(rcF,rcU){
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
       	local.metaTitle="Company Administration";
        
        //set up region 4
        //set div CSS ID
        local.controllerContent[1].cssID='defaultCompanyAdminRegion';
        //set the region
        local.controllerContent[1].regionID=4;
        //set the content
        if(isDefined('local.rcURL.r4') && isNumeric(local.rcURL.r3)){ //CRUD
        	switch(lcase(local.rcURL.r4)){
                case "process":
                	if(!adminProcess(local.rcForm)){
                        savecontent variable="local.temp"{
                            writeOutput(adminManage(local.rcForm));
                        }                    	
                    }
                    break;
           		default:
                    savecontent variable="local.temp"{
                    	writeOutput(adminManage());
                    }
           	}
        }
        else if(isDefined('local.rcURL.r3') && isNumeric(local.rcURL.r3)){ //MANAGE
            savecontent variable="local.temp"{
                writeOutput(adminManage());
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
		xmldoc = fileread(expandPath('assets/xml/company.xml')); 
		local.obj = XmlParse(xmldoc);
        local.regionHead = "Company Information:";
        savecontent variable="local.temp"{
	        include "#application.baseEPath#/views/companys/admin_dsp_list.cfm";
        }
        
        return local.temp;
    }
    
	/*<!--- /////   _ADMIN PROCESS  ///// --->*/
    private any function adminProcess(rcF){
    	local.rcF = arguments.rcF;
    
        local.processMsg = 'Company updated successfully.';
		
		try{
			savecontent variable="temp"{
				writeOutput('
					<company>
						<companyName>#rcF.companyname#</companyName>
						<copyright>#rcF.copyright#</copyright>
						<contactEmail>#rcF.contactemail#</contactEmail>
						<address>#rcF.address#</address>
						<address2>#rcF.address2#</address2>
						<city>#rcF.city#</city>
						<state>#rcF.state#</state>
						<zip>#rcF.zip#</zip>
					</company>
				');
	        }
	        filewrite(expandPath('/assets/xml/company.xml'),temp);
		   	xmldoc = fileread(expandPath('assets/xml/company.xml'));
			application.company = XmlParse(xmldoc); 
        }catch(Any e){
			writeDump(e); abort;
        	return false;
        }
		
        location("#application.baseEPath#/?company/admin/&msg=#local.processMsg#",false);
    }
    
	/*<!--- /////   _ADMIN MANAGE  ///// --->*/
    private any function adminManage(rcF){
    	if(isDefined('argumentsrcF')){
            local.rcF = arguments.rcF;
        }

		//Region heading
        local.regionHead = "Company:";
                
        //Create form builder object
        local.fbObj = new com.formBuilder();

		xmldoc = fileread(expandPath('assets/xml/company.xml')); 
		local.obj = XmlParse(xmldoc);
        
        savecontent variable="local.temp"{
	        include "#application.baseEPath#/views/companys/admin_dsp_manage.cfm";
        }
        
        return local.temp;
    }
}