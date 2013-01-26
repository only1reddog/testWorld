<cfif session.userLoggedIn>
	<cfoutput>
		<p>Welcome to the Administration Center.</p>
		<p>Use the navigation menu above or the links below to perform your administrative tasks.</p>
		<p>You are currently logged in as: <b>#session.userRole# - #trim(session.userObj.getFirstName())# #trim(session.userObj.getLastName())#</b>.</p>
	</cfoutput>
    <cfif !session.userObj.getIsActive() || session.userObj.getIsDeleted()>
    	<div id="invalidAccoutNotice">
        	Your account has been disabled. Please contact your administrator.
        </div>
    </cfif>
	<cfmodule template="#application.baseEPath#/views/menus/adminNav.cfm" ulClass="adminHome" showHome="0">
<cfelse>
	<cflocation addtoken="no" url="#application.baseEPath#/?login">
</cfif>