public class BatchClassAccount implements Database.Batchable<SObject>
{
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        //Query all the records at once...
        return Database.getQueryLocator('Select ID, Name, Type From Account  WHERE Type = NULL LIMIT 1');
    }
    public void execute(Database.BatchableContext bc, List<Account> subListFromStartMethod)
    {
        //Processes 2000 records at a time...
        for(Account accRec:subListFromStartMethod)
        {
            //accRec.BillingStreet = '1234 Main Street, Apartment 101';
            //accRec.BillingCountry = 'USA';
            //accRec.BillingState = 'Texas';
            DELETE accRec;
        }
        //DELETE subListFromStartMethod;
        
    }
    public void finish(Database.BatchableContext bc)
    {
        //Any post processing logic goes here like Sending Email...
        System.debug('@@ Batch Job Completed');
        //Database.executeBatch(new BatchClassContact(), 1);
    }
}

//Select ID, Name, BillingStreet, BillingCountry, BillingState From Account WHERE BillingState ='Texas' LIMIT 10