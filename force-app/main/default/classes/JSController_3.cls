public class JSController_3 
{
  @RemoteAction
    public static Contact createContact(string fn, string ln, string em, string phn)
    {
        try{
            Contact conList= new Contact(FirstName=fn, LastName=ln, Email=em, Phone=phn);
            insert  conList;
            return  conList;
        }
        catch(Exception e)
        {
            return Null;
        }
    }
    @RemoteAction
    public static List<Contact> fetchAllContacts(){
        return [Select Id,Name,FirstName,lastName,Email from Contact Order by CreatedDate DESC LIMIT 10];
    }
}