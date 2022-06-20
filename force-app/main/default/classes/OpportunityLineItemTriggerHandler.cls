/**
 * Author: DeaGle
 */
public without sharing class OpportunityLineItemTriggerHandler {
    private OpportunityLineItemTriggerHandler() {}
    public static OpportunityLineItemTriggerHandler handlerInstance;
    
    public static OpportunityLineItemTriggerHandler getInstance() {
        if(handlerInstance == null)
            handlerInstance = new OpportunityLineItemTriggerHandler();
        return handlerInstance;
    }

    public void onBeforeInsert(List<OpportunityLineItem> lineItemList) {

    }

    public void onBeforeUpdate(List<OpportunityLineItem> lineItemList, Map<Id,OpportunityLineItem> oldLineItemMap) {
        for(OpportunityLineItem lineItem : lineItemList) {
            if(((lineItem.Sales_Price__c != null && lineItem.Sales_Price__c != oldLineItemMap.get(lineItem.Id).Sales_Price__c) || (lineItem.UnitPrice != null && lineItem.UnitPrice != oldLineItemMap.get(lineItem.Id).UnitPrice)) && lineItem.Finance_Price__c > 0) {
                Double salesPriceMD = 0;
                if(lineItem.Sales_Price__c > 0 && lineItem.Sales_Price__c < lineItem.Finance_Price__c) {
                    salesPriceMD = (((lineItem.Finance_Price__c - lineItem.Sales_Price__c)/100) * lineItem.Finance_Price__c);
                }
                Double customerPriceMD = 0;
                if(lineItem.UnitPrice > 0 && lineItem.UnitPrice < lineItem.Finance_Price__c) {
                    customerPriceMD = (((lineItem.Finance_Price__c - lineItem.UnitPrice)/100) * lineItem.Finance_Price__c);
                }

                if(customerPriceMD > salesPriceMD) {
                    lineItem.Approval_Markdown__c = customerPriceMD;
                }else if(salesPriceMD > customerPriceMD) {
                    lineItem.Approval_Markdown__c = salesPriceMD;
                }
            }
        }
    }


}