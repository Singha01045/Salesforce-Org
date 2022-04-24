public class CPULimitHit
{
    public static void normalMethod()
    {
        list<Account> accList = [SELECT Id, name,phone FROM Account LIMIT 100];
        for(Account accRec: accList )
        {
            accRec.Phone= '8900000000';
            UPDATE accList; 
            normalMethod();
        }    
        //UPDATE accList;   
    }
    
    @future
    public static void futureMethod()
    {
        List<Account> lstacc=[Select Id from Account limit 10000];
        Set<Id> setIds=new Set<Id>();
        for(Account a:lstacc)
        { 
            setIds.add(a.id);
        }
        Map<id,account> aMap = new Map<id,account>([Select Id,Name from Account limit 50000]);
        List<account> accList = aMap.values() ;
        Set<id> accIds = aMap.keySet() ;
        system.debug('@@@2nd time calling');
        //normalMethod();
    }     
}