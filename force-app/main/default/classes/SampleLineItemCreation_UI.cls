public class SampleLineItemCreation_UI {
    
    @AuraEnabled
    public static string SampleLineItemcreation (List<Sample_Line_Item__c> SLIRecords){
        system.debug('SLI Records ====>' + SLIRecords);
        insert SLIRecords;
        return 'Success';
    }
    
    @AuraEnabled
    public static Integer SampleLineItemCount (String sampleRecordId){
        Integer totalRecords = [SELECT COUNT() FROM Sample_Line_Item__c where Sample__c =: sampleRecordId];
        return totalRecords;
    }
    
}