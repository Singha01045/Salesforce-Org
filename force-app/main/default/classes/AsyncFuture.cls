public class AsyncFuture 
{
    @future (callout=true)
    public static void futurecall () 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard Platform User']; 
        UserRole r = [SELECT Id FROM UserRole WHERE Name='CFO'];
        User futureUser = new User (
            firstname = 'Feature', lastname = 'User', alias = 'fUser', defaultgroupnotificationfrequency = 'N',
            digestfrequency = 'N', email = 'anjali.singh@utilitarianlab.com',
            emailencodingkey = 'UTF-8', languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
            timezonesidkey = 'Asia/Colombo',
            username = 'fuser@test.org',
            userpermissionsmarketinguser = false,
            userpermissionsofflineuser = false,
            userroleid = r.Id);
        insert (futureUser);
    }    
}