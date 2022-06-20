import { LightningElement,wire,api } from 'lwc';
import getOppRecord from '@salesforce/apex/OpportunityHanlder.getRecord'
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

export default class CreateSalesOrder extends NavigationMixin(LightningElement){
    
    @api recordId;
    oppRecord;

    @wire(getOppRecord,{oppId:'$recordId'})
    recordDetails({data,error}){
        if(data){
            this.oppRecord = data[0];
            console.log('RecordId',this.recordId);
            console.log('Data',data);
            this.openCreateRecordForm();
        }
        if(error){
            console.log("Error",error);
        }
    }

    openCreateRecordForm(){
        let defaultValues = encodeDefaultFieldValues({
            Opportunity__c: this.oppRecord.Id
        });
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Sales_Order__c',
                actionName: 'new'
            },state: {
                defaultFieldValues: defaultValues
            }
        });
    }
}