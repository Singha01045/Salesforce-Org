@RestResource(urlMapping='/activityWebservice/*')
global class Webservice_Activity 
{ 
    @httpPost
    global static ActivityResponseWrapper.ReponseWrapper makeWebServiceCallout()
    {
        ActivityResponseWrapper.ReponseWrapper response = new ActivityResponseWrapper.ReponseWrapper(); 
        ActivityWrapper recInfoWrap = ActivityWrapper.parse(RestContext.request.requestBody.tostring());
        response.failed_activity_list = new list<ActivityResponseWrapper.failure_activity_cls>();
        
        set<string> uniqueID = new set<string>();
        
        map<string, string> mapofUidByaccId = new map<string, string>();
        
        for(ActivityWrapper.cls_Activity actRecDetails: recInfoWrap.Activity){
            uniqueID.add(actRecDetails.search_by_value);
        }
        
        list<Account> accList = [SELECT Id, U_ID__c FROM Account WHERE U_ID__c IN :uniqueID];
        
        // check for null - accList
        for(Account accRec : accList)
        {
            mapofUidByaccId.put(accRec.U_ID__c, accRec.Id);
        }
        system.debug('accList:: '+accList);
        list<task> taskListToBeInserted = new list<task>();
        
        if(recInfoWrap.Activity != null && !recInfoWrap.Activity.isEmpty() && !accList.isEmpty()){
            for(ActivityWrapper.cls_Activity actRecDetails: recInfoWrap.Activity){
                if(mapofUidByaccId.containsKey(actRecDetails.search_by_value)){
                    Task newTask= new Task();
                    newTask.Activity_Note__c = actRecDetails.activity_type;
                    newTask.Activity_Type__c = actRecDetails.activity_type;
                    newTask.Exam_Date__c = actRecDetails.exam_date;
                    newTask.Exam_Name__c = actRecDetails.exam_name;
                    newTask.Exam_Slug__c = actRecDetails.exam_slug;
                    newTask.Is_qualified_in_exam__c = actRecDetails.is_qualified_in_exam;
                    newTask.Skill_Based_Exam_Score__c = actRecDetails.skill_based_exam_score;
                    newTask.Subject__c = actRecDetails.subject;
                    newTask.Search_by_value__c = actRecDetails.search_by_value;
                    newTask.WhatId = mapofUidByaccId.get(newTask.Search_by_value__c);
                    taskListToBeInserted.add(newTask);
                    
                }else{
                    system.debug('Account you are looking for is not available in the org...');
                    ActivityResponseWrapper.failure_activity_cls failedActivityList = new ActivityResponseWrapper.failure_activity_cls();
                    failedActivityList.failure_activity_details = actRecDetails;
                    failedActivityList.error_msg ='Account you are looking for is not available in the org...';
                    response.failed_activity_list.add(failedActivityList);
                }
            }
            
            system.debug('taskListToBeInserted:: '+taskListToBeInserted);
            system.debug('taskListToBeInserted.size():: '+taskListToBeInserted.size());
            
            if(!taskListToBeInserted.isEmpty()){   
                Database.SaveResult[] activityResult = database.insert(taskListToBeInserted, false);
                system.debug('activityResult::'+activityResult);
                system.debug('activityResult.size()::'+activityResult.size());
                response.success_activity_list = new list<task>();
                for(integer i =0; i<activityResult.size();i++){
                    if(activityResult[i].isSuccess()){
                        
                        response.success_activity_list.add(taskListToBeInserted[i]);
                    }
                    else{
                        
                        /*for(ActivityWrapper.cls_Activity failedDetails : recInfoWrap.Activity){
                            ActivityResponseWrapper.failure_activity_cls failedActivityList = new ActivityResponseWrapper.failure_activity_cls();
                            failedActivityList.failure_activity_details = failedDetails;
                            failedActivityList.error_msg ='Account is not available...';
                            response.failed_activity_list.add(failedActivityList);
                        }*/
                    }
                }
            }
        }
        
        return response;
    }
}