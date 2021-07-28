public class AccountBatch implements Database.Batchable<sObject> {
    /*
     * 1. Start Method --> will return Query for the Records to be Processed
     * 2. Execute Method --> this will process records chunk by chunk
     * 3. Finsih Method--> finish method will ack 
	*/
  public Database.QueryLocator start(Database.BatchableContext bc){
      String query = 'SELECT Id , Name , Contact__c ,Description FROM Account';
    return Database.getQueryLocator(query);
  }


  public void execute(Database.BatchableContext bc , List<Account> scope){
        for(Account acc : scope){
           acc.Name = acc.Name.split('-')[0]+'-'+System.now();
        }
        update scope;
  }


  public void finish(Database.BatchableContext bc){
    System.debug('Batch Completed');
  }

}
