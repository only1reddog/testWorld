function delVal(item){
	if(typeof(item)==='undefined'){
		item='item';
	}
	if(confirm('Are you sure you wish to delete this ' + item + '? This action cannot be reversed.'))
		return true;
	else{
		return false;
	}
};