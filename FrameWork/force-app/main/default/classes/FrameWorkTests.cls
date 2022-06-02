/**
 * Created by maxprogood on 31.05.2022.
 */

@IsTest
private class FrameWorkTests {
    @IsTest
    static void testBeforeDeleteAcct() {
        Account account = new Account(Name = 'Test');
        insert account;
        insert new Opportunity(
                Name = account.Name + ' Opportunity',
                StageName = 'Prospecting',
                CloseDate = System.today().addMonths(1),
                AccountId = account.Id
        );
        Test.startTest();
        Database.DeleteResult result = Database.delete(account, false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals(
                'Cannot delete account with related opportunities.',
                result.getErrors()[0].getMessage()
        );
    }

    @IsTest
    static void testBeforeInsertAcct() {
        String myName = 'BatMan';
        Account account = new Account(Name = myName);
        Contact con = new Contact(LastName = 'BatMan', AccountId = account.Id);
        Test.startTest();
        insert con;
        Test.stopTest();
        Contact contact = [SELECT Id, Name FROM Contact WHERE Name = :myName LIMIT 1];
        System.assertEquals(contact.Name, account.Name);
        insert account;
    }

    @IsTest
    static void testAfterInsertAcct() {
        Account account = new Account(Name = 'Test');
        Test.startTest();
        insert account;
        Test.stopTest();
        insert new Contact(FirstName = 'no-caps', LastName = 'Test', AccountId = account.Id);
        List<Contact> contactCaps = [SELECT Id, FirstName FROM Contact WHERE FirstName = 'NO-CAPS'];
        System.assertEquals(1, contactCaps.size());
    }

    @IsTest
    static void testAfterDeleteAcct() {
        Account account = new Account(Name = 'Test');
        Contact contact = new Contact(LastName = 'Test Last Name', AccountId = account.Id);
        insert account;
        insert contact;
        Test.startTest();
        delete account;
        Test.stopTest();
        List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :account.Id];
        if (contacts.size() == null) {
            System.assertEquals(null, contacts.size());
            delete contacts;
        }
    }

    @IsTest
    static void testAfterUnDeleteAcct() {
        Account account = new Account(Name = 'Test');
        insert account;
        delete account;
        Test.startTest();
        undelete account;
        Test.stopTest();
        List<Account> accounts = [SELECT Id FROM Account WHERE Name = :'Undeleted :' + account.Name];
        System.assertEquals(1, accounts.size());
    }

    @IsTest
    static void testAfterDeleteCon() {
        Account acct = new Account(Name = 'SFDC Account');
        insert acct;
        Contact con = new Contact(
                FirstName = 'Joe',
                LastName = 'Smith',
                AccountId = acct.Id);
        insert con;
        Opportunity opp = new Opportunity(Name = acct.Name + ' Opportunity',
                StageName = 'Prospecting',
                CloseDate = System.today().addMonths(1),
                AccountId = acct.Id);
        insert opp;
        Test.startTest();
        delete con;
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE ContactId = :con.Id];
        Test.stopTest();

        System.assertEquals(0, opportunities.size());
    }
}

