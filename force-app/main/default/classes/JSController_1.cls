public class JSController_1 
{
    @RemoteAction
    public static String createContact(String fn, String ln, String em){
        try{
            insert new Contact(FirstName=fn,LastName=ln,Email=em);
            return 'success';
        }catch(Exception e){
            //System.debug('Error :'+e.getMessage()+' AT '+e.getLineNumber());
            return 'Error :'+e.getMessage()+' AT '+e.getLineNumber();
        }
    }
    @RemoteAction
    public List<Contact> conList{get; set;}
    public JSController_1()
    {
        conList=[Select FirstName,lastName,Email from Contact Order by CreatedDate DESC LIMIT 10];
    }
}