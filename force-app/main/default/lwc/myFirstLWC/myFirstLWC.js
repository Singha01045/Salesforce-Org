import { LightningElement, track, api } from 'lwc';
import{ add, minus } from './utils.js';
import * as UTILS from './utils.js';
import add1 from './utils.js';

export default class MyFirstLWC extends LightningElement {
    reusableProperty = 'Hi, Anjali here';

    /*connectedCallback(){
        UTILS.add1(6,23);
        add(8,8)
        add1(24,32)
        minus(80,50)
    }*/

    @track trackParam = "trackvalue"; 
    @api apiParam = "apiParam";
    nonReactiveProp = "Non-Reactive Prop";

    handleParam(){
       // this.trackParam = 'Value changed for Track Param';
       // this.apiParam = 'Value changed for API Param';
        this.nonReactiveProp = "Value changed for Non-Reactive Param";
    }
}