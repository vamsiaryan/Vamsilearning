trigger trail on Contact(after insert,after update,before insert,before delete,before undelete)
{
    switch on  Trigger.operationType{
        when AFTER_INSERT{
            contactuser1sync.afterinsert(trigger.newmap,null)
        }
        when BEFORE_INSERT{
            contactuser1sync.beforeinsert(trigger.newmap,null)
        }
        when AFTER_UPDATE{
            contactuser1sync.afterupdte(trigger.newmap,trigger.oldmap)
        }
        when BEFORE_DELETE{
            contactuser1sync.afterupdte(trigger.newmap,trigger.oldmap)
        }
        when AFTER_DELETE{
            contactuser1sync.afterupdte(trigger.newmap,trigger.oldmap)
        }
        when AFTER_UNDELETE{
            contactuser1sync.afterupdte(trigger.newmap,null)
        }
    }
}