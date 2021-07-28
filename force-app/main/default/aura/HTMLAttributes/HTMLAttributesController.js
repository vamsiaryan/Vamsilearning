({
    onLoadDataSet : function(component, event, helper) {
        helper.dataSetupHlp(component, event, helper);
    },
    getPhoneNumber : function(component , event , helper){
        let selectedItem = event.currentTarget;
        let Name = selectedItem.dataset.name;
        let Phone = selectedItem.dataset.phone;
        let Gender = selectedItem.dataset.gender;
        let ind = selectedItem.dataset.ind;
        alert(ind + "."+Name+" : "+Phone+" : "+Gender);
    }
})