public class VigneshAssignment 
{
    //Question-1 : Concatenate 2 strings
    public static String firstName;
    public static String lastName;
    public static String stringConcatenation(String fname,String lname) 
    {
        firstName=fname;
        lastName=lname;
        String Str = String.valueOf(fname) + String.valueOf(lname);
        system.debug('Str----'+Str);
        return Str;
    }
    
    //Question-2: return date from day, month and year
    public static Integer day;
    public static String month;
    public static Integer year;
    public VigneshAssignment(Integer d, String m, Integer y) 
    {
        day=d;
        month=m;
        year=y;
    }
    public Double showDate()
    {
        
        system.debug('Today Date is: ' + day);
        return day;
    }
    public Integer dayz(Integer day, Integer month, Integer year)
    {
        date myDate = date.newInstance(day,month,year);
        Integer dayz = myDate.day();
        return dayz;
    }
    
    //Question-3 : return Boolean value based on condition
    public static Boolean returnBoolean(String color) 
    {
        if(color =='green')
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    //Question-4: calculate string list size
    public Integer getSizeFunction( List <String> strList) 
      {
             return strList.size();
      }    
      /*List <string> myList = New List<string>{'dskf','sldfk','fer','ewrwe'};
      system.debug(myList.size());*/
    
      public void getSizeFunction( List <Integer> intList) 
      {
        Integer sum=0;
        for(Integer i: intList )
        {
            system.debug(i);
            sum=sum+i;
        }
          system.debug('The same of the entered numbers is: '+sum);
      }
    
    //Question-5: Create a Non-Parameterized Constuctor that assigns some value
    public VigneshAssignment()
    {
        String Name='Jon Doe';
        Integer rollNo=10;
        System.debug('Name: ' + Name + 'Roll No: ' + rollNo);
    }
    
    //Question-6: Create a Parameterized Constuctor that changes the value
    public VigneshAssignment(String n, Integer rNo)
    {
        String Name=n;
        Integer rollNo=rNo;
        System.debug('Name: ' + Name + 'Roll No: ' + rollNo);
    }  
}