public class AuraController 
{
    @Auraenabled
    public static decimal calculateSum(decimal fn, decimal sn)
    {
        decimal sum= fn+sn;
        return sum;
    }
    @Auraenabled
    public static list<contact> getContactList(String accId)
    {
        list<contact> conList= [SELECT Id, FirstName, LastName, Phone, Email FROM Contact WHERE AccountId = : accId];
        return conList;
    }
    @Auraenabled
    public static list<opportunity> getOppList(String accId)
    {
        list<Opportunity> oppList= [SELECT Id, Name, StageName, Amount FROM Opportunity WHERE AccountId = : accId];
        return oppList;
    }
    @AuraEnabled
    public static Contact createContact(Contact con, Id accId)
    {
        con.AccountId=accId;
        insert con;
        return con;
    }
    
    @AuraEnabled
    public static Opportunity createOpportunity(Opportunity oppRecord, Id accId)
    {
        oppRecord.AccountId = accId;
        insert oppRecord;
        return oppRecord;
    }
    
    @AuraEnabled
    public static List<Contact> findContactByName(String searchConKey, String accId) 
    {
        String name = '%' + searchConKey + '%';
        return [SELECT name FROM Contact WHERE name LIKE :name AND AccountId = : accId];
    }
    
    @AuraEnabled
    public static List<Opportunity> findOpportunityByName(String searchOppKey, String accId) 
    {
        String name = '%' + searchOppKey + '%';
        return [SELECT name FROM Opportunity WHERE name LIKE :name AND AccountId = : accId];
    }
    
    @AuraEnabled 
    public static Map<String, String> getStageNameFieldValue()
    {
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        
        List<Schema.PicklistEntry> pValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pValues) {
            
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
}