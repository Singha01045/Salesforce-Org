({
    /*======REDUNDANCY=======
	show : function(component, event, helper) {
        var btn=event.getSource();     //returns the element on which event is invoked
        var label=btn.get("v.label");
        var result= 'You have invoked an action on '+label;
        component.set("v.message", result);
	},
    display: function(component, event, helper){
        var btn=event.getSource();     //returns the element on which event is invoked
        var label=btn.get("v.label");
        var result= 'You have invoked an action on '+label;
        component.set("v.message", result);
    }*/
    
    show : function(component, event, helper) {
       helper.helperMethod(component, event);
	},
    display: function(component, event, helper){
        helper.helperMethod(component, event);
    }
    
})