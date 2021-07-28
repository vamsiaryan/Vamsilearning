({
    handleAppEvent: function (component, event, helper) {
        // read a event attribute for list of accounts 
        let accounts = event.getParam("accountData");
        component.set("v.accounts", accounts);
    },
    editActionHanlder: function (component, event, helper) {
        let accId = event.getParam("recordId");
        let accName = event.getParam("recordName");
        let finalHeaderName = "Editting " + accName;
        component.set("v.modelHeader", finalHeaderName);
        component.set("v.selectedAccountId", accId);
    },
    cancelEdit: function (component, event, helper) {
        component.set("v.selectedAccountId", "");
    },
    saveDetails: function (component, event, helper) {
        component.find("editRecord").submit();
    },
    handleSubmit: function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "On SUBMIT!",
            "mode": "dismissible",
            "type": "info",
            "message": "The record has been Submitted."
        });
        toastEvent.fire();
    },
    handleSuccess: function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "On Success!",
            "mode": "dismissible",
            "type": "success",
            "message": "The record has been Updated."
        });
        toastEvent.fire();
        component.set("v.selectedAccountId", "");
    }
})