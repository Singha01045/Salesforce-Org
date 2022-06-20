import { LightningElement, api } from 'lwc';

export default class ProgressBarChild extends LightningElement {
    @api percentage

    get getStyle(){
        return `width:` +this.percentage+'%'
    }

}