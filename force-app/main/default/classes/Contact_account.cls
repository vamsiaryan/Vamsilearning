public with sharing class Contact_account {
    public static void afterInsert(Map<Id,Contact> newMap){
        // Invoke Rollup summary to Account --> AccountNumber
        //RollUpSummary.onInsertRollUp(newMap);
        CreateEventProcess.intialize('Contact' , 'After Insert' , newMap.values() , null );
    }
   public static void beforeInsert(List<Contact> newList){
       for(Contact record : newList){
           if(record.AccountId == null){
               //record.AccountId.addError('Account Name is Required');
           }
           if(record.Phone == null){
               record.Phone.addError('Phone is Required');
           }
           if(record.Email == null ){
               record.Email.addError('Email is Required');
           }
       }
       // Map Account Names
       getAccountNames(newList);
       // Duplicate Check
       //findDuplicates(newList);
   }
   private static void findDuplicates(List<Contact> newList){
        // Get All Phone and Email from the Contact List
        Set<String> phones = new Set<String>();
        Set<String> emails = new Set<String>();
        Map<String,List<Contact>> newData = new Map<String,List<Contact>>();
        for(Contact record : newList){
            phones.add(record.Phone);
            emails.add(record.Email);
            String key = record.Phone+'-'+record.Email;
            if(newData.get(key) == null ){
                newData.put(key,new List<Contact>());
            }
            newData.get(key).add(record);
        }
        // Retrive the Exiting Contacts based on the Phone adn Email
        Map<Id,Contact> exitingData = new Map<Id,Contact>([Select Id , Name , Phone , Email
                                                             FROM Contact WHERE Phone IN: phones AND Email IN: emails ]);

        for(Contact extData : exitingData.values()){
            String key = extData.Phone +'-'+extData.Email;
            for(Contact newDetail : newData.get(key)){
                newDetail.addError('It is Duplicated please use the exiting Contact : '+extData.Name);
                // <a href='/Id'>ContactName</a>
                newDetail.LastName.addError('Please use the exiting Contact  <a href=\'/'+extData.Id+'\'>'+extData.Name+'</a>' , false);
            }
        }
   }

   private static void getAccountNames(List<Contact> newList){
       AccountTriggerHandler.isUpdateAccountContact = false;
       AccountTriggerHandler.isProcessAccountSync = false;
    set<String> phones = new Set<String>();
    set<String> emails = new Set<String>();
    Map<String,List<Contact>> contacts = new Map<String,List<Contact>>();
    for(Contact record : newList){
        if(record.AccountId == null){
            phones.add(record.Phone);
            emails.add(record.Email);
            String compositeKey = record.Phone+'-'+record.Email;
            if(contacts.get(compositeKey) == null ){
                contacts.put(compositeKey , new List<Contact>());
            }
            contacts.get(compositeKey).add(record);
        }
    }

    // query the exiting Account 
    Map<Id,Account> accountMap = new Map<Id,Account>([Select Id , Phone , Company_Email__c FROM Account
                                                                     WHERE Phone IN: phones AND Company_Email__c IN: emails]);
    
    // Prepare Accounts with composite key combination
    Map<String,Account> accountsKeyMap = new Map<String,Account>();
    for(Account record : accountMap.values()){
        String compositKey = record.Phone+'-'+record.Company_Email__c;
        accountsKeyMap.put(compositKey,record);
    }
    
    // Prepare for new Accounts
    List<Account> accDetails = new List<Account>();
    for(String key : contacts.keyset()){
        Account acc = accountsKeyMap.get(key);
        List<Contact> cons = contacts.get(key);
         if(acc == null && cons.size() > 0  ){
                acc = new Account();
                acc.Name = cons[0].LastName;
                acc.AccountNumber = '1234546';
                acc.Phone = cons[0].Phone;
                acc.Company_Email__c = cons[0].Email;
                accountsKeyMap.put(key,acc);
                accDetails.add(acc);
            }
    
    }

    if(accDetails.size() > 0 ){
        insert accDetails;
    }

    // Prepare contacts to update account Id 
    for(String key : contacts.keyset()){
        Account acc = accountsKeyMap.get(key);
        List<Contact> cons = contacts.get(key);
        for(Contact con : cons){
        if(acc != null && con != null ){
            con.AccountId = acc.Id;
        }
    }
    }
    AccountTriggerHandler.isUpdateAccountContact = true;
    AccountTriggerHandler.isProcessAccountSync = true;
   }

   public static void afterUpdate(Map<Id,Contact> newMap , Map<Id,Contact> oldMap){
          // RollUpSummary.onAfterUpdate(newMap,oldMap);
          CreateEventProcess.intialize('Contact' , 'After Update' , newMap.values() , oldMap );
          ContactUserSync.syncUser(newMap,oldMap);
   }
   public static void afterDelete(Map<Id,Contact> oldMap){
            //RollUpSummary.onInsertRollUp(oldMap);
            CreateEventProcess.intialize('Contact' , 'After Delete' , oldMap.values() , oldMap );
   }
   public static void afterUndelete(Map<Id,Contact> newMap){
            //RollUpSummary.onInsertRollUp(newMap);
            CreateEventProcess.intialize('Contact' , 'After Undelete' , newMap.values() , null );
   }
}