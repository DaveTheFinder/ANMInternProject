/**
 * Created by kbandala on 6/7/18.
 */

public with sharing class UpdateAccount {
    private List<Account> oldAccounts;
    private List<Account> newAccounts;
    private Set<Id> accountShippingIds;
    private Set<Id> accountBillingIds;
    private List<In_Sync_Shipping__c> shippingToUpdate;
    private List<In_Sync_Billing__c> billingToUpdate;


    public UpdateAccount(List<Account> oldAccountRecords, List<Account> newAccountRecords){
        this.oldAccounts = oldAccountRecords;
        this.newAccounts = newAccountRecords;

        this.accountShippingIds = new Set<Id>();
        this.accountBillingIds = new Set<Id>();

        this.billingToUpdate = new List<In_Sync_Billing__c>();
        this.shippingToUpdate = new List<In_Sync_Shipping__c>();

        updateInSync();
    }

    //Function that gets the OldAddress of the Record to change and its new Address
    //it then modifies it and updates it into the database
    public void updateInSync(){
        Integer i = 0;
        for(Account a : newAccounts){
            GetAddresses oldAccountAddresses = new GetAddresses(oldAccounts.get(i));
            GetAddresses newAccountAddresses = new GetAddresses(a);

            Address oldAccountShippingAddress = oldAccountAddresses.getShippingAddress();
            Address oldAccountBillingAddress = oldAccountAddresses.getBillingAddress();

            Address newAccountShippingAddress = newAccountAddresses.getShippingAddress();
            Address newAccountBillingAddress = newAccountAddresses.getBillingAddress();

            //Checks if the user typed some input
            //if not (data was deleted) and it previously had data, then it deletes the old data
            //if the user typed data, then it checks if data was changed and it just updates it
            if(newAccountShippingAddress != null ) {
                if (oldAccountShippingAddress != null) {
                    if (addressIsNotTheSame(oldAccountShippingAddress, newAccountShippingAddress)) {
                        accountShippingIds.add(a.Id);
                    }
                } else {
                    accountShippingIds.add(a.Id);
                }
            }

            if(newAccountBillingAddress != null){
                if(oldAccountBillingAddress != null){
                    if(addressIsNotTheSame(oldAccountBillingAddress, newAccountBillingAddress)){
                        accountBillingIds.add(a.Id);
                    }
                }else{
                    accountBillingIds.add(a.Id);
                }
            }
            i++;

        }
        startShippingSync();

        startBillingSync();

        if(!shippingToUpdate.isEmpty()) updateShippingAddress();
        if(!billingToUpdate.isEmpty()) updateBillingAddress();


    }

    //FUnction that updates every record given the ID of the Account that was modified
    public void startShippingSync(){
        for(In_Sync_Shipping__c inSyncShipping : [SELECT Id, Account__c, Shipping_City__c, Shipping_Country__c, Shipping_Country_Code__c, Shipping_Postal_Code__c,
                Shipping_State__c, Shipping_State_Code__c, Shipping_Street__c FROM In_Sync_Shipping__c WHERE Account__c in :accountShippingIds]){

            Account a = Database.query('SELECT Id FROM Account WHERE Id = ' +'\''+inSyncShipping.Account__c+'\'');
            shippingToUpdate.add(changeAddress(a, inSyncShipping));
            System.debug(shippingToUpdate);
        }

    }

    //FUnction that updates every record given the ID of the Account that was modified
    public void startBillingSync(){
        for(In_Sync_Billing__c inSyncBilling : [SELECT Id,Account__c, Billing_City__c, Billing_Country__c, Billing_Country_Code__c, Billing_Postal_Code__c,
                Billing_State__c, Billing_State_Code__c, Billing_Street__c FROM In_Sync_Billing__c WHERE Account__c in :accountBillingIds]){

            Account a = Database.query('SELECT Id FROM Account WHERE Id = ' +'\''+inSyncBilling.Account__c+'\'');
            billingToUpdate.add(changeBillingAddress(a, inSyncBilling));

        }

    }


    //FUnction that updates every record with the new data,
    //if the user deleted all the previous data, then it deletes the old data.
    public In_Sync_Billing__c changeBillingAddress(Account a, In_Sync_Billing__c updated){

        GetAddresses address = new GetAddresses(a);
        Address newAddress = address.getBillingAddress();

        if(newAddress != null ) {

            updated.Billing_Street__c = newAddress.street;
            updated.Billing_State_Code__c = newAddress.stateCode;
            updated.Billing_State__c = newAddress.state;
            updated.Billing_Postal_Code__c = newAddress.postalCode;
            updated.Billing_Country_Code__c = newAddress.countryCode;
            updated.Billing_Country__c = newAddress.country;
            updated.Billing_City__c = newAddress.city;

            return updated;
        }

        return eraseAllBillingData(updated);
    }

    public In_Sync_Shipping__c changeAddress(Account a, In_Sync_Shipping__c updated){

        GetAddresses address = new GetAddresses(a);
        Address newAddress = address.getShippingAddress();

        if(newAddress != null) {
            updated.Shipping_Street__c = newAddress.street;
            updated.Shipping_State_Code__c = newAddress.stateCode;
            updated.Shipping_State__c = newAddress.state;
            updated.Shipping_Postal_Code__c = newAddress.postalCode;
            updated.Shipping_Country_Code__c = newAddress.countryCode;
            updated.Shipping_Country__c = newAddress.country;
            updated.Shipping_City__c = newAddress.city;

            return updated;
        }

        return eraseAllShippingData(updated);

    }

    //Function that checks if Data was modified
    public boolean addressIsNotTheSame(Address oldAddress, Address newAddress){
        return (oldAddress.postalCode == newAddress.postalCode && oldAddress.street == newAddress.street &&
                oldAddress.city == newAddress.city && oldAddress.stateCode == newAddress.stateCode &&
                oldAddress.state == newAddress.state && oldAddress.countryCode == newAddress.countryCode &&
                oldAddress.country == newAddress.country);
    }


    public void updateShippingAddress(){
        update shippingToUpdate;
    }

    public void updateBillingAddress(){
        update billingToUpdate;
    }

    //Function that erases all previous data
    private In_Sync_Billing__c eraseAllBillingData(In_Sync_Billing__c updated){

        updated.Billing_Street__c = null;
        updated.Billing_State_Code__c = null;
        updated.Billing_State__c = null;
        updated.Billing_Postal_Code__c = null;
        updated.Billing_Country_Code__c = null;
        updated.Billing_Country__c = null;
        updated.Billing_City__c = null;

        return updated;
    }

    //Function that erases all previous data
    private In_Sync_Shipping__c eraseAllShippingData(In_Sync_Shipping__c updated){

        updated.Shipping_Street__c = null;
        updated.Shipping_State_Code__c = null;
        updated.Shipping_State__c = null;
        updated.Shipping_Postal_Code__c = null;
        updated.Shipping_Country_Code__c = null;
        updated.Shipping_Country__c = null;
        updated.Shipping_City__c = null;

        return updated;
    }




}