public with sharing class AccountTriggerHandler {
    public static Boolean isUpdateAccountContact = true;
    public static Boolean isProcessAccountSync = true;
    public static Boolean isFirstTime = true;
    AccountContactSync syncHandler = new AccountContactSync();
    public void beforeInsert(List<Account> newList){
     // You need not required to Perform any DML to update values for the Current record and It performs validations
     for(Account record : newList){
         // check if the value exits or not 
         if(record.AccountNumber == null ){
             // At Page Level
             record.addError('Please fill the required information before save');
             // At a Field Level
             record.AccountNumber.addError('Value is required to save Account');
         }
         if(record.AccountNumber != null ){
             // Override field Value
             record.Description = record.AccountNumber +' : '+record.Name;
         }

     }
     if(isUpdateAccountContact){
        syncHandler.updateAccountContact(newList);
     }
    }
    public void afterInsert(List<Account> newList , Map<Id,Account> newMap){
        // You need DML to update values for the Current record and  It also validations the record field information
        for(Account record : newList){
            // check if the value exits or not 
            if(record.AccountNumber == null ){
                // At Page Level
                record.addError('Please fill the required information after save');
                // At a Field Level
                record.AccountNumber.addError('Value is required to save Account');
            }
        }
        // Call other Action Class from Here 
        if(isProcessAccountSync){
             syncHandler.processAccountSync(newList);
        }
        // Query the records from the Object using SOQL
        List<Account> accList = [SELECT Id , Name , Description , AccountNumber FROM Account WHERE Id IN: newMap.keySet() AND AccountNumber != null];

        // Perform your business logic to update values 
        for(Account record : accList){
            record.Description = record.AccountNumber + ' : '+record.Name ;
        }
        // Perform the DML operation to commit the changed data
        if(accList.size() > 0 ){
            update accList;
        }
    }

    public void beforeUpdate(Map<Id,Account> newMap , Map<Id,Account> oldMap){
        for(Id key : newMap.keyset()){
            Account newRecord = newMap.get(key);
            Account oldRecord = oldMap.get(key);
            // Compare the Account number ischanged 
            if(oldRecord.AccountNumber != newRecord.AccountNumber){
                newRecord.addError('Please review the Trigger errors');
                newRecord.AccountNumber.addError('You are trying to update value , which is not allowed');
            }
            newRecord.Description = newRecord.AccountNumber +' : '+newRecord.Name;
        }
    }
    public void afterUpdate(Map<Id,Account> newMap , Map<Id,Account> oldMap){
        // Check is this first time 
        if( isFirstTime ){
            isFirstTime = false;
        }
    }
}