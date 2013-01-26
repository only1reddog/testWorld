component output="false" persistent="true" table="PAGEREGION" accessors="true" hint="Page Regions"{
    property name="id" fieldtype="id" column="pageRegionID" generator="increment";
	property name="regionName" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="regionName" ormtype="string" length="255";

	property name="regionType" fieldtype="many-to-one" fkcolumn="regionTypeID" cfc="PageRegionType";

	property name="regionText" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="regionText" ormtype="text" length="4000";
    property name="orderby" type="numeric" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="orderby" ormtype="integer" length="10";
    property name="isActive" type="Boolean" default="0"
    	persistent="true" fieldtype="column" column="isActive" sqltype="smallint" length="1";
    property name="isDeleted" type="Boolean" default="0"
    	persistent="true" fieldtype="column" column="isDeleted" sqltype="smallint" length="1";
                
    public any function init(
    		string regionName="Default Region", regionType, numeric orderby=0, Boolean isActive=false, Boolean isDeleted=false, string regionText="Default body text"
        ) output="false"{
		
        this.setRegionName(arguments.regionName);
        if(isDefined('arguments.regionType')){
	        this.setRegionType(arguments.regionType);
		}
        this.setRegionText(arguments.regionText);
        this.setOrderby(arguments.orderby);
        this.setIsActive(arguments.isActive);
        this.setIsDeleted(arguments.isDeleted);
	
    	return this;
    }
}