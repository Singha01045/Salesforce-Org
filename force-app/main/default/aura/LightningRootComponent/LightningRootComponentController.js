({
	handleChildEvent : function(component, event, helper) 
    {
        alert('Event is handled by Container/Parent Component and fired by Source/Child Component');
        var income=event.getParam('totalIncome');  //getting the param from the event...
        component.set('v.totalAmount', income); 
        //event.stopPropagation();
    }
})