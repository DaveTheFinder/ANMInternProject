/**
 * Created by kbandala on 6/8/18.
 */
@IsTest
private class DeleteAccountTest {

    @IsTest
    public static void deleteAccount(){

        Account a = new Account(Name = 'TestingAccountInsertion', ShippingCity = 'Vancouver', ShippingCountry = 'Canada',
                BillingCity = 'Toronto', BillingCountry = 'Canada');
        insert a;

        String queryGetShippingCity = 'SELECT Shipping_City__c, Shipping_Country__c FROM In_Sync_Shipping__c WHERE Name=' + '\''+'TestingAccountInsertion'+'\'';
        In_Sync_Shipping__c queryShipping = Database.query(queryGetShippingCity);
        System.assertEquals(queryShipping.Shipping_City__c,'Vancouver');
        System.assertEquals(queryShipping.Shipping_Country__c,'Canada');

        delete a;



    }
}