/** 
* 
* @className        INTEG_TransactionItem_OB_Queueable
* @description      Queueable class to start the integration process for Transaction Items and its parents
* @author           Rohit  Kapoor
* @date created     16-FEB-2020
* @last change
**/ 
global class INTEG_TransactionItem_OB_Queueable implements Queueable, Database.AllowsCallouts {

	set<id> transactionIdsSet = new set<Id>();
	string transactionItemObjName = Constants.EMPTY_STRING;

/*
*  @ConstructorName:INTEG_TransactionItem_OB_Queueable
*  @Description:    Parameterized constructor to initiate some class variables
*  @param:          set<Id> transactionIdsSet, String transactionItemObjName
*  @return          N/A
*  @author          Rohit Kapoor
*/ 
    global INTEG_TransactionItem_OB_Queueable(set<Id> transactionIdsSet, String transactionItemObjName){
        //setting up class variables with the parameters sent from the class enqueued this class
    	this.transactionIdsSet = transactionIdsSet;
    	this.transactionItemObjName = transactionItemObjName;
    }

/*
*  @methodName:		execute
*  @Description:    Calling INTEG_TransactionItem_OB_ServiceHandler.sendTransactionItems() to do the integration process 
				    for Transaction Items and its parents
*  @param:          QueueableContext
*  @return          N/A
*  @author          Rohit Kapoor
*/ 
    global void execute(QueueableContext context) {
        //Calling method to do the callouts and other processing
    	INTEG_TransactionItem_OB_ServiceHandler.sendTransactionItems(transactionIdsSet, transactionItemObjName);
        
    }

}