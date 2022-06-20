public without sharing class OppSplitParentController {

    @AuraEnabled(cacheable=true)
     public static List<Opportunity> getRecord(String oppId){
       try {
            System.debug('OppId'+oppId);
            return [Select Id, Name,AccountId,TotalOpportunityQuantity,Pricebook2Id,(SELECT Id,Name,Quantity,Quantity_Unit__c,Product2Id,PricebookEntryId,UnitPrice From OpportunityLineItems), Amount from opportunity where Id=:oppId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string createOpp(Opportunity parentOpp,List<OppWrapper> oppWrappers){
        try {
            System.debug('ParentOPPPPP'+parentOpp);
            List<Opportunity> oppList = new List<Opportunity>();
            for(OppWrapper opWrapper:oppWrappers){
                Opportunity opp = new Opportunity();
                opp.Name = opWrapper.oppName;
                opp.AccountId = parentOpp.AccountId;
                opp.TotalOpportunityQuantity = opWrapper.totalQuantity;
                //opp.Amount = opWrapper.totalAmount;
                opp.Pricebook2Id = parentOpp.Pricebook2Id;
                opp.Parent_Opportunity__c = parentOpp.Id;
                opp.StageName = 'New';
                opp.CloseDate = opWrapper.closeDate;
                opp.Next_Order_Date__c = opWrapper.nextOrderDate;
                opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('One Time').getRecordTypeId();
                oppList.add(opp);
            }

            insert oppList;
            List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
            List<Sales_Order__c> salesList = new List<Sales_Order__c>();

            for(Integer i=0;i<oppList.size();i++){
                Opportunity opp = oppList[i];
                String oppId = opp.Id;

                Sales_Order__c salesOrder = new Sales_Order__c();
                salesOrder.Name = 'Sales_'+opp.Name+'_'+(i+1);
                salesOrder.Opportunity__c = oppId;
                salesOrder.Amount__c = oppWrappers[i].totalAmount;
                salesOrder.Initiated_By__c = UserInfo.getUserId();
                salesOrder.Account__c = opp.AccountId;
                salesOrder.Order_quantity__c = oppWrappers[i].totalQuantity;

                List<LineItemWrapper> products = oppWrappers[i].products;

                for(LineItemWrapper lineWrapper:products){
                    if(lineWrapper.quantityChoosed!=0){
                        OpportunityLineItem oppLineItem = new OpportunityLineItem();
                        oppLineItem.OpportunityId = oppId;
                        oppLineItem.PricebookEntryId = lineWrapper.PricebookEntryId;
                        oppLineItem.Product2Id = lineWrapper.Product2Id;
                        oppLineItem.UnitPrice = lineWrapper.amountChoosed;
                        oppLineItem.Quantity = lineWrapper.quantityChoosed;
                        oppLineItem.Quantity_Unit__c = lineWrapper.quantityUnit;
                        oppLineItems.add(oppLineItem);
                    }
                }

                salesList.add(salesOrder);
            }

            insert oppLineItems;
            insert salesList;

            Opportunity parOpp = new Opportunity(Id=parentOpp.Id,StageName='In-Progress');
            update parOpp;

            return 'Success';
        } catch (Exception e) {
            System.debug('LineNumber ---'+e.getLineNumber());
            System.debug('get-message ---'+e.getMessage());
            throw new AuraHandledException(e.getMessage()+e.getLineNumber());
        }
    }

    public class OppWrapper{
        @AuraEnabled public String oppName{get;set;}
        @AuraEnabled public Date nextOrderDate{get;set;}
        @AuraEnabled public Date closeDate{get;set;}
        @AuraEnabled public Integer totalQuantity{get;set;}
        @AuraEnabled public Decimal totalAmount{get;set;}
        @AuraEnabled public List<LineItemWrapper> products{get;set;}  
    }

    public class LineItemWrapper {
        @AuraEnabled public String OpportunityId{get;set;}
        @AuraEnabled public String Id{get;set;}
        @AuraEnabled public String Name{get;set;}
        @AuraEnabled public String Product2Id{get;set;}
        @AuraEnabled public String PricebookEntryId{get;set;}
        @AuraEnabled public Integer Quantity{get;set;}
        @AuraEnabled public Decimal UnitPrice{get;set;}
        @AuraEnabled public Integer quantityChoosed{get;set;}
        @AuraEnabled public String quantityUnit{get;set;}
        @AuraEnabled public Decimal amountChoosed{get;set;}
        @AuraEnabled public Integer remainingQuantity{get;set;}
        @AuraEnabled public Decimal remainingAmount{get;set;}
    }
}