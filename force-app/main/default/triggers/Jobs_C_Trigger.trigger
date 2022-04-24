trigger Jobs_C_Trigger on Jobs__c (before update, after update)
{
    if(trigger.isUpdate && (trigger.isBefore || trigger.isAfter) )
    {
        PrithviAssignmentTriggerHelper.validateJobFieldAfterBeforeUpdate(trigger.new);   //PrithviAssignment2Task4
    }

}