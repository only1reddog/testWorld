<!--- include javascript in the <head> --->
<cfsavecontent variable="local.jsHead">
	<script src="<cfoutput>#application.baseEPath#</cfoutput>/assets/js/deleteVal.js"></script>
    <script language="javascript">
		$(function(){
			$('.deleteIcon').click(function(e){
				if(delVal('administrator')){
					location.href='<cfoutput>#application.baseEPath#/?user/admin/#isNumeric(local.obj.getID())? local.obj.getID(): "0"#/delete</cfoutput>';
				}
			});
		});
	</script>
</cfsavecontent>
<cfhtmlhead text="#local.jsHead#">

<!---<cfdump var="#local.obj#" label="obj"><cfabort>--->
<cfoutput>
	<h2>#local.regionHead#</h2>
    <cfif isDefined('local.errMsg')>
    	<div class="red">#local.errMsg#</div>
    </cfif>
	<!--- form --->
    #local.fbObj.startForm(action='#application.baseEPath#/?user/admin/#isNumeric(local.obj.getID())? local.obj.getID(): "0"#/process',formID='adminForm')#
        #local.fbObj.makeHidden(fieldName='id',fieldValue="#len(local.obj.getID())? local.obj.getID(): '0'#")#
        #local.fbObj.makeText('First Name','firstName','firstName',trim(local.obj.getFirstName()),'adminInput',255)#
        #local.fbObj.makeText('Last Name','lastName','lastName',trim(local.obj.getLastName()),'adminInput',255)#
        #local.fbObj.makeText('Network Username','userName','userName',trim(local.obj.getUserName()),'adminInput',255)#
        #local.fbObj.makeText('Email','empEmail','empEmail',trim(local.obj.getEmpEmail()),'adminInput',255)#
        #local.fbObj.makeRadio(fieldLabel='Active',fieldName='isActive',fieldSelectedValue=local.obj.getIsActive(),fieldArray=local.ary)#
    <cfif val(local.obj.getID())>
    	#local.fbObj.endForm(hasCancel=true,cancelURL='#application.baseEPath#/?user/admin',hasCustom=true,customText='Delete',customClass='deleteIcon deleteButton')#
	<cfelse>
	    #local.fbObj.endForm(hasCancel=true,cancelURL='#application.baseEPath#/?user/admin')#
    </cfif>
</cfoutput>