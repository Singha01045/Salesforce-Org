import { LightningElement,api,wire,track} from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import PROJECT_OBJECT from '@salesforce/schema/Project__c';
import getRecordDetails from '@salesforce/apex/ProjectHanlder.getAccRecord';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class CreateApplicationAccount extends NavigationMixin(LightningElement) {
      @api recordId;
    @track recordTypeSelected;


    @wire(getRecordDetails,{ accId : '$recordId'})
    recordDetails({data,error}){
        if(data){
            this.accRecord = data;
            console.log('RecordId', this.recordId);
            console.log('Data',data);
            this.openCreateRecordForm();
        }
        if(error){
            console.log("Errorsss",error);
        }
    }

    @wire(getObjectInfo, { objectApiName: PROJECT_OBJECT })
    accObjectInfo({data, error}) {
        if(data) {
            let optionsValues = [];
            const rtInfos = data.recordTypeInfos;

            let rtValues = Object.values(rtInfos);

            for(let i = 0; i < rtValues.length; i++) {
                if(rtValues[i].name !== 'Master') {
                    optionsValues.push({
                        label: rtValues[i].name,
                        value: rtValues[i].recordTypeId
                    })
                }
            }

            this.recordTypeSelected = optionsValues[1].value;
            this.options = optionsValues;
        }
        else if(error) {
            window.console.log('Error ===> '+JSON.stringify(error));
        }
    }

    openCreateRecordForm(){
        debugger;
        
        let defaultValues = encodeDefaultFieldValues({
            Account__c:this.recordId,
            Customer_Name__c :this.accRecord.Name,
            Application_Name__c	:`${this.accRecord.Name}-Application`,
            City__c:this.accRecord.BillingCity?this.accRecord.BillingCity:"",
            Country__c:this.accRecord.BillingCountry?this.accRecord.BillingCountry:"",
            Postal_Code__c	:this.accRecord.BillingPostalCode?this.accRecord.BillingPostalCode:"",
            State__c:this.accRecord.BillingState?this.accRecord.BillingState:"",
            Street__c:this.accRecord.BillingStreet?this.accRecord.BillingStreet:"",
        });

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Project__c',
                actionName: 'new'
            },state: {
               defaultFieldValues: defaultValues,
               recordTypeId: this.recordTypeSelected
            }
        });
    }

}