/**
 * Created by maxprogood on 22.05.2022.
 */

public class AccountTriggerHandler extends TriggerHandler {
    //Delete contacts with duplicate Last Name
    public override void beforeInsert(List<SObject> newList) {
        Set<String> myName = new Set<String>();
        for (Account account : (List<Account>) newList) {
            myName.add(account.Name);
        }
        delete [SELECT Id FROM Contact WHERE LastName IN :myName AND AccountId IN :newList];
    }

    // Check account with related opportunities
    public override void beforeDelete(List<SObject> oldList) {
        List<Opportunity> opportunities = [SELECT Id,AccountId FROM Opportunity WHERE AccountId IN :oldList];
        Set<Id> accIds = new Set<Id>();
        for (Opportunity opp : opportunities) {
            accIds.add(opp.AccountId);
        }
        for (Account account :(List<Account>) oldList){
            if(accIds.contains(account.Id)){
                account.Id.addError('Cannot delete account with related opportunities.');
            }
        }
    }

    //rename contacts First Name to upper Case
    public override void afterInsert(List<SObject> newList) {
        List<Contact> contacts = [SELECT Id, FirstName FROM Contact WHERE AccountId IN :newList];
        for (Contact contact : contacts) {
            contact.FirstName = contact.FirstName.toUpperCase();
        }
        update contacts;
    }

    // Check accounts with related contacts and delete them
    public override void afterDelete(List<SObject> oldList) {
        delete [SELECT Id FROM Contact WHERE AccountId IN : oldList];
    }

    // Add 'Undelete' word to Name in unDelete Account
    public override void afterUnDelete(List<SObject> oldList) {
        List<Account> accList = new List<Account>();
        for (Account undeletedAccount : (List<Account>) oldList) {
            accList.add(new Account(
                    Id = undeletedAccount.Id,
                    Name = 'Undeleted :' + undeletedAccount.Name
            ));
        }
        update accList;
    }
}