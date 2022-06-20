public with sharing class LwcClass {
    public LwcClass() {
    }
    
    // method must only get data, it can’t mutate (change) data.
    @AuraEnabled(cacheable=true)
    public static List<Account>  getAccount(){
        try {
            return [SELECT Id, Name, Phone, Email__c FROM Account];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
