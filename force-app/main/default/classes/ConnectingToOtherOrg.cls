public class ConnectingToOtherOrg
{
    public static string getAccessToken()
    {
        string clientId= '3MVG9pRzvMkjMb6k.Ka41BwgSg7U90n.gfj81Kax3QkoJiI_dC07kuYh0E9UclILgtx2M8r.DKxMKHKbNvWyl';
        string clientSecret = '10A00D5037C737804DD7065BC5863C3FA457F607F5ACC657EFBABF8367C74DD4';
        string username ='dineshb@utilitarianlab.com';
        string password = 'Apex@2022a6jwnPxa58ibam6VEmgApSGOd';
        
        
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
    
    public static void getRecords()
    {
        string endPoint = 'https://utilitarianlabsprivatelimit-dev-ed.my.salesforce.com/services/data/v54.0/query/?q=SELECT+LastName,Id+from+Contact';
        Http newHttp = new Http();
        HttpRequest newRequest = new HttpRequest();
        newRequest.setEndpoint(endPoint);
        newRequest.setMethod('GET');
        newRequest.setHeader('Authorization','Bearer '+getAccessToken());
        
        HttpResponse newResponse = newHttp.send(newRequest);
        System.debug('Response:: '+newResponse.getBody());
        
        if(newResponse.getStatusCode()==200)
        {
            Map<String, Object> getResult = (Map<String, Object>)JSON.deserializeUntyped(newResponse.getBody()); 
            System.debug('RESULTS:: ' + getResult);
        }
    }
    
    public static void updateRecords()
    {
        string endPoint = 'https://utilitarianlabsprivatelimit-dev-ed.my.salesforce.com/services/data/v54.0/sobjects/Contact/0035j00000NlfrJAAR';
        Http newHttp = new Http();
        HttpRequest newRequest = new HttpRequest();
        newRequest.setEndpoint(endPoint);
        newRequest.setMethod('PATCH');
        newRequest.setHeader('Authorization','Bearer '+getAccessToken());
        newRequest.setHeader('Content-Type', 'application/json');

        
        newRequest.setBody('{ "FirstName" : "Updated", "LastName" : "Contact", "Phone" : "5555555", "Email" : "updation@util.com" }');
        
        /*string reqBody = '{ "FirstName" : "Updated", "LastName" : "Contact", "Phone" : "5555555", "Email" : "updation@util.com" }' ;*/
        
        HttpResponse newResponse = newHttp.send(newRequest);
        System.debug('Response:: '+newResponse.getBody());
        
        if(newResponse.getStatusCode()==200)
        {
            Map<String, Object> getResult = (Map<String, Object>)JSON.deserializeUntyped(newResponse.getBody()); 
            System.debug('RESULTS:: ' + getResult);
        }
    }
    
    public static void deleteRecords(String idToDelete)
    {
        string endPoint = 'https://utilitarianlabsprivatelimit-dev-ed.my.salesforce.com/services/data/v54.0/sobjects/Contact/'+idToDelete;
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
}