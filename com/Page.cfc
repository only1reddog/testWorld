component accessors="true" hint="Make me a page, man"{
	public any function init(template,params){
    	local.html='';
    	structDelete(variables,"init");
        structDelete(variables,"this");
        structAppend(variables,arguments.params);
        savecontent variable="local.html"{
            include arguments.template;
        }
        return local.html;
    }
}