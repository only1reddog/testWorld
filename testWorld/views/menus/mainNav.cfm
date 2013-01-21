<cfprocessingdirective suppressWhiteSpace = 'yes'>
<!---<cfif !isNull(params.getPageURL())>--->
	<!--- get all pages with index.cfm as parent. empty parent will not show in menus --->
	<cfscript>
		hql = "select pageURL, linkText from StaticPages where parentURL = 'index' and isActive = 1 and isDeleted = 0 ORDER BY orderby";
		mainNavList = ormExecuteQuery(hql);
	</cfscript>
	<cfoutput>
    <ul class="mainNav">
        <cfloop array="#mainNavList#" index="local.ni">
        	<li>
                <a href="#application.baseEPath#/#trim(local.ni[1])#">#trim(local.ni[2])#</a>
        		<cfif local.ni[1] neq 'index'>
		   			<cfset hql2 = "select pageURL, linkText from StaticPages where parentURL = '#local.ni[1]#' and isActive = 1 and isDeleted = 0">
					<cfset local.mainNavList_sub = ormExecuteQuery(hql2)>
                    <cfif arrayLen(local.mainNavList_sub)>
                        <ul>
                            <cfloop array="#local.mainNavList_sub#" index="local.ni_s">
                                <li><a href="#application.baseEPath#/?#trim(local.ni_s[1])#">#trim(local.ni_s[2])#</a></li>
                            </cfloop>
                        </ul>
                    </cfif>
		       	</cfif>
        	</li>
        </cfloop>
        <li>
            <a href="#application.baseEPath#/?login" class="last">Login</a>
        </li>
    </ul>
    </cfoutput>
<!---</cfif>--->
</cfprocessingdirective>