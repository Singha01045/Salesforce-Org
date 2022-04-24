public class EnqueueMultipleJobs implements Queueable
{
    public integer startIndex;
    public integer endIndex;
    public EnqueueMultipleJobs (integer startIndex,integer endIndex) 
    {
        this.startIndex = startIndex;
        this.endIndex = endIndex;
    }
    public void execute(QueueableContext qCntxt)
    {
        //list<Account> accList = [SELECT Id, name,phone FROM Account LIMIT 100];
        list<account> accListTobeInsert = new list<account>();
        for(integer i = startIndex;i<endIndex;i++){
            account acc = new account();
            acc.Name = 'testing'+i;
            accListTobeInsert.add(acc);
        }
        system.debug('accListTobeInsert::'+accListTobeInsert);
        system.debug('accListTobeInsert.size()::'+accListTobeInsert.size());
        
        if(!accListTobeInsert.isEmpty()){
            insert accListTobeInsert;
        }
        
        if(endIndex < 3000){
            startIndex = endIndex;
            endIndex = endIndex + 500;
            system.enqueueJob( new EnqueueMultipleJobs(startIndex,endIndex));
        }
        
    }
    
    @future
    public static void futureExample(integer startIndex,integer endIndex){
        list<account> accList = [select id from account limit 2];
        system.debug('accList::'+accList);
        /*list<account> accListTobeInsert = new list<account>();
        for(integer i = startIndex;i<endIndex;i++){
            account acc = new account();
            acc.Name = 'testing'+i;
            accListTobeInsert.add(acc);
        }
        system.debug('accListTobeInsert::'+accListTobeInsert);
        system.debug('accListTobeInsert.size()::'+accListTobeInsert.size());
        
        if(!accListTobeInsert.isEmpty()){
            insert accListTobeInsert;
        }*/
    }

}