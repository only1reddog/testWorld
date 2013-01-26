<!---<cfdump var="#local.obj#" label="obj"><cfabort>--->
<cfoutput>
	<h2>#local.regionHead#</h2>
    <cfif isDefined('local.errMsg')>
    	<div class="red">#local.errMsg#</div>
    </cfif>
	<!--- form --->
    #local.fbObj.startForm(action='#application.baseEPath#/?company/admin/1/process',formID='adminForm')#
        #local.fbObj.makeText('Company Name','companyName','companyName',local.obj.company[1].companyName.xmltext,'adminInput',255)#
        #local.fbObj.makeText('Copyright Text','copyright','copyright',local.obj.company[1].copyright.xmltext,'adminInput',255)#
        #local.fbObj.makeText('Contact Email','contactEmail','contactEmail',local.obj.company[1].contactEmail.xmltext,'adminInput',255)#
        #local.fbObj.makeText('Street Address','address','address',local.obj.company[1].address.xmltext,'adminInput',255)#
        #local.fbObj.makeText('Street Address 2','address2','address2',local.obj.company[1].address2.xmltext,'adminInput',255)#
        #local.fbObj.makeText('City','city','city',local.obj.company[1].city.xmltext,'adminInput',255)#
        #local.fbObj.makeText('State','state','state',local.obj.company[1].state.xmltext,'adminInput',255)#
        #local.fbObj.makeText('Zip','zip','zip',local.obj.company[1].zip.xmltext,'adminInput',255)#
   #local.fbObj.endForm(hasCancel=true,cancelURL='#application.baseEPath#/?company/admin')#
</cfoutput>