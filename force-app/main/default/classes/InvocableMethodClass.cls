public class InvocableMethodClass 
{
    @InvocableMethod
    public static list<string> returnAccountName(List<Id> accIdz)
    {
        List<string> accountNames=new List<string>();
        List<Account> selectedAccount= [SELECT Name FROM Account WHERE Id in : accIdz];
        for(Account account: selectedAccount)
        {
            accountNames.add(account.Name);     
        }
        return accountNames;
    }

}