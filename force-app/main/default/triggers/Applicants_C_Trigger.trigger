trigger Applicants_C_Trigger on Applicants_Form__c (before insert, after insert, after update) 
{
    if(trigger.isBefore && !PrithviAssignmentTriggerHelper.runOnce)
    {
        PrithviAssignmentTriggerHelper.validateSingleApplicant(trigger.new);   //PrithviAssignment2Task1
        PrithviAssignmentTriggerHelper.runOnce=true;
    }
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate) )
    {
        PrithviAssignmentTriggerHelper.updateJobFieldAfterInsertOrUpdateNewApplicant(trigger.new);   //PrithviAssignment2Task2,3
    }
}