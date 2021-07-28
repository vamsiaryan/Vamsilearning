public with sharing class RollUpSummary {
    public static void onInsertRollUp(Map<Id,Contact> newMap) {
        // Get Accounts Id from the Contact
        Set<Id> accountIds = new Set<Id>();
        for(Contact record : newMap.values()){
            if(record.AccountId != null ){
                accountIds.add(record.AccountId);
            }
        }
        // Invoke update method
        updateAccounts(accountIds);
    }

    public static void onAfterUpdate(Map<Id,Contact> newMap , Map<Id,Contact> oldMap){
        // Get Modified AccountIds from the Contact records
        Set<Id>  accountIds = new Set<Id>();
        for(Contact newCon : newMap.values()){
            Contact oldCon = oldMap.get(newCon.Id);
            if(newCon.AccountId != oldCon.AccountId){
                accountIds.add(newCon.AccountId);
                accountIds.add(oldCon.AccountId);
            }
        }
        // Invoke update method
        updateAccounts(accountIds);
    }

    private static void updateAccounts(Set<Id> accountIds){
        // get The Account with Contact information (Child to Parent SOQL)
        List<Account> accList = [Select Id , total__c , (SELECT Id FROM Contacts) FROM Account WHERE Id IN:accountIds];
        // Assign the Total count to Account fields
        for(Account acc : accList){
            acc.total__c = acc.Contacts.size();
        }
        // Update the Account
        if(accList.size() > 0 ){
            update accList;
        }
    }
}