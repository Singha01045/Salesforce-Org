({
	displayOpportunity : function(component, event, helper) 
    {
        var action = component.get("c.getOppList"); 
        action.setParams({ accId: component.get("v.recordId") });
        action.setCallback(this, function(response) 
        {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                component.set('v.columns', 
                [
                    {label: 'Opportunity ID', fieldName: 'Id', type: 'Id'},
                    {label: 'Opportunity Name', fieldName: 'Name', type: 'text'},
                    {label: 'Stage Name', fieldName: 'StageName', type: 'text'},
                    {label: 'Amount', fieldName: 'Amount', type: 'Amount'}

                ]);
                component.set("v.OppList", response.getReturnValue());
            }
            else 
            {
                console.log("Failed with state: " + state);
            }  
        });
        
        $A.enqueueAction(action);
	},
    
    fireOwnEvent : function(component, event, helper) 
    {
        $A.enqueueAction(component.get('c.displayOpportunity'));
        var appEvent = $A.get("e.c:DisplayFormOnButtonClickApplicationEvent");
        appEvent.setParams ({"showOpportunityForm": true});
        appEvent.fire();
	},
    
    searchOpportunity: function(component, event) 
    {
        var searchKey = event.getParam("searchKey");
        var action = component.get('c.findOpportunityByName');
        action.setParams({
            "searchOppKey": searchKey,
            accId:component.get('v.recordId')
        });
        action.setCallback(this, function(a) {
            component.set("v.OppList", a.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})