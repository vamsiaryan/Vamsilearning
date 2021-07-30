import { LightningElement , api } from 'lwc';

export default class Myheader extends LightningElement {
    @api
    username="Deepak";

    @api
    sampleMethod(event){
        
    }
    hadleNameChange(event){
        let changed=event.target.value;
        let inputValue=this.template.querySelector("lightning-input[data-my-id=mypoint]").value;
        this.username=inputValue;
    }
}