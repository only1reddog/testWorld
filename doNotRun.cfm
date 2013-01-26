<!---///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////                                                                                                                  /////
/////              THIS WILL ERASE EVERYTHING IN THE DB AND REPLACE WITH VALUES BELOW!!!!!!                            /////
/////                                                                                                                  /////
/////  This file should be ran as /doNotRun.cfm any time you need to rebuild your db. This WILL drop old tables. It    /////
/////  will wipe out all of the DB data, recreate default data as defined below. It will alter tables.                 /////
/////  This file should NOT BE in production. You may experience errors when you run this file. Try re-running.        /////
/////  After you get a successful page load here and your db has been updated and populated you may need to run        /////
/////  index.cfm?kill=1 or ?kill=1 or &kill=1 to restart the application. If you get a(almost) blank page on the       /////
/////  first run of kill=1, re-run it. The second run will work and reset the application.                             /////
/////                                                                                                                  /////
/////              THIS WILL ERASE EVERYTHING IN THE DB AND REPLACE WITH VALUES BELOW!!!!!!                            /////
/////                                                                                                                  /////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--->
<!DOCTYPE html>
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="robots" content="no index, no follow" />
	<title>Making the DB</title>
</head>

<body>

<cftry>
	<cfset onApplicationStart()><!---<cfabort>--->
    <H1>DB Rebuild</H1> 
    <cfset ormReload() />
    
    <h1>ORM RELOADED</h1>
		<!--- ///////// POPULATE DEFAULT RECORDS IN THE DB //////// --->
        
        <!--- //// Admins ////--->
      	<cfscript>
	        admin1 = new com.AppUser();
			admin1.setFirstName('Glenn');
			admin1.setLastName('Hartong');
			admin1.setEmpNo('750638');
			admin1.setUserName('ghartong');
			admin1.setEmpEmail('ghartong@jewels.com');
			admin1.setRole(0);
			entitySave(admin1);
			ormFlush();
		</cfscript>
                        
		<!--- //// Layouts ////--->
		<!--- create default layout (use init defaults)--->
		<cfset commonLay = new com.Layouts() />
        <!--- dump to see it --->        
        <!---<cfdump var="#commonLay#" label="commonLay dump">--->
		<!--- save it --->
        <cfset entitySave(commonLay) />
        <cfset ormFlush()>
        
		<!--- create admin layout --->
		<cfset adminLay = new com.Layouts(layoutName="Admin",isActive=true) />
        <!--- dump to see it --->        
        <!---<cfdump var="#adminLay#" label="adminLay dump">--->
		<!--- save it --->
        <cfset entitySave(adminLay) />
        
		<!--- //// Page Regions ////--->
		<!--- create page region types (they need to be in this order to set the correct IDs. CSS and HTML rely on these IDs being correct--->
		<cfset topBannerRegion = new com.PageRegionType(regionTypeName="Top Banner Region",isActive=true,orderby=1) />
        <!--- dump to see it --->        
        <!---<cfdump var="#topBannerRegion#" label="topBannerRegion dump">--->
		<!--- save it --->
        <cfset entitySave(topBannerRegion) />
		<cfset leftColRegion = new com.PageRegionType(regionTypeName="Left Column Region",isActive=true,orderby=2) />
        <!--- dump to see it --->        
        <!---<cfdump var="#leftColRegion#" label="leftColRegion dump">--->
		<!--- save it --->
        <cfset entitySave(leftColRegion) />
		<cfset rightColRegion = new com.PageRegionType(regionTypeName="Right Column Region",isActive=true,orderby=4) />
        <!--- dump to see it --->        
        <!---<cfdump var="#rightColRegion#" label="rightColRegion dump">--->
		<!--- save it --->
        <cfset entitySave(rightColRegion) />
		<cfset defaultRegion = new com.PageRegionType(regionTypeName="Default Content Region",isActive=true,orderby=3) />
        <!--- dump to see it --->        
        <!---<cfdump var="#defaultRegion#" label="defaultRegion dump">--->
		<!--- save it --->
        <cfset entitySave(defaultRegion) />
		<cfset bottomBannerRegion = new com.PageRegionType(regionTypeName="Bottom Banner Region",isActive=true,orderby=5) />
        <!--- dump to see it --->        
        <!---<cfdump var="#bottomBannerRegion#" label="bottomBannerRegion dump">--->
		<!--- save it --->
        <cfset entitySave(bottomBannerRegion) />
                
		<!--- //// Home page ////--->
        <!--- create the pageLayout entity to use in page, Common is in most pages so we'll reuse this --->
        <cfset comLay = entityLoad("Layouts",{layoutName="Common"}, true) />
        <!--- create the region entities to use in page --->
        <cfset homeRegion1 = new com.PageRegion(isActive=true,orderby=1,regionName='Welcome to the Test World.',regionText="<p>Holla y'all.</p>",regionType=defaultRegion)>
		<!--- create the new page --->
		<cfset home = new com.StaticPages(pageName="Welcome",pageURL="index",parentURL="",linkText="Home",orderby=1,metaTitle="Welcome to the Test World",isActive=true,pageLayout=comLay) />
		<!--- add the regions from above to the new page --->
        <cfset home.setRegions([homeRegion1])>
        <!--- dump to see it --->        
        <!---<cfdump var="#home#" label="Home dump">--->
		<!--- save it --->
        <cfset entitySave(home) />
        
		<!--- //// Login page ////--->
        <!--- we want the Common layout so we'll just reuse the one we created for the Home page (see pageLayout=comLay below when we create this page)---> 
        <!--- create the region entities to use in page --->
        <cfset loginRegion4 = new com.PageRegion(isActive=true,orderby=1,regionName='',regionText='Please use the login form below to begin',regionType=defaultRegion)>
		<!--- create the new page --->
        <cfset loginPage = new com.StaticPages(pageName="Login",pageURL="login",parentURL="",linkText="Login",orderby=997,metaTitle="Login",isActive=true,pageLayout=comLay) />
		<!--- add the regions from above to the new page --->
        <cfset loginPage.setRegions([loginRegion4])>
        <!--- dump to see it --->        
        <!---<cfdump var="#loginPage#" label="loginPage dump">--->
		<!--- save it --->
        <cfset entitySave(loginPage) />

		<!--- //// Logout page ////--->
        <!--- we want the Common layout so we'll just reuse the one we created for the Home page (see pageLayout=comLay below when we create this page)---> 
        <!--- create the region entities to use in page --->
        <cfset logoutRegion4 = new com.PageRegion(isActive=true,orderby=1,regionName='Congratulations',regionText='You have been successfully logged out.',regionType=defaultRegion)>
		<!--- create the new page --->
        <cfset logoutPage = new com.StaticPages(pageName="Logout",pageURL="logout",parentURL="",linkText="Logout",orderby=996,metaTitle="See you soon",isActive=true,pageLayout=comLay) />
		<!--- add the regions from above to the new page --->
        <cfset logoutPage.setRegions([logoutRegion4])>
        <!--- dump to see it --->        
        <!---<cfdump var="#logoutPage#" label="logoutPage dump">--->
		<!--- save it --->
        <cfset entitySave(logoutPage) />

		<!--- //// Security page ////--->
        <!--- we want the Common layout so we'll just reuse the one we created for the Home page (see pageLayout=comLay below when we create this page)---> 
        <!--- create the region entities to use in page --->
        <cfset securityRegion4 = new com.PageRegion(isActive=true,orderby=1,regionName='Warning!',regionText='You are attempting to enter a restricted area. If you feel you have reached this page in error, please contact your administrator.',regionType=defaultRegion)>
		<!--- create the new page --->
        <cfset securityPage = new com.StaticPages(pageName="Security Check",pageURL="security",parentURL="",linkText="Security Check",orderby=996,metaTitle="Warning - Security Check",isActive=true,pageLayout=comLay) />
		<!--- add the regions from above to the new page --->
        <cfset securityPage.setRegions([securityRegion4])>
        <!--- dump to see it --->        
        <!---<cfdump var="#securityPage#" label="securityPage dump">--->
		<!--- save it --->
        <cfset entitySave(securityPage) />

		<!--- //// Admin default page ////--->
        <!--- we want the Admin layout so we'll just reuse the one we created above(adminLay below when we create this page)---> 
        <!--- create the region entities to use in page --->
        <cfset adminDefaultRegion1 = new com.PageRegion(isActive=true,orderby=1,regionText='',regionType=defaultRegion)>
		<!--- create the new page --->
        <cfset adminHome = new com.StaticPages(pageName="Administration Center",pageURL="admin",parentURL="admin",linkText="Administration Center Home",orderby=1,metaTitle="Administration Center",isActive=true,pageLayout=adminLay) />
		<!--- add the regions from above to the new page --->
        <cfset adminHome.setRegions([adminDefaultRegion1])>
        <!--- dump to see it --->        
        <!---<cfdump var="#adminHome#" label="adminHome dump">--->
		<!--- save it --->
        <cfset entitySave(adminHome) />

		<!--- //// Help default page ////--->
        <!--- we want the Admin layout so we'll just reuse the one we created above(adminLay below when we create this page)---> 
        <!--- create the region entities to use in page --->
        <cfset helpDefaultRegion1 = new com.PageRegion(isActive=true,orderby=1,regionName='',regionText='',regionType=defaultRegion)>
		<!--- create the new page --->
        <cfset adminHelp = new com.StaticPages(pageName="Helpful Information",pageURL="help",parentURL="admin",linkText="Help",orderby=998,metaTitle="Help",isActive=true,pageLayout=adminLay) />
		<!--- add the regions from above to the new page --->
        <cfset adminHelp.setRegions([helpDefaultRegion1])>
        <!--- dump to see it --->        
        <!---<cfdump var="#adminHelp#" label="adminHelp dump">--->
		<!--- save it --->
        <cfset entitySave(adminHelp) />

		<!--- //// Example Regions page ////--->
        <!--- we want the Common layout so we'll just reuse the one we created for the Home page (see pageLayout=comLay below when we create this page)---> 
        <!--- create the region entities to use in page --->
        <cfset exampleRegionsRegion1 = new com.PageRegion(isActive=true,regionText='This is a top ad.',regionType=topBannerRegion,regionName="TOP BANNER")>
        <cfset exampleRegionsRegion2 = new com.PageRegion(isActive=true,regionText='This is a left col.',regionType=leftColRegion,regionName="LEFT COL")>
        <cfset exampleRegionsRegion3 = new com.PageRegion(isActive=true,regionText='This is a right col.',regionType=rightColRegion,regionName="RIGHT COL")>
        <cfset exampleRegionsRegion4 = new com.PageRegion(isActive=true,regionText='This is the default content region.',regionType=defaultRegion,regionName="DEFAULT CONTENT REGION")>
        <cfset exampleRegionsRegion5 = new com.PageRegion(isActive=true,regionText='This is a bottom ad.',regionType=bottomBannerRegion,regionName="BOTTOM BANNER")>
		<!--- create the new page --->
        <cfset exampleRegionPage = new com.StaticPages(pageName="Regions Example",pageURL="region-example",parentURL="",linkText="Regions Ex:",orderby=995,metaTitle="Example Regions",isActive=true,pageLayout=comLay) />
		<!--- add the regions from above to the new page --->
        <cfset exampleRegionPage.setRegions([exampleRegionsRegion1,exampleRegionsRegion2,exampleRegionsRegion3,exampleRegionsRegion4,exampleRegionsRegion5])>
        <!--- dump to see it --->        
        <!---<cfdump var="#exampleRegionPage#" label="exampleRegionPage dump">--->
		<!--- save it --->
        <cfset entitySave(exampleRegionPage) />

		<!--- //// 404 page ////--->
        <!--- we want the Common layout so we'll just reuse the one we created for the Home page (see pageLayout=comLay below when we create this page)---> 
        <!--- create the region entities to use in page --->
        <cfset pageNotFoundRegion1 = new com.PageRegion(isActive=true,orderby=2,regionText='You seem to have ended up on a page that no longer exists or never existed in the first place.',regionType=defaultRegion)>
        <cfset pageNotFoundRegion2 = new com.PageRegion(regionTypeID=2,isActive=true,orderby=1,regionText='If you are having difficulty finding what you are looking for, contact your administrator or Application Services.',regionName='WARNING!!',regionType=leftColRegion)>
		<!--- create the new page --->
        <cfset pageNotFound = new com.StaticPages(pageName="Sorry, that pages doesn't seem to exist",pageURL="404",parentURL="",linkText="404",orderby=999,metaTitle="Oops!",isActive=true,pageLayout=comLay) />
		<!--- add the regions from above to the new page --->
        <cfset pageNotFound.setRegions([pageNotFoundRegion1, pageNotFoundRegion2])>
        <!--- dump to see it --->        
        <!---<cfdump var="#pageNotFound#" label="pageNotFound dump">--->
		<!--- save it --->
        <cfset entitySave(pageNotFound) />

		<!--- force orm to update now so we can do more with updated db below if we want --->
        <cfset ormFlush() />

        <!--- set/add examples --->
		<!--- load entities--->
		<!---<cfset athletic = entityLoad("Property",{name="Athletic"}, true) />
        <cfset brunette = entityLoad("Property",{name="Brunette"}, true) />--->
        <!--- set 2 existing and add 1 new property --->
        <!---<cfset joanna.setProperties([athletic, brunette, new com.Property("Sassy")] ) />--->
        <!--- add a new property to a Girl Obj --->
        <!---<cfset joanna.addProperties(new com.Property("Classy") ) />--->
        <!--- set a single property on a Girl Obj --->
        <!---<cfset joanna.setIsHot( true ) />--->

		<!--- remove example --->
        <!---<cfset joanna.removeProperties(entityLoad( "Property", {name="Classy"}, true )) />--->

		<!--- //// Further Examples... comment on/off to use ////--->

        <!--- example grabbing an entity by id--->
		<!---<cfset testPageData = entityLoadByPK("StaticPages",1)/>--->
        <!--- dump to see it --->        
        <!---<cfdump var="#testPageData#" label="example grabbing a page by id">--->
        <!--- example grabbing an entity by column value--->
		<!---<cfset testPageData = entityLoad("StaticPages",{pageURL='index.cfm'},true)/>--->
        <!--- dump to see it --->        
        <!---<cfdump var="#testPageData#" label="example grabbing a page by column value">--->
        <!---
        <!--- set the title --->        
        <cfset testPageData.setMetaTitle('CHANGED IT')>
        <!--- dump to see it, check out the page in a browser too --->
        <cfdump var="#testPageData#">
		--->
        		
		<!--- get a list --->
        <!---<cfset pagesObj = entityLoad("StaticPages")>--->
        <!--- dump to see it --->        
        <!---<cfdump var="#pagesObj#" label="pagesObj all">--->
        
		<!--- entity to query --->
        <!--- its interesting that the dump of the query shows that the Layouts and Regions are components (array of components) proves they are entities --->
        <!---<cfset pagesQ = entityToQuery(pagesObj)>
        <cfdump var="#pagesQ#" label="pagesQ">--->

    <h1>End DB Rebuild</h1>
    <cfcatch type="any">
    	<cfdump var="#cfcatch#"><cfabort>
    </cfcatch>
</cftry>
    
</body>
</html>