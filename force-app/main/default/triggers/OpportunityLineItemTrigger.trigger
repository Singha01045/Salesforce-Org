/**
 * Author: DeaGle
 */
trigger OpportunityLineItemTrigger on OpportunityLineItem (before update) {
    SObject_Trigger_Control__c triggerConfig = SObject_Trigger_Control__c.getValues('OpportunityLineItem');
    if(triggerConfig != null && triggerConfig.Trigger_Status__c) {
        OpportunityLineItemTriggerHandler handlerInstance = OpportunityLineItemTriggerHandler.getInstance();
        if(Trigger.isBefore && Trigger.isUpdate) {
            handlerInstance.onBeforeUpdate(Trigger.New, Trigger.OldMap);
        }
    }
}