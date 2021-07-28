public with sharing class EventProcessor {

    @InvocableMethod(label='Publish Event Process')
    public static void publishMessage(List<Event_Process__c> events){
        Map<String,Set<Event_Process__c>> eventGroup = getEventGroups(events);

        // Invoke Operations 
        if(eventGroup.keySet().contains('Contact')){
            processContacts(eventGroup.get('Contact'));
        }        
        
        for(Event_Process__c event : events){
            event.Status__c = 'Completed';
        }
        Update events;
    }

    public static void processContacts(Set<Event_Process__c> details){
        Map<Id,Contact> newMap = new Map<Id,Contact>();
        Map<Id,Contact> newMapUpdate = new Map<Id,Contact>();
        Map<Id,Contact> oldMap = new Map<Id,Contact>();
        Set<Id> eventIds = new Set<Id>();
        for(Event_Process__c record : details){
                eventIds.add(record.Id);
                String currentJSON = record.Current_JSON__c;
                String oldJSON = record.Old_JSON__c;
                String eventType = record.Event_Type__c;
                sObject currentJSON_object = (sObject)JSON.deserialize(currentJSON, sObject.class);
                sObject oldJSON_object = oldJSON != null ? (sObject)JSON.deserialize(oldJSON, sObject.class) : null ;
                Id recordId = Id.valueOf(String.valueOf(currentJSON_object.get('Id')));
                if(eventType != 'After Update'){
                    newMap.put(recordId,(Contact)currentJSON_object);
                }
                else{
                    newMapUpdate.put(recordId,(Contact)currentJSON_object);
                    oldMap.put(recordId,(Contact)oldJSON_object);
                }
            }
     
      
        if(newMap.keySet().size() > 0 && details.size() < 11){
            RollUpSummary.onInsertRollUp(newMap);
        }
        if(newMapUpdate.keyset().size() > 0 && details.size() < 11){
            RollUpSummary.onAfterUpdate(newMapUpdate, oldMap);
        }
     if(!system.isBatch() && details.size() > 10){
        EventProcessBatch obj = new EventProcessBatch();
        obj.eventIds = eventIds;
        obj.query = 'SELECT ID , Current_JSON__c ,Event_Type__c,Old_JSON__c FROM Event_Process__c WHERE Id IN: eventIds ';
        Id batchId = Database.executeBatch(obj, 10);
     }
    }
    private static sObject getSobjectType(String objectName){
        return Schema.getGlobalDescribe().get(objectName).newsObject();
    }

    private static Map<String,Set<Event_Process__c>> getEventGroups(List<Event_Process__c> events){
          // group the information based on the Event Type source
       Map<String,Set<Event_Process__c>> eventGroup = new Map<String,Set<Event_Process__c>>();
       for(Event_Process__c record : events){
           String type = record.Type__c;
           if(eventGroup.get(type) == null ){
                eventGroup.put(type , new Set<Event_Process__c>());
           }
           eventGroup.get(type).add(record);
       }
       return eventGroup;
    }
}