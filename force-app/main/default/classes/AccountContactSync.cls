public with sharing class AccountContactSync {
    
    /*
        ==> Get all Accounts to a Method
        ==> Process them and Intiate a Contact Creation 
        ==> Update Source Account Details with Contact Information (SF Id)
    */

    public void processAccountSync(List<Account> accountList){
        // Contacts to be Created
       // List<Contact> contactList = new List<Contact>();
       Map<String,Contact> contactMap = new Map<String,Contact>();
       Map<String,List<Account>> accountMap = new Map<String,List<Account>>();
        // Iterate the List of Accounts to Create an Contact Records
        for(Account record : accountList){
            String compositeKey = record.Phone+'-'+record.Company_Email__c;
            if(record.Contact__c == null && contactMap.get(compositeKey) == null ){
                Contact con = new Contact();
                con.LastName = record.Name;
                con.AccountId = record.Id;
                con.Phone = record.Phone;
                con.Email = record.Company_Email__c;
                contactMap.put(compositeKey,con);
            }
            if(accountMap.get(compositeKey) == null ){
                accountMap.put(compositeKey , new List<Account>());
            }
            accountMap.get(compositeKey).add(record);
        }

        if(contactMap.values().size() > 0 ){
            Insert contactMap.values();
        }

        // Time to update the Contact Field on Account Object
        List<Account> accountsToUpdate = new List<Account>();
        for(Contact record : contactMap.values()){
            String key = record.Phone+'-'+record.Email;
            List<Account> accounts = accountMap.get(key);
            for(Account acc : accounts){
                Account tem = new Account();
                tem.Id = acc.Id;
                tem.Contact__c = record.Id;
                accountsToUpdate.add(tem);
            }
        }
        if(accountsToUpdate.size() > 0 ){
            update accountsToUpdate;
        }
    }

    public void updateAccountContact(List<Account> accountList){
        /*
        ==> Iterate AccountList --> Get Phone and Email from all the Accounts When Contact is Blank
        ==> Get the Contacts from Contact Object based on Phone and Email
        ==> Account --> Phone-Email <-- Contact 
        ==> Map<String,Contact> --> Key will be Phone-Email for Contact List == con.phone+'-'+con.Email
        ==> Iterate account get contact based on Composite key and update fields
         */
        set<String> phones = new Set<String>();
        set<String> emails = new Set<String>();
        Map<String,List<Account>> accountMap = new Map<String,List<Account>>();
         for(Account record : accountList){
             if(record.Contact__c == null){
                phones.add(record.Phone);
                emails.add(record.Company_Email__c);
                String compositeKey = record.Phone+'-'+record.Company_Email__c;
                if(!accountMap.keyset().contains(compositeKey) && accountMap.get(compositeKey) == null ){
                  List<Account> accList =   new List<Account>();
                    accountMap.put(compositeKey , accList);
                }
                List<Account> exitingMapValues = accountMap.get(compositeKey);
                exitingMapValues.add(record);
                accountMap.put(compositeKey , exitingMapValues);
             }
         }

         // get contacts based on phones and emails
         List<Contact> contactList = [SELECT Id , Phone , Email FROM Contact WHERE Phone IN: phones AND Email IN: emails];
         // Update Account details based on the Contacts
         for(Contact record : contactList){
             String key = record.Phone+'-'+record.Email;
             List<Account> accList = accountMap.get(key);
             for(Account acc : accList){
                acc.Contact__c = record.Id;
             }
         }
         
    }
}
/*
Use Case 1 : 

When 100 Accounts have no same email and Phone and 50 Contacts is already exiting 
 As Is --> 100+50 = 150 
 To be --> 50 = 50 

 Use Case 2 : 

 When 100 Accounts having email and Phone out of 100 Account we have 5 Accounts having same email and Phone and 50 Contacts is already exiting

 As Id --> 100 + 50 = 150 
 To be --> 5 + 50 = 55

 Clue : this can be same in USe case 1 when you implement in Use Case 2

\*/