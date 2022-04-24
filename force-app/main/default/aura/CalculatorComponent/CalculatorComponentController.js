({
	handleClick : function(component, event, helper) 
    {
        var sum = parseInt(component.get("v.firstNumber")) + parseInt(component.get("v.lastNumber"));
        var appEvent = $A.get("e.c:LightningApplicationEvent");
        appEvent.setParams ({"sumResult": sum});
        appEvent.fire();	
	}
})