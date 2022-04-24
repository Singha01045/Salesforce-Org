({
    
    //#############  EVENT HANDLING AND FIRING IN THE SAME COMPONENT  ###########
    handleOwnEvent : function(component, event, helper) 
    {
        alert(" A Child Component Fired and Handled me. It All Happened So Fast. Now, I'm Here! ");
        event.stopPropagation();
    },
   
	fireOwnEvent : function(component, event, helper) 
    {
        var ntfEvent= component.getEvent('notifyEvent');
		ntfEvent.fire();
	}
    /*
    fireOwnEvent_SetMsgForParent : function(component, event, helper)
    {
        var event= component.getEvent('notifyEvent');
        event.setParams({
            "message" : " A Child Component Fired and the Parent Handled me. It All Happened So Fast. Now, I'm Here! "
        })
        event.fire();    
    }*/
})