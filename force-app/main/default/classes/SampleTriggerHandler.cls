/**
 * Author: DeaGle
 */
public without sharing class SampleTriggerHandler {
    
    private SampleTriggerHandler() {}
    static SampleTriggerHandler handlerInstance;
    public static SampleTriggerHandler getInstance() {
        if(handlerInstance == null) 
            handlerInstance = new SampleTriggerHandler();
        return handlerInstance;
    }

    public void onBeforeInsert(List<Project__c> sampleList) {
        Set<Id> accountIdSet = new Set<Id>();
        for(Project__c newSample : sampleList) {
            if(newSample.Account__c != null)
                accountIdSet.add(newSample.Account__c);
        }

        if(!accountIdSet.isEmpty())
            validateSample(sampleList, accountIdSet);
    }

    private void validateSample(List<Project__c> sampleList, Set<Id> accountIdSet) {
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Potential_Opportunity__c, Total_Team_Members__c FROM Account WHERE Id IN:accountIdSet AND Run_Validation_Rule__c = true AND RecordType.DeveloperName = 'Direct_Customer']);
        for(Project__c sRec : sampleList) {
            if(accountMap.containsKey(sRec.Account__c) && (accountMap.get(sRec.Account__c).Total_Team_Members__c == null || accountMap.get(sRec.Account__c).Potential_Opportunity__c > accountMap.get(sRec.Account__c).Total_Team_Members__c)) {
                sRec.addError(Constants.OPP_ACC_TEAM_MEMBER_VALIDATION_MSG);
            }
        }
    }
}