public without sharing class OpportunityTriggerHandler {
    static OpportunityTriggerHandler handlerInstance;
    public static OpportunityTriggerHandler getInstance() {
        if(handlerInstance == null) 
            handlerInstance = new OpportunityTriggerHandler();
        return handlerInstance;
    }

    public void onBeforeInsert(List<Opportunity> opportunityList) {
        Set<Id> accountIdSet = new Set<Id>();
        for(Opportunity newOpp : opportunityList) {
            if(newOpp.accountId != null)
                accountIdSet.add(newOpp.accountId);
        }

        if(!accountIdSet.isEmpty())
            validateOpportunity(opportunityList, accountIdSet);
    }

    private void validateOpportunity(List<Opportunity> oppList, Set<Id> accIdSet) {
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Potential_Opportunity__c, Total_Team_Members__c FROM Account WHERE Id IN:accIdSet AND Run_Validation_Rule__c = true AND RecordType.DeveloperName = 'Direct_Customer']);
        for(Opportunity opp : oppList) {
            if(accountMap.containsKey(opp.accountId) && (accountMap.get(opp.accountId).Total_Team_Members__c == null || accountMap.get(opp.accountId).Potential_Opportunity__c > accountMap.get(opp.accountId).Total_Team_Members__c)) {
                opp.addError(Constants.OPP_ACC_TEAM_MEMBER_VALIDATION_MSG);
            }
        }
    }
    
    public void intiateApprovalProcess(list<opportunity> newOppList,Map<id,Opportunity> oldOppMap){
        try{
            Map<Id,Opportunity> freshOppMap = new Map<Id,Opportunity>([SELECT Id, Owner.ManagerId, Owner.UserRoleId FROM Opportunity WHERE Id IN:oldOppMap.keySet()]);
            Map<Id, Approval.ProcessSubmitRequest> oppToapprovalRequestMap = new Map<Id, Approval.ProcessSubmitRequest>();
            Map<Id,UserRole> userRoleMap = new Map<Id,UserRole>([SELECT Id, ParentRoleId, Name FROM UserRole]);
            Map<Id,Id> oppTomdApprovalRoleIdMap = new Map<Id,Id>();

            if(!newOppList.isEmpty()) {
                for(opportunity opp : newOppList){
                    if(opp.Approval_Markdown__c != null && opp.Approval_Markdown__c >=3 && opp.Approval_Markdown__c <6 && opp.Approval_Markdown__c != oldOppMap.get(opp.Id).Approval_Markdown__c){
                        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                        req.setComments('Submitting for Discount Approval.');
                        req.setObjectId(opp.Id);
                        system.debug('opp.Owner.ManagerId----->'+opp.Owner.ManagerId);
                        if(freshOppMap.get(opp.Id).Owner.ManagerId != null) {
                            req.setNextApproverIds(new List<Id> { freshOppMap.get(opp.Id).Owner.ManagerId });
                            oppToapprovalRequestMap.put(opp.Id, req);
                        }
                    }else if(userRoleMap.get(freshOppMap.get(opp.Id).Owner.UserRoleId) != null && opp.Approval_Markdown__c != null && opp.Approval_Markdown__c >=6 && opp.Approval_Markdown__c != oldOppMap.get(opp.Id).Approval_Markdown__c){
                        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                        req.setComments('Submitting for Discount Approval.');
                        req.setObjectId(opp.Id);
                        Id mdRoleId = LeadApprovalUtility.getMDIdRecursive(userRoleMap, userRoleMap.get(freshOppMap.get(opp.Id).Owner.UserRoleId));
                        if(mdRoleId != null)
                            oppTomdApprovalRoleIdMap.put(opp.Id, mdRoleId);
                        oppToapprovalRequestMap.put(opp.Id, req);
                    }else if(opp.Approval_Markdown__c != null && opp.Approval_Markdown__c >=3 && opp.Approval_Markdown__c <6 && opp.Initial_Discount_Approved__c == true && oldOppMap.get(opp.Id).Initial_Discount_Approved__c == false) {
                        System.debug('--- second level approval submission');
                        initiateSecondPricingApproval(opp.Id);
                    }
                }
                if(!oppToapprovalRequestMap.isEmpty()) {
                    if(!oppTomdApprovalRoleIdMap.isEmpty()) {
                        Map<Id,Id> roleToUserIdMap = new Map<Id,Id>();
                        List<User> mdUserList = [SELECT Id,UserRoleId FROM User WHERE UserRoleId IN :oppTomdApprovalRoleIdMap.values()];
                        for(User usr: mdUserList) {
                            roleToUserIdMap.put(usr.UserRoleId, usr.Id);
                        }
                        for(Id oppId : oppTomdApprovalRoleIdMap.keySet()) {
                            if(roleToUserIdMap.containsKey(oppId))
                                oppToapprovalRequestMap.get(oppId).setNextApproverIds(new List<Id> { roleToUserIdMap.get(oppTomdApprovalRoleIdMap.get(oppId)) });
                            else
                                oppToapprovalRequestMap.remove(oppId);
                        }
                    }
                    if(!oppToapprovalRequestMap.isEmpty())
                        List<Approval.ProcessResult> result = Approval.process(oppToapprovalRequestMap.values());
                }
            }
        }
        catch(exception ex){
            system.debug('Error==>'+ex.getMessage());
            system.debug('Error>>><<'+ex.getLineNumber());
            HandleBusinessException.captureError('OppTriggerHandler', 'initiateApprovalProcess', ex);
        }
    }
    public void updatePriciningOnAccount(Map<Id,Opportunity> newMap, Map<Id, Opportunity> oldMap){
        try{
            system.debug('Opportunity Updated');
            set<Id> opportunityIds = new set<id>();
            List<OpportunityLineItem> OpportunityLineItemList = new List<OpportunityLineItem>();
            List<Account> accountListToBeUpdated = new List<Account>();
            List<Account> accountList = new List<Account>();
            Map<String, Map<String,Decimal>> priceByProductFamilyByAccountId = new Map<String, Map<String,Decimal>>();
            
            for(Opportunity oppRec : newMap.Values()){
                if(oppRec.StageName != oldMap.get(oppRec.Id).StageName && oppRec.StageName == Constants.OPPOTUNITY_STAGE_CLOSED_WON && oppRec.RecordTypeId == Constants.OpportunityRecordTypeOneTime){
                    system.debug('Closed Won');
                    opportunityIds.add(oppRec.id);
                }
            }
            system.debug('opportunityIds>>'+opportunityIds);
            if(!opportunityIds.isEmpty()){
                OpportunityLineItemList = [Select Id,TotalPrice,OpportunityId,Product2Id,Product2.Family,opportunity.AccountID From OpportunityLineItem where OpportunityId in : opportunityIds];
                system.debug('OpportunityLineItemList>>'+OpportunityLineItemList);
                if(!OpportunityLineItemList.isEmpty()){
                    for(OpportunityLineItem oppLineItemRec : OpportunityLineItemList){
                        if(priceByProductFamilyByAccountId.containsKey(oppLineItemRec.opportunity.AccountID)){
                            Map<String, Decimal> totalPriceByProductFamily = priceByProductFamilyByAccountId.get(oppLineItemRec.opportunity.AccountID);
                            system.debug('oppLineItemRec.Product2.Family>>'+oppLineItemRec.Product2.Family);
                            if(totalPriceByProductFamily.containsKey(oppLineItemRec.Product2.Family)){
                                Decimal totalPrice = totalPriceByProductFamily.get(oppLineItemRec.Product2.Family) + oppLineItemRec.TotalPrice;
                                totalPriceByProductFamily.put(oppLineItemRec.Product2.Family, totalPrice);
                                priceByProductFamilyByAccountId.put(oppLineItemRec.opportunity.AccountID, totalPriceByProductFamily);
                            }else{
                                totalPriceByProductFamily.put(oppLineItemRec.Product2.Family, oppLineItemRec.TotalPrice);
                                priceByProductFamilyByAccountId.put(oppLineItemRec.opportunity.AccountID, totalPriceByProductFamily);
                            }
                        }else{
                            system.debug('oppLineItemRec.Product2.Family>>'+oppLineItemRec.Product2.Family);
                            Map<String, Decimal> totalPriceByProductFamily = new Map<String, Decimal>(); 
                            totalPriceByProductFamily.put(oppLineItemRec.Product2.Family, oppLineItemRec.TotalPrice);
                            priceByProductFamilyByAccountId.put(oppLineItemRec.opportunity.AccountID, totalPriceByProductFamily);
                        }
                    }
                    for(String accountId : priceByProductFamilyByAccountId.keySet()){
                        system.debug('accountId>>'+accountId);
                        for(String family : priceByProductFamilyByAccountId.get(accountId).keySet()){
                            system.debug('Family>>'+family);
                            system.debug('Price'+priceByProductFamilyByAccountId.get(accountId).get(family));
                            
                        }
                    }
                    if(!priceByProductFamilyByAccountId.isEmpty()){
                        accountList = [Select id,COLOR_Opportunity_Closed_Value__c,CPD_Opportunity_Closed_Value__c,SPD_Opportunity_Closed_Value__c,FLAVOR_Opportunity_Closed_Value__c,PLANT_BASED_Opportunity_Closed_Value__c From Account Where id IN :priceByProductFamilyByAccountId.keySet()];
                        if(!accountList.isEmpty()){
                            for(Account accountRec : accountList){
                                Account accRec = new Account();
                                accRec.Id = accountRec.Id;
                                Map<String, Decimal> totalPriceByProductFamily = priceByProductFamilyByAccountId.get(accountRec.Id);
                                if(!totalPriceByProductFamily.isEmpty()){
                                    for(String productFamily : totalPriceByProductFamily.keySet()){
                                        if(productFamily == 'COLOR')
                                            accRec.COLOR_Opportunity_Closed_Value__c = totalPriceByProductFamily.get(productFamily) + accountRec.COLOR_Opportunity_Closed_Value__c;
                                        if(productFamily == 'CPD')
                                            accRec.CPD_Opportunity_Closed_Value__c = totalPriceByProductFamily.get(productFamily) + accountRec.CPD_Opportunity_Closed_Value__c;
                                        if(productFamily == 'SPD')
                                            accRec.SPD_Opportunity_Closed_Value__c = totalPriceByProductFamily.get(productFamily) + accountRec.SPD_Opportunity_Closed_Value__c;
                                        if(productFamily == 'FLAVOR')
                                            accRec.FLAVOR_Opportunity_Closed_Value__c = totalPriceByProductFamily.get(productFamily) + accountRec.FLAVOR_Opportunity_Closed_Value__c;
                                        if(productFamily == 'PLANT BASED')
                                            accRec.PLANT_BASED_Opportunity_Closed_Value__c = totalPriceByProductFamily.get(productFamily) + accountRec.PLANT_BASED_Opportunity_Closed_Value__c;
                                        
                                    }
                                }
                                accountListToBeUpdated.add(accRec);
                            }
                        }
                        if(!accountListToBeUpdated.isEmpty()){
                            update accountListToBeUpdated;
                        }
                    }
                }
            }
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage());
            system.debug('Error>>><<'+ex.getLineNumber());
        }
    }

    @future
    private static void initiateSecondPricingApproval(Id oppId) {
        if(!String.isBlank(oppId)) {
            try{
                Opportunity opp = [SELECT Id, Approval_Markdown__c, Initial_Discount_Approved__c FROM Opportunity WHERE Id =:oppId];
                if(opp.Approval_Markdown__c != null && opp.Approval_Markdown__c >=3 && opp.Approval_Markdown__c <6 && opp.Initial_Discount_Approved__c == true) {
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    req.setComments('Submitting for Discount Approval.');
                    req.setObjectId(opp.Id);
                    req.setProcessDefinitionNameOrId('X3_6_MD_Approval');
                    Approval.ProcessResult result = Approval.process(req);
                }
            }catch(Exception ex) {
                System.debug('--- Message'+ex.getMessage());
                System.debug('--- Line NO:'+ex.getLineNumber());
                HandleBusinessException.captureError('OpportunityTriggerHandler', 'initiateSecondPricingApproval', ex);
            }
        }
    }
}