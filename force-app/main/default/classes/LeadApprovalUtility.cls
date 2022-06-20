/**
* Author: Aakash.
*/
public without sharing class LeadApprovalUtility {
    @AuraEnabled
    public static String submitForApprovalToMarketingHead(string leadId){
        try{
            system.debug('leadId>>'+leadId);
            if(String.isBlank(leadId))
                return Constants.PENDING;
            Lead lRec = [SELECT Id, Marketing_Head_Approved__c FROM Lead WHERE Id=:leadId];
            if(!String.isBlank(leadId)) {
                ProcessInstance[] recordUnderApproval = [Select ID, Status,TargetObjectID, TargetObject.Name From ProcessInstance Where Status =: Constants.PENDING AND TargetObjectID =:leadId];
                if(!recordUnderApproval.isEmpty()){
                    return Constants.PENDING;
                }else if(lRec.Marketing_Head_Approved__c){
                    return Constants.PENDING;
                }else{
                    String symegaConfigMHGroupName = '';
                    List<Id> marketingHeadId = new List<Id>();
                    Lead leadRecToBeSubmittedForApproval = new Lead();
                    List<Group_Member__c> marketingHead = new List<Group_Member__c>();
                    leadRecToBeSubmittedForApproval = [Select Id, OwnerId From Lead WHERE Id =: leadId];
                    //custom setting
                    Symega_Configuration__c orgConfig = Symega_Configuration__c.getValues('Lead Approval Group');
                    if(orgConfig != null && !String.isBlank(orgConfig.Lead_Approval_Marketing_Head_Group_Name__c)) {
                        symegaConfigMHGroupName = orgConfig.Lead_Approval_Marketing_Head_Group_Name__c;
                        system.debug('symegaConfigMHGroupName>>'+symegaConfigMHGroupName);
                        //get Marketing group User
                        if(!String.isBlank(symegaConfigMHGroupName))
                            marketingHead = [Select Assignment_Approval_Group__c,User__c,Lead_Assigned_Approved_On__c,Id From Group_Member__c Where Assignment_Approval_Group__r.Name = :symegaConfigMHGroupName AND Assignment_Approval_Group__r.Type__c =: Constants.LEAD_APPROVAL AND Active__c = TRUE ORDER BY Lead_Assigned_Approved_On__c ASC limit 1];
                        system.debug('marketingHead>>'+marketingHead);
                        if(!marketingHead.isEMpty())
                            marketingHeadId.add(marketingHead[0].User__c);
                        // Create an approval request 
                        Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                        approvalRequest.setComments('Submitting for marketing head approval.');
                        approvalRequest.setObjectId(leadId);
                        // Submit on behalf of a specific submitter
                        approvalRequest.setSubmitterId(UserInfo.getUserId()); 
                        // Submit the record to specific process and skip the criteria evaluation
                        approvalRequest.setProcessDefinitionNameOrId(Constants.LEAD_APPROVAL_PROCESS_MH);
                        approvalRequest.setSkipEntryCriteria(true);
                        if(!marketingHeadId.isEmpty()){
                            system.debug('approval firing');
                            approvalRequest.setNextApproverIds(marketingHeadId);
                            // Submit the approval request for the account
                            Approval.ProcessResult result = Approval.process(approvalRequest);
                            //TODO: check if approval is success.
                            //share record to MH
                            LeadShare shareLead = new LeadShare(LeadId = leadId, UserOrGroupId = marketingHead[0].User__c, LeadAccessLevel = 'Edit', RowCause = 'Manual');
                            insert shareLead;
                        }
                    }else{
                        throw new LeadApprovalException('Error: PLease configure Org configuration');
                    }
                    
                }
            }
            return 'Success';
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage());
            system.debug('Error>>><<'+ex.getLineNumber());
            HandleBusinessException.captureError('LeadApproval', 'submitForApprovalToMarketingHead', ex);
            return 'Error';
        }
    }
    @future
    public static void submitForApprovalToBusinessHead(String leadId){
        system.debug('leadId>>'+leadId);
        
        if(!String.isBlank(leadId)) {
            try{
                List<Lead> leadForApprovalList = [SELECT Id, Business_Head__c FROM Lead WHERE Id =:leadId AND Business_Head__c != null];
                System.debug('leadForApprovalList ---' + leadForApprovalList);
                if(!leadForApprovalList.isEmpty() && leadForApprovalList[0].Business_Head__c != null) { 
                    Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                    approvalRequest.setComments('Submitting for business head approval.');
                    approvalRequest.setObjectId(leadId);
                    
                    
                    List<Id> businessHeadIdList = new List<Id>{leadForApprovalList[0].Business_Head__c};
                        
                        // Submit on behalf of a specific submitter
                        approvalRequest.setSubmitterId(UserInfo.getUserId()); 
                    
                    // Submit the record to specific process and skip the criteria evaluation
                    approvalRequest.setProcessDefinitionNameOrId(Constants.LEAD_APPROVAL_PROCESS_BH);
                    approvalRequest.setSkipEntryCriteria(true);
                    if(!businessHeadIdList.isEmpty())
                        approvalRequest.setNextApproverIds(businessHeadIdList);
                    // Submit the approval request for the account
                    Approval.ProcessResult result = Approval.process(approvalRequest);
                }else {
                    throw new LeadApprovalException('Business head isn\'t configured.');
                }
            }catch(Exception e) {
                system.debug('Error==>'+e.getMessage());
                system.debug('Error>>><<'+e.getLineNumber());
                HandleBusinessException.captureError('LeadApprovalUtility', 'submitForApprovalToBusinessHead', e);
            }
        }
    }
    public static void updateApprovedDate(string groupName){
        List<Group_Member__c> groupMember = new List<Group_Member__c>();
        try{
            if(!String.isBlank(groupName)){
                groupMember = [Select Lead_Assigned_Approved_On__c From Group_Member__c Where Assignment_Approval_Group__r.Name =:groupName AND Active__c = TRUE ORDER BY Lead_Assigned_Approved_On__c ASC limit 1];
                if(!groupMember.isEmpty()){
                    groupMember[0].Lead_Assigned_Approved_On__c = DateTime.now();
                    update groupMember;
                }
            }
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage());
            system.debug('Error>>><<'+ex.getLineNumber());
        }
    }
    
    /**
     * Added by DeaGle
     * Req: Submit Project for business head approval based on role hierarchy. 
     */
    @AuraEnabled
    public static String submitProjectBHApproval(string projectId){
        try{

            system.debug('---'+projectId);
            
            if(!String.isBlank(projectId)) {
                ProcessInstance[] recordUnderApproval = [Select ID, Status,TargetObjectID, TargetObject.Name From ProcessInstance Where Status =: Constants.PENDING AND TargetObjectID =:projectId];
                if(!recordUnderApproval.isEmpty()){
                    return 'Record is currently under approval process.';
                }
                Id ownerRoleId = [SELECT Id, Owner.UserRoleId FROM Project__c WHERE Id = :projectId].Owner.UserRoleId;
                if(ownerRoleId != null) {
                    Id approverId = getBusinessHeadApproverId(ownerRoleId);
                    //Actual Approver
                    if(approverId != null) {
                        Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                        approvalRequest.setComments('Submitting project request for an approval.');
                        approvalRequest.setObjectId(projectId);
                        // Submit on behalf of a specific submitter
                        approvalRequest.setSubmitterId(UserInfo.getUserId());
                        // Submit the record to specific process and skip the criteria evaluation
                        approvalRequest.setProcessDefinitionNameOrId(Constants.PROJECT_APPROVAL_PROCESS);
                        approvalRequest.setSkipEntryCriteria(true);
                        system.debug('Initiate Project Approval');
                        approvalRequest.setNextApproverIds(new List<Id>{ approverId }); 
                        // Submit the approval request for the account
                        Approval.ProcessResult result = Approval.process(approvalRequest);
                        return 'SUCCESS';
                    }
                } 
                
            }
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage());
            system.debug('Error>>><<'+ex.getLineNumber());
            HandleBusinessException.captureError('LeadApprovalUtility', 'submitProjectBHApproval', ex);
        }
        return 'Couldn\'t find approver on your role, please contact administrator.';
    }

    private static Id getBusinessHeadApproverId(Id currentUserRoleId) {
        if(!String.isBlank(currentUserRoleId)) {
            Map<Id,UserRole> userRoleMap = new Map<Id,UserRole>([SELECT Id, ParentRoleId, Name FROM UserRole]);
            if(userRoleMap.containsKey(currentUserRoleId)) {
                Id bhRoleId = getBusinessHeadIdRecursive(userRoleMap, userRoleMap.get(currentUserRoleId));
                if(bhRoleId != null) {
                    List<User> bhUserList = [SELECT Id FROM User WHERE UserRoleId =:bhRoleId];
                    if(!bhUserList.isEmpty()) {
                        return bhUserList[0].Id;
                    }else {
                        Id mdRoleId = getMDIdRecursive(userRoleMap, userRoleMap.get(bhRoleId));
                        if(mdRoleId != null) {
                            List<User> mdUserList = [SELECT Id FROM User WHERE UserRoleId =:mdRoleId];
                            if(!mdUserList.isEmpty()) {
                                return mdUserList[0].Id;
                            }
                        }
                    }
                }
            }
        }
        return null;
    }

    private static Id getBusinessHeadIdRecursive(Map<Id,UserRole> userRoleMap, UserRole currentRole) {
        if(currentRole.ParentRoleId != null && userRoleMap.get(currentRole.ParentRoleId).Name != null && userRoleMap.get(currentRole.ParentRoleId).Name.containsIgnoreCase('Business Head')) {
            return userRoleMap.get(currentRole.ParentRoleId).Id;
        }else if(currentRole.ParentRoleId != null){
            return getBusinessHeadIdRecursive(userRoleMap, userRoleMap.get(currentRole.ParentRoleId));
        }else {
            return null; //TOP Role - CEO.
        }
    }

    public static Id getMDIdRecursive(Map<Id,UserRole> userRoleMap, UserRole currentRole) {
        if(currentRole.ParentRoleId != null && userRoleMap.get(currentRole.ParentRoleId).Name != null && userRoleMap.get(currentRole.ParentRoleId).Name.containsIgnoreCase('Managing Director')) {
            return userRoleMap.get(currentRole.ParentRoleId).Id;
        }else if(currentRole.ParentRoleId != null){
            return getMDIdRecursive(userRoleMap, userRoleMap.get(currentRole.ParentRoleId));
        }else {
            return null; //TOP Role - CEO.
        }
    }
    class LeadApprovalException extends Exception {}
}