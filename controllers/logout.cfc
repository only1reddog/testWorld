component{
	public void function init(){
        //clear session variables logging out user
        structClear(session);
        
        //user check
        session.userLoggedIn = 0;
    }
}