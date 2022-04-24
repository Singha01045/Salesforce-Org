public with sharing class SpoonacularAPICallout 
{
    private static final string SPOONACULAR_API = 'https://api.spoonacular.com';
    private static final string API_KEY = 'a8a2e9d6d8714b2397bc915aa0656d4f';
    
    @AuraEnabled
    public static string getRandomRecipe()
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndPoint(SPOONACULAR_API+'/recipes/random?apiKey='+API_KEY);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        //If the request is succesful, parse the JSON response...
        system.debug('STATUS CODE:: '+ res.getStatusCode());
        if(res.getStatusCode() == 200)
        {
            return res.getBody();
        }
        return '';
    }
    
    @AuraEnabled
    public static string getRecipeInformation(string RecipeID)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        //https://api.spoonacular.com/recipes/{id}/information
        req.setEndPoint(SPOONACULAR_API+'/recipes/'+RecipeID+'/information?apiKey='+API_KEY);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        system.debug('STATUS CODE:: '+ res.getStatusCode());
        if(res.getStatusCode() == 200)
        {
            return res.getBody();
        }
        return '';
    }
    
    @AuraEnabled
    public static string getRecipeByIngredients(string ingredients)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndPoint(SPOONACULAR_API+'/recipes/findByIngredients?apiKey='+API_KEY +'&ingredients='+ingredients);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        system.debug('STATUS CODE:: '+ res.getStatusCode());
        if(res.getStatusCode() == 200)
        {
            return res.getBody();
        }
        return '';
    }
    
}