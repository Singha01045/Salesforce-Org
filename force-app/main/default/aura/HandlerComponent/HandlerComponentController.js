({
	// Both Child and Parent are Handling the Event
	// Handling the Event + Setting the msg
    handleChildEventz : function(component, event, helper) 
    {
        alert(" A Child Component Fired and the Parent Component Handled me. It All Happened So Fast. Now, I'm Here! ");  
        var notify=event.getParam('message');  //getting the param from the event...
        component.set('v.msg', notify);
        //event.stopPropagation();
    }
    
    /* //Just Handling the Child Event
    handleChildEventz : function(component, event, helper) 
    {  
        var notify=event.getParam('message');  
        component.set('v.msg', notify);
    }*/
})