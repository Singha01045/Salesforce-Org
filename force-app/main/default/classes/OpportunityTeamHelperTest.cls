@isTest
private class OpportunityTeamHelperTest {
    @isTest 
    static void test() 
    {
        Test.startTest();
        
        Opportunity_Team_Master__c obj = new Opportunity_Team_Master__c();
        insert obj;
        
        Project__c recordType = new Project__c();
        insert recordType;
        
        list<Contact> conList = new list<Contact>();
        for(Integer i =0; i<10; i++){
            Contact con = new Contact();
            con.FirstName = 'FIRSTNAME- '+ i;
            con.LastName = 'LASTNAME- ' + i;
            conList.add(con);
        }
        insert conList;
        
        list<String> contactIDList =  new list<String>();
        for(Contact con: conList){
            contactIDList.add(con.Id);
        }
        
        OpportunityTeamHelper.getOpportunityteamMaster();
        
        OpportunityTeamHelper.createOppTeam(obj.id, recordType.id , contactIDList);
        
        Test.stopTest();
    }
}