public class CallingClassViaProcessBuilder 
{
    @InvocableMethod
    public static void updatedAccountName(List<Id> accId)
    {
        List<Account> accountToBeUpdated=new List<Account>();
        List<Account> selectedAccount= [SELECT Name FROM Account WHERE Id in : accId];
        for(Account account: selectedAccount)
        {
            account.Name = account.Name + ' Process Builder';
            accountToBeUpdated.add(account);     
        }
        update accountToBeUpdated;
    }

}