public with sharing class Contact_count {
    public static void afterInsert(Map<Id,Contact> newmap) {

        Set<Id> accountIds = new Set<Id>();
        for(Id key : newMap.keyset()){
            Contact record = newMap.get(key);
            if(record.AccountId != null){
                
                accountIds.add(record.AccountId);
            }
        }

        if(accountids.size() > 0){
            Map<Id,Account> accountMap = new Map<id,Account>
            ([ Select Id , Total__c,(SELECT Id , FirstName FROM Contacts) FROM Account WHERE Id IN: accountIds]);

            if(accountMap != null && accountMap.keyset().size() > 0 ){
                
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
}
