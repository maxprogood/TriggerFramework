/**
 * Created by maxprogood on 28.05.2022.
 */

public with sharing class ContactTriggerHandler extends TriggerHandler {
    //Delete related opportunities
    public override void afterDelete(List<SObject> oldList) {
        delete [SELECT Id FROM Opportunity WHERE ContactId IN : oldList];
    }
}