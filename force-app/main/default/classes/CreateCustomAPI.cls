//Salesforce Apex Rest API Integration...
@RestResource(urlMapping='/createGetRecord/*')
global class CreateCustomAPI 
{
    //Using POSTMAN here to get and post the Records...
    /*@httpPost         
    global static string recordCreate()
    {
        system.debug('RecordRequestList:: ' + RestContext.request.requestBody.tostring());
        LeadRecordInfo leadInfoRec = LeadRecordInfo.parse(RestContext.request.requestBody.tostring());
        system.debug('leadInfoRec::'+leadInfoRec.EmailAddress);
        
        Lead leadRec = new Lead();
        leadRec.Firstname = leadInfoRec.FirstName;
        leadRec.LastName = leadInfoRec.LastName;
        leadRec.Email = leadInfoRec.EmailAddress;
        leadRec.Company = 'DEFAULT';
        
        insert leadRec;
        return leadRec.Id;
    }
    
    global class ContactInfo
    {
        String FName{get;set;}
        String LName{get;set;}
        String Phn{get;set;}
        String Email{get;set;}
        String Title{get; set;} 
        Date Bday{get; set;}
    }
    
    
    @httpGet
    global static ContactInfo getLeadInfo()
    {
        RestRequest req = RestContext.Request;
        Id conID = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1); 
        Contact existingConRecList = [SELECT Id, FirstName, LastName, Email, Phone, Title, Birthdate FROM Contact WHERE Id =: conID];
        
        ContactInfo conRec = new ContactInfo();
        conRec.FName = existingConRecList.FirstName;
        conRec.LName = existingConRecList.LastName;
        conRec.Email = existingConRecList.Email;
        conRec.Phn = existingConRecList.Phone;
        conRec.Title =existingConRecList.Title;
        conRec.Bday = existingConRecList.Birthdate;
        return conRec;
    }
    
    
    //Using WORKBENCH(RestExplorer) here to get the Records...
    @HttpGet
    global static List<Account> getAllAccounts()              
    {
        List<Account> accList;
        try
        {
            accList = [SELECT Name, Phone, Id, Website, ShippingStreet FROM Account LIMIT 10];
            return accList; 
        }
        catch(Exception e)
        {
            system.debug('Error:: ' + e.getMessage());
        }
        return accList;
    }*/
    
    @HttpGet
    global static Account getAllAccounts() 
    {
        RestResponse getResponse = RestContext.response;
        RestRequest getRequest = RestContext.request;
        string accountID = getRequest.requestURI.substring(getRequest.requestURI.lastindexOf('/')+1);
        system.debug('Account ID:: '+ accountID);
        Account accResult = [SELECT Name, Phone, Id, Website, ShippingStreet FROM Account WHERE Id=:accountID];
        return accResult;
    }
    
    @httpPost
    global static string doPost(String name, String phn, String ac, String site)
    {
        Account accRecord = new Account();
        accRecord.Name=name;
        accRecord.Phone=phn;
        accRecord.AccountNumber=ac;
        accRecord.Website=site;
        return accRecord.Id;
    }
}