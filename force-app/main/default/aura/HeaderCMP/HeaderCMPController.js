({
    searchAction : function(component , event , helper){
        // Get value from the input field
         // Find the component based on Id 
         let searchField = component.find("searchField");
         let searchValue = searchField.get("v.value"); 
         // Call Apex Method FROM THE LITNG Controller.js
         const action = component.get("c.getAccounts");
         action.setParams({
            accountName : searchValue
         });
         action.setCallback( this , function(response){
            const state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.accounts",response.getReturnValue());
            }
            else{
                alert("its error");
            }
         });
         $A.enqueueAction(action);
    },
    fireAppEvent : function(component , event , helper){
        let oldValues = event.getParam("oldValue");
        let newValues = event.getParam("value");
        console.log("Old Values : "+JSON.stringify(oldValues));
         // Fire an Event on success server call
         let appEvent = $A.get("e.c:SearchEvent");
         appEvent.setParams({
             accountData : component.get("v.accounts")
         });
         if(JSON.stringify(oldValues) != JSON.stringify(component.get("v.accounts"))){
         appEvent.fire();
         }
    }
})