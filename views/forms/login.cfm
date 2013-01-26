<!--- array for js validation instead of writing JS ---->
<cfset local.jAry = []>
<cfscript>
	local.jAry[1]={valType='required',fieldID='username',errMsg='Username is required.'};
	local.jAry[2]={valType='required',fieldID='password',errMsg='Password is required.'};
</cfscript>
<cfsavecontent variable="jsHead">
    <cfoutput>
        #local.fbObj.jsValidate(local.jAry,false)##chr(13)#
    </cfoutput>
</cfsavecontent>
<cfhtmlhead text="#jsHead#">

<cfoutput>
	<cfif isDefined('url.msg')>
		<div id="errMsg" class="red">
			Login was #url.msg#
		</div>
	</cfif>
	<!-- login form -->
	#local.fbObj.startForm(formID='loginForm',action='#application.baseEPath#/?#cgi.QUERY_STRING#')#
    	#local.fbObj.makeText(fieldLabel="Username",fieldName="username",fieldID="username")#
        #local.fbObj.makeText(fieldLabel="Password",fieldName="password",fieldID="password",fieldType="password")#
    #local.fbObj.endForm(submitText="Login")#
</cfoutput>