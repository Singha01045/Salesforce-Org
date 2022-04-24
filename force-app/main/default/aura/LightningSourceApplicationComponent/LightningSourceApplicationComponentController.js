({
	handleOwnApplicationEvent : function(component, event, helper) {
		var id=component.get('v.id');
        alert('Application Event is in Source Component '+id);
        //event.preventDefault();
	},
    fireOwnApplicationEvent : function(component, event, helper) {
        var appEvent= $A.get('e.c:LightningApplicationEvent');
        appEvent.setParams({
            message: 'Hello'
        })
        alert("Firing");
        appEvent.fire();
	}
})