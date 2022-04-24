public class testOpenWeatherController 
{
    public string City{get; set;}
    public string Temp{get; set;}
    public string Pressure{get; set;}
    public string Humidity{get; set;}
    public string minTemp{get; set;}
    public string maxTemp{get; set;}
    
    public testOpenWeatherController(ApexPages.StandardController stdController)
    {
        Contact conRec = (Contact)stdController.getRecord();
        conRec=[SELECT Id, MailingCity FROM Contact WHERE Id=: conRec.id];
        
        string contactMailingCity= conRec.MailingCity;
        string apiKey = '24733be0d5fc5071062123fe2e7819bb' ;
        string requestEndPoint = 'http://api.openweathermap.org/data/2.5/weather' ;
        requestEndPoint+='?q='+contactMailingCity;
        requestEndPoint+='&units=metric';
        requestEndPoint+='&APPID='+apiKey;        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(requestEndPoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode()==200)
        {
            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            system.debug('Results:: ' + results);
            City=String.valueOf(results.get('name'));
            
            Map<String, Object> mainResults = (Map<String, Object>)(results.get('main'));
            system.debug('Main Results:: ' + mainResults);
            
            Temp=String.valueOf(mainResults.get('temp'));
            Pressure=String.valueOf(mainResults.get('pressure'));
            Humidity=String.valueOf(mainResults.get('humidity'));
            minTemp=String.valueOf(mainResults.get('temp_min'));
            maxTemp=String.valueOf(mainResults.get('temp_max'));
        }
        else
        {
            ApexPages.Message displayErrorMsg = new ApexPages.Message(ApexPages.Severity.Error, 'There was an error in reading data');
            ApexPages.addMessage(displayErrorMsg);
        }
        
    }
}