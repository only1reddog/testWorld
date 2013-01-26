<cfcomponent displayname="Application" output="true" hint="Handle the application.">
	<cfset THIS.Name = "worldTest" />
	<cfset THIS.ApplicationTimeout = CreateTimeSpan( 0, 0, 20, 0 ) />
	<cfset THIS.SessionManagement = true />
	<cfset THIS.SetClientCookies = true />

	<cfset THIS.mappings["/com"] = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "com" />
    <cfset THIS.mappings["/controllers"] = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "controllers" />
	
    <cfset THIS.datasource = "testWorld" />
    <cfset THIS.ormEnabled = true />
    <cfset THIS.ormSettings = {
			dbCreate="none",
			dialect="MySQL5",
			useDBForMapping=true,
			cfclocation="com"
		}/>
    <!--- DO NOT DO IN PRODUCTION --->
	<cfif !isNull(url.reload)>
    	<cfset THIS.ormSettings.logSQL = true>
		<cfset THIS.ormSettings.dbCreate="dropcreate" />
	</cfif>
      
	<cffunction name="OnApplicationStart" access="public" returntype="boolean" output="false" hint="Fires when the application is first created.">
	    <cfset application.dsn = THIS.datasource>
	    <cfset application.baseEPath = ''>
	    <!---read company info from xml --->
	   	<cffile action="read" file="#expandPath('assets/xml/company.xml')#" variable="xmldoc"> 
		<cfset application.company = XmlParse(xmldoc)> 
            
 		<cfreturn true />
	</cffunction>
 
	<cffunction name="OnSessionStart" access="public" returntype="void" output="false" hint="Fires when the session is first created.">
    	<cfparam name="session.userLoggedIn" default="0">
        
		<cfreturn />
	</cffunction>
 
	<cffunction name="OnRequestStart" access="public" returntype="boolean" output="false" hint="Fires at first part of page processing.">
 		<cfargument name="TargetPage" type="string" required="true"/>
		<!--- SECURITY CHECK --->
        <cfif find('admin',lcase(cgi.QUERY_STRING))>
			<!--- is user allowed in admin area --->
            <cfset new com.securityCheck()>
        </cfif>
        
 		<!--- dev process clock --->
		<cfset request.tickcount = getTickCount()>

 		<!--- psuedo URL rewrite --->
        <cfinclude template="#application.baseEPath#/com/urlRewrite.cfm">
        
        <!--- set current URL info - lcase so it can be found below in services if needed OR set to index--->
        <cfif isDefined('url.r1') && len(url.r1)>
			<cfset url.r1 = lcase(url.r1)>
        <cfelse>
			<cfset url.r1 = 'index'>
		</cfif>
		<cftry>
			<!--- get page info, pass it into the page below --->
            <cfif isDefined('url.r2') && lcase(url.r2) eq 'admin'>
                <!--- load admin homepage info. this page and regions used by default for all of admin center unless a specific page is made and used in conjuction w/controler --->
	            <cfset variables.args = entityLoad("StaticPages",{pageURL="admin",isActive=true,isDeleted=false},true)>
            <cfelse>
                <!--- load page info --->
	            <cfset variables.args = entityLoad('StaticPages',{pageURL=url.r1,isActive=true,isDeleted=false},true)>
            </cfif>
			<cfif !structKeyExists(variables,'args')><!--- 404 if not found --->
                <cfset variables.args = entityLoad("StaticPages",{pageURL='404'},true)>
            </cfif>			

            <!--- if there is a controller call it; --->
            <cfif fileExists(expandPath('#application.baseEPath#/controllers/#url.r1#.cfc'))><!---controller cfc names MUST BE LOWER CASE on linux box--->
                <cfif isDefined('url.r2') && len(url.r2)>
                	<cftry>
                    	<!--- see if r2 is a method in our controller and run it--->
			            <cfinvoke component="controllers.#url.r1#" method="#url.r2#" returnvariable="request.rc" rcF="#form#" rcU="#url#">
                        <!---<cfdump var="#request.rc#"><cfabort>--->
                        <cfcatch type="any"><!--- if not just run the init() --->
                        	<!--- for debugging. you may get a method not found error on front end with this dump in place. Use with caution --->
                        	<!---<cfdump var="#cfcatch#" label="controller not init error"><cfabort> --->
			                <cfset request.rc = createObject('controllers.#url.r1#').init(form,url)>
                        </cfcatch>
                    </cftry>
					<!--- see if there's a page in db for the r2 method and use it if so --->
                    <cfset local.args = entityLoad("StaticPages",{pageURL='#url.r1#/#url.r2#',isActive=true,isDeleted=false},true)>
                    <cfif structKeyExists(local,'args')><cfset variables.args = local.args></cfif>
                <cfelse><!--- if no r2 just run the init() --->
 	               <cfset request.rc = createObject('controllers.#url.r1#').init(form,url)>
            	</cfif>
                <cfif isDefined('request.rc.metaTitle')>
	                <cfset variables.args.setMetaTitle(request.rc.metaTitle)>
                </cfif>
            </cfif>
			
			<cfif structKeyExists(variables,'args')>
	            <!--- create the page and pass in the page info from above--->
	            <cfset variables.myPage = createObject('com.Page').init('#application.baseEPath#/layouts/#trim(lcase(variables.args.getPageLayout().getLayoutName()))#.cfm',variables.args)>
	        </cfif>    
			<cfcatch type="any">
            	<!--- for debugging if this is uncommented you may get bogus errors (specially on db rebuild). use with caution--->
				<cfdump var="#cfcatch#"><cfabort><!--- --->

				<!--- during site creation this is helpful to have, can prly remove on production. wouldn't hurt to keep either. --->
				<cfset variables.myPage='Error in page creation. Line 102 Application.cfc'>
            </cfcatch>
		</cftry>
		<cfreturn true />
	</cffunction>
 
	<cffunction name="OnRequest" access="public" returntype="void" output="true" hint="Fires after pre page processing is complete.">
		<cfargument name="TargetPage" type="string" required="true"/>
        
		<!--- reset the application by adding kill=1 to URL--->
 		<cfif isDefined('url.kill')>
        	<cfset onApplicationStart()>
        </cfif>
        
		<!--- the page --->
		<cfinclude template="#ARGUMENTS.TargetPage#" />
 
		<cfreturn />
	</cffunction>
 
	<cffunction name="OnRequestEnd" access="public" returntype="void" output="true" hint="Fires after the page processing is complete.">
 		<!--- dev only --->
	 		<!--- dev footer --->
			<cfoutput><br>process time: #getTickCount() - request.tickcount#ms</cfoutput>

  		<cfreturn />
	</cffunction>
 
	<cffunction name="OnSessionEnd" access="public" returntype="void" output="false" hint="Fires when the session is terminated.">
 		<cfargument name="SessionScope" type="struct" required="true"/>
		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#"/>
 
		<cfreturn />
	</cffunction>
 
	<cffunction name="OnApplicationEnd" access="public" returntype="void" output="false" hint="Fires when the application is terminated.">
 		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#"/>
 
		<cfreturn />
	</cffunction>
 
	<cffunction name="OnError" access="public" returntype="void" output="true" hint="Fires when an exception occures that is not caught by a try/catch.">
		<cfargument name="Exception" type="any" required="true"/>
		<cfargument name="EventName" type="string" required="false" default=""/>
 
			<!--- DO NOT USE IN PRODUCTION --->
				<cfoutput>What the what? - onError() in Application.cfc</cfoutput>
                <cfdump var="#arguments.Exception#">
            
		<cfreturn />
	</cffunction>
 
</cfcomponent>