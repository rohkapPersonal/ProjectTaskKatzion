/** 
* 
* @className        TestDataFactory
* @description      Test data factory class to create test data
* @author           Rohit  
* @date created     13-FEB-2020
* @last change
**/
public class TestDataFactory {
    
/*
*  @methodName:     createTransaction
*  @Description:    to create Transaction__c records
*  @param:          integer - number of records needs to be created
*  @return          list<Transaction__c>
*  @author          Rohit Kapoor
*/
    public static list<Transaction__c> createTransaction(integer count){
    	list<Transaction__c> listOfTransaction = new list<Transaction__c>();
    	for(integer i = 0; i<count; i++){
    		Transaction__c trans = new Transaction__c();
    		trans.Name = 'test'+ i;
    		trans.Transaction_Count__c = 1;
    		trans.Total_Discount__c = 5.00;
            trans.Total_Cost__c = 1000.00;
    		listOfTransaction.add(trans);
    	}
    	return listOfTransaction;
    }

/*
*  @methodName:     createTransaction
*  @Description:    to create TransactionItem__c records
*  @param:          integer count - number of records needs to be created, 
					id transactionId - Transaction Id
*  @return          list<TransactionItem__c>
*  @author          Rohit Kapoor
*/
    public static list<TransactionItem__c>createTransactionItem(integer count, id transactionId){
    	list<TransactionItem__c> listOfTI = new list<TransactionItem__c>();
    	for(integer i = 0; i<count; i++){
    		TransactionItem__c ti = new TransactionItem__c();
    		ti.Name = 'test'+ i;
    		ti.Transaction__c = transactionId;
    		ti.Item_Cost__c = 100;
    		listOfTI.add(ti);
    	}
    	return listOfTI;
    }
}