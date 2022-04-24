public class MapClass
{
    public Boolean mapContainKeyCheck()
    {
        Map<Integer, String> m1=new Map<Integer, String>{1=>'Owner',2=>'Account'};
        m1.put(3,'Beneficiary');
        m1.put(4,'Lead');
        Map<Integer, String> m2=new Map<Integer, String>(m1);
        //system.debug(m1.get(4));
        //return m1.equals(m2);
        //return m1.containsKey(8);
        return m1.isEmpty();
    }
    public void getAllKeyValuePair()
    {
        /*Map<Integer, String> m1=new Map<Integer, String>{1=>'Owner',2=>'Account',3=>'Contact', 4=>'Lead', 5=>'Opportunity'};
        m1.put(3,'Beneficiary');
        m1.put(4,'Leadzz');
        Map<Integer, String> myMapRec=new Map<Integer, String>(m1);
        
        for(Integer key:myMapRec.keyset())
        {
            system.debug(myMapRec.get(key));
        }*/
        
        Account[] accs=[SELECT Name, Phone FROM Account LIMIT 10];
        
        List<Account> acc=new List<Account>();
        acc=[SELECT Industry FROM Account LIMIT 10];
        
        Map<Integer, List<Account>> mRec=new Map<Integer, List<Account>>{1=>accs, 2=>acc};
        for(Integer key:mRec.keyset())
        {
            if(key==1)
            {
                for(Account getName:accs)
                { system.debug('KEY: '+ key + '  VALUE: ' + getName); }
            }
            else if(key==2)
            {
                for(Account getIndustry:acc)
                { system.debug('KEY: '+ key + '  VALUE: ' + getIndustry.Industry ); }
            }
        }
    }
    
    public void getContactListByAccount()
    {
        Map<Account,List<Contact>> contactListByAccountRec = new Map<Account,List<Contact>>();
        for(Account accRec : [Select id,Name,(Select Id,Name,FirstName,LastName from Contacts) from Account])
        {
                contactListByAccountRec.put(accRec,accRec.Contacts);
                system.debug('Contact List of '+ accRec.Name + ': '+ accRec.Contacts);
        }
        /*for(Account getValueByKey: contactListByAccountRec.keyset())
        {
            system.debug(contactListByAccountRec.get(getValueByKey));
        }*/
    }
    
    public void mapByMap()
    {
        Map<Integer, Map<Account, List<Contact>>> getMapOfMap = new Map<Integer, Map<Account, List<Contact>>>();
        
        Map<Account, List<Contact>> getSubList= new Map<Account, List<Contact>>();
        
        for(Account accDetails: [SELECT Name, Id, (SELECT FirstName, LastName FROM Contacts) FROM Account])
        {
            getSubList.put(accDetails, accDetails.Contacts);
        }
        getMapOfMap.put(1, getSubList);
        system.debug(getMapOfMap);
    }
}