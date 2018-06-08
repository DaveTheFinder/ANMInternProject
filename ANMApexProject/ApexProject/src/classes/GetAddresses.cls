/**
 * Created by kbandala on 6/7/18.
 */

public with sharing class GetAddresses {
    private Account account;

    public GetAddresses (Account account){
        this.account = account;
    }

    //Function that returns the Address of a given account
    public Address getBillingAddress(){
        Id key = account.Id;
        String soqlQuery = 'SELECT BillingAddress FROM Account WHERE Id = ' +'\''+key+'\'';
        Account accountData = Database.query(soqlQuery);
        Address billingAddress = (Address) accountData.BillingAddress;
        return billingAddress;
    }

    //Function that returns the Address of a given account
    public Address getShippingAddress(){
        Id key = account.Id;
        String soqlQuery = 'SELECT ShippingAddress FROM Account WHERE Id = ' +'\''+key+'\'';
        Account accountData = Database.query(soqlQuery);
        Address shippingAddress = (Address) accountData.ShippingAddress;
        return shippingAddress;
    }

}