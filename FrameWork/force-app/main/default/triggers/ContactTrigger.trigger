/**
 * Created by maxprogood on 28.05.2022.
 */

trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerFramework.run();
}