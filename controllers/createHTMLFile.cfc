component{
	public void function init(obj,rcF,rcU){ /*pass in page params for menu creation*/
		local.obj = arguments.obj;
        //	if(lcase(local.obj.getParentURL()) eq 'index'){
				/* GET CONTROLLER */
				if(fileExists(expandPath('#application.baseEPath#/controllers/#local.obj.getPageURL()#.cfc'))){
					request.rc = createObject('controllers.#local.obj.getPageURL()#').init(rcF,rcU);
				}
						
	        	/* CREATE THE PAGE*/
	        	pageContent = createObject('com.Page').init('/layouts/#local.obj.getPageLayout().getLayoutName()#.cfm',local.obj);				
					
				/*FILE INFO*/
				theFile = '#local.obj.getPageURL()#.html';
				sourceFile = expandPath('/#theFile#');
				destinationFile = expandPath('/archives/#theFile#.#dateformat(now(),'yyyymmdd')##timeformat(now(),'hhmmss')#');
			
				/* BACKUP EXISTING */
				//TODO decide if this is needed. archives folder gets huge quick
				if(fileExists(sourceFile)){
					fileMove(sourceFile,destinationFile);
				}

				/*CREATE NEW HTML FILE*/
				fileWrite(sourceFile,pageContent);        
				
				/*CREATE MAIN NAV JS FILE*/
				js = new controllers.createMainNav(local.obj);	
        //	}
	}
}