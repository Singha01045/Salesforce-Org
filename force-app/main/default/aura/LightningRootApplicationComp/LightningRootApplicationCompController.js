({
	handleApplicationEvent : function(component, event, helper) 
    {
		var getId= component.get('v.id');  //locker-service
        alert("Application Event is in Root Component " + getId);
        component.set('v.msg', event.getParam("message"));    
	}
})