public with sharing class ChildQueueableClass implements Queueable 
{
    public void execute(QueueableContext qCntxt)
    {
        Case  myCase = [ SELECT Id, Status, Priority FROM Case WHERE Priority = 'Low' ]; 
        myCase.Status = 'Working';
        update myCase;
    }
}