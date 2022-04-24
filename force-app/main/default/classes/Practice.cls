public class Practice 
{
    public void insertContactList()
    {
        list<contact> conList = new list<contact>();
        contact con1= new contact(LastName='Saif1', AccountId='0015j00000YPQuDAAX');  //
        contact con2= new contact(LastName='Saif2', AccountId='0015j00000YPQuDAAX');   //
        contact con3= new contact(LastName='Saif3', AccountId='0015j00000YPOUVAA5');  ////
        contact con4= new contact(LastName='Saif4', AccountId='0015j00000YOZOGAA5');   ///
        contact con5= new contact(LastName='Saif5', AccountId='0015j00000YPDHSAA5');    ////////////
        contact con6= new contact(LastName='Saif6', AccountId='0015j00000YPOUVAA5');    ////
        contact con7= new contact(LastName='Saif7', AccountId='0015j00000YPDHSAA5');     //////////////
        contact con8= new contact(LastName='Saif8', AccountId='0015j00000YOZOGAA5');   ///
        conList.add(con1);
        conList.add(con2);conList.add(con3);conList.add(con4);conList.add(con5);conList.add(con6);conList.add(con7);
        insert conList;  
    }
    
    //Practice1: BEFORE INSERT : When ever a case is created with origin as email then set status as new and Priority as Medium.

    public static void practice1(list<Case> caseList)    
    {
        for(Case caseRec: caseList)
        {
            if(caseRec.Origin=='Email')
            {
                caseRec.Status = 'New';
                caseRec.Priority='Medium';
            }
        }
    }
    
    //Practice2: BEFORE INSERT: When ever Lead is created with LeadSource as Web then give rating as cold otherwise hot.

    public static void practice2(list<Lead> leadList)    
    {
        for(Lead leadRec: leadList)
        {
            if(leadRec.LeadSource=='Web')
            {
                leadRec.Rating = 'Cold';
            }
            else
            {
                leadRec.Rating = 'Hot';
            }
        }
    }
    
    //Practice3: AFTER INSERT : Whenever New Account Record is created then needs to create associated Contact Record automatically.

    public static void practice3(list<account> accList)    
    {
        list<Contact> conList= new list<Contact>();
        for(account accRec: accList)
        {
            if(accRec.Industry=='Banking')
            {
                contact con= new contact();
                con.AccountId=accRec.Id;
                con.FirstName= accRec.Name;
                con.LastName=accRec.Industry;
                con.Email=accRec.Email__c;
                conList.add(con);
            }
        } 
        insert conList;
    }
    
    //Practice5: AFTER INSERT: Create the number of contacts equal to the Number of Locations field on the Account Object.

    public static void practice5(list<Account> accList)    
    {
        list<Contact> conList = new list<Contact>();
        for(Account accRec: accList)
        {
            for(Integer var=1; var<accRec.No_of_Locations__c; var++)
            {
                contact conRec= new contact();
                conRec.AccountId= accRec.Id;
                conRec.FirstName='Contact';
                conRec.LastName=' '+var;
                conList.add(conRec);
            }
        }
        insert conList;
    }
    
    //Practice6: BEFORE UPDATE: When ever Opportunity "Stage" is modified to "Closed Won" then set "Close Date" as "Today Date" and "Type" as "New Customer".
    
    public static void practice6(list<Opportunity> opplist)
    {
        for(Opportunity oppRecord: oppList)
        {
            if(oppRecord.StageName=='Closed Won')
            {
                oppRecord.CloseDate=system.today();
                oppRecord.Type='New Customer';
            }
        }
    }
    
    //Practice7: BEFORE INSERT: when a new contact is created for a existing account then set contact otherphone as account phone

    public static void practice7(list<Contact> conList)
    {
        list<Id> conId= new list<Id>(); 
        for(Contact conRecord: conList) 
        { 
            conId.add(conRecord.AccountId); 
        } 
        map<Id, Account> accList= new map<Id, Account>( [SELECT Id, Phone FROM Account WHERE Id=: conId] ); 
        for(Contact conRec: conList) 
        { 
            conRec.OtherPhone= accList.get(conRec.AccountId).Phone; 
        } 
    }
    
    //Practice 8: BEFORE INSERT UPDATE: The following Trigger will fires when we try to create the account with same name i.e. Preventing the users to create Duplicate Accounts
    
    public static void practice8(list<Account> newList)
    {
        /*//1st Method
        for(Account acc: newList)
        {           
            list<account> a =[SELECT Id, Name FROM Account WHERE Name =: acc.Name];
            if(a.size()>0)
                acc.addError('Duplicate Names Not Allowed');
        }
        
        //2nd Method
        map<Id, Account> accList= new map <Id, Account> ([SELECT Id, Name FROM Account WHERE Name != NULL]);
        for(Account accRec: newList)      
        {
             if(accRec.Name== accList.get(accRec.Id).Name && accList.size()>0)
             {
                 accRec.addError('No Duplicacy Allowed');
             }
        }*/       
        
        //3rd METHOD
        
        set<string> accNameSet = new set<String> ();
        list<Account> accList =[SELECT Id, Name FROM Account WHERE Name!=NULL];
        for(Account acc: accList)
        {
            accNameSet.add(acc.Name);
        }
        for(Account acc: newList)
        {
            if(accNameSet.contains(acc.Name))
            {
                acc.addError('Duplicate Account!!!');
            }
        }
        
    }
    
    //Practice9: BEFORE DELETE: Write a trigger in which if an account that has related contacts and the user tries to delete that account it throws you an error "Account cannot be deleted".
    
    public static void practice9(list<Account> oldList)
    {
        set<Id> accId = new set<Id>();
        for(Account acc: oldList)
        {
              accId.add(acc.Id);
        }
        map<Id, Account> accRecList= new map<Id, Account>( [SELECT Id, (SELECT AccountId FROM Contacts) FROM Account WHERE Id=: accId] );
        
        for(Account acc: oldList)
        {
            if(accRecList.get(acc.Id).Contacts.size()>0)
            {
                acc.addError('This Account cannot be deleted');
            }
        }
    }
    
    //Practice10: BEFORE INSERT UPDATE: Write a trigger on lead to prevent duplicate records based on lead email, if a record already created with the same Email, Or record is Updated. The trigger should throw an error.
    
    Public static void practice10(list<Lead> newList)
    {
        set<string> leadEmailSet = new set<string>();
        list<Lead> leadList = [SELECT Id, Email FROM Lead WHERE Email != NULL];
        for(Lead ld : leadList)
        {
            leadEmailSet.add(ld.Email);
        }
        for(Lead ld: newList)
        {
            if(leadEmailSet.contains(ld.Email))
            {
                ld.addError('DUPLICATE EMAIL');
            }
        }
        
            
    }

}