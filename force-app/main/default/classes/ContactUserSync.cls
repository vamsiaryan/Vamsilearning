public with sharing class ContactUserSync {
    // Call this method from User Trigger when there is an Activity performed : Before Insert , After Insert , Before Update and After Update
   public static void syncContact(Map<Id,User> newMap , Map<Id,User> oldMap){
        // User and Contact is related with a Field called ==> ContactId
        Map<Id,user> conUserMap = new Map<Id,User>();
        for(User newUser : newMap.values()){
            // First we need to check is this partner user 
            if(newUser.ContactId != null && oldMap == null){
                conUserMap.put(newUser.contactId,newUser);
            }
            else if(newUser.ContactId != null && ( oldMap.get(newUser.Id).FirstName != newUser.FirstName 
                                                || oldMap.get(newUser.Id).LastName != newUser.LastName)){
                    conUserMap.put(newUser.contactId,newUser);

            }
        }
        // Check the conUserMap is not blank 
        if(conUserMap.keySet().size() > 0 ){
            Map<Id,Contact> conMap = new Map<Id,Contact>([Select Id , FirstName , LastName FROM Contact WHERE Id IN: conUserMap.keySet()]);
            for(Contact record : conMap.values()){
                record.FirstName = conUserMap.get(record.Id).FirstName;
                record.LastName =  conUserMap.get(record.Id).LastName;
            }
            if(conMap.values().size() > 0 ){
                // Update the Contact to the Contact Object through DML 
                update conMap.values();
            }
        }
   }


   // Contact to User Sync The identifier is ContactId 
   public static void syncUser(Map<Id,Contact> newMap , Map<Id,Contact> oldMap){
        // Contact Id When there is a Change in the FirstName and LastName
        set<Id> contactIds = new Set<Id>();
        for(Contact newRec : newMap.values()){
            Contact oldRec = oldMap.get(newRec.Id);
            if(newRec.LastName != oldRec.LastName || newRec.FirstName != oldRec.FirstName){
                contactIds.add(newRec.Id);
        }
        }
        // Check the Size of contact Ids before doing User SOQl
        if(contactIds.size() > 0){
            List<User> users = [SELECT Id , FirstName , LastName ,ContactId FROM User WHERE ContactId IN: contactIds];
            for(User record : users){
                record.FirstName = newMap.get(record.ContactId).FirstName;
                record.LastName = newMap.get(record.ContactId).LastName;
            }
            if(users.size() > 0 ){
                Update users;
            }
            Update [Select Id FROM Contact WHERE Id IN: contactIds];
        }
   }
}