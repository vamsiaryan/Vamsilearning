public with sharing class TriggerHandlerStu {
   
    public static void afterInsert(Map<Id,Contact> newMap){
        /*
        --> Do you have Account Id ? Contact.AccountId 
        --> Can we update Account using AccountId ? 
        */
        Set<Id> accountIds = new Set<Id>();
        for(Id key : newMap.keyset()){
            Contact record = newMap.get(key);
            if(record.AccountId != null){
                // add it to set for Account Query
                accountIds.add(record.AccountId);
            }
        }
        // Check Do you have a Valid Account Ids in accountIds collection 
        if(accountIds.size() > 0 ){
            // Query Account Details with Contact Information
            Map<Id,Account> accountMap = new Map<Id,Account>(
                [ Select Id , Total__c,(SELECT Id , FirstName FROM Contacts) FROM Account WHERE Id IN: accountIds]
                );
         // Check is there any accounts returned from Query
         if(accountMap != null && accountMap.keyset().size() > 0 ){
             // iterate the account records to update the Total Contact field value
             for(Id key : accountMap.keyset()){
                 Account parent = accountMap.get(key);
                 List<Contact> childs = parent.Contacts;
                 Integer totalContacts = childs.size();
                 parent.Total__c = totalContacts;
             }
         }
         update accountMap.values();
        }
    }

    public static void afterDelete(Map<Id,Contact> oldMap){
        // Get all Accountids from the Deleted Contacts 
        Set<Id> accountIds = new Set<Id>();
        for(Id key : oldMap.keyset()){
            Contact record = oldMap.get(key);
            if(record.AccountId != null){
                accountIds.add(record.AccountId);
            }
        }

        // check for valida account Id in AccountIds collection 
        if(accountIds.size() > 0 ){
            // query your Accounts with Contact information 
            Map<Id,Account> accountMap = new Map<Id,Account>(
                [SELECT Id , Total__c , (SELECT Id , LastName FROM Contacts) FROM Account WHERE ID IN: accountIds]
            );
            for(Id key : accountMap.keyset()){
                Account parent = accountMap.get(key);
                List<Contact> childs = parent.Contacts;
                Integer totalContacts = childs.size();
                parent.Total__c = totalContacts;
            }
            update accountMap.values();
        }
    }

    public static void afterUpdate(Map<Id,contact> newMap , Map<Id,Contact> oldMap){
        // get changed AccountIds from the newMap and OldMap
        Set<Id> accountIds = new Set<Id>();
        for(Id key : newMap.keyset()){
            Contact newContact = newMap.get(key);
            Contact oldContact = oldMap.get(key);
            // check is there any chamges in account Id on Contact record
            if(newContact.AccountId != oldContact.AccountId){
                if(newContact.AccountId != null){
                    accountIds.add(newContact.AccountId); 
                }
                if(oldContact.AccountId != null){
                    accountIds.add(oldContact.AccountId); 
                }
            }
        }
         /// check for the size
         if(accountIds.size() > 0 ){
             Map<Id,Account> accountMap = new Map<Id,Account>(
                 [SELECT Id , Total__c , (SELECT Id , LastName FROM Contacts) FROM Account WHERE Id IN: accountIds]
             );
             // Check the accountMap have any records 
             if(accountMap.keyset().size() > 0){
                 for(Id key : accountMap.keyset()){
                     Account parent = accountMap.get(key);
                     List<Contact> childs = parent.Contacts;
                     Integer totalContacts = childs.size();
                     parent.Total__c = totalContacts;
                 }

                 update accountMap.values();
             }
         }
    }

    public static void afterUndelete(Map<Id,Contact> newMap){
        afterInsert(newMap);
    }
}
