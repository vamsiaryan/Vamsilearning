public with sharing class Contacttriggerhandler {
    public static void beforeInsert(List<Contact> newList){
        List<Account> AccountList = new List<Account>();
        for(Contact record : newList){
                if(record.Accountid == null ){

                Account aco = new Account();
                aco.AccountNumber = 'vamsi1123456';
                aco.AccountName = record.FirstName;
                
                AccountList.add(aco);
                //record.addError('Please fill the required information before save');
                // At a Field Level
                //record.AccountNumber.addError('Value is required to save Account');
            }
            if(AccountList.size() > 0 ){
                Insert AccountList;
            }
        }
            List<Contact> contactToUpdate = new List<Contact>();
            for(d aco : AccountList){
                //Contact cot = new Contact();
                record.AccountId = aco.Id;
                //cot.Contact__c = aco.Id;
                contactToUpdate.add(cot);
            }
            if(accountsToUpdate.size() > 0 ){
               // update accountsToUpdate;
            }
        }


    public static void afterInsert(Map<Id,Contact> newMap){
for (Id key : newmap.keyset()) {
    Contact record =newmap.get(key);
    if(record.Phone == null || record.Phone == '')
    {
        record.Phone.addError('Mobile number is required');
    }
}
    }

}
