/*
*      Author: Anjali Singh
*/

public class SyncToOpportunityHelper {
    
    @AuraEnabled
    public static void createQuoteLineItem(String quoteId){
        try{
            if(!String.isBlank(quoteId)) {
                system.debug('Quote Id:: '+ quoteId);
                
                Quote getOppIdFromRecordPage = new Quote();
                getOppIdFromRecordPage = [SELECT Id, OpportunityId FROM Quote WHERE Id =: quoteId];
                list<OpportunityLineItem> productListToBeSynced = new list<OpportunityLineItem>([SELECT Id, SortOrder, OpportunityId, Name, Product2Id, ProductCode, Quantity, Discount, TotalPrice,
                                                                                                 UnitPrice, Description, ServiceDate, ListPrice, Quantity_Unit__c, Subtotal, PricebookEntryId,
                                                                                                 Packaging_Quantity__c, Packaging_Type__c, Packaging_Unit__c, SAP_Price__c, Sales_Price__c, 
                                                                                                 Sales_Price_Markup_From_Finance__c, Sales_Price_Markup_From_SAP__c, Finance_Price__c, Finance_Markup__c
                                                                                                 FROM OpportunityLineItem WHERE OpportunityId =:getOppIdFromRecordPage.OpportunityId]);
                
                list<QuoteLineItem> quoteLineItemToBeDeleted = new list<QuoteLineItem>();
                quoteLineItemToBeDeleted = [SELECT Id, QuoteId FROM QuoteLineItem WHERE QuoteId =: quoteId];
                delete quoteLineItemToBeDeleted;
                
                if(!productListToBeSynced.isEmpty()){
                    list<QuoteLineItem> quoteLineItemList = new list<QuoteLineItem>();
                    for(OpportunityLineItem productRec : productListToBeSynced){
                        
                        QuoteLineItem newQuoteLineRec = new QuoteLineItem();
                        newQuoteLineRec.QuoteId = getOppIdFromRecordPage.Id;
                        newQuoteLineRec.UnitPrice = productRec.UnitPrice;
                        newQuoteLineRec.ServiceDate = productRec.ServiceDate;
                        newQuoteLineRec.Discount = productRec.Discount;
                        newQuoteLineRec.Quantity = productRec.Quantity;
                        newQuoteLineRec.PricebookEntryId = productRec.PricebookEntryId;
                        newQuoteLineRec.Product2Id = productRec.Product2Id;
                        newQuoteLineRec.SortOrder = productRec.SortOrder;
                        newQuoteLineRec.Description  = productRec.Description ;
                        newQuoteLineRec.Quantity_Unit__c = productRec.Quantity_Unit__c ;
                        newQuoteLineRec.Packaging_Quantity__c = productRec.Packaging_Quantity__c;
                        newQuoteLineRec.Packaging_Type__c = productRec.Packaging_Type__c;
                        newQuoteLineRec.Packaging_Unit__c = productRec.Packaging_Unit__c;
                        newQuoteLineRec.SAP_Price__c = productRec.SAP_Price__c;
                        newQuoteLineRec.Sales_Price__c = productRec.Sales_Price__c;
                        newQuoteLineRec.Sales_Price_Markup_From_Finance__c = productRec.Sales_Price_Markup_From_Finance__c;
                        newQuoteLineRec.Sales_Price_Markup_From_SAP__c = productRec.Sales_Price_Markup_From_SAP__c;
                        newQuoteLineRec.Finance_Price__c = productRec.Finance_Price__c;
                        newQuoteLineRec.Finance_Markup__c = productRec.Finance_Markup__c;
                        quoteLineItemList.add(newQuoteLineRec);
                    }
                    system.debug('---'+quoteLineItemList);
                    if(!quoteLineItemList.isEmpty()){
                        insert quoteLineItemList;
                    }                            
                }
            }
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage());
            system.debug('Error@@==>'+ex.getLineNumber());
        }
    }
    
}