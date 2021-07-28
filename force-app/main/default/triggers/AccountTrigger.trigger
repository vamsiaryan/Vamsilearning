
trigger AccountTrigger on Account (before insert , after insert , before update) {
    AccountTriggerHandler handler = new AccountTriggerHandler();
        // Before Insert 
        if(Trigger.isBefore && Trigger.isInsert){
            handler.beforeInsert(Trigger.new);
        }
    // After Insert 
        if(Trigger.isAfter && Trigger.isInsert){
            handler.afterInsert(Trigger.new, Trigger.newMap);
        }
    // Before Update
    if(Trigger.isBefore && Trigger.isUpdate){
        handler.beforeUpdate(Trigger.newMap , Trigger.oldMap);
    }

}