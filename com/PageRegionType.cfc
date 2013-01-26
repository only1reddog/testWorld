component output="false" persistent="true" table="PAGEREGIONTYPE" accessors="true" hint="Page Region Types"{
    property name="id" fieldtype="id" column="pageRegionTypeID" generator="increment";
	property name="regionTypeName" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="regionTypeName" ormtype="string" length="255";
    property name="orderby" type="numeric" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="orderby" ormtype="integer" length="10";
    property name="isActive" type="Boolean" default="0"
    	persistent="true" fieldtype="column" column="isActive" sqltype="smallint" length="1";
    property name="isDeleted" type="Boolean" default="0"
    	persistent="true" fieldtype="column" column="isDeleted" sqltype="smallint" length="1";
                
    public any function init(string regionTypeName="Default Region", numeric orderby=1, Boolean isActive=false, Boolean isDeleted=false) output="false"{
		
        this.setRegionTypeName(arguments.regionTypeName);
        this.setOrderby(arguments.orderby);
        this.setIsActive(arguments.isActive);
        this.setIsDeleted(arguments.isDeleted);
	
    	return this;
    }
}