component output="false" persistent="true" table="DEPARTMENT" accessors="true" hint="I represent a Department object"{
    property name="id" fieldtype="id" column="departmentID" generator="increment";
	property name="departmentName" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="departmentName" ormtype="string" length="255";
    property name="isActive" type="Boolean" default="0"
    	persistent="true" fieldtype="column" column="isActive" sqltype="smallint" length="1";
    property name="isDeleted" type="Boolean" default="0"
    	persistent="true" fieldtype="column" column="isDeleted" sqltype="smallint" length="1";
    
    public any function init(
    		string departmentName="Generic Department",Boolean isActive=1,Boolean isDeleted=0
        ) output="false"{
		
        this.setDepartmentName(arguments.departmentName);
        this.setIsActive(arguments.isActive);
        this.setIsDeleted(arguments.isDeleted);
	
    	return this;
    }
}