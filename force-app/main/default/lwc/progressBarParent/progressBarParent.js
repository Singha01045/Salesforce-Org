import { LightningElement } from 'lwc';

export default class ProgressBarParent extends LightningElement {
    percentage = 10
    changeHandler(event){
        this[event.target.name] = event.target.value <= 100 ? event.target.value : 100     //event is an Object...
    }
}