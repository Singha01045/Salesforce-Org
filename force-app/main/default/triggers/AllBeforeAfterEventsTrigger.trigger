trigger AllBeforeAfterEventsTrigger on Contact (before insert, after insert, before update, after update, before delete, after delete, after undelete) 
{
    if(trigger.isInsert)
    {
        if(trigger.isBefore)
        {
            for(Contact con:trigger.old)
            {
                system.debug(con);           //Throws exception
            }
        }
        if(trigger.isBefore)
        {
            for(Contact con:trigger.new)
            {
                system.debug(con);           //Inserts Value but ID NULL
            }
        }
        if(trigger.isAfter)
        {
            for(Contact con:trigger.old)
            {
                system.debug(con);           //Throws exception
            }
        }
        if(trigger.isAfter)
        {
            for(Contact con:trigger.new)
            {
                system.debug(con);           //Inserts Value ID assigned
            }
        }
    }
    
    if(trigger.isUpdate)
    {
        if(trigger.isBefore)
        {
            for(Contact con:trigger.old)
            {
                system.debug(con);           //Updates value at the same ID
            }
        }
        if(trigger.isBefore)
        {
            for(Contact con:trigger.new)
            {
                system.debug(con);           //Updates value at the same ID
            }
        }
        
        if(trigger.isAfter)
        {
            for(Contact con:trigger.old)
            {
                system.debug(con);           //Updates value at the same ID
            }
        }
        if(trigger.isAfter)
        {
            for(Contact con:trigger.new)
            {
                system.debug(con);           //Updates value at the same ID
            }
        }
    }
    
    if(trigger.isDelete)
    {
        if(trigger.isBefore)
        {
            for(Contact con:trigger.old)
            {
                system.debug(con);           //Gives the details of old list with ID before deleting it
            }
        }
        if(trigger.isBefore)
        {
            for(Contact con:trigger.new)
            {
                system.debug(con);           //Throws Exception
            }
        }
        if(trigger.isAfter)
        {
            for(Contact con:trigger.old)
            {
                system.debug(con);           //Gives the details of old list with ID after deleting it
            }
        }
        if(trigger.isAfter)
        {
            for(Contact con:trigger.new)
            {
                system.debug(con);           //Throws Exception
            }
        }
    }
    
    if(trigger.isUndelete)
    {
        if(trigger.isAfter)
        {
            for(Contact con:trigger.old)
            {
                system.debug(con);           //Throws Exception
            }
        }
        if(trigger.isAfter)
        {
            for(Contact con:trigger.new)
            {
                system.debug(con);           //Gives the details of old list with ID after undeleting it
            }
        }
    }

}