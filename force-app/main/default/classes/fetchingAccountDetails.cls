public class fetchingAccountDetails 
{
  @RemoteAction
    public static Account createAccount(string name, string link, string fx, string city, string state, string country, string ind, integer employee, decimal revenue )
    {
        try{
            Account accList= new Account(Name=name, Website=link, Fax=fx, BillingCity=city, BillingState=state, BillingCountry=country, Industry=ind, NumberOfEmployees=employee, AnnualRevenue=revenue);
            insert  accList;
            return  accList;
        }
        catch(Exception e)
        {
            system.debug('Error '+e.getMessage()+'AT ' + e.getLineNumber());
            return Null;
        }
    }
    @RemoteAction
    public static List<Account> fetchAllAccounts()
    {
        return [SELECT Id, Name, Website, Fax, BillingAddress, Industry FROM Account LIMIT 10];
    }
}