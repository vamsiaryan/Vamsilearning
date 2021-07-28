({
    getContacts : function(component, event, helper) {
        let account = event.getParam("accountId");
         // Call Apex Method FROM THE LITNG Controller.js
         const action = component.get("c.getAccountContacts");
         action.setParams({
            parentId : account
         });
         action.setCallback( this , function(response){
            const state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.contacts",response.getReturnValue());
            }
            else{
                alert("its error");
            }
         });
         $A.enqueueAction(action);;
    }
})