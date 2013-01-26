<!---<cfdump var="#local#" label="obj"><cfabort>--->
<cfoutput>
	<cfif !arrayLen(local.Obj)>
		<p class="red">There are currently no employees available.</p>
	<cfelse>
		<ul>
	        <cfloop array="#local.Obj#" index="local.u">
	            <li>#trim(local.u.getFirstName())#</li>
	        </cfloop>
		</ul>
	</cfif>
</cfoutput>