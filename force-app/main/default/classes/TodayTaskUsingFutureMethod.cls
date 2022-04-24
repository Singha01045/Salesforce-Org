public class TodayTaskUsingFutureMethod
{
    public TodayTaskUsingFutureMethod()
    {
        takeShower();
        haveBreakfast();
        carServicing();
        officeTime();
    }
    public static void takeShower()
    {
        system.debug('I am taking shower...');
    }
    public static void haveBreakfast()
    {
        system.debug('I am having my breakfast...');
    }
    
    @future
    public static void carServicing()
    {
        system.debug('I need to get my car serviced...');
        // bikeServicing();                                                         No Errors but Future method cannot be called from a future or batch method...
        // Database.executeBatch(new UpdateContactAddress(), 200);                  Database.executeBatch cannot be called from a batch start, batch execute, or future method...
    }

    @future
    public static void bikeServicing()
    {
        system.debug('I need to get my bike serviced...');
    }

    public static void officeTime()
    {
        system.debug('Going to Office...');
    }

}