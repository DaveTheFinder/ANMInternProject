/**
 * Created by kbandala on 6/8/18.
 */
@IsTest
private class InsertAccountTest {

    @IsTest
    public static void insertAccountWithNoEmptyFields(){
        Account a = new Account(Name = 'TestingAccountInsertion', ShippingCity = 'Vancouver', ShippingCountry = 'Canada',
                                BillingCity = 'Toronto', BillingCountry = 'Canada');
        insert a;

        String queryGetShippingCity = 'SELECT Shipping_City__c, Shipping_Country__c FROM In_Sync_Shipping__c WHERE Name=' + '\''+'TestingAccountInsertion'+'\'';
        In_Sync_Shipping__c queryShipping = Database.query(queryGetShippingCity);
        System.assertEquals(queryShipping.Shipping_City__c,'Vancouver');
        System.assertEquals(queryShipping.Shipping_Country__c,'Canada');

        String queryGetBillingCity = 'SELECT Billing_City__c, Billing_Country__c FROM In_Sync_Billing__c WHERE Name=' +'\'' +'TestingAccountInsertion'+'\'';
        In_Sync_Billing__c queryBilling = Database.query(queryGetBillingCity);
        System.assertEquals('Toronto', queryBilling.Billing_City__c);
        System.assertEquals('Canada', queryBilling.Billing_Country__c);

    }

    @IsTest
    public static void insertAccountWithEmptyFields(){
        Account a = new Account(Name='TestingAccountInsertion');
        insert a;

        String queryGetShippingCity = 'SELECT Shipping_City__c, Shipping_Country__c FROM In_Sync_Shipping__c WHERE Name=' + '\''+'TestingAccountInsertion'+'\'';
        In_Sync_Shipping__c queryShipping = Database.query(queryGetShippingCity);
        System.assertEquals(null, queryShipping.Shipping_City__c);
        System.assertEquals(null, queryShipping.Shipping_Country__c);

        String queryGetBillingCity = 'SELECT Billing_City__c, Billing_Country__c FROM In_Sync_Billing__c WHERE Name=' +'\'' +'TestingAccountInsertion'+'\'';
        In_Sync_Billing__c queryBilling = Database.query(queryGetBillingCity);
        System.assertEquals(null, queryBilling.Billing_City__c);
        System.assertEquals(null, queryBilling.Billing_Country__c);

    }
}