import { LightningElement,api,wire,track } from 'lwc';
import {CloseActionScreenEvent} from 'lightning/actions';
import createOpp from '@salesforce/apex/OppSplitParentController.createOpp'
import getOppRecord from '@salesforce/apex/OppSplitParentController.getRecord'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import { NavigationMixin } from 'lightning/navigation';


export default class OppSplitParent extends LightningElement {
    @api recordId;
    oppRecord;
    prodListResp = [];
    childSplits = [];
    prodList = [];

    currentOppName = "";

    isLoaded = true;
    showAlert = false;
    hasChildSplits = false;
    hasLoaded = false;
    showDetails = false;
    isSplitLeft = true;

    tableColums = [
        { label: 'Product', fieldName: 'Name' },
        { label: 'Quantity', fieldName: 'Quantity'},
        { label: 'Amount', fieldName: 'UnitPrice',type: 'currency' },
    ]

    @wire(getOppRecord,{oppId:'$recordId'})
    recordDetails({data,error}){
        debugger;
        if(data){
            this.oppRecord = data[0];
            if(this.oppRecord.Amount==null || this.oppRecord.TotalOpportunityQuantity==null){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Field not found',
                        message: 'Amount and quantity not found',
                        variant: 'error',
                    }),
                );
                this.closePopup();
            }

            this.oppRecord.OpportunityLineItems && this.oppRecord.OpportunityLineItems.forEach(prod=>{
                let obj = {...prod};
                obj.quantityChoosed = obj.Quantity;
                obj.amountChoosed = obj.UnitPrice;
                obj.remainingQuantity = obj.Quantity;
                obj.remainingAmount = obj.UnitPrice;
                obj.quantityUnit = obj.Quantity_Unit__c;
                this.prodList.push(obj);
            })
            
            this.prodListResp = this.prodList;

            this.hasLoaded = true;
            console.log('RecordId',this.recordId);
            console.log('Data',data);
        }
        if(error){
            console.log("Error",error);
        }
    }

    addNewSplit(){
        debugger;
        if(this.showDetails){
            let list = this.template.querySelector('c-opp-split-details').getProductList();
            if(list.products && list.products.length == 1 && list.products[0].quantityChoosed==0){
                this.showToast('Error','Choose quantity more than 0','error')
                return;
            }
            if(list){
                this.addSplits(list);
                this.showDetails = false;
            }
        }else{
            this.currentOppName = this.oppRecord.Name+'-'+(this.childSplits.length+1);
            this.showDetails = this.isSplitLeft;
        }
    }
    closePopup(){
        if(this.showAlert){
            this.dispatchEvent(new CloseActionScreenEvent());
        }else{
            this.showAlert = true;
        }
    }

    addSplits(splits){
        let totalQuantity = 0;
        let totalAmount = 0;

        splits.products.forEach(sProd=>{
            debugger;
            totalQuantity+=sProd.quantityChoosed;
            totalAmount+=sProd.amountChoosed;

            if(this.prodList.findIndex(prod=>prod.Id==sProd.Id)>=0 && sProd.quantityChoosed!=0){
                let index = this.prodList.findIndex(prod=>prod.Id==sProd.Id);
                let obj = {...sProd};
                if(obj.quantityChoosed==obj.remainingQuantity){
                    this.prodList.splice(index,1);
                }else{
                    obj.remainingQuantity = obj.remainingQuantity - obj.quantityChoosed;
                    obj.quantityChoosed = obj.remainingQuantity;
                    obj.amountChoosed = obj.remainingAmount;
                    this.prodList[index] = obj;
                }
            }
        })

        splits.totalQuantity = totalQuantity;
        splits.totalAmount = totalAmount;

        if(splits.totalQuantity==0){
            this.showToast('Error','Choose quantity more than 0','error')
            return;
        }

        this.childSplits.push(splits);
        this.hasChildSplits = this.childSplits.length>0;
        this.isSplitLeft = this.prodList.length>0;
        console.log("ProdList-----",this.prodList);
        console.log("ChildSplits---",JSON.stringify(this.childSplits));
    }

    createOpp(){
        this.isLoaded = false;
        createOpp({parentOpp:this.oppRecord,oppWrappers:this.childSplits}).then(result=>{
            if(result=='Success'){
                this.isLoaded = true;
                this.dispatchEvent(new CloseActionScreenEvent());
                this.showToast('Split Created','Split Created Successfully','success')
                this.refreshPage();
            }else{
                this.isLoaded = true;
                this.showToast('Split Created Failure','Split Created Failed','error');
            }

        }).catch(err=>{
            this.isLoaded = true;
            this.showToast('Split Created Failure','Split Created Failed','error');
            console.log("Error",err);
        })
    }


    showToast(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    refreshPage(){
        this.dispatchEvent(new CloseActionScreenEvent());
        //window.location.reload();
        if(window && this.recordId) {
            window.location.href='/lightning/r/Opportunity/'+this.recordId+'/view';
        }
        /* if(this.recordId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    objectApiName: 'Opportunity', // objectApiName is optional
                    actionName: 'view'
                }
            });
        } */
    }

    closeAlert(){
        this.showAlert=false;
    }
}