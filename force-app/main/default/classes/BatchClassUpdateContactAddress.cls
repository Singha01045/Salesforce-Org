public with sharing class BatchClassUpdateContactAddress implements Database.Batchable<SObject>, Database.Stateful
{
    public Integer recordsProcessed =0;

    public Database.QueryLocator start(Database.BatchableContext bCntxt) 
    {
        return Database.getQueryLocator(
            'SELECT ID, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode,' +
            '(SELECT ID, MailingStreet, MailingCity, ' +
            'MailingState, MailingPostalCode, MailingCountry FROM Contacts) FROM Account ' +
            'Where BillingCountry = \'USA\' '
        );
    }

    public void execute(Database.BatchableContext bCntxt, list<Account> expectingAcountList)
    {
        list<Contact> contactListsToBeInserted = new list<Contact>();
        for(Account accRec: expectingAcountList )
        {
            for(Contact conRec: accRec.Contacts)
            {
                conRec.MailingStreet = accRec.BillingStreet;
                conRec.MailingCity = accRec.BillingCity;
                conRec.MailingState = accRec.BillingState;
                conRec.MailingCountry = accRec.BillingCountry;
                conRec.MailingPostalCode = accRec.BillingPostalCode;
                contactListsToBeInserted.add(conRec);
                
            }  
            recordsProcessed = recordsProcessed +1;
        }
        UPDATE contactListsToBeInserted;
    }

    public void finish(Database.BatchableContext bCntxt)
    {
        System.debug(recordsProcessed + ' records processed...');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :bCntxt.getJobId()];
        system.debug('<---- JOB COMPLETED ---->' + job);
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{ job.CreatedBy.Email,'anjalisingh.cse18@satyug.edu.in' , 'dinesh.butilitarianlab@gmail.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Sharing Recalculation ' + job.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + job.TotalJobItems + ' batches with ' + job.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        
        //Sending Email Without Template...
        /*list<Messaging.SingleEmailMessage> mailList = new list<Messaging.SingleEmailMessage>();
        string[] toAddress = new string[]{'anjali.singh@utilitarianLab.com', 'anjalisingh.cse18@satyug.edu.in'};
        mail.setSubject('Learning Batch Class!!!');
        mail.setPlainTextBody('Hello!! I am learning to send Emails via Batch Apex Class');
        mail.setToAddresses(toAddress);
        mailList.add(mail);
        if(!mailList.isEmpty())
        Messaging.sendEmail(mailList);
        
        //Sending Email With Template...
        list<Messaging.SingleEmailMessage> mailList = new list<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemp = [SELECT Id, Subject, Body FROM EmailTemplate WHERE DeveloperName= 'Dummy_Template'];
        Contact con = [SELECT Id, Email FROM Contact WHERE LastName = 'Ji'];
        mail.setTemplateId(emailTemp.Id);
        mail.setTargetObjectId(con.Id);
        mailList.add(mail);
        if(!mailList.isEmpty())
        Messaging.sendEmail(mailList);*/
        
    }
}