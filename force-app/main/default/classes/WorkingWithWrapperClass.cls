public class WorkingWithWrapperClass 
{
    public string Course;
    public string Duration;
    
    public WorkingWithWrapperClass()                                  //Constructor
    {
        Course='Computer Science';
        Duration='4 Years'; 
        
        myWrapperClass getSingleRecord = new myWrapperClass();          
        getSingleRecord.Name='Ashok Singh';
        getSingleRecord.Age=49;
        getSingleRecord.isGraduated=true;
        
        myWrapperClass wrap1=new myWrapperClass();                  //Creating Object
        wrap1.Name='Anjali Singh'; 
        wrap1.Age=22;
        wrap1.isGraduated=true;
        
        myWrapperClass wrap2=new myWrapperClass();
        wrap2.Name='Ankita Singh';
        wrap2.Age=20;
        wrap2.isGraduated=false;
        
        List<myWrapperClass> getMultipleRecord = new List<myWrapperClass>();
        getMultipleRecord.add(getSingleRecord);
        getMultipleRecord.add(wrap1);
        getMultipleRecord.add(wrap2);
        

        system.debug('List 1: ' + wrap1);
        system.debug('List 2: ' + wrap2);
        system.debug('All Lists: ' + getMultipleRecord);
        
    }
    
    public class myWrapperClass                      //This is the Wrapper or Container Class
    {
        Public String Name;
        Public Integer Age{get; set;}
        public Boolean isGraduated;
    }

}