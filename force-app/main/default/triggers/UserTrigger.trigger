trigger UserTrigger on User (After insert , After Update) {

    switch on Trigger.operationType {
        when  AFTER_INSERT {
            ContactUserSync.syncContact(Trigger.newMap, null);
        }
        when AFTER_UPDATE{
            ContactUserSync.syncContact(Trigger.newMap, Trigger.oldMap);
        }
        
    }

}