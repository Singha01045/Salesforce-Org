public class FetchingAccountListByWrapperClass 
{                               
    public FetchingAccountListByWrapperClass()
    {
        List<Account> accList=[SELECT Name,(SELECT FirstName FROM Contacts) FROM Account];
        List<wrapAccountClass> wrapAccountList = new List<wrapAccountClass>();                               
        for(Account getAllList:accList)
        {
            wrapAccountList.add(new wrapAccountClass(getAllList));
            system.debug('Account Name: ' + getAllList.Name + getAllList.Contacts);      
        }
        system.debug(wrapAccountList);
    }
    
    public class wrapAccountClass
    {
        public Account acc;
        public wrapAccountClass(Account a)
        {
            acc=a;
        }
    }
}