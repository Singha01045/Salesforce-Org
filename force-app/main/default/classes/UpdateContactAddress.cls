public with sharing class UpdateContactAddress implements Database.Batchable<SObject>, Database.Stateful
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
                recordsProcessed = recordsProcessed +1;
            }  
        }
        UPDATE contactListsToBeInserted;
    }

    public void finish(Database.BatchableContext bCntxt)
    {
        System.debug(recordsProcessed + ' records processed...');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :bCntxt.getJobId()];
       // call some utility to send email
        //EmailUtils.sendMessage(job, recordsProcessed);
    }
}