/** 
* 
* @className        TransactionItemTriggerHandler
* @description      Handler class for TransactionItemTrigger 
* @author           Rohit  
* @date created     13-FEB-2020
* @last change
**/ 
public class TransactionItemTriggerHandler extends TriggerHandler {
 /**
 * @name beforeInsert
 * @Description Method for beforeInsert trigger context
 * @author Rohit
 */
    public override void beforeInsert(){}

 /**
 * @name afterInsert
 * @Description Method for afterInsert trigger context
 * @author Rohit
 */
    public override void afterInsert(){
        set<id>transIdsSet = new set<Id>();
        set<id>finalTransIdsSet = new set<Id>();
        //fetching all the parents (Transaction__c) of Transaction Items
        if(Trigger.new != null && !Trigger.new.isEmpty()){
            for(TransactionItem__c ti : (list<TransactionItem__c>)Trigger.new){
                transIdsSet.add(ti.Transaction__c);
            }
        }

        if(!transIdsSet.isEmpty()){

            //fetching all the Transaction__c using transIdsSet set
            for(Transaction__c trans : [Select id, Transaction_Count__c,Related_Transaction_Count__c, 
                                                (select id from TransactionItem__r) 
                                                from Transaction__c where Id IN: transIdsSet]){
                //if Transaction Count on Transaction__c equals to Number of Transaction Items on the same Transaction
                if(trans.Transaction_Count__c == trans.TransactionItem__r.size()){
                    //preparing final set ot Transaction__c ids
                    finalTransIdsSet.add(trans.id);
                }
            }
        }    
        //calling method which will do the complete processing like sending data to 3rd party end points
        if(!finalTransIdsSet.isEmpty()){
            sendTransactionItems(finalTransIdsSet);
        }
    }

 /**
 * @name beforeUpdate
 * @Description Method for beforeUpdate trigger context
 * @author Rohit
 */
    public override void beforeUpdate(){}

 /**
 * @name afterUpdate
 * @Description Method for afterUpdate trigger context
 * @author Rohit
 */
    public override void afterUpdate(){}

/**
 * @name afterUndelete
 * @Description Method for afterUndelete trigger context
 * @author Rohit
*/
    public override void afterUndelete(){
        set<id>transIdsSet = new set<Id>();
        set<id>finalTransIdsSet = new set<Id>();

        //fetching all the parents (Transaction__c) of Transaction Items
        if(Trigger.new != null && !Trigger.new.isEmpty()){
            for(TransactionItem__c ti : (list<TransactionItem__c>)Trigger.new){
                transIdsSet.add(ti.Transaction__c);
            }
        }

        if(!transIdsSet.isEmpty()){
            //fetching all the Transaction__c using transIdsSet set
            for(Transaction__c trans : [Select id, Transaction_Count__c,Related_Transaction_Count__c, 
                                                (select id from TransactionItem__r) 
                                                from Transaction__c where Id IN: transIdsSet]){
                //if Transaction Count on Transaction__c equals to Number of Transaction Items on the same Transaction
                if(trans.Transaction_Count__c == trans.TransactionItem__r.size()){
                    //preparing final set ot Transaction__c ids
                    finalTransIdsSet.add(trans.id);
                }
            }
        }
            
        //calling method which will do the complete processing like sending data to 3rd party end points
        if(!finalTransIdsSet.isEmpty()){
            sendTransactionItems(finalTransIdsSet);
        }
    }

/**
 * @name afterDelete
 * @Description Method for afterDelete trigger context
 * @author Rohit
*/
    public override void afterDelete(){
        set<id>transIdsSet = new set<Id>();
        set<id>finalTransIdsSet = new set<Id>();
		
        //fetching all the parents (Transaction__c) of Transaction Items
        if(Trigger.old != null && !Trigger.old.isEmpty()){
            for(TransactionItem__c ti : (list<TransactionItem__c>)Trigger.old){
                transIdsSet.add(ti.Transaction__c);
            }
        }

        if(!transIdsSet.isEmpty()){
            //fetching all the Transaction__c using transIdsSet set
            for(Transaction__c trans : [Select id, Transaction_Count__c,Related_Transaction_Count__c, 
                                                (select id from TransactionItem__r) 
                                                from Transaction__c where Id IN: transIdsSet]){
                //if Transaction Count on Transaction__c equals to Number of Transaction Items on the same Transaction
                if(trans.Transaction_Count__c == trans.TransactionItem__r.size()){
                    //preparing final set ot Transaction__c ids
                    finalTransIdsSet.add(trans.id);
                }
            }
        }
            
        //calling method which will do the complete processing like sending data to 3rd party end points
        if(!finalTransIdsSet.isEmpty()){
            sendTransactionItems(finalTransIdsSet);
        }
    }
    
/*
*  @MainMethodName  sendTransactionItems
*  @Description:    MAIN METHOD - To start processing of Transaction Items to be sent to the endpoint
                    1. This method is queueing a class which has implemented the Queueable interface. It is done as on triggers
                       callouts are not allowed
                    2. the method will INTEG_TransactionItem_OB_ServiceHandler.sendTransactionItems, service class for creating JSON,
                        fetching necessary data and doing callouts
*  @param:          set<id> transactionIdsSet
*  @return          N/A
*  @author          Rohit Kapoor
*/  
    public static void sendTransactionItems(set<Id> transactionIdsSet){
        try{
            Id jobID = system.enqueueJob(new INTEG_TransactionItem_OB_Queueable(transactionIdsSet, Constants.TRANSACTIONITEM_OBJ_API_NAME));
        }catch(exception ex){}
    }
}