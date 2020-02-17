@isTest
private class Utilities_Test {
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

//to test Utilities.createExceptionLog()
    public static testMethod void testPerformTransaction(){
     	string errorMessage = 'Test error';
     	string StackTrace = '200';
     	string integrationName = 'TransactionItem Integration';
     	string severity = 'Exception';
     	string obj = 'TransactionItem__c';
     	string classTriggerName = 'TransactionItemTriggerHandler';

     	Utilities.createExceptionLog(errorMessage,StackTrace,integrationName ,severity,obj, '','', classTriggerName);
    }
}