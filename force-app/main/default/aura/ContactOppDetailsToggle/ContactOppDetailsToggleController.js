({
    //CONTACTS METHODS
    displayContact : function(component, event, helper) 
    {
        
        //Step 1
        var action = component.get("c.getContactList");  //returns object of Action Class
        
        //Step 2
        action.setParams({ accId: component.get("v.recordId") });
        
        //Step 4
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                component.set('v.columns', 
                [
                    {label: 'Contact ID', fieldName: 'Id', type: 'text'},
                    {label: 'First Name', fieldName: 'FirstName', type: 'text'},
                    {label: 'Last Name', fieldName: 'ContactUrl', type: 'url', typeAttributes: {label: {fieldName: 'LastName'}}},
                    {label: 'Phone', fieldName: 'Phone', type: 'phone', cellAttributes: { iconName: 'utility:phone_portrait'}}
                ]);
                
                var lstContacts = response.getReturnValue();
                lstContacts.forEach(function(item)
                {
                    item['ContactUrl'] = '/lightning/r/Contact/' +item['Id'] +'/view';
                });
                
                component.set("v.ContactList", response.getReturnValue());
                component.set("v.toggle" , true);
            }
            else 
            {
                console.log("Failed with state: " + state);
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    
    fireContactEvent : function(component, event, helper) 
    {
        $A.enqueueAction(component.get('c.displayContact'));
        var appEvent = $A.get("e.c:DisplayFormOnButtonClickApplicationEvent");
        appEvent.setParams ({"showContactForm": true});
        appEvent.fire();
	},
    
    searchContact: function(component, event) 
    {
        var searchKey = event.getParam("searchKey");
        var action = component.get('c.findContactByName');
        action.setParams({
            "searchConKey": searchKey,
            accId:component.get('v.recordId')
        });
        action.setCallback(this, function(a) {
            component.set("v.ContactList", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    //OPPORTUNITY METHODS
    displayOpportunity : function(component, event, helper) 
    {
        component.set('v.columns', 
                      [
                          {label: 'Opportunity ID', fieldName: 'Id', type: 'text' },
                          {label: 'Opportunity Name', fieldName: 'Name', type: 'text' },
                          {label: 'Stage Name', fieldName: 'StageName', type: 'text' },
                          {label: 'Close Date', fieldName: 'CloseDate', type: 'date' }
                      ]);
        
        var action = component.get("c.getOppList");
        action.setParams
        ({
            accId: component.get("v.recordId")
        });
        
        action.setCallback(this, function(data) 
                           {
                               component.set("v.OppList", data.getReturnValue());
                               component.set("v.toggle" , false);
                           });
        $A.enqueueAction(action);
    },
    
    fireOpportunityEvent : function(component, event, helper) 
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