import { LightningElement } from 'lwc';
import {CloseActionScreenEvent} from 'lightning/actions';

export default class PushSOToSAP extends LightningElement {

    closePopup(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    connectedCallback() {
        // alert("Called");
        setTimeout(()=>this.closePopup(),1500);
    }
}