<cfif !isNull(params.getPageURL())>
	<!--- get all pages with index.cfm as parent. empty parent will not show in menus --->
	<cfscript>
		if( !isDefined('application.mainNavList') ){
   			hql = "select pageURL, linkText from StaticPages where parentURL = 'index' and isActive = 1 and isDeleted = 0";
			application.mainNavList = ormExecuteQuery(hql);
		}
	</cfscript>
	<cfoutput>
    <ul class="mainNav">
        <cfloop array="#application.mainNavList#" index="local.ni">
        	<li>
                <a href="#application.baseEPath#/?#trim(local.ni[1])#" <cfif local.ni[1] eq params.getPageURL()>class="mainNavActive"</cfif>>#trim(local.ni[2])#</a>
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
		<cfif session.userLoggedIn>
            <li>
                <a href="#application.baseEPath#/?logout" class="last">Logout</a>
            </li>
        <cfelse>
            <li>
                <a href="#application.baseEPath#/?login" class="last">Login</a>
            </li>
        </cfif>
    </ul>
    </cfoutput>
</cfif>