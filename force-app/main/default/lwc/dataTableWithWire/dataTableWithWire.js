import { LightningElement,track, wire } from 'lwc';
import getAccountFromController from '@salesforce/apex/LwcClass.getAccount'; 

export default class DataTableWithWire extends LightningElement {
    @track data;
    @track columns = [
        {label:'Label', fieldName: 'Name', type: 'text'},
        {label:'Phone', fieldName: 'Phone', type: 'phone'},
        {label:'Industry', fieldName: 'Industry', type: 'text'},
    ];
    
    //Wired the function here called -> Identifier Adapter and defining a JS Function
    //Using @wire to wire a property or Function
    @wire (getAccountFromController) accountRecords({error, data}){
        if(data){
            this.data = data;
        }
        else if(error){
            this.data = undefined;
        }

    }
}