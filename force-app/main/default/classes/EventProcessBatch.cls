public with sharing class EventProcessBatch implements Database.Batchable<sObject>{
    public string query;
    public  Set<Id> eventIds;
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc , List<sObject> scope){

    }
    public void finish(Database.BatchableContext bc){
        
    }
   
}