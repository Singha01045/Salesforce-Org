public class YouTubeReferenceTriggerHelper 
{
    //========== Using Before Insert to populate Rating field of Account as Warm based on the condition.
    Public Static Void beforeInsertChangingAccountField(List<Account> newList)
    {
            for(Account acc: newList)
            {
                if(acc.Industry=='Media')
                {
                    acc.Rating='Cold';
                }
            }  
    }
    
    //=============Using After Insert to create related Opportunity when Account is created.============
    Public Static void afterInsertCreatingOpportunity(list<account> accList)   //through this list, we can have ids of each account
    {
        list<Opportunity> oppList= new list<Opportunity>(); 
        for(Account acc: accList)
        {
            opportunity oppRecord= new opportunity();
            oppRecord.Name=acc.name;
            oppRecord.accountId=acc.Id;
            oppRecord.stageName='Prospecting';
            oppRecord.CloseDate=system.today();
            oppList.add(oppRecord);   
        } 
        if(!oppList.isEmpty())
        {
            insert oppList;
        }
    }

    //=============Using Before Update to display description when Account's phone is modified.============
    
    Public Static Void beforeUpdateDisplayingMessage(List<Account> newList, Map<id, account> oldList)
    {
            for(Account acc: newList)
            {
                if( oldList !=Null && acc.Phone != oldList.get(acc.Id).Phone ) //oldList !=Null : performing update operation   acc.Phone=new state of phone    oldList.get(acc.Id).Phone: existing value of phone
                {
                    acc.Description='Phone number has been updated on Account';
                }
            }  
    }
    
    /*Public Static void afterUpdateRelatedOpportunityField(list<account> accList, map<id, account> oldList)   //through this list, we can have ids of each account
    {
        map<id, account> accIdToAccountMap= new map<id, account>(); 
        list<opportunity> oppList = new list<opportunity>();
        for(Account acc: accList)
        {
            if( oldList !=Null && acc.Phone != oldList.get(acc.Id).Phone )
            {
                accIdToAccountMap.put(acc.id, acc);
            }  
        } 
        oppList= [SELECT Id, Phone FROM Opportunity WHERE ]
        
    }*/
    
    //===========Using Before Dlt to not dlt employee records if active is true================
    
    public static void beforeDeleteCheckEmployeeStatus(list<University__c> oldList)
    {
        for(University__c uni : oldList)
        {
            if(uni.Active__c== TRUE)
            {
                uni.addError('Active Record Cannot be dltd');
            }
        }
    }
    
    

       
    
}