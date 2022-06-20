import { LightningElement, api } from 'lwc';

export default class BarChildComponent extends LightningElement {
    className="redBar"
    @api changeBarColor(){
        this.className="greenBar"
    }
}