<!---<cfdump var="#local#" label="obj"><cfabort>--->
<cfoutput>
	<cfif isNull(local.Obj)>
		<p class="red">There is no information available for that department.</p>
	<cfelse>
	    <p>#trim(local.Obj.getDepartmentName())#</p>
	</cfif>
</cfoutput>