public class DescibeDemoController 
{
    
    @RemoteAction
    public static Map<String,String> fetchObjects()
    {
        Map<String,String> allObjectNameByAPI = new Map<String,String>();
        List<Schema.SObjectType> obj = Schema.getGlobalDescribe().Values();
        for(Schema.SObjectType st : obj)
        {
            allObjectNameByAPI.put(st.getDescribe().getName(),st.getDescribe().getLabel());
        }
        return allObjectNameByAPI;
    }
    
    
    @RemoteAction
    public static Map<String,String> getAllRelatedFields(String ObjectName)
    {
        Map<String,String> allFieldByAPI = new Map<String,String>();
        SObjectType objTyp = Schema.getGlobalDescribe().get(ObjectName);
        DescribeSObjectResult objDef = objTyp.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap();
        Set<String> fieldSet = fields.keySet();
        List<SelectOption> options = new List<SelectOption>();
        for(String s:fieldSet)
        {
            SObjectField Sobjfields = fields.get(s);
            DescribeFieldResult selectedField = Sobjfields.getDescribe();
            if(selectedField.isUpdateable() || selectedField.isIdLookup())
            allFieldByAPI.put(selectedField.getName(),selectedField.getLabel());
        }
        return allFieldByAPI;
    }
      
    /*@RemoteAction 
    public static list<sObject> queryFields(string SobjectField)
    {
        List<sObject> RecordList = Database.query(SobjectField);
        return RecordList;
    }*/
    
    
    public static string getAccessToken()
    {
        string clientId= '3MVG9pRzvMkjMb6kGZzZoCQDzSrtcKe9lMPP_Z66cb4Cy778UbvEWYnxjSnmcV.h2lCW9rsmOR8Flsm8rJnrA';
        string clientSecret = '48B40EF73F685911FAE84F5B23AF47B69F2EF4C45E911D7E70DCF9BEC137E7A2';
        string username ='isha.raj@utilitarianlab.com';
        string password = '11IRs@123';
        
        Http ATHttp = new Http();
        HttpRequest ATRequest = new HttpRequest();
        ATRequest.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        ATRequest.setMethod('POST');
        string reqBody = 'grant_type=password' + 
              '&client_id=' + ClientId + 
              '&client_secret=' + ClientSecret + 
              '&username=' + username +
              '&password=' + password ;
        
        ATRequest.setBody(reqBody);
        HttpResponse ATResponse = ATHttp.send(ATRequest);
        
        if(ATResponse.getStatusCode()==200)
        {
            Map<String, Object> getResult = (Map<String, Object>)JSON.deserializeUntyped(ATResponse.getBody());
            String accessToken = (string) getResult.get('access_token');
            System.debug('ACCESS TOKEN:: ' + accessToken);
            return accessToken;  
        }
        return null;
    }
    
    
    @RemoteAction
    public static list<Object> getQueriedRecords(string SobjectField)
    {
        string endPoint = 'https://utilitarianlabspvtltd3-dev-ed.my.salesforce.com/services/data/v54.0/query/?q='+SobjectField;
        system.debug('EndPoint:: ' + endPoint);
        Http newHttp = new Http();
        HttpRequest newRequest = new HttpRequest();
        newRequest.setEndpoint(endPoint);
        newRequest.setMethod('GET');
        newRequest.setHeader('Authorization','Bearer '+getAccessToken());
        
        HttpResponse newResponse = newHttp.send(newRequest);
        System.debug('Response:: '+newResponse.getBody());
        Map<String, Object> getResult;
        List<Object> recordsList;
        if(newResponse.getStatusCode()==200)
        {
            getResult = (Map<String, Object>)JSON.deserializeUntyped(newResponse.getBody()); 
            if(getResult != null && getResult.containsKey('records'))
            {
                recordsList = (List<Object>) getResult.get('records');
                System.debug('--- accList'+recordsList);
            }
            System.debug('RESULTS:: ' + getResult);
        }
        return recordsList;
    }
    
    @RemoteAction
    public static void deleteRecords(String recordID, string selectedSObject)
    {
        string endPoint = 'https://utilitarianlabspvtltd3-dev-ed.my.salesforce.com/services/data/v54.0/sobjects/'+selectedSObject+'/'+recordID;
        Http newHttp = new Http();
        HttpRequest newRequest = new HttpRequest();
        newRequest.setEndpoint(endPoint);
        newRequest.setMethod('DELETE');
        newRequest.setHeader('Authorization','Bearer '+getAccessToken());
        
        HttpResponse newResponse = newHttp.send(newRequest);
        System.debug('Response:: '+newResponse.getBody());
        
        if(newResponse.getStatusCode()==200)
        {
            Map<String, Object> getResult = (Map<String, Object>)JSON.deserializeUntyped(newResponse.getBody()); 
            System.debug('RESULTS:: ' + getResult);
        }
    }
    
    @RemoteAction
    public static void updateRecords(Contact recToBeUpdated, String recordID, string selectedSObject)
    {
        string endPoint = 'https://utilitarianlabspvtltd3-dev-ed.my.salesforce.com/services/data/v54.0/sobjects/'+selectedSObject+'/'+recordID;
        Http newHttp = new Http();
        HttpRequest newRequest = new HttpRequest();
        newRequest.setEndpoint(endPoint);
        newRequest.setMethod('PATCH');
        newRequest.setHeader('Authorization','Bearer '+getAccessToken());
        newRequest.setHeader('Content-Type', 'application/json');

        
        newRequest.setBody(JSON.serialize(recToBeUpdated));
               
        HttpResponse newResponse = newHttp.send(newRequest);
        System.debug('Response:: '+newResponse.getBody());
        
        if(newResponse.getStatusCode()==200)
        {
            Map<String, Object> getResult = (Map<String, Object>)JSON.deserializeUntyped(newResponse.getBody()); 
            System.debug('RESULTS:: ' + getResult);
        }
    }
}