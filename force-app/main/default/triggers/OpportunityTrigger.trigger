trigger OpportunityTrigger on Opportunity (after insert, after update, before update) 
{
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate))
        {
            //AjeetAssignmentTriggerHelper.updateAccountFieldAfterInsertUpdateOppField(trigger.new);             //Ajeet Assignment 4
        }
    if(trigger.isUpdate && trigger.isBefore)
    {
        //Practice.practice6(trigger.new);
    }
}