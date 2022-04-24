({
	getPicklistValues: function(component, event) 
    {
        var action = component.get("c.getStageNameFieldValue");
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               if (state === "SUCCESS") 
                               {
                                   var result = response.getReturnValue();
                                   var fieldMap = [];
                                   for(var key in result)
                                   {
                                       fieldMap.push({key: key, value: result[key]});
                                   }
                                   component.set("v.fieldMap", fieldMap);
                               }
                           });
        $A.enqueueAction(action);
    }
})