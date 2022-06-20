import { LightningElement, track, api } from  'lwc';

export default class ChildLwc extends LightningElement {  //Pascal-Case
     @api userDetails 
     @api message 
     @api className    

    get alertClassName(){
        return this.className ? `alert ${this.className}` : `alert`
    }

    
    /*

    //HOW TO PASS DATA AS STRING TO CHILD COMPONENT
    @api message            //Child Component use the same attr along with @api to hold 2 data...   Reusable Attributes...  As soon as it gets the data, it'll render into html
    @api className

    get alertClassName(){
        return this.className ? `alert ${this.className}` : `alert`
    }




    //Camel-Case
    @track trackParam = "trackvalue"; 
    @api apiParam = "apiParam";
    @api change = 'changeByAPI';
    nonReactiveProp = "Non-Reactive Prop";

    handleParam(){
        this.trackParam = 'Value changed for Track Param';
        this.apiParam = 'Value changed for API Param';
        this.nonReactiveProp = "Value changed for Non-Reactive Param";
    }
    
    //Parent to Child
    @api testChildMethod(parentParam){
        alert('This is the Child Method. Name:: '+parentParam.Name);
    }

    //Child to Parent
    handleMe(){
        //1. Create Custom Event + Param passing 
        const childEvent = new CustomEvent('eventfire',
        {
            detail : {
                firstParam : '1st value',
                secondparam: '2nd value'
            }
        });
        
        //2. Dispatch Custom Event
        this.dispatchEvent(childEvent);
    }
    */

}


