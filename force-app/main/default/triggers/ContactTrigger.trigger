trigger ContactTrigger on Contact (before insert, after insert, after delete, after update, before update)
{
    /*if(trigger.isAfter && (trigger.isInsert || trigger.isDelete))
    {
        //AjeetAssignmentTriggerHelper.getTotalContacts(trigger.new, trigger.old);             //Ajeet Old Assignment 
    }

    if(trigger.isBefore && trigger.isInsert)
    {
       // Practice.practice7(trigger.new);
    }

    if(trigger.isAfter && trigger.isUpdate)
    {
        AjeetAssignmentTriggerHelper.updateAccFieldOnContactAfterUpdateInsert(trigger.new);     //Ajeet Aassignment 5
       // AjeetAssignmentTriggerHelper.assignment1ContactTriggerAfterInsertUpdate(trigger.new);     //Ajeet Assignment 1
    } */
    
    
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate))
     {
         //AjeetAssignmentTriggerHelper.updateContactFieldAfterInsertUpdateAccountField(trigger.new);   //Ajeet Assignment2   
     }
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate))
     {
         List<Contact> contactList = New List<Contact>();
         List<Task> taskList = New List<Task>();
         for(Contact conRec : trigger.new)
         {
             Task createTask = New Task();
             createTask.whoId = conRec.Id;
             createTask.Subject = 'Task Created on Contact Insertion or Updation...';
             taskList.add(createTask); 
             //contactList.add(conRec);
         }
         insert taskList;  
     }
    
}