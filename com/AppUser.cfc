component output="false" persistent="true" table="APPUSER" accessors="true" hint="I represent an Application User object"{
    property name="id" fieldtype="id" column="appUserID" generator="increment";
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
    property name="role" type="numeric" default="2"
    	persistent="true" fieldtype="column" column="role" sqltype="smallint" length="1";
    property name="isActive" type="Boolean" default="0"
    	persistent="true" fieldtype="column" column="isActive" sqltype="smallint" length="1";
    property name="isDeleted" type="Boolean" default="0"
    	persistent="true" fieldtype="column" column="isDeleted" sqltype="smallint" length="1";
  	property name="departmentID" type="string" getter="true" setter="true"
    	persistent="true" fieldtype="column" column="departmentID" ormtype="string" length="255";
    
    public any function init(
    		string firstName="John", string lastName="Doe", string empNo="888888", string userName="JDoe",
        	string empEmail="jdoe@jewels.com",Boolean isActive=1,Boolean isDeleted=0,role=2,departments
        ) output="false"{
		
        this.setFirstName(arguments.firstName);
        this.setLastName(arguments.lastName);
        this.setEmpNo(arguments.empNo);
        this.setUserName(arguments.userName);
        this.setEmpEmail(arguments.empEmail);
        this.setRole(arguments.role);
        this.setIsActive(arguments.isActive);
        this.setIsDeleted(arguments.isDeleted);
        if(isDefined('arguments.departments')){
	        this.setDepartments(arguments.departments);
		}
	
    	return this;
    }
}