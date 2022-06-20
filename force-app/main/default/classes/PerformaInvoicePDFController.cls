public class PerformaInvoicePDFController {
    
    public String recordId =  System.currentPageReference().getParameters().get('id');
    public Symega_Configuration__c symObj {get;set;}
    public Opportunity oppDetails {get;set;}
    public String shippingAddress {get;set;}
    public integer sumOfQuantity {get;set;}
    public integer sumOfRate {get;set;}
    public integer sumOfAmount {get;set;}
    
    public PerformaInvoicePDFController(){
        
        sumOfQuantity=0;
        sumOfRate = 0;
        sumOfAmount = 0;
        symObj = [Select id, Name, symega_address__c, Buyer_If_other_than_consignee__c, Exporter_HS_Code__c, Carton_Packaging__c, Bank_Name_And_Address__c, Account_Name__c, Account_No__c FROM Symega_Configuration__c where Name='exporter'];
        System.debug('symObj'+symObj.symega_address__c);
        
        oppDetails = [SELECT id, Fiscal_Year__c, (SELECT ProductCode, Description, Quantity, UnitPrice, TotalPrice FROM OpportunityLineItems), Account.ShippingAddress, Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingCountry, Account.ShippingGeocodeAccuracy, Account.ShippingLatitude, Account.ShippingLongitude, Account.ShippingPostalCode  FROM Opportunity WHERE Id =: recordId];
        system.debug('oppDetails :: ' +oppDetails);
        
        for(OpportunityLineItem opp1 : oppDetails.OpportunityLineItems){
            sumOfQuantity = sumOfQuantity+Integer.valueOf(opp1.Quantity);
            sumOfRate = sumOfRate+integer.valueOf(opp1.UnitPrice);
            sumOfAmount = sumOfAmount+integer.valueOf(opp1.TotalPrice);
        }
        
    }
    
    @AuraEnabled
    public static string savePDF(String url,String id,String fileName){
        try {
            
            PageReference ref = new PageReference(url);
            
            ContentVersion cont = new ContentVersion();
            
            cont.Title = fileName;
            cont.PathOnClient = fileName+'.pdf';
            cont.VersionData = ref.getContentAsPdf();
            cont.Origin = 'H';
            
            insert cont;    
            ContentDocumentLink cdl = createContentLink(cont.Id, id);
            
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersionId
        ].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        // ShareType is either 'V', 'C', or 'I'
        // V = Viewer, C = Collaborator, I = Inferred
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    
    @AuraEnabled
    public static string emailToClient(String url,String oppId){
        try {
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            List<Opportunity> opprec = [SELECT Id, Account.id, Account.Email__c From Opportunity Where Id =: oppId];
            PageReference ref = new PageReference(url);
            Blob emailAttach = ref.getContentAsPdf();
            if(!opprec.isEmpty()){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('Invoice');
                efa.setBody(emailAttach);
                efa.setContentType('application/pdf');
                
                List<String> recipients = new List<String>();
                recipients.add(opprec[0].Account.Email__c);
                system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('Symega');
                String subject = 'Test Subject';
                String htmlBody = 'Test Email Body';
                mail.setSubject(subject);
                mail.setHtmlBody(htmlBody);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa });
                mails.add(mail);
                    system.debug('mails-->'+mails.size());
                if(!mails.isEmpty())
                    system.debug('mails-->'+mails.size());
                    Messaging.sendEmail(mails);
            }
            return 'Success';
        }catch(exception e){
            return e.getStackTraceString();
        }
    }
}