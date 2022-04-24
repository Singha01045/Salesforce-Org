public class List_SetClass 
{
    public void ListClass()
    {
        list<Integer> list1=new Integer[3];
        list1.add(0,5);
        list1.add(1,2);
        list1.add(2,200);
        list1.set(3,87);
        list1.sort();
        system.debug('List: '+list1);
        Integer getListByIndex=list1.get(3);
        system.debug(getListByIndex);
        Boolean containItem=list1.contains(2);
        system.debug(containItem); 
    }
  
    public void setClass()
    {
        list<Integer> list1=new Integer[3];
        list1.add(0,5);
        list1.add(1,2);
        list1.add(2,200);
        list1.set(3,87);
        set<Integer> set1=new set<Integer>(list1);
        set1.add(20);
        system.debug('List: '+list1);
        system.debug('Set: '+set1);
        set1.clear();
        system.debug('After clearing The Set: '+set1);
        list<String> myStr=new list<String>();
        myStr.add('Anjali');
        myStr.add('Ankita');
        list<String> mySecondStr= new list <String>();
        mySecondStr=myStr.clone();
        Boolean getRes=myStr.equals(mySecondStr);
        system.debug(myStr.size());
    }

}