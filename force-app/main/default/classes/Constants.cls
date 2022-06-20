public class Constants {
    public static final string LEAD_APPROVAL = 'Lead Approval';
    public static final string PENDING = 'Pending';
    public static final string LEAD_STATUS_QUALIFIED = 'Qualified';
    public static final string LEAD_STATUS_NURTURING = 'Nurturing';  
    public static final string REJECTED_STAGE = 'Dormant / Rejected';
    public static final string ACCEPTED_BY_MH_STATUS = 'Marketing Qualification';
    public static final string ACCEPTED_BY_BH_STATUS = 'Sales Qualification';
    public static final string LEAD_STAGE_UNDER_APPROVAL = 'Under Approval';
    public static final string PROJECT_APPROVAL_TYPE = 'Project Approval';
    public static final string PROJECT_APPROVAL_PROCESS = 'Project_Approval_Process';
    public static final string LEAD_APPROVAL_PROCESS_MH = 'Lead_Nurture_Approval'; 
    public static final string LEAD_APPROVAL_PROCESS_BH = 'Lead_Approval_BH';
    public static final string ACCEPTED_BY_MH_SUBSTAGE = 'Accepted by Marketing Head'; 
    public static final string REJECTED_BY_MH_SUBSTAGE = 'Rejected by Marketing Head'; 
    public static final string ACCEPTED_BY_BH_SUBSTAGE = 'Accepted by Business Head'; 
    public static final string REJECTED_BY_BH_SUBSTAGE = 'Rejected by Business Head'; 
    public static final string BH_APPROVAL_GROUP = 'Lead Approval Business Head';
    public static final string MH_APPROVAL_GROUP = 'Lead Approval Marketing Head';
    public static final string ContactRecordTypeProductMember = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Product Member').getRecordTypeId();
    public static final string OpportunityRecordTypeOneTime = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('One Time').getRecordTypeId();
    public static final string OPPOTUNITY_STAGE_CLOSED_WON = 'Closed Won'; 
    public static final String LEAD_BUSINESS_HEAD_REQ_ERROR_MSG = 'Please add business head in-order to proceed';
    public static final String LEAD_SEGMENT_REQ_BY_MH_ERROR_MSG = 'Please provide Lead segment in-order to proceed';
    public static final String LEAD_APPROVAL_STATUS_MH_APPROVED = 'Approved By Marketing Head';
    public static final String LEAD_APPROVAL_STATUS_BH_APPROVED = 'Approved By Business Head';
    public static final String OPP_ACC_TEAM_MEMBER_VALIDATION_MSG = System.Label.Opportunity_Accont_Team_Validation_Message;
}