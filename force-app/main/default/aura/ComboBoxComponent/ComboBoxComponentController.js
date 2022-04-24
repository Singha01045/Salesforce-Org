({
	handleChange : function(component, event, helper) 
    {
		var event = component.getEvent("picklistEvent");
        event.setParams({
            "selectedValue" : component.get("v.selectOption")
        })
        event.fire();
	}
})