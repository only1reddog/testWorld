<cfsilent>
	<cfparam name="variables.metaTitle" default="Welcome">
	<cfparam name="variables.metadesc" default="Welcome">
	<cfparam name="variables.metakeywords" default="Welcome">
    <cfparam name="variables.parentURL" default="index.cfm">
    <cfif len(params.getMetaTitle())><cfset variables.metaTitle = params.getMetaTitle()></cfif>
    <cfif len(params.getMetadesc())><cfset variables.metadesc = params.getMetadesc()></cfif>
    <cfif len(params.getMetakeywords())><cfset variables.metakeywords = params.getMetakeywords()></cfif>
</cfsilent>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
    <meta name="description" content="<cfoutput>#trim(variables.metadesc)#</cfoutput>" />
    <meta name="keywords" content="<cfoutput>#trim(variables.metakeywords)#</cfoutput>" />
    <meta name="robots" content="index, follow" />

    <title><cfoutput>#trim(variables.metaTitle)#: Admin</cfoutput></title>

    <link rel="stylesheet" href="<cfoutput>#application.baseEPath#</cfoutput>/assets/css/admin.css" />
    <!--[if lt IE 9]>
    <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
    <script type="text/javascript" src="http<cfif cgi.HTTPS eq 'on'>s</cfif>://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
</head>
<body>
	<header>
    	<cfoutput>
        	<!--- display logo image if exists, else just display company name --->
			<cfif fileExists(expandPath('#application.baseEPath#/assets/img/logo.gif'))>
                <img src="#application.baseEPath#/assets/img/logo.gif" alt="Logo" id="companyLogo" >
            <cfelse>
            	<h1 id="companyLogoAlt">Admin Layout</h1>
            </cfif>
        </cfoutput>
        <nav>
			<cfinclude template="#application.baseEPath#/views/menus/adminNav.cfm">
        </nav>
    </header>
    <div id="torso">
    	<!--- debugging --->
        <!---<cfdump var="#params.getRegions()#"><cfabort> --->
        
		<h1 id="pageTitle"><cfoutput>#params.getPageName()#</cfoutput></h1>
        
        <cfif arrayLen(params.getRegions())>
        	<cfoutput>
            	<cfloop array="#params.getRegions()#" index="local.pageRegion">
                	<div id="regionType_#local.pageRegion.getRegionType().getId()#">
                        #local.pageRegion.getRegionText()#
                        
                        <!--- loop through controller content if exists --->
                        <cfif isDefined('request.rc')>
                            <cftry>
                        	<cfloop array="#request.rc.controllerContent#" index="local.CC">
								<cfset local.crID = isDefined('local.CC.regionID')? local.CC.regionID: 4>
                                <cfif local.pageRegion.getRegionType().getId() eq local.crID>
                                    <aside class="controllerAside" id="#local.CC.cssID#">
                                       #local.CC.txt#
                                    </aside>
                                </cfif>
                        	</cfloop>
                            <cfcatch type="any"><cfdump var="#cfcatch#"></cfcatch>
                            </cftry>
                        </cfif>
                    </div>
                </cfloop>
            </cfoutput>
        </cfif>
    </div>
	<footer>
        <div>
        	<cfoutput>
                &copy;#year(now())# - GH
                <cfif session.userLoggedIn>
                    &bull;
                    Logged in as #trim(session.userRole)#: #trim(session.userObj.getFirstName())# #trim(session.userObj.getLastName())#
                </cfif>
			</cfoutput>
        </div>
    </footer>
</body>
</html>