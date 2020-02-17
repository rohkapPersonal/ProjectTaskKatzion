/** 
* 
* @className        Test_INTEGTransactionOBSerHandler
* @description      Test class for INTEG_Transaction_OB_ServiceHandler
* @author           Rohit  
* @date created     16-FEB-2020
* @last change
**/
@isTest
private class Test_INTEGTransactionOBSerHandler {
    @testSetup
    public static void setUpData(){
    	list<Transaction__c> listTransactions = TestDataFactory.createTransaction(1);
    	if(!listTransactions.isEmpty()){
    		insert listTransactions;
    	}

    	list<TransactionItem__c> listTransactionItems = TestDataFactory.createTransactionItem(2, listTransactions[0].id);
    	if(!listTransactionItems.isEmpty()){
    		insert listTransactionItems;
    	}
    	list<Services__mdt> services = [Select id, Endpoint_URL__c, Service_URL__c, Client_Id__c, Client_Secret__c, 
        									Grant_Type__c, Password__c,Token__c from Services__mdt
        									where DeveloperName =: Constants.TRANSACTIONITEM_TEST_SEND_DATA limit 1];
    }

    public static testMethod void testPerformTransaction(){

    	list<TransactionItem__c> listTI = [select id, Transaction__c from TransactionItem__c limit 2];
        id transactionId = listTI[0].Transaction__c;
        set<id> setTransactionIds = new set<id>{transactionId};
		// Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        INTEG_Transaction_OB_ServiceHandler.sendTransactions(setTransactionIds, Constants.TRANSACTION_OBJ_API_NAME);
    	
        //INTEG_TransactionItem_OB_ServiceHandler.performTransaction();
    }

}