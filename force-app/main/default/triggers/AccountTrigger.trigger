trigger AccountTrigger on Account (before insert, after insert, before update, after update, after delete, before delete)
{
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            //AjeetAssignmentTriggerHelper.updateAccFieldAfterInsertUpdateContact(trigger.new);    //AjeetAssignemnt1
            system.enqueueJob(new ContactCreationQueueableClass(Trigger.new));   //Trigger.new has list of accounts thet are inserted...
        }
        if(trigger.isUpdate) 
        {
           //AjeetAssignmentTriggerHelper.updateContactFieldAfterUpdateAccountField(trigger.new);   //AjeetAssignment3
        }
        
    }
    
   /* if(trigger.isAfter && trigger.isUndelete || (trigger.isBefore && trigger.isDelete))
    {
        PrithviAssignmentTriggerHelper.UpdateDateTimeFieldOnAccountBeforeDeleteAfterUndelete(trigger.newMap, trigger.oldMap);    //PrithviAssignemnt1
    }
    
    //YouTube Examples
    if(trigger.isInsert)
    {
        if(trigger.isBefore)
        {
            YouTubeReferenceTriggerHelper.beforeInsertChangingAccountField(trigger.new);
        }
        else if(trigger.isAfter)
        {
            YouTubeReferenceTriggerHelper.afterInsertCreatingOpportunity(trigger.new);    
        }
    }
    
    if(trigger.isUpdate)
    {
        if(trigger.isBefore)
        {
            YouTubeReferenceTriggerHelper.beforeUpdateDisplayingMessage(trigger.new, trigger.oldMap);
        }
        else if(trigger.isAfter)
        {
            //YouTubeReferenceTriggerHelper.afterUpdateRelatedOpportunityField(trigger.new, trigger.oldMap);    
        }
    }
    
    
    //Examples
    if(trigger.isAfter && trigger.isInsert)
    {
        //Practice.practice3(trigger.new);
        Practice.practice5(trigger.new);

    }
    
    if(trigger.isBefore)
    {
        if(trigger.isInsert || trigger.isUpdate)
        {
          // Practice.practice8(trigger.new);
        }
        
        list<string> accListSet = new list<string>();
        for(Account acc:Trigger.new)
        {
            accListSet.add(acc.name);
        }
        list<Account> listOfDuplicateAccounts = [select Id, Name FROM Account WHERE Name in :accListSet];
        for(Account acc:trigger.new)
        {
            if(trigger.isInsert)
            {
                if(listOfDuplicateAccounts.size()!=0)
                {
                    acc.addError('Insert Different Name as Account already exists with this name');
                }
            }
            if(trigger.isUpdate)
            {
                for(Account oldaccount :trigger.old)
                {
                    if(acc.Name != oldAccount.Name && listOfDuplicateAccounts.size()!=0)
                    {
                        acc.addError('Update with New Name as Account already exists with this name');
                    }
                }
            }
        }
    }
    
    if(trigger.isBefore && trigger.isDelete)
    {
       // Practice.practice9(trigger.old);
    }*/
}