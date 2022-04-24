public with sharing class PdfExampleController 
{
    public List<Account> accList{get;set;}
    public PdfExampleController ()
    {
        accList = [select id, Name, Phone, Website, Email__c, ShippingStreet from account limit 10];
    }
}