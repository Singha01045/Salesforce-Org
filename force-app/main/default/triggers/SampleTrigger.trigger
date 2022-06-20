/**
 * Author: DeaGle
 */
trigger SampleTrigger on Project__c (before insert) {
    SObject_Trigger_Control__c triggerConfig = SObject_Trigger_Control__c.getValues('Project__c');
    if(triggerConfig != null && triggerConfig.Trigger_Status__c) {
        SampleTriggerHandler handlerInstance = SampleTriggerHandler.getInstance();
        if(Trigger.isBefore && Trigger.isInsert) {
            handlerInstance.onBeforeInsert(Trigger.New);
        }
    }
}