component output="false" persistent="true" table="EMPLOYEE" accessors="true" hint="I represent an Employee object"{
    property name="id" fieldtype="id" column="employeeID" generator="increment";
	property name="firstName" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="firstName" ormtype="string" length="255";
	property name="lastName" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="lastName" ormtype="string" length="255";
	property name="empNo" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="empNo" ormtype="string" length="255";
	property name="userName" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="userName" ormtype="string" length="255";
	property name="empEmail" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="empEmail" ormtype="string" length="255";
    property name="isActive" type="Boolean" default="0"
    	persistent="true" fieldtype="column" column="isActive" sqltype="smallint" length="1";
    property name="isDeleted" type="Boolean" default="0"
    	persistent="true" fieldtype="column" column="isDeleted" sqltype="smallint" length="1";
	
	property name="department" fieldtype="many-to-one" fkcolumn="departmentID" cfc="Department";

    
    public any function init(
    		string firstName="John", string lastName="Doe", string empNo="888888", string userName="JDoe",
        	string empEmail="jdoe@jewels.com",Boolean isActive=1,Boolean isDeleted=0,department
        ) output="false"{
		
        this.setFirstName(arguments.firstName);
        this.setLastName(arguments.lastName);
        this.setEmpNo(arguments.empNo);
        this.setUserName(arguments.userName);
        this.setEmpEmail(arguments.empEmail);
        this.setIsActive(arguments.isActive);
        this.setIsDeleted(arguments.isDeleted);
        if(isDefined('arguments.department')){
	        this.setDepartment(arguments.department);
		}
	
    	return this;
    }
}