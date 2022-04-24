public class SoqlQueriesApex 
{
    public static String accId;
    public void dmlOnAccount()
     {
         Account acc=new Account(Name='Google', Phone='7678255079',NumberOfEmployees=50);
         insert acc;
         system.debug(acc);
         Account cloneCopyAcc=acc.clone(false,false,false);
         insert cloneCopyAcc;
         
         acc.Name='GFG';
         acc.Phone='9305089636';
         update acc;
         system.debug(acc);
         
         insert new Account(Name='Facebook', Phone='8587063159');
         accId = acc.Id;
     }
    
    public void dmlOnContact()
    {
        Contact ct=new Contact(FirstName='Sundar', LastName='Pichai',Phone='9866868', AccountId=accId);
        insert ct;
        insert new Contact(FirstName='Jeff', LastName='Bezos', Phone='8287289', Department='IT', AccountId=accId);
    }
    
    public void insertDataIntoLead(String fname, String lname, String cmpny, String phn)
    {
        Lead leadDetails= new Lead();
        leadDetails.FirstName=fname;
        leadDetails.LastName=lname;
        leadDetails.Company=cmpny;
        leadDetails.Phone=phn;
        insert leadDetails;
    }
    
    public void updateLeadData(String uID, String com)
    {
        Lead l1=new Lead();
        l1 = [SELECT Company FROM Lead WHERE Id=:uID];
        l1.Company=com;
        update l1;
        System.debug('Updation Successful!!!' );
    }
}