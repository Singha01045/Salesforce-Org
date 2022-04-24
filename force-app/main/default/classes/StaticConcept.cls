public class StaticConcept 
{
    public Integer myInt=1;
    public static Integer x=0;
    public StaticConcept()
    {
        myInt++;
    }
    //Static Block: Calling: 1. system.debug(StaticConcept.x); -> both blocks called  2. StaticConcept  obj=new StaticConcept(); system.debug(obj);
    static
    {
        x=8;
        system.debug(x);
        system.debug('Inside Static Block');
        system.debug('Static Block has the highest priority');        
    }
    //Non-Static Block: Calling: object creation is must.
    {
        x=10;
        system.debug(x);
        system.debug('Inside Non-Static Block');
        system.debug('Non-Static Block has the 2nd highest priority');        
    }
    
    public static Integer getMyInt()
    {
        system.debug('Inside self-created Mthd....');
        return x;
    }
}

/*
system.debug(StaticConcept.myInt);
system.debug(StaticConcept.x);
system.debug(StaticConcept.getMyInt());
StaticConcept obj=new StaticConcept();
system.debug(obj);
system.debug(obj.getMyInt());
*/