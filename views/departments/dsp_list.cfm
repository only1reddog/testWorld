<!---<cfdump var="#local#" label="obj"><cfabort>--->
<cfoutput>
	<cfif !arrayLen(local.Obj)>
		<p class="red">There are currently no departments available.</p>
	<cfelse>
		<ul>
	        <cfloop array="#local.Obj#" index="local.u">
	            <li><a href="/?department/#trim(local.u.getID())#">#trim(local.u.getDepartmentName())#</li>
	        </cfloop>
		</ul>
	</cfif>
</cfoutput>