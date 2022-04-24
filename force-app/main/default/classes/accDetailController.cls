public class accDetailController
{
    @RemoteAction
    public static string createAccount(string name, string link, string fx, string city, string state, string country, string ind, integer employee, decimal revenue )
    {
        try{
            Account accRecord= new Account(Name=name, Website=link, Fax=fx, BillingCity=city, BillingState=state, BillingCountry=country, Industry=ind, NumberOfEmployees=employee, AnnualRevenue=revenue);
            insert  accRecord;
            return  accRecord.id;
            
        }
        catch(Exception e)
        {
            system.debug('Error '+e.getMessage()+'AT ' + e.getLineNumber());
            return Null;
        }
    }
    @RemoteAction
    public static String createContact(string fname, string lname, string phn, string id )
    {
        try{
            Contact conRecord= new contact(FirstName=fname, LastName=lname, Phone=phn, AccountId=id);
            insert  conRecord;
            return  conRecord.Id;
        }
        catch(Exception e)
        {
            system.debug('Error '+e.getMessage()+'AT ' + e.getLineNumber());
            return Null;
        }
    }
}