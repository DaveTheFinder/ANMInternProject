/**
 * Created by kbandala on 6/7/18.
 */

public with sharing class DeleteAccount {
    List<Id> accountIds;
    List<Account> accounts;

    public DeleteAccount(List<Account> accounts){
        this.accounts = accounts;
        this.accountIds = new List<Id>();
        startDeleting();
    }

    // Function that stores the Id's of the accounts that want to be deleted
    public void startDeleting(){
        for(Account a : accounts){
            accountIds.add(a.Id);
        }
        deleteInSyncShipping();
        deleteInSyncBilling();
    }

    // Function that gets all the InSyncBilling records that are related to the Id's that were previously stored
    public void deleteInSyncBilling(){
        List<In_Sync_Billing__c> toDeleteBillings = [SELECT Id FROM In_Sync_Billing__c WHERE Account__c in :accountIds];

        //If there are records to delete, then delete
        if(toDeleteBillings != null) delete toDeleteBillings;

    }

    // Function that gets all the InSyncShipping records that are related to the Id's that were previously stored
    public void deleteInSyncShipping(){
        List<In_Sync_Shipping__c> toDeleteShippings = [SELECT Id FROM In_Sync_Shipping__c WHERE Account__c in :accountIds];

        //If there are records to delete, then delete
        if(toDeleteShippings != null) delete toDeleteShippings;

    }

}