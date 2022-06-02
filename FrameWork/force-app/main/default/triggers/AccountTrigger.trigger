/**
 * Created by maxprogood on 27.05.2022.
 */

trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
        TriggerFramework.run();
}