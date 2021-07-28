Trigger ContactTrigger on Contact (after insert) {
if(Trigger.isafter && Trigger.isinsert){
    Contacttriggerhandler.afterInsert(Trigger.newmap);
}
}