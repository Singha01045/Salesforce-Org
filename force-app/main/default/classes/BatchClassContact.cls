public class BatchClassContact implements Database.Batchable<SObject>
{
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('Select ID, LastName From Contact LIMIT 10');
    }
    
    public void execute(Database.BatchableContext bc, List<Contact> subListFromStartMethod)
    {
        for(Contact conRec:subListFromStartMethod)
        {
            conRec.LastName = 'John';
        }
        Update subListFromStartMethod;   
    }
    
    public void finish(Database.BatchableContext bc)
    {
        System.debug('@@ Batch Job Completed');
    }
}