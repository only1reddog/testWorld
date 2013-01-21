<!---///////////////////////////////////////////////////////////////////////////////
/////                                                                           ////
/////                    --- PSUEDO URL REWRITE ---                             ////
/////    I take the first url variable and parse it out into local.r[N]         ////
/////    local.r1 is the cfc to use                                             ////
/////    local.r2 is the method to call                                         ////
/////    local.r3...local.rN can be whatever you need.                          ////
/////    Any normal url vars can follow with normal &key=value convention       ////
/////                                                                           ////
/////    Example url   index.cfm?employee/detail/john/doe&userID=192            ////
/////    will return:                                                           ////
/////                url.r1 = employee                                          ////
/////                url.r2 = detail                                            ////
/////                url.r3 = john                                              ////
/////                url.r4 = doe                                               ////
/////                url.userID = 192                                           ////
/////                                                                           ////
/////    which will call /com/Employee.cfc and use the detail() method.         ////
/////    url.r3, url.r4 and url.userID (in this case) are used for whatever     ////
/////    you need. Perhaps url.r3 can be First_name and url.r4 Last_name and    ////
/////    url.userID be the page visitor ID. The point is after r2 it's up to    ////
/////    you.                                                                   ////
/////                                                                           ////
/////    Example url2   index.cfm?employee                                      ////
/////    will return:                                                           ////
/////                url.r1 = employee                                          ////
/////                                                                           ////
/////    which will call /com/Employee.cfc and use the default method.          ////
/////    Perhaps that is a method that returns ALL employees to use as a list.  ////
/////                                                                           ////
////////////////////////////////////////////////////////////////////////////////--->
<!--- DEBUGGING (uncomment here and below to view output --->
<!---<cfdump var="#url#" label="URL - in urlRewrite.cfm">--->

<!--- loop counter --->
<cfset local.rewriteCounter = 1>
<cfoutput>
	<!--- loop through query string --->
	<cfloop list="#cgi.QUERY_STRING#" delimiters="&" index="local.urlPath">
		<!--- don't change legit key/value pairs --->
    	<cfif !find('=',local.urlPath)>
        	<!--- loop through our special var --->
            <cfloop list="#local.urlPath#" delimiters="/" index="local.urlVar">
            	<!--- create the r[N] vars --->
                <cfset url['r#rewriteCounter#'] = local.urlVar>
                <!--- increment counter --->
                <cfset local.rewriteCounter++>
            </cfloop>        
        </cfif>	
    </cfloop>
</cfoutput>

<!--- DEBUGGING (uncomment here and above to view output--->
<!---<cfdump var="#url#" label="url2 - in urlRewrite.cfm"><cfabort>--->