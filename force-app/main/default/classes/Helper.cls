public class Helper {
    
    public static void triggerHelper(list<task> taskList)
    {
        Set<Id> LeadId = new Set<Id>();
        for(Task tak : taskList){
            if(tak.WhoId !=null && tak.Status == 'Deferred'){
                LeadId.add(tak.WhoId);
            }
        }
        
        Map<Id,Lead> LeadMap = new Map<Id,Lead> ([SELECT Id,(SELECT WhoId,Status FROM Tasks WHERE Status='Deferred') FROM Lead WHERE Id IN:LeadId]);
        for(Task newtask : taskList){
            if(newtask.whoId != null && LeadMap.containsKey(newtask.whoId)){
                Lead led = LeadMap.get(newtask.WhoId);
                if(led.tasks.size()>0){
                    newtask.addError('Duplicate Task Found In the database');
                }
            }
        }
    }
    
    
    //ISHA TASK
    public static void triggerHelper1(map<id, lead> newMap, map<id, lead> oldMap)
    {
        for(lead newtask : newMap.values()){
            if(newtask.Status != oldMap.get(newtask.id).status){
                if(newTask.Status == 'Open - Not Contacted'	&& oldMap.get(newtask.id).status == 'Working - Contacted'){
                    newTask.Status = 'Working - Contacted';
                }
                if((newTask.Status == 'Open - Not Contacted' || newTask.Status == 'Working - Contacted') && oldMap.get(newtask.id).status == 'Closed - Converted'){
                    newTask.Status = 'Closed - Converted';
                }
                if((newTask.Status == 'Open - Not Contacted' || newTask.Status == 'Working - Contacted' || newTask.Status == 'Closed - Converted')	&& oldMap.get(newtask.id).status == 'Closed - Not Converted'){
                    newTask.Status = 'Closed - Not Converted';
                }
            }
        }
    }
    
    @Auraenabled
    public static wrapperClass getDataForUI(id recId){
        
        wrapperClass getSingleRecord = new wrapperClass();
        //getSingleRecord.recordTypeDevName = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sample').getDeveloperName();
        getSingleRecord.fName = [SELECT FirstName FROM Contact WHERE Id = :recId].FirstName;
        return getSingleRecord;
    }
    public class wrapperClass                      //This is the Wrapper or Container Class
    {
        Public String recordTypeDevName;
        public string fName;
    }
    
}