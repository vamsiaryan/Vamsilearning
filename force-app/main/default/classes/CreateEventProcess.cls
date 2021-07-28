public with sharing class CreateEventProcess {
    public static void intialize(String objectName , String eventType , List<sObject> newList , Map<Id,sObject> oldMap){
            List<Event_Process__c> events = new List<Event_Process__c>();
             
            for(sObject record : newList){
                if(oldMap != null){
                String s = JSON.serialize(oldMap.get(Id.valueOf(String.valueof(record.get('Id')))));
                }
             Event_Process__c event = new Event_Process__c(
                 Status__c = 'New',
                 Old_JSON__c = oldMap != null ? JSON.serialize(oldMap.get(Id.valueOf(String.valueof(record.get('Id'))))) : null,
                 Current_JSON__c = JSON.serialize(record),
                 Event_Type__c = eventType,
                 Type__c = objectName
             );
             events.add(event);
            }
 
            Insert events;
    }
 }