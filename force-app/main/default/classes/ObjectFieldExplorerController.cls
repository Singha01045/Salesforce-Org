public class ObjectFieldExplorerController 
{
    /*public List<SelectOption> getobjNames()
    {
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None','--None--'));
        for(Schema.SObjectType f : gd)
        {
            if(f.getDescribe().getName().contains('__c'))
                options.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getName()));
        }
        return options;
    }*/
    
    public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();

    public String selectedObject {get; set;}

    public String selectedField {get; set;}

    Public ObjectFieldExplorerController()
    {   
        selectedObject = 'SObjects';
    }

    public List<SelectOption> getObjectNames() 
    {
        List<SelectOption> objNames = new List<SelectOption>();
       
            objNames.add(new SelectOption('SObjects','SObjects'));
            objNames.add(new SelectOption('Pages','pages'));
            objNames.add(new SelectOption('Components','Components'));
        return objNames;
     }

     public List<ApexClass> getObjectFields() 
     { 
            
            List<sobject> ac = new List<sobject>();
            if(selectedObject == 'SObjects'){
            //ac =[select name from sObjects];
            
            }
            else if(selectedObject == 'Pages')
            {
            ac =[select name from ApexPage];
            }
            else{
            ac =[select name from ApexComponent];
            }
            return ac;
      }    
}