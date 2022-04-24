({
	searchKeyChange : function(component, event, helper)
    {
		var myEvent = $A.get("e.c:SearchBarEvent");
        myEvent.setParams({"searchKey": event.target.value});
        myEvent.fire();
	}
})