public class AjeetAssignmentTriggerHelper 
{
    /* //Counting Total No of Contacts inside a particular Account
    public static void getTotalContacts(list<contact> newList, list<contact> oldList)
    {
        set<Id> accountsID= new set<Id>();
        if(newList != Null)             //used for dlt    
        {
            for(contact con: newList)
            {
                if(con.AccountId != Null)
                {
                    accountsID.add(con.AccountId);
                }
            }
        }
        if(oldList!=Null)              //used for new insert and new update
        {
            for(contact con: oldList)
            {
                if(con.AccountId!=Null)
                {
                    accountsID.add(con.AccountId);
                }
            }
        }
        
        list<Account> accList = [SELECT Id, Total_No_of_Contacts__c,(SELECT Id FROM Contacts) FROM Account WHERE Id =: accountsID];
        if(!accList.isEmpty())
        {
            for(Account acc: accList)
            {
                acc.Total_No_of_Contacts__c = acc.Contacts.size(); 
            }
        }
        update accList;
    }    
    
    
    //Ajeet Assignment 1 : When the Account has more than 1 Contact, update Only_Default_Contact to FALSE.
    
    public static void updateAccFieldAfterInsertUpdateContact(list<Account> accList)
    {
        List<Id> accIds = new List<Id>();
        List<Account> accRecords = [Select id, name from account Where id In :  accList];
        for(Account acc:accRecords)
        {
            contact conRecord= new contact();
            conRecord.AccountId=acc.Id;
            conRecord.FirstName='Info';
            conRecord.LastName='Default';
            conRecord.Email='info@websitedomain.ltd';
            insert conRecord;
            accIds.add(acc.Id);
        }
        List<Account> accListToUpdate =[SELECT Id, Only_Default_Contact__c FROM Account WHERE Id IN :accIds];
        for(Account acc:accListToUpdate)
            acc.Only_Default_Contact__c=true;
        update accListToUpdate;
    }
    
    Public static void assignment1ContactTriggerAfterInsertUpdate(list<Contact> conList)
    {
        set<Id> conId = new set<Id>();
        for(Contact conRecord: conList)
        {
            conId.add(conRecord.AccountId);
        }
        list<Account> accList =[SELECT Id, Only_Default_Contact__c FROM Account WHERE Id=:conId];
        for(Account acc: accList)
        {
            acc.Only_Default_Contact__c = false;
        }
        update accList;
    }
        
    
   //Ajeet Assignment 2 : When the Account.BillingPostalCode == Contact.MailingPostalCode, update Out_of_Zip to TRUE.
    
    public static void updateContactFieldAfterInsertUpdateAccountField(list<Contact> contactList)
    {
        //1st Method
        for(Contact conRec: contactList)
        {
            Account acc= new Account();
            conRec.AccountId= acc.Id;
            if(acc.BillingPostalCode != conRec.MailingPostalCode )
            {
                conRec.Out_of_Zip__c=true;
            }   
        }

         //2nd Method
        set<Id> contactIds = new set<Id>();
        for(Contact con: contactList)
        {
            contactIds.add(con.AccountId);

        }
        map<Id, Account> accountList = new map<Id, Account> ( [SELECT Id, BillingPostalCode, (SELECT AccountId, Out_of_Zip__c,MailingPostalCode FROM Contacts) FROM Account WHERE Id=:contactIds] );
        for(Contact con: contactList)
        {
              if(accountList.get(con.AccountId).BillingPostalCode != con.MailingPostalCode)
              {
                con.Out_of_Zip__c =TRUE;
              }           
        }   
    }
    
    
    //Ajeet Assignment 3 : When an Account is updated and the Website is filled in, update all the Profile field on all Contacts.
    
    public static void updateContactFieldAfterUpdateAccountField(list<Account> allAaccountList)
    {
        set<Id> accIds= new set<Id>();
        for(Account acc: allAaccountList)
        {
            if(acc.Website != NULL)
            {
                accIds.add(acc.Id);
            }
        }
        
        list<Contact> contactList = [SELECT Id, FirstName,Account_Website__c, LastName,AccountId, Profile__c, Account.Website FROM Contact WHERE AccountId IN: accIds ]; 
        for(Contact conRec: contactList){
            //conRec.Profile__c = conRec.Account.Website +'/'+ conRec.FirstName.split(' ')[0]+'-'+conRec.LastName;
            conRec.Profile__c = conRec.Account.Website +'/'+ conRec.FirstName.substring(0,1)+'-'+conRec.LastName;
        }
        update contactList;
    }
    
    
   //Ajeet Assignment 4 : When an Opportunity is greater than $20k, mark Account's field is_gold to TRUE
    
    public static void updateAccountFieldAfterInsertUpdateOppField(list<opportunity> oppRecordList)
    {
        //MY SOLUTION

        list<Account> accList= new list<Account>();

        for(Opportunity oppRecord : oppRecordList)
        {
            Account acc= new Account();
            acc.Id = oppRecord.AccountId;
            if(oppRecord.Amount<=20000)
            {
                acc.is_gold__c=true;
            }
            else {
                acc.is_gold__c=false;
            }
            accList.add(acc);
        }
        update accList;
  
        //AJEET SOLUTION
        List<Account> accListToBeUpdated = new List<Account>();
        Map<Id, Boolean> isGoldByAccountId = new Map<Id, Boolean>();
        for(Opportunity oppRec:oppList)
        {
              if(oppRec.Amount >=20000)
              {
                   if(isGoldByAccountId.containsKey(oppRec.AccountId))
                      isGoldByAccountId.put(oppRec.AccountId,True);
              }
        }
        for(String accId :isGoldByAccountId.keySet())
        {
              accListToBeUpdated.add(new Account(Id=accId,is_Gold__c=isGoldByAccountId.get(accId)));
        }
        update accListToBeUpdated;

     }*/
    
    //Ajeet Assignment 5 : If 70% or more of the Contacts on an Account are Dead, mark the need_intel field to TRUE
    public static void updateAccFieldOnContactAfterUpdateInsert(list<Contact> contactList)
    {
        //Getting all Unique Account Id
        set<Id> accId= new set<Id>();
        for(Contact conRec:contactList)
        {
            accId.add(conRec.AccountId);
        }
        system.debug('ID: ' + accId);  
        list<Account> acclist = new list<Account> ();
        map<Id, Integer>  accountsWithDeadContacts = new map<Id, Integer> ();
        map<Id, Integer> totalContactsInTheAccount = new map<Id, Integer> ();

        for(Account acc: [SELECT Id, Need_Intel__c, (SELECT Id, AccountId, Dead__c FROM Contacts) FROM Account WHERE Id IN: accId])
        {
            list<Contact> conList = acc.Contacts;
            totalContactsInTheAccount.put( acc.Id, conList.size() );
        }

        for(Account acc : [SELECT Id,Need_Intel__c, (SELECT Id, AccountId, Dead__c FROM Contacts WHERE Dead__c= TRUE) FROM Account WHERE Id IN: accId ])
        {
           list<Contact> conList = acc.Contacts;
           accountsWithDeadContacts.put( acc.Id, conList.size() );
           Decimal deadContactPercentage = ( (accountsWithDeadContacts.get(acc.Id) * 100) / totalContactsInTheAccount.get(acc.Id) );
           system.debug(deadContactPercentage);
           if(deadContactPercentage <= 70)
           {
               acc.Need_Intel__c =TRUE;
               accList.add(acc);
           }
           else{
            acc.Need_Intel__c =FALSE;
            accList.add(acc);
           }
        }  
        update accList;       
    }
       
}