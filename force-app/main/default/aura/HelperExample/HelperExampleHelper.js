({
	helperMethod : function(component, event) {
		var btn=event.getSource();     //returns the element on which event is invoked
        var label=btn.get("v.label");
        var result= 'You have invoked an action on '+label;
        component.set("v.message", result);
	}
})