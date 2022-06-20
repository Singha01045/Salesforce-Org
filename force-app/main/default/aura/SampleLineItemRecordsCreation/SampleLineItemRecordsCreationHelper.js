({
    addRecord: function(component, event) {
        debugger;
        var recordList = component.get("v.SampleLineItemList");
        var SLICount = component.get("v.SamplelineItemSize");
        
        if(recordList.length <(6-SLICount)){
            recordList.push({"record":{
                'Product__c': '',
                'Quantity__c': '',
                'Qunatity_Unit__c': '',
                'Packaging_Quantity__c': '',
                'Packaging_Unit__c': '',
                'Current_Shelf_Life__c': '',
                'Expected_Shelf_Life__c': ''
            },"lookupObj":{}});
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Warning',
                message: 'You can add maximum 6 Sample Line Items to a sample.',
                duration:' 5000',
                key: 'info_alt',
                type: 'warning',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }         
        component.set("v.SampleLineItemList", recordList);
    }
})