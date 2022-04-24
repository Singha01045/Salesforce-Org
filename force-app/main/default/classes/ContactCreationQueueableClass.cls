public with sharing class ContactCreationQueueableClass implements Queueable
{

    private list<Account> accListToCreateContacts;
    public ContactCreationQueueableClass ( List<Account> expectingAccountsFromTrigger )
    {
        this.accListToCreateContacts = expectingAccountsFromTrigger;
    }

    public void execute (QueueableContext qContext) 
    {
       list<Contact> conListToBeInserted = new list<Contact>();
       for(Account accRec: accListToCreateContacts )
       {

           Contact conRec = new Contact();
           conRec.LastName= accRec.Name;
           conRec.AccountId = accRec.Id;
           conListToBeInserted.add(conRec);
       }
       if( conListToBeInserted.size()>0 )
       INSERT conListToBeInserted;
       system.debug('Im inside Queue 1');
        
       system.enqueueJob( new q2JOB() );
       //system.enqueueJob( new q3JoB() );   // Only one Queueable Job can be invoked from another...
        
    }


    /*public void execute (QueueableContext qContext) 
    {
        //Write your logic that needs to be run in the background... 
        DELETE [SELECT Id, Roll_ID__c FROM University__c WHERE Roll_ID__c = 1];
        system.enqueueJob( new ChildQueueableClass() );
    }*/
}