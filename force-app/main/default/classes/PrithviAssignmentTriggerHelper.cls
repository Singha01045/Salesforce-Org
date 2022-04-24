public class PrithviAssignmentTriggerHelper 
{
    //ASSIGNMENT-1 before Delete, after Undelete
    
    public static void UpdateDateTimeFieldOnAccountBeforeDeleteAfterUndelete(Map<Id, Account> newList, Map<Id, Account> oldList)
    { 
        //if deleted update datetime field on Account --- Task 1
            List<Account> oldAccList = [SELECT ID FROM Account WHERE ID IN: oldList.keySet()];
            for(Account aRec: oldAccList)
            {
                aRec.Deleted_Time__c = System.now();
            }
            update oldAccList;
        
        //If undeleted then update undeleted field on Account --- Task 2
            List<Account> newAccList = [SELECT ID FROM Account WHERE ID IN: newList.keySet()];
            
            for(Account a : newAccList) 
            {
                a.Undeleted_Time__c = system.now();
            }
            if(!newAccList.isEmpty())
                update newAccList;
        
        /*MY CODE
        if(trigger.isAfterDelete)
        {
            list<Account> accList = [SELECT Id FROM Account];
            for(Account acc: accList)
            {
                acc.Deleted_Time__c = System.now();
                update acc;
            }
            update accList;
        } 
        
        if(trigger.isAfterUndelete)
        {
            
            list<Account> accList = [SELECT Id FROM Account];
            for(Account acc: accList)
            { 
                acc.Undeleted_Time__c = system.now();
            }  
            update accList;
        }*/
    }
    
    
    //ASSIGNMENT-2
    
    //Task-1: Validate that same person cannot apply for one job twice.
    
    public static Boolean runOnce=false;
    public static void validateSingleApplicant(list<Applicants_Form__c> appRecordList)
    {
        
        //Getting all the Unique Job ids
        set<Id> allJobsId = new set<Id>();
        for(Applicants_Form__c appRecord: appRecordList)
        {
            allJobsId.add(appRecord.Choose_Job__c);
        }
        
        //Getting Existing Jobs
        list<Applicants_Form__c> existingApplicants = [SELECT Id, Choose_Job__c, Applying_Contact__c FROM Applicants_Form__c WHERE Choose_Job__c=:allJobsId];
        map<Id, list<Id>> allContactsById = new map<Id, list<Id>>();
        
        if(!existingApplicants.isEmpty())
        {
            for(Applicants_Form__c appRecord : existingApplicants)
            {
                if(allContactsById.containsKey(appRecord.Choose_Job__c))          //If the job id is already existing goto next line, otherwise goto else part
                {
                    allContactsById.get(appRecord.Choose_Job__c).add(appRecord.Applying_Contact__c);     //Adding new contact on the existing job Id
                }
                else
                {
                    allContactsById.put(appRecord.Choose_Job__c, new list<Id>{appRecord.Applying_Contact__c});  //Adding new Job id with contacts
                }
            }
        }
        
        //Processing new applicant list
        for(Applicants_Form__c appRecord : appRecordList)
        {
            if(allContactsById.containsKey(appRecord.Choose_Job__c))
            {
                list<Id> existingContacts = allContactsById.get(appRecord.Choose_Job__c);
                if(existingContacts.contains(appRecord.Applying_Contact__c))
                {
                    appRecord.addError('Sorry! You cannot apply for the same job twice');
                }
            }
        } 
    }
    
    public static void updateJobFieldAfterInsertOrUpdateNewApplicant(list<Applicants_Form__c> appList)
    {
        //Task-2: Updating Total No of Candidates field of Job record based on the application form of an applicant
        
        list<Jobs__c> jobList= [SELECT Id, (SELECT Id FROM Choose_Job__r) FROM Jobs__c];
        if(!jobList.isEmpty())
        {
            for(Jobs__c jobRec: jobList)
            {
                jobRec.Total_no_of_Applied_Candidates__c = jobRec.Choose_Job__r.size(); 
            }
        }	
        update jobList;
        
        //Task-3: Updating Term field of Job record based on the applied month of the Applicant
    
        list<Jobs__c> jobList1 = [SELECT Id, Term__c, (SELECT Id,Application_Submitted_Date__c FROM Choose_Job__r) FROM Jobs__c];
        for(Jobs__c var: jobList1)
        {
            for(Applicants_Form__c  app: appList )
            {
                Integer month=app.Application_Submitted_Date__c.month();
                system.debug(month);
                if(month>=1 && month<=4)
                {
                    var.Term__c='Summer';
                }
                else if(month>=5 && month<=8)
                {
                    var.Term__c='Rainy';
                }
                else 
                {
                    var.Term__c='Winter';
                }   
            } 
        }
    }
    
    // Task 4: Applying Validation Rule on Job if no of applied candidates is exceeding required no of candidate field (after update, before update)
    
    public static void validateJobFieldAfterBeforeUpdate(list<Jobs__c> jobList)
    {
            for(Jobs__c var: jobList)
            {
                if( (var.Total_no_of_Applied_Candidates__c) > (var.Required_No_of_Candidates__c) )
                {
                    var.addError('You cannot apply for this job now as seats are full!');
                }
            }
    }
}