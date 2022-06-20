trigger TriggerOnOpportunity on Opportunity (before insert, after update) {
    SObject_Trigger_Control__c triggerConfig = SObject_Trigger_Control__c.getValues('Opportunity');
    if(triggerConfig != null && triggerConfig.Trigger_Status__c) {
        OpportunityTriggerHandler handlerInstance = OpportunityTriggerHandler.getInstance();
        if(Trigger.isBefore && Trigger.isInsert) {
            handlerInstance.onBeforeInsert(Trigger.New);
        }else if(trigger.isAfter && trigger.isUpdate) {
            System.debug('Trigger fired');
            handlerInstance.intiateApprovalProcess(trigger.new,trigger.oldMap);
            handlerInstance.updatePriciningOnAccount(trigger.newMap, trigger.oldMap);
        }
    }
}