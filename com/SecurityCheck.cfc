component hint="I check for authorized admin users"{
	public void function init(){
		if(session.userLoggedIn){
            if(!session.userObj.getIsActive() || session.userObj.getIsDeleted()){ //inactive or deleted user account
            	session.userLoggedIn=0;
                location("/?security",false);
            }
            if(session.userObj.getRole() NEQ 0 && session.userObj.getRole() NEQ 1){ //not an admin or editor
                location("/?security",false);
            }
        }
        else{
        	location("/?login",false);
        }
    }
}
