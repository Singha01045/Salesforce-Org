public class NoSplitOpportunityHelper {
    @AuraEnabled
    public static void createOneTimeOppRec(String oppId){
        try{
            if(!String.isBlank(oppId)) {
                List<Opportunity> parentOpportunity = new List<Opportunity>();
                list<Opportunity> childOppToBeDeleted = new list<Opportunity>();
                list<OpportunityLineItem> productToBeInserted = new list<OpportunityLineItem>();
                
                parentOpportunity = [Select Id, Name, AccountId, CloseDate, Customer_Followup_Date__c, Customer_Payment_update__c
                                     ,Customer_response__c, TotalOpportunityQuantity, Probability, Fert_Code__c,LeadSource, Next_Order_Date__c, NextStep, Order_fulfillment__c,
                                     Payment_Term__c, StageName, Type From Opportunity Where Id = :oppId];
                
                productToBeInserted = [SELECT Id, OpportunityId, SortOrder, ServiceDate, Discount, Quantity, PricebookEntryId, Product2Id, TotalPrice, UnitPrice, ListPrice, Description, Quantity_Unit__c FROM OpportunityLineItem WHERE OpportunityId = : oppId];
                
                /* childOppToBeDeleted = [SELECT Id, Parent_Opportunity__c FROM Opportunity WHERE Split_Percentage__c = 100 AND Parent_Opportunity__c = :oppId ];
                delete childOppToBeDeleted; */
                
                if(!parentOpportunity.isEmpty()) {
                    Opportunity oneTimeOppRec = new Opportunity();
                    oneTimeOppRec.Parent_Opportunity__c = parentOpportunity[0].Id;
                    oneTimeOppRec.RecordTypeId = Constants.OpportunityRecordTypeOneTime;
                    oneTimeOppRec.Name = parentOpportunity[0].Name+' - 1' ;
                    oneTimeOppRec.AccountId = parentOpportunity[0].AccountId;
                    oneTimeOppRec.CloseDate = parentOpportunity[0].CloseDate;
                    oneTimeOppRec.TotalOpportunityQuantity = parentOpportunity[0].TotalOpportunityQuantity ;
                    oneTimeOppRec.Customer_Followup_Date__c = parentOpportunity[0].Customer_Followup_Date__c ;
                    oneTimeOppRec.Customer_Payment_update__c = parentOpportunity[0].Customer_Payment_update__c ;
                    oneTimeOppRec.Customer_response__c = parentOpportunity[0].Customer_response__c ;
                    oneTimeOppRec.Fert_Code__c = parentOpportunity[0].Fert_Code__c ;
                    oneTimeOppRec.LeadSource = parentOpportunity[0].LeadSource ;
                    oneTimeOppRec.Next_Order_Date__c = parentOpportunity[0].Next_Order_Date__c ;
                    oneTimeOppRec.NextStep   = parentOpportunity[0].NextStep ;
                    oneTimeOppRec.StageName  = 'New';
                    oneTimeOppRec.Probability    = parentOpportunity[0].Probability ;
                    oneTimeOppRec.Order_fulfillment__c = parentOpportunity[0].Order_fulfillment__c ;
                    oneTimeOppRec.Payment_Term__c = parentOpportunity[0].Payment_Term__c ;
                    oneTimeOppRec.Type = parentOpportunity[0].Type;
                    insert oneTimeOppRec;
                    
                    if(!productToBeInserted.isEmpty()){
                        list<OpportunityLineItem> productList = new list<OpportunityLineItem>();
                        for(OpportunityLineItem productRec : productToBeInserted){
                            
                            OpportunityLineItem newProductRec = new OpportunityLineItem();
                            newProductRec.OpportunityId = oneTimeOppRec.Id;
                            newProductRec.UnitPrice = productRec.UnitPrice;
                            newProductRec.ServiceDate = productRec.ServiceDate;
                            //newProductRec.Discount = productRec.Discount;
                            newProductRec.Quantity = productRec.Quantity;
                            newProductRec.PricebookEntryId = productRec.PricebookEntryId;
                            newProductRec.Product2Id = productRec.Product2Id;
                            newProductRec.SortOrder = productRec.SortOrder;
                            newProductRec.Description  = productRec.Description ;
                            newProductRec.Quantity_Unit__c = productRec.Quantity_Unit__c;
                            productList.add(newProductRec);
                        }
                        system.debug('---'+productList);
                        if(!productList.isEmpty()){
                            insert productList;
                            parentOpportunity[0].StageName = 'In-Progress';
                            update parentOpportunity[0];
                        }                            
                    }
                }
                
                
            }
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage());
            system.debug('Error@@==>'+ex.getLineNumber());
        }
    }
}