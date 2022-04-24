public class FetchingRecordsViaQueries 
{
    public void getContactSizeFromAccount(String AId)
    {
              Account acc= [SELECT Id, Name,(SELECT FirstName, LastName FROM Contacts) FROM Account WHERE Id=:AId];
              if(acc.Contacts.size()>0)
                {
                    System.debug(acc.Contacts.size());
                }
                else
                {
                    System.debug('No Contact');
                }
    }
    
    public void fetchingContactRecords()
    {
        String str='IT';
        Contact[] con= [SELECT FirstName,LastName FROM Contact WHERE Department=:str];
        System.debug(con);
    }
    
    //Fetching Records Dynamically
    public list<sObject> fetchRecordDetials(String recID, String recName)
    {
        try
        {
            if(recID!=NULL)
            {
                if(recName=='CONTACTS')
                {
                    return [SELECT Id, Name, (SELECT FirstName, LastName, Phone FROM Contacts) FROM Account WHERE Id=:recID].Contacts;
                }
                else if(recName=='OPPORTUNITIES')
                {
                    return [SELECT Id, Name,(SELECT Name, Amount, CloseDate, StageName FROM Opportunities) FROM Account WHERE Id=:recID].Opportunities;
                    
                }
                else
                {
                    return NULL;
                }
            }
            else
            {
                return NULL;
            }
        }
        
        catch(Exception e )
        {
            return NULL;
        }
    }
    //Fetching Contact Records by applying sub-query on Account
    public void getAllContactRecords()
    {
        Account[] accRecordList=[SELECT Name, Phone,(SELECT FirstName, LastName FROM Contacts) FROM Account];
        
        for(Account accRecord:accRecordList)
        {
            System.debug('Account record: ' + accRecord.Name);
            if(accRecord.Contacts.size()>0)
            {
                List<Contact> conList = accRecord.Contacts;
                System.debug('Total Contacts :' + conList.size());
                for(Contact con :conList)
                {
                    System.debug('@@@@ Contact fn: '+con.FirstName +'!!!!!! Contact ln: '+con.LastName);
                }
            }
            else
            {
                System.debug('No Contact Record Found for This Account');
            }
        }
    }
    
    public void fetchLeadRecords(String leadId)
    {
       Lead l1=new Lead();
       l1=[SELECT FirstName, LastName, Company, Phone From Lead WHERE Id=:leadId];
       system.debug(l1);
    }
}

/*
================Fetching Related Account Name by querying on Contact===============================
Contact[] cts=[SELECT FirstName, LastName FROM Contact WHERE FirstName='Jeff' AND LastName='Bezos'];
Contact c=cts[0];
String res=c.Account.Name;
System.debug(res);
*/