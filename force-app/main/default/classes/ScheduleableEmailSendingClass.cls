global class ScheduleableEmailSendingClass implements Schedulable
{
    global void execute (SchedulableContext ctx)
    {
        sendEmail();
    }

  public void sendEmail()
  {
        list<Messaging.SingleEmailMessage> mailList = new list<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        string[] toAddress = new string[]{'anjali.singh@utilitarianLab.com', 'anjalisingh.cse18@satyug.edu.in'};
        mail.setSubject('Learning Batch Class!!!');
        mail.setPlainTextBody('Hello!! I am learning to send Emails via Schedueable Apex Class');
        mail.setToAddresses(toAddress);
        mailList.add(mail);
        if(!mailList.isEmpty())
        Messaging.sendEmail(mailList);
  } 

}