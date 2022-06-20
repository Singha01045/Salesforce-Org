({
    init: function (component, event, helper) {
        /*component.set('v.loading', true);
        var action = component.get('c.getDataForUI');
        action.setParams
        ({ 
            recId: component.get("v.recordId")
        });
        action.setCallback(this, function(response)
        {
        var state=response.getState();
        alert(state);
        if(state ==='SUCCESS' || state === 'DRAFT')
        {
            var result=response.getReturnValue();
            component.set("v.FirstName",'getDataForUI.fName')
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
        
        $A.enqueueAction(action);*/
    },
 
	handleSuccess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Sample Created",
            "message": "Record ID: " + event.getParam("id")
        });
    },
    
     handleError: function (component, event, helper) {
        component.set('v.loading', false);
        $A.get("e.force:showToast")
        .setParams({
            type: 'error',
            mode: 'pester',
            message: 'An undefined error has occured' }).fire();
    },
    
    handleLoad: function(component, event, helper) {
        component.set('v.loading', false);
    },
 
    /*handleSubmit: function(component, event, helper) {
        event.preventDefault();
    }*/

})