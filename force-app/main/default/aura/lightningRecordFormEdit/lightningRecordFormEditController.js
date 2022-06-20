({
    handleSuccess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Account Created",
            "message": "Record ID: " + event.getParam("id")
        });
    },
	handleCreateLoad : function(component, event, helper) {
		 var nameFieldValue = component.find("recordEditForm").set("v.value", "My New Contact");
         cmp.find('recordEditForm').submit(fields);
	}

})