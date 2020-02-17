/** 
* 
* @className        Test_TransactionItemTriggerHandler
* @description      Test class for TransactionTriggerHandler
* @author           Rohit  
* @date created     13-FEB-2020
* @last change
**/
@isTest
private class Test_TransactionItemTriggerHandler {
    
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
    }


//TestMethod - TestAfterInsertTransactionItems. 
//checking if Deleting a TransactionItem will fulfill the afterDelete method of TransactionItemTriggerHandler
    public static testMethod void TestAfterInsertTransactionItems(){
        Test.startTest();
        List<TransactionItem__c> listTI = [select id, Transaction__c from TransactionItem__c limit 2];
        id transactionId = listTI[0].Transaction__c;
        delete listTI;

        list<TransactionItem__c> listTransactionItems = TestDataFactory.createTransactionItem(1, transactionId);
    	if(!listTransactionItems.isEmpty()){
    		insert listTransactionItems;
    	}

        for(Transaction__c trans : [Select id, Transaction_Count__c,Related_Transaction_Count__c, 
                                                (select id from TransactionItem__r) 
                                                from Transaction__c where Id =: transactionId ]){
        	system.assertEquals(trans.TransactionItem__r.size(), trans.Transaction_Count__c);

        	Test.stopTest();    
    	}
    }


//TestMethod - TestDeleteTransactionItems. 
//checking if Deleting a TransactionItem will fulfill the afterDelete method of TransactionItemTriggerHandler
    public static testMethod void TestDeleteTransactionItems(){
        Test.startTest();
        List<TransactionItem__c> listTI = [select id, Transaction__c from TransactionItem__c limit 2];
        id transactionId = listTI[0].Transaction__c;
        delete listTI[0];

        for(Transaction__c trans : [Select id, Transaction_Count__c,Related_Transaction_Count__c, 
                                                (select id from TransactionItem__r) 
                                                from Transaction__c where Id =: transactionId ]){
        	system.assertEquals(trans.TransactionItem__r.size(), trans.Transaction_Count__c);

        	Test.stopTest();    
    	}
    }

//TestMethod - TestAfterUndeleteTransactionItems. 
//checking if Undeleting a TransactionItem will fulfill the afterUnDelete method of TransactionItemTriggerHandler
    public static testMethod void TestAfterUndeleteTransactionItems(){
        Test.startTest();
        List<TransactionItem__c> listTI = [select id, Name, Transaction__c from TransactionItem__c limit 2];
        id transactionId = listTI[0].Transaction__c;
        string TIName = listTI[0].Name;
        delete listTI;

        List<TransactionItem__c> listTI_Undelete = [select id, Name, Transaction__c from TransactionItem__c where Name = : TIName All Rows];
        undelete listTI_Undelete;

        for(Transaction__c trans : [Select id, Transaction_Count__c,Related_Transaction_Count__c, 
                                                (select id from TransactionItem__r) 
                                                from Transaction__c where Id =: transactionId ]){
        	system.assertEquals(trans.TransactionItem__r.size(), trans.Transaction_Count__c);

        	Test.stopTest();    
    	}
    }
    
    /*public static testMethod void performTransactionSuccessTest(){
        Test.startTest();
        List<Activity__c> actlist = [select id,Activity_Number__c, Name from Activity__c];
        DATG_INTEG_MP_OB_DLV_ServiceHandler servHandler  = new DATG_INTEG_MP_OB_DLV_ServiceHandler();
        List<DATG_InterfaceTxnResponse> txnRespList = servHandler.createMPDeliverableTxn(actlist,false);
        system.assertNotEquals(0, txnRespList.size()); 
        Test.setMock(HttpCalloutMock.class, new DATG_Utility_HttpMockCallout());
        servHandler.performTransaction(txnRespList.get(0));
        Test.stopTest();    
    }*/
}