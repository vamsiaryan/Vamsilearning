({
    viewContacts: function (component, event, helper) {
        // Application event need to be invoked with selected Acount Id   
        let appEvent = $A.get("e.c:AccountContactEvt");
        appEvent.setParams({
            accountId: component.get("v.record").Id
        });
        appEvent.fire();
    },
    editAction: function (component, event, helper) {
        let cmpEvent = component.getEvent("selectRecord_EventName");
        cmpEvent.setParams({
            recordId: component.get("v.record").Id,
            recordName : component.get("v.record").Name
        });
        cmpEvent.fire();
    }
})