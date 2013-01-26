<!--- include javascript in the <head> --->
<cfsavecontent variable="local.jsHead">
	<script src="<cfoutput>#application.baseEPath#</cfoutput>/assets/js/deleteVal.js"></script>
    <script language="javascript">
		$(function(){
			$('.deleteIcon').click(function(e){
				if(delVal('page')){
					location.href='<cfoutput>#application.baseEPath#/?staticPages/admin/#isNumeric(local.obj.getID())? local.obj.getID(): "0"#/delete</cfoutput>';
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
    #local.fbObj.startForm(action='#application.baseEPath#/?staticPages/admin/#isNumeric(local.obj.getID())? local.obj.getID(): "0"#/process',formID='adminForm')#
        #local.fbObj.makeHidden(fieldName='id',fieldValue="#len(local.obj.getID())? local.obj.getID(): '0'#")#
        #local.fbObj.makeText('Meta Title','metaTitle','metaTitle',trim(local.obj.getMetaTitle()),'adminInput',255)#
        #local.fbObj.makeText('Meta Description','metadesc','metadesc',trim(local.obj.getMetadesc()),'adminInput',255)#
        #local.fbObj.makeText('Meta Keywords','metakeywords','metakeywords',trim(local.obj.getMetakeywords()),'adminInput',255)#
        #local.fbObj.makeText('Link Text','linkText','linkText',trim(local.obj.getLinkText()),'adminInput',255)#
        #local.fbObj.makeText('Page Name','pageName','pageName',trim(local.obj.getPageName()),'adminInput',255)#
        #local.fbObj.makeText('Page URL','pageURL','pageURL',trim(local.obj.getPageURL()),'adminInput',255)#
        #local.fbObj.makeText('Parent URL','parentURL','parentURL',trim(local.obj.getParentURL()),'adminInput',255)#
        #local.fbObj.makeSelect(fieldLabel='Layout',fieldName='layoutID',fieldSelectedValue=local.lSelectedID,fieldArray=local.layoutArray)#
        #local.fbObj.makeSelect(fieldLabel='Display Order',fieldName='orderby',fieldSelectedValue=local.oSelectedID,fieldArray=local.orderbyArray)#
        #local.fbObj.makeRadio(fieldLabel='Active',fieldName='isActive',fieldSelectedValue=local.obj.getIsActive(),fieldArray=local.ary)#
    <cfif val(local.obj.getID())>
    	#local.fbObj.endForm(hasCancel=true,cancelURL='#application.baseEPath#/?staticPages/admin',hasCustom=true,customText='Delete',customClass='deleteIcon deleteButton')#
	<cfelse>
	    #local.fbObj.endForm(hasCancel=true,cancelURL='#application.baseEPath#/?staticPages/admin')#
    </cfif>
</cfoutput>