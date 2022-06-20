import { LightningElement,wire,api,track} from 'lwc';

import getOppRecord from '@salesforce/apex/ProjectHanlder.getOppRecord'
import savePDF from '@salesforce/apex/PerformaInvoicePDFController.savePDF'
import emailToClient from '@salesforce/apex/PerformaInvoicePDFController.emailToClient'
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GenerateInvoiceComponent extends LightningElement {
    @api recordId;
    @track url;
    @track record;
    @track loaded;

    @wire(getOppRecord,{id:'$recordId'})
    wiredResponse(result){
        if(result && result.data){
            this.record =result.data;
            this.url = 'https://symegafood--symegadev--c.visualforce.com/apex/PerformaInvoicePDF'+'?id='+this.record.Id;
            console.log('URL-----',this.url);
            this.loaded = true;
        }
    }

    savePDF(){
        savePDF({url:this.url,id:this.record.Id,fileName:this.record.Name+"_FILE"}).then(result => {

            console.log("JADSJKHKDHSD",result);
            this.showNotification('Success','Your performa invoice generated successfully','success');
            this.closeAction();
        }).catch(error=>{
            console.log("Error",error);
        });
    }
    emailToClient(){
        emailToClient({url:this.url,oppId:this.record.Id}).then(result => {

            console.log("JADSJKHKDHSD",result);
            this.showNotification('Success','performa invoice sent successfully','success');
            this.closeAction();
        }).catch(error=>{
            console.log("Error",error);
        });
    }

     closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    showNotification(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }
        }