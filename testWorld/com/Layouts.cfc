component output="false" persistent="true" table="LAYOUTS" accessors="true" hint="Chrome object for the site"{
    property name="id" fieldtype="id" column="layoutID" generator="increment";
	property name="layoutName" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="layoutName" ormtype="string" length="255";
    property name="numRegions" type="numeric" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="numRegions" ormtype="integer" length="10";
    property name="isActive" type="Boolean" default="0"
    	persistent="true" fieldtype="column" column="isActive" sqltype="smallint" length="1";
    property name="isDeleted" type="Boolean" default="0"
    	persistent="true" fieldtype="column" column="isDeleted" sqltype="smallint" length="1";

	public any function init(layoutName="Common",numRegions=1,isActive=true,isDeleted=false){
        this.setLayoutName(arguments.layoutName);
        this.setNumRegions(arguments.numRegions);
        this.setIsActive(arguments.isActive);
        this.setIsDeleted(arguments.isDeleted);
        
        return this;
    }
}