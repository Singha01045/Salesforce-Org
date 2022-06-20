public without sharing class ProjectHanlder {
    public ProjectHanlder() {}
    
    @AuraEnabled(cacheable=true)
    public static Lead getLeadRecord(String leadId){
        try {
            if(String.isBlank(leadId))
                return null;
            return [Select Id, Name, Company, Address FROM Lead where Id =:leadId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Account getAccRecord(String accId){
        try {
            if(String.isBlank(accId))
                return null;
            return [Select Id, Name,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet FROM Account where Id =:accId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Opportunity getOppRecord(String id){
        try {
            if(String.isBlank(id))
                return null;
            return [Select Id, Name FROM Opportunity where Id =:id];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }



    @AuraEnabled
    public static Map<String,Object> createFeedback(String id, String feedback, Date cDate){
        Map<String,Object> returnMap = new Map<String,Object>();
        try {
            
            if(String.isBlank(id) || String.isBlank(feedback) || cDate == null) {
                returnMap.put('status',false);
                returnMap.put('message','Please fill all necessary details.');
                return returnMap;
            }
                
            Project__c project = [SELECT Account__c,Acidity__c,Actual_Date_of_Dispatch__c,Additional_Comments__c,Additive_Status__c,Allergen_Free_declaration__c,Allergen__c,Annual_Value__c,Annual_Volume_Full__c,Annual_Volume_in_units__c,Application_guidelines_if_any__c,Application_method__c,Application_Name__c,Application_product_shelf_life__c,Application_reciepe_code__c,Application_Samples_Receipe_Support__c,Application_Trails__c,Brix_degrees__c,Business_potential_value_INR__c,Category_Buyer__c,Category_description_as_per_FSSAI__c,Center_filling_Cream__c,City__c,Confectionary_Type__c,Cost_in_Use_target__c,Cost_in_use__c,Country_of_Compliance__c,Country_Regulation__c,Country__c,Critical__c,Currency_Type__c,Current_Cost__c,Current_Packaging__c,Current_RM_FG_Code__c,Current_Shelf_life__c,Current_Supplier_Name__c,Customer_Base_Details__c,Customer_Brand_details__c,Customer_Code__c,Customer_Comments__c,Customer_Contact__c,Customer_Cost_in_USE_CIU__c,Customer_Feedback__c,Customer_Launch_Date__c,Customer_Name__c,Customer_Target_price__c,Dispatch_Details__c,Documentation_Support__c,Dosage_guidelines_by_customer__c,End_Use_Applications__c,End_use_application_other__c,End_Use_category__c,Expected_Annual_Value__c,Expected_Shelf_Life__c,Expected_Volume_Unit__c,Export__c,Fat__c,Final_Fat__c,Final_SNF__c,First_Sample_due_date__c,Flavor_Legal_Status__c,Flavour_CIU__c,Flavour_Legal_Status__c,Halal_certifications__c,Id,If_Private_Label__c,If_yes_Flavour_Details__c,Ingredient_Specific_If_Any__c,Integration_Product_Type__c,IsDeleted,Kosher_certifications__c,Lead_Time__c,Lead__c,Legal_Status_as_per_EU__c,Legal_Status_as_per_Indian_FSSAI__c,Legal_Status_as_per_US__c,Legal_Status__c,Matching_Target_details__c,Milk_Solids__c,Minimum_order_quantity_unit__c,Minimum_order_quantity__c,Moved_Production_date__c,MSDS__c,Name,New_Supplier__c,Nutritional__c,of_pulp_if_with_fruit_pulp__c,Oil_sprinkling_Dust_on__c,Opportunity_Close_Date__c,Opportunity_Sub_Type__c,Opportunity_Type__c,Opportunity__c,Organic_certifications__c,Other_Application_Methods__c,Other_Project_Composition__c,Other__c,Packaging_Unit__c,Payment_Terms__c,Physical_Form__c,pH__c,Postal_Code__c,Preferred_thickness_Viscosity__c,Priority__c,Processing_condition__c,Product_approval_format_by_customer__c,Product_Description__c,Product_recommended__c,Product_Spec__c,Product_Type__c,Project_Category__c,Project_Completion_Date__c,Project_Name__c,Project_Reference__c,Project_request_status__c,Project_Salesforce_Code__c,Project_Title__c,Project_Type__c,Proposed_Cost__c,Proposed_date_of_dispatch__c,Proposed_Supplier_Name__c,Prototype_Feedback__c,Quantity_Unit__c,Quantity__c,Quote_Volume_in_units__c,Raw_Material_Name__c,Reason_for_New_Supplier__c,Reason_for_rejection__c,Recipe_Cost__c,RecordTypeId,Regulatory_Requirements__c,Required_End_Date__c,RM_Category__c,Sales_Code__c,Sales_head_review__c,Sample_Name__c,Sample_Size_for_trails__c,Parent_Project__c,Sampling_Quantity_details__c,Scaled_up_date__c,Sensory_profiling_Report_Required__c,Sensory_Target_profile_expectation__c,Ship_To_Address__c,Solubility_Preference__c,Solublity__c,Specific_inputs_by_customer__c,Start_Date__c,State__c,Status__c,Street__c,Sugar__c,Supplier_COA__c,Supplier_Food_Grade_Status__c,Supplier_Legal_Status__c,Supplier_MSDS__c,Supplier_Spec__c,SystemModstamp,S_O_Date__c,Target_Date__c,Target_GM_Improvement_at_FG_levels__c,Target_Price__c,Target_Saving_Percentage__c,Technical_Complexity__c,Tested_at_Flavor_Level__c,Time_Duration_in_hours__c,Total_Solids__c,Type_of_PR__c,Usage_Levels_in_Recipes_Average__c,Wet_Dry__c,Where_Used__c FROM Project__c where Id=:id];
            project.Customer_Feedback__c = feedback;
            project.Actual_Date_of_Dispatch__c = cDate;
            project.RecordTypeId = project.RecordTypeId;
            project.Status__c = 'New';
            project.Parent_Project__c = id;
            project.Id = null;
            insert project;
            returnMap.put('status',true);
            returnMap.put('message',project.id);
        } catch (Exception e) {
            System.debug('--- Exception'+e.getMessage());
            returnMap.put('status',false);
            returnMap.put('message',e.getMessage());
        }
        return returnMap;
    }
}