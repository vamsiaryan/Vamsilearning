trigger Contact_count on Contact (after insert , after update ) {
    if(Trigger.isAfter && Trigger.isInsert){
        Contact_count.afterInsert(Trigger.newMap);
    }

    if(Trigger.isAfter && Trigger.isUpdate){
        Contact_count.afterUpdate(Trigger.newMap , Trigger.oldMap);
    }
    
}