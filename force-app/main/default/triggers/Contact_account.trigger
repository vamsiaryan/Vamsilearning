trigger Contact_account on Contact (before insert , after insert , after update , after delete , after undelete) {
    if(Trigger.isBefore && Trigger.isInsert){
        Contact_account.beforeInsert(Trigger.new);
    }
    else if(Trigger.isAfter && Trigger.isInsert){
        Contact_account.afterInsert(Trigger.newMap);
    }
    else if(Trigger.isAfter && Trigger.isUpdate){
        Contact_account.afterUpdate(Trigger.newMap, Trigger.oldMap);
    }
    else if(Trigger.isAfter && Trigger.isDelete){
        Contact_account.afterDelete(Trigger.oldMap);
    }
    else if(Trigger.isAfter && Trigger.isUndelete){
        Contact_account.afterUndelete(Trigger.newMap);
    }
}