({
    addsum : function(component, event, helper) {
        let num1=component.find("fnum1").get("v.value");
        let num2=component.find("fnum2").get("v.value");
        let num3=Number(num1)+Number(num2);
        component.find("fnum3").set("v.value",num3);
        let params = event.getParam("arguments");
        if(params){
            let fun = params.heading2;
            alert("Params : "+fun);
        }
    }
})
