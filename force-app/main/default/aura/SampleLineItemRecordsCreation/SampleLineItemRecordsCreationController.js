({
    loadOptions: function (component, event, helper) {
        var opts = [
            
            { value: "mg", label: "mg" },
            { value: "gm", label: "gm" },
            { value: "Kg", label: "Kg" },
            { value: "Tonne", label: "Tonne" },
            { value: "MT", label: "MT" }
        ];
        component.set("v.options", opts);
        var action = component.get("c.SampleLineItemCount");
        var currentRecordId = component.get("v.recordId");
        action.setParams({
            'sampleRecordId': currentRecordId
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse == 6){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Warning',
                        message: 'You can Add 6 Sample Line Items at one time.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'warning',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                }
                else if(storeResponse <6){
                    component.set("v.SamplelineItemSize", storeResponse);
                    
                }
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
    
    addRow: function(component, event, helper) {
        
        helper.addRecord(component, event);
    },
    
    removeRow: function(component, event, helper) {
        
        debugger;
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        var idtoDelete = selectedItem.dataset.index;
        var recordList = component.get("v.SampleLineItemList");    
        
        if(recordList.length>1){
            recordList.splice(index, 1);
            component.set("v.SampleLineItemList", recordList);
        }else{
            component.set("v.SampleLineItemList",[{"record":{
                'Product__c': '',
                'Quantity__c': '',
                'Qunatity_Unit__c': '',
                'Packaging_Quantity__c': '',
                'Packaging_Unit__c': '',
                'Current_Shelf_Life__c': '',
                'Expected_Shelf_Life__c': ''
            },"lookupObj":{}}]
                         );
        }
        
        if(idtoDelete != undefined){
            var deleteEvent = component.getEvent("deleteEvent");
            deleteEvent.setParams({"IdsTodelete" : idtoDelete });
            deleteEvent.fire();
        }
        
    },
    
    SaveSampleDetails : function(Component, helper, event){
        debugger;
        var SampleDetails = Component.get("v.SampleLineItemList");
        var CurrentRecId = Component.get("v.recordId");
        
        var allRecords = [];
        for(var i=0; i<SampleDetails.length; i++){
            if(SampleDetails[i].record.Product__c !== '' || SampleDetails[i].record.Quantity__c !== '' || SampleDetails[i].record.Qunatity_Unit__c !== '' || SampleDetails[i].record.Packaging_Quantity__c !== '' || SampleDetails[i].record.Packaging_Unit__c !== ''){
                var tempVal = SampleDetails[i].record;
                tempVal.Sample__c = CurrentRecId;
                tempVal.Product__c = SampleDetails[i].lookupObj.Id;
                allRecords.push(tempVal);
                
            }
            /*else if(SampleDetails[i].record.Product__c !== null || SampleDetails[i].record.Quantity__c !== null || SampleDetails[i].record.Qunatity_Unit__c !== null || SampleDetails[i].record.Packaging_Quantity__c !== null || SampleDetails[i].record.Packaging_Unit__c !== null){
                var tempVal = SampleDetails[i].record;
                tempVal.Sample__c = CurrentRecId;
                tempVal.Product__c = SampleDetails[i].lookupObj.Id;
                allRecords.push(tempVal);
                
            }*/
            
        }
        
        var action = Component.get("c.SampleLineItemcreation");
        if(allRecords.length>0){
            // set param to method  
        action.setParams({
            'SLIRecords': allRecords
        });
        
        // set a callBack    
        action.setCallback(this, function(response) {
            //$A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Sample Line Item(s) Have been created',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                
                // if storeResponse size is equal 0 ,display No Result Found... message on screen. }
                if (storeResponse.length == 0) {
                    Component.set("v.Message", 'No Result Found...');
                } else {
                    Component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                //component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
            
        }
        else {
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Warning',
                    message: 'All record(s) are Empty',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'warning',
                    mode: 'sticky'
                });
                toastEvent.fire();
            
        }
        
    },
    
    CloseQuickAction : function(Component, helper, event){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})