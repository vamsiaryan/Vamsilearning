trigger TriggerStu on Contact (after insert , after delete , after update , after undelete) {
    if(Trigger.isAfter && Trigger.isInsert){
        TriggerHandlerStu.afterInsert(Trigger.newMap);
    }
    if(Trigger.isAfter && Trigger.isDelete){
        TriggerHandlerStu.afterDelete(Trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        TriggerHandlerStu.afterUpdate(Trigger.newMap , Trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isUndelete){
        TriggerHandlerStu.afterUndelete(Trigger.newMap);
    }
}