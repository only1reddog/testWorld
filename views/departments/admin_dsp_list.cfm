<!--- include javascript in the <head> --->
<cfsavecontent variable="local.jsHead">
	<script src="<cfoutput>#application.baseEPath#</cfoutput>/assets/js/deleteVal.js"></script>
    <script language="javascript">
		$(function(){
			$('.deleteIcon').click(function(e){
				if(!delVal('department')){
					e.stopPropagation();
					return false;
				} 
			});
		});
	</script>
</cfsavecontent>
<cfhtmlhead text="#local.jsHead#">

<!---<cfdump var="#local#" label="obj"><cfabort>--->
<cfset local.rowCount = 1>
<cfoutput>
	<h2>#local.regionHead#</h2>
    <a href="#application.baseEPath#/?department/admin/0/add" class="addIcon">Add a new department</a>
    <cfif isDefined('url.msg')>
    	<div class="red">#url.msg#</div>
    </cfif>
	<cfif !arrayLen(local.Obj)>
		<p class="red">There are currently no departments available.</p>
	<cfelse>
        <table id="departmentAdminList" class="adminList">
        	<thead>
            	<tr>
                	<th class="iconCol"><!-- Delete -->&nbsp;<br></th>
                    <th class="iconCol"><!-- Edit -->&nbsp;<br></th>
                    <th>Department</th>
                    <th>Active</th>
                </tr>
            </thead>
            <tbody>
                <cfloop array="#local.Obj#" index="local.u">
                    <tr class="#local.rowCount mod 2 eq	0? 'evenRow': 'oddRow'#">
                        <td><a href="#application.baseEPath#/?department/admin/#local.u.getId()#/delete" title="Delete" class="deleteIcon">&nbsp;</a></td>
                    	<td><a href="#application.baseEPath#/?department/admin/#local.u.getId()#" class="editIcon" title="Edit">&nbsp;</a></td>
                        <td>#trim(local.u.getDepartmentName())#</td>
                        <td>#yesNoFormat(local.u.getIsActive())#</td>
                    </tr>
                    <cfset local.rowCount++>
                </cfloop>
        	</tbody>
        </table>
        <div class="recordcount">#arrayLen(local.obj)# records found</div>
	</cfif>
</cfoutput>