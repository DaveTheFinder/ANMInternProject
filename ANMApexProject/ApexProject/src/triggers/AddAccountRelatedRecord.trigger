/**
 * Created by kbandala on 6/7/18.
 */

trigger AddAccountRelatedRecord on Account (before delete, after insert, after update){
    if(Trigger.isAfter && Trigger.isInsert){
        new InsertAccount(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        new UpdateAccount(Trigger.old, Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isDelete){
        new DeleteAccount(Trigger.old);
    }

}