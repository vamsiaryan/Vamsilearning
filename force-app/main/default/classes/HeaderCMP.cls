public with sharing class HeaderCMP {
    
  @AuraEnabled
  public static List<Account> getAccounts(String accountName){
    String name = '%'+accountName+'%';
    List<Account> accList = [Select Id , Name , Phone , Description FROM Account WHERE Name LIKE : name ];
    return accList;
  }

  @AuraEnabled
  public static List<Contact> getAccountContacts(String parentId){
    return [Select Id , FirstName , LastName FROM Contact WHERE AccountId =: parentId];
  }
}