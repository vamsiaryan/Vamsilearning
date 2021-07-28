({
    displayComponent : function(component, event, helper) {
            let displayName="c:"+component.find("comname").get("v.value");
            $A.createComponent(displayName,
                {
                    "aura:id" :component.find("comname").get("v.value")
                },
                function(newcomponent , status , errorMessage){
                    if(status === "SUCCESS"){
                        let body = component.get("v.body");
                        body.push(newcomponent);
                        component.set("v.body",body);
                    }
                    else{
                        alert("ERROR:"+JSON.stringify(errorMessage));
                    }
            });
    },
    deleteComponent1 : function(component, event, helper){
        let deleteComponentname=component.find("comname").get("v.value");
        let deleteComponent=component.find(deleteComponentname);
        if(deleteComponent){
            deleteComponent.destroy();
        }
    }
})
