public class LinkedIn_SF_Controller {
    
    public string  clientId                     {get;set;}
    public string  clientSecret                 {get;set;}
    public string  redirectUrl                  {get;set;}
    public string  code                         {get;set;}
    public string accessToken                   {get;set;}
    public string state                         {get;set;}

    Public LinkedIn_SF_Controller(){
        redirectUrl = 'https://anjalisinghorg-dev-ed.my.salesforce.com/apex/LinkedIn_AccessToken';
    }
    
    public PageReference requestCode(){
        string url ='https://www.linkedin.com/oauth/v2/authorization';
        url = url + '?response_type=code';
        url = url + '&client_id='+clientId;
        url = url + '&scope=r_liteprofile';
        url = url + '&state='+state;
        url = url + '&redirect_uri='+redirectUrl;
        PageReference page = new PageReference(url);
        return page;
    }
    
    public void readCode(){
        code=Apexpages.currentPage().getParameters().get('code');
    }
    
    public void requestToken(){
        string endpoint ='https://www.linkedin.com/oauth/v2/accessToken';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        string reqBody = 'grant_type=authorization_code'; 
        reqBody = reqBody + '&client_id=' + clientId;
        reqBody = reqBody + '&client_secret=' + clientSecret;
        reqBody = reqBody + '&code=' + code;
        reqBody = reqBody + '&redirect_uri=' + redirectUrl;
        
        request.setBody(reqBody);
        HttpResponse response = http.send(request);
        
        String jsonString = response.getBody();
        System.JSONParser jsonParse = JSON.createParser(jsonString);
        while(jsonParse.nextToken()!=null) {
            if(jsonParse.getText() == 'access_token') {
                jsonParse.nextToken();
                accessToken = jsonParse.getText();
            }
        }
    }
}