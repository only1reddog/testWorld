component output="false" persistent="true" table="STATICPAGES" accessors="true" hint="Static Pages"{
    property name="id" fieldtype="id" column="staticPageID" generator="increment";
	property name="metaTitle" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="metaTitle" ormtype="string" length="255";
	property name="metadesc" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="metadesc" ormtype="text" length="2000";
	property name="metakeywords" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="metakeywords" ormtype="string" length="255";
	property name="linkText" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="linkText" ormtype="string" length="255";
	property name="pageName" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="pageName" ormtype="string" length="255";
	property name="pageURL" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="pageURL" ormtype="string" length="255";
	property name="parentURL" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="parentURL" ormtype="string" length="255";
    property name="orderby" type="numeric" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="orderby" ormtype="integer" length="10";
    property name="isActive" type="Boolean" default="0"
    	persistent="true" fieldtype="column" column="isActive" sqltype="smallint" length="1";
    property name="isDeleted" type="Boolean" default="0"
    	persistent="true" fieldtype="column" column="isDeleted" sqltype="smallint" length="1";
        
	property name="pageLayout" fieldtype="many-to-one" fkcolumn="layoutID" cfc="Layouts";
    property name="regions" type="array"
        persistent="true" fieldtype="one-to-many" cfc="PageRegion" fkcolumn="pageID" lazy="false" orderby="pageID,regionTypeID" cascade="save-update";
                
    public any function init(
    		string metaTitle="Default Page Title", string metadesc="", string metakeywords="", string linkText="Link Text",
            string pageName="New Page", string pageURL="", string parentURL="index", numeric orderby=0, Boolean isActive=false, 
            Boolean isDeleted=false, pageLayout
        ) output="false"{
		
        this.setMetaTitle(arguments.metaTitle);
        this.setMetadesc(arguments.metadesc);
        this.setMetakeywords(arguments.metakeywords);
        this.setLinkText(arguments.linkText);
        this.setPageName(arguments.pageName);
        this.setPageURL(arguments.pageURL);
        this.setParentURL(arguments.parentURL);
        this.setOrderby(arguments.orderby);
        this.setIsActive(arguments.isActive);
        this.setIsDeleted(arguments.isDeleted);
        if(isDefined('arguments.pageLayout')){
	        this.setPageLayout(arguments.pageLayout);
		}
    	return this;
    }
}