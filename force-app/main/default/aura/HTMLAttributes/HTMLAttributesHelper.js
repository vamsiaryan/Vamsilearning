({
    dataSetupHlp : function(component , event , helper) {
        let dataJson = [];
        
        dataJson.push({Name : "jyothi",Phone : "7980336681",Gender : "Female"});
        dataJson.push({Name : "mohan",Phone : "8985216425",Gender : "male"});
        dataJson.push({Name : "Vamsi",Phone : "90109838391",Gender : "male"});
        dataJson.push({Name : "naveen",Phone : "9640090111",Gender : "male"});
       
        component.set("v.dataSetDetails",dataJson);
    }
})