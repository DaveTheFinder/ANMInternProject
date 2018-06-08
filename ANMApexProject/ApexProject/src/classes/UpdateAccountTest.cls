/**
 * Created by kbandala on 6/8/18.
 */
@IsTest
private class UpdateAccountTest {

    @IsTest
    public static void updateAccountWithFields(){

        Account a = new Account(Name = 'TestingAccountInsertion', ShippingCity = 'Vancouver', ShippingCountry = 'Canada',
                BillingCity = 'Toronto', BillingCountry = 'Canada');
        insert a;

        String name = ''+'\''+'TestingAccountInsertion'+'\'';
        Account account = Database.query('SELECT ShippingCountry, BillingCity FROM Account WHERE Name = '+name);
        account.ShippingCountry = 'Germany';
        account.BillingCity = 'Berlin';
        update account;

        String queryGetShippingCountry= 'SELECT Shipping_Country__c FROM In_Sync_Shipping__c WHERE Name=' +name;
        In_Sync_Shipping__c queryShipping = Database.query(queryGetShippingCountry);

        System.assertNotEquals('Canada', queryShipping.Shipping_Country__c);
        System.assertEquals('Germany',queryShipping.Shipping_Country__c);

    }

    @IsTest
    public static void updateAccountWithEmptyShippingFields(){
        Account a = new Account(Name = 'TestingAccountInsertion', ShippingCity = 'Vancouver', BillingCity = 'Toronto',
                BillingCountry = 'Canada');
        insert a;

        String name = ''+'\''+'TestingAccountInsertion'+'\'';
        Account account = Database.query('SELECT ShippingCity FROM Account WHERE Name = '+name);
        account.ShippingCity = null;
        update account;

        String queryGetShippingCity= 'SELECT Shipping_City__c FROM In_Sync_Shipping__c WHERE Name=' +name;
        In_Sync_Shipping__c queryShipping = Database.query(queryGetShippingCity);

        System.assertNotEquals('Vancouver', queryShipping.Shipping_City__c);
        System.assertEquals(null,queryShipping.Shipping_City__c);
    }

    @IsTest
    public static void updateAccountWithEmptyBillingFields(){
        Account a = new Account(Name = 'TestingAccountInsertion', ShippingCity = 'Vancouver', BillingCity = 'Toronto');
        insert a;

        String name = ''+'\''+'TestingAccountInsertion'+'\'';
        Account account = Database.query('SELECT BillingCity FROM Account WHERE Name = '+name);
        account.BillingCity = null;
        update account;

        String queryGetBillingCity= 'SELECT Billing_City__c FROM In_Sync_Billing__c WHERE Name=' +name;
        In_Sync_Billing__c queryBilling = Database.query(queryGetBillingCity);

        System.assertNotEquals('Toronto', queryBilling.Billing_City__c);
        System.assertEquals(null,queryBilling.Billing_City__c);
    }

    @IsTest
    public static void updateAccountWithOldEmptyShippingFields(){
        Account a = new Account(Name='TestingAccountInsertion');
        insert a;

        String name = ''+'\''+'TestingAccountInsertion'+'\'';
        Account account = Database.query('SELECT ShippingCity FROM Account WHERE Name = '+name);
        account.ShippingCity = 'Vancouver';
        update account;

        String queryGetShippingCity = 'SELECT Shipping_City__c FROM In_Sync_Shipping__c WHERE Name=' +name;
        In_Sync_Shipping__c queryShipping = Database.query(queryGetShippingCity);

        System.assertNotEquals(null, queryShipping.Shipping_City__c);
        System.assertEquals('Vancouver', queryShipping.Shipping_City__c);

    }

    @IsTest
    public static void updateAccountWithOldEmptyBillingFields(){
        Account a = new Account(Name='TestingAccountInsertion');
        insert a;

        String name = ''+'\''+'TestingAccountInsertion'+'\'';
        Account account = Database.query('SELECT BillingCity FROM Account WHERE Name = '+name);
        account.BillingCity = 'Toronto';
        update account;

        String queryGetBillingCity = 'SELECT Billing_City__c FROM In_Sync_Billing__c WHERE Name=' +name;
        In_Sync_Billing__c queryBilling = Database.query(queryGetBillingCity);

        System.assertNotEquals(null, queryBilling.Billing_City__c);
        System.assertEquals('Toronto', queryBilling.Billing_City__c);

    }

}