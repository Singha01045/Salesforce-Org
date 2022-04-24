trigger University_C_Trigger on University__c (before delete) 
{
    YouTubeReferenceTriggerHelper.beforeDeleteCheckEmployeeStatus(trigger.old);
}