({
	handleShowMessage : function(component, event, helper) 
    {
		component.find("messages").showMsg("Confirmation Message");  //calling via method name of Child Component
	},
    handleError : function(component, event, helper) 
    {
		component.find("messages").showError("Error Message");
	},
    handleRemoveMessage : function(component, event, helper) 
    {
	   component.find("messages").remove();
	}
})