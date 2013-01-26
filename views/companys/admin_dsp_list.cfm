<!---<cfdump var="#local.obj.company#" label="obj"><cfabort>--->
<cfoutput>
	<h2>#local.regionHead#</h2>
    <cfif isDefined('url.msg')>
    	<div class="red">#url.msg#</div>
    </cfif>
    <table id="companyAdminList" class="adminList">
    	<thead>
        	<tr>
                <th class="iconCol"><!-- Edit -->&nbsp;<br></th>
                <th>Company</th>
            </tr>
        </thead>
        <tbody>
	        <tr>
	        	<td><a href="#application.baseEPath#/?company/admin/1" class="editIcon" title="Edit">&nbsp;</a></td>
	            <td>#local.obj.company[1].companyName.xmlText#</td>
	        </tr>
    	</tbody>
    </table>
</cfoutput>