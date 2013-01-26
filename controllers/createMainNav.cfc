component{
	public any function init(params){ /*pass in page params for menu creation*/
		theFile = 'mainNav.js';
		sourceFile = expandPath('/assets/js/#theFile#');
		destinationFile = expandPath('/archives/#theFile#.#dateformat(now(),'yyyymmdd')##timeformat(now(),'hhmmss')#');
		
		savecontent variable = "navHTML"{
	    	include "../views/menus/mainNav.cfm";
		}
		/* escape single quotes */
		navHTML = replace(navHTML,"'","\'","all");
	
		/*write some funky js */
	    savecontent variable="fileContent"{
	    	writeOutput("var navHTML = ");
	    	writeOutput("'");
	    	writeOutput(navHTML);
	    	writeOutput("';");
			writeOutput(" document.write(navHTML);");
	    }
	    /* remove line breaks*/
	    fileContent = replace(fileContent,chr(10),'','all');

		if(fileExists(sourceFile)){ /*archive*/
			fileMove(sourceFile,destinationFile);
		}
		
		/*write new js file*/
		fileWrite(sourceFile,fileContent);
	}
}