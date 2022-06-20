/**
 * @author [Anjali Singh]
 * @email [anjali.singh@utilitarianLab.com]
 * @create date 2022-06-02 16:42:09
 * @modify date 2022-06-14 17:05:32
 * @desc [description]
 */
import { LightningElement, track, api} from 'lwc';

export default class ParentLWC extends LightningElement {
    userDetails = [
        {
            name: 'John Doe',
            title: 'CEO &Founder',
            company: 'Harvard University, example',
            buttontext: 'Contact',
            imageUrl: 'https://www.w3schools.com/w3images/team1.jpg'
        },
        {
            name: 'Steve Smith',
            title: 'CEO &Founder',
            company: 'Standford University, example',
            buttontext: 'Contact',
            imageUrl: 'https://www.w3schools.com/w3images/team2.jpg'
        },
        {
            name: 'David Warner',
            title: 'CEO &Founder',
            company: 'Sydney University, example',
            buttontext: 'Contact',
            imageUrl: 'https://www.w3schools.com/w3images/team3.jpg'
        },
        {
            name: 'Peter Parker',
            title: 'CEO &Founder',
            company: 'Delhi University, example',
            buttontext: 'Contact',
            imageUrl: 'https://www.w3schools.com/w3images/team4.jpg'
        }
    ]



    /*  @track parentChange = "1st change by Parent";

    //Parent to Child
    handleChange(){
        this.parentChange = "2nd change by Parent";
    }
    
    callChild(){
        var childComp = this.template.querySelector('c-child-lwc');
        var sendParam =  {'Name':'Anjali Singh'};
        childComp.testChildMethod(sendParam);
    }
    
    //Communicate from Child to Parent Component
    handleEvent(event){
        alert('Custom Event Fired from Parent');
        this.parentChange = "Custom Event";
        //alert('Parameter rcvd from Child: '+event.detail);
        alert('1st Param from Child: '+event.detail.firstParam);
        alert('2nd Param from Child: '+event.detail.secondparam);
    } */ 
    
}