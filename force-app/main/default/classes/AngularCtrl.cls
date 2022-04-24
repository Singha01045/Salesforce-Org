public class AngularCtrl {
    @RemoteAction
    public static Contact create(String fname, string em)
    {
        try{
            Contact con=new Contact(FirstName=fname, Email=em);
            insert con;
            return con;
        }
        catch(Exception e)
        {
            return null;
        }
        
    }
    @RemoteAction
    public static list<contact> fetch()
    {
        return [SELECT Id, Name, FirstName, Email FROM Contact LIMIT 10];
    }
}