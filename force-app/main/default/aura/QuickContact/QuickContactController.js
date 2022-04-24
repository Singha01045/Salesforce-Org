({
    doSave : function(component, event, helper) 
    {
        var action = component.get('c.createContact');
        action.setParams
        ({ 
            con: component.get('v.createCon'), 
            accId: component.get("v.recordId")
        });
        action.setCallback(this, function(response)
        {
        var state=response.getState();
        alert(state);
        if(state ==='SUCCESS' || state === 'DRAFT')
        {
            var result=response.getReturnValue();
        }    
        else if(state ==='ERROR')
        {
            var err= response.getError();
            console.log("Error Array: " , err)
            console.log("Error Array: " , err[0].duplicateResults)
            console.log("Error Array: " , err[0].fieldErrors)
            console.log("Error Array: " , err[0].pageErrors)
        }
        }, 'ALL' );
        
        $A.enqueueAction(action);

    },
    handleEvent : function(component, event, helper) 
    {
		component.set("v.show", event.getParam("showContactForm"));
	}
})