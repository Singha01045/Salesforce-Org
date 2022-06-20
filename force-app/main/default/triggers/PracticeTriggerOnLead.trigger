trigger PracticeTriggerOnLead on Lead (before insert, before update, after update) 
{
    //Practice.practice2(trigger.new);
    /*if(trigger.isAfter && trigger.isUpdate)
    {
        List<Lead> leadList = New List<Lead>();
        List<Task> taskList = New List<Task>();
        map<Id, lead> oldLeadMap = new map<Id, Lead>(trigger.old);
        for(Lead leadRec : trigger.new)
        {
            
            if(leadRec.Follow_up_Date__c != oldLeadMap.get(leadRec.id).Follow_up_Date__c && leadRec.Follow_up_Date__c >= System.TODAY())
            {
                leadList.add(leadRec);
                Task createTask = New Task();
                createTask.whoId = leadRec.id;
                createTask.OwnerId = leadRec.OwnerId;
                createTask.Subject = 'Do The Follow-up with Customer';
                //createTask.ActivityDate = leadRec.Follow_up_Date__c;
                createTask.ReminderDateTime = leadRec.Follow_up_Date__c;
                taskList.add(createTask); 
            }
            else
            {
                leadRec.addError('Cannot Update the Record as Past Follw-Up Date is not supported by system, Please select either today date or future date');
            }
        }
        insert taskList;
    }*/
    
    
    //ISAAAAAAA
    if(trigger.isBefore)
    {
        if(trigger.isUpdate){
            Helper.triggerHelper1(trigger.newMap, trigger.oldMap);
        }
        //Practice.practice10(trigger.new);
        
        /*list<string> leadEmail= new list<string>();
        for(Lead ld: trigger.new)
        {
            leadEmail.add(ld.Email);
        }
        
        list<Lead> leadList = [SELECT Id, Email FROM Lead WHERE Email=: leadEmail];
        for(Lead ld: trigger.new)
        {
            if(trigger.isInsert)
            {
                if(leadList.size()>0) { ld.addError('Duplicate Email'); }
            }
            if(trigger.isUpdate)
            {
                for(Lead ldd: trigger.old)
                {
                    if(ldd.Email != ld.Email && leadList.size()>0) { ld.addError('Duplicate'); }
                }
            }
        }  */
    }
    
}