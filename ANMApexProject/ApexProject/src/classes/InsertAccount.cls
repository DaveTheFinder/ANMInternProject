/**
 * Created by kbandala on 6/7/18.
 */

public with sharing class InsertAccount {
    private List<Account> accounts;

    public InsertAccount(List<Account> accounts){

        this.accounts = accounts;
        runInSyncMethods();

    }

    //Function that gets the compound ShippingAddress and BillingAddress from an Account
    //It then stores given addresses with its corresponding, key, data and name
    public void runInSyncMethods(){
        for(Account a : accounts){

            Id key = a.Id;
            String name = a.Name;
            GetAddresses addresses = new GetAddresses(a);

            Address shipAddress = addresses.getShippingAddress();
            Address billAddress = addresses.getBillingAddress();

            insertShippingInSync(key,shipAddress,name);
            insertBillingInSync(key, billAddress,name);
        }
    }

    //Function that stores a ShippingInSync record given the Id and Name of its Parent (Account), it then stores
    //the Address of that parent
    public void insertShippingInSync(Id accountId, Address accountAddress,String name){
        In_Sync_Shipping__c inSyncShipping;

        //Checks if the User inserted a ShippingAddress
        //if it did, then it stores the address into the record
        //if not then it just creates the record with its parent's name and Id
        if(accountAddress!=null) {

            inSyncShipping = new In_Sync_Shipping__c(Account__c = accountId, Shipping_City__c = accountAddress.city,
                    Shipping_Country__c = accountAddress.country, Shipping_Country_Code__c = accountAddress.countryCode,
                    Shipping_Postal_Code__c = accountAddress.postalCode, Shipping_State__c = accountAddress.state,
                    Shipping_State_Code__c = accountAddress.stateCode, Shipping_Street__c = accountAddress.street, Name=name);

        } else {

            inSyncShipping = new In_Sync_Shipping__c(Account__c = accountId, Name = name);

        }
        insert inSyncShipping;
    }

    //Function that stores a BillingInSyng record given the Id and Name of its Parent (Account), it then stores
    //the Address of that parent
    public void insertBillingInSync(Id accountId, Address accountAddress,String name){
        In_Sync_Billing__c inSyncBilling;

        //Checks if the User inserted a BillingAddress
        //if it did, then it stores the address into the record
        //if not then it just creates the record with its parent's name and Id
        if(accountAddress!=null) {

            inSyncBilling = new In_Sync_Billing__c(Account__c = accountId, Billing_Street__c = accountAddress.street,
                    Billing_City__c = accountAddress.city, Billing_State__c = accountAddress.state, Billing_State_Code__c = accountAddress.stateCode,
                    Billing_Country__c = accountAddress.country, Billing_Country_Code__c = accountAddress.countryCode,
                    Billing_Postal_Code__c = accountAddress.postalCode, Name = name);

        }else {

            inSyncBilling = new In_Sync_Billing__c(Account__c = accountId, Name = name);

        }
        insert inSyncBilling;
    }

}
