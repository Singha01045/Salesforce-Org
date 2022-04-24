public class q2JOB implements Queueable
{
    public void execute (QueueableContext qContext) 
    {
        system.debug('Im Inside Queue 2');
        system.enqueueJob( new q3JoB() );
    }
}