public class KishanAssignmentOnCustomObject 
{
    public void fetchTestRecords_1(string testId1)
    {
        List<Test7__c> getList=new List<Test7__c>();
        getList=[SELECT OwnerId, Name, 
                 Test5__r.Name,
                 Test5__r.Test2__r.Name,
                 Test5__r.Test2__r.Test1__r.Name FROM Test7__c 
                 WHERE Test5__r.Test2__r.Test1__c =: testId1];     //Child to Parent(API)
        system.debug('Fetching the Records of Assignment 1: '+getList);
        for(Test7__c iterateOverElement:getList)
        {
           system.debug('Records of Test5 Found: '+iterateOverElement.Test5__r);
           system.debug('Records of Test2 Found: '+iterateOverElement.Test5__r.Test2__r);
           system.debug('Records of Test1 Found: '+iterateOverElement.Test5__r.Test2__r.Test1__r);
        }
        
    }
    
    public void fetchTestRecords_2(string testId1)
    {
        List<Test1__c> getList=new List<Test1__c>();
        getList=[SELECT OwnerId, Name,(SELECT OwnerId, Name FROM Test2s__r ),(SELECT OwnerId, Name FROM Test4s__r )FROM Test1__c WHERE Id=:testId1];  //Parent to child(CRN)
        system.debug('Fetching the Records of Assignment 2: '+getList);
        //system.debug('Fetching the Records of Assignment 2: '+getList[0].Test2s__r);
        //system.debug('Fetching the Records of Assignment 2: '+getList[0].Test4s__r);
        for(Test1__c iterateOverElement:getList)     //Parent API Name
        {
            //system.debug('Fetching the Records of Assignment 2: '+oLoop.Test2s__r);
            //system.debug('Fetching the Records of Assignment 2: '+oLoop.Test4s__r);
            for(Test2__c testRec : iterateOverElement.Test2s__r) 
            {
                System.debug('Records of Test2 Found: '+testRec);
            }
            
            for(Test4__c testRec : iterateOverElement.Test4s__r) 
            {
                System.debug('Records of Test4 Found: '+testRec);
            }
            
        }
    }
    
    public void fetchTestRecords_3(string testId1)
    {
        List<Test6__c> getList=new List<Test6__c>();
        getList=[SELECT Name,OwnerId,
                 Test4__r.Name, 
                 Test4__r.Test1__r.Name,Id FROM Test6__c 
                 WHERE Test4__r.Test1__c=:testId1];              //Child To Parent(API)
        system.debug('Fetching the Records of Assignment 3: '+getList);
        
        for(Test6__c iterateOverElement: getList)
        {
            if(iterateOverElement.Test4__r!=NULL)
            {
               system.debug('Records of Test4 Found: '+iterateOverElement.Test4__r);
            }
            if(iterateOverElement.Test4__r.Test1__r!=NULL)
            {
                system.debug('Records of Test1 Found: '+iterateOverElement.Test4__r.Test1__r);
            }
        }
        
    }
    public void fetchTestRecords_4(string testId4)
    {
        List<Test5__c> getList=new List<Test5__c>();
        getList=[SELECT OwnerId,test2__r.Name, 
                 test2__r.test3__r.Name, 
                 test2__r.test3__r.test6__r.test4__r.Name FROM Test5__c 
                 WHERE test2__r.test3__r.test6__r.test4__c=:testId4];    
        System.debug('Fetching the Records of Assignment 4: '+getList);
        for(Test5__c iterateOverElement: getList)
        {
            system.debug('Records of Test2 Found: '+iterateOverElement.test2__r);
            system.debug('Records of Test3 Found: '+iterateOverElement.test2__r.test3__r);
            system.debug('Records of Test4 Found: '+iterateOverElement.test2__r.test3__r.test6__r.test4__r);
        }
    }
    public void fetchTestRecords_5(string testId3)
    {
        List<Test3__c> getList=new List<Test3__c>();
        getList=[SELECT OwnerId, Name,(SELECT OwnerId,Name FROM Test2s__r ),(SELECT OwnerId, Name FROM Test7s1__r) FROM Test3__c WHERE Id=:testId3];  //Parent To Child
        system.debug('Fetching the Records of Assignment 5: '+getList);
        for(Test3__c iterateOverElement:getList)
        {
            if(iterateOverElement.Test2s__r.size()>0)
            {
                for(Test2__c getRecord: iterateOverElement.Test2s__r)
                {
                    system.debug('Records of Test2 Found: '+getRecord);
                }
            }
            else
            {
                system.debug('No Records!!');
            }
            for(Test7__c getRecord: iterateOverElement.Test7s1__r)
            {
                system.debug('Records of Test7 Found: '+getRecord);
            }
        }
    }

}