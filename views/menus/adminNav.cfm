<!--- set class for different pages --->
<cfparam name="attributes.ulClass" default="mainNav">
<!--- show home link? --->
<cfparam name="attributes.showHome" default="1">

<cfoutput>
    <ul class="#attributes.ulClass#">
    	<cfif attributes.showHome>
            <li>
                <a href="#application.baseEPath#?admin">Home</a>
            </li>
        </cfif>
        <!---admins only--->
        <cfif isDefined('session.userRole') AND session.userRole eq 'Administrator'>
        	<li>
                <a href="#application.baseEPath#?user/admin&isAdmin=1">Administrators</a>
                <!--- for future use
            	<a name="userAnchor">Users</a>
                <ul>
                    <li>
                        <a href="#application.baseEPath#?user/admin&isAdmin=1">Administrators</a>
                    </li>
					<li>
                        <a href="#application.baseEPath#?editor/admin">Editors</a>
                    </li>
                </ul>
				--->
            </li>
        </cfif>
    	<li>
        	<a name="pageAnchor">Pages</a>
            <ul>
                <li>
		            <a href="#application.baseEPath#?staticPages/admin&sec=0">Static Pages</a>
                </li>
				<li>
		            <a href="#application.baseEPath#?staticPages/admin&sec=1">Admin Pages</a>
                </li>
				<li>
		            <a href="#application.baseEPath#?staticPages/admin&sec=2">System Pages</a>
                </li>
            </ul>
        </li>
        <li>
        </li>
    	<li>
          	<a href="#application.baseEPath#?logout" class="last">Logout</a>
        </li>
	</ul>
</cfoutput>