/** 
* 
* @className        TransactionTriggerHandler
* @description      Handler class for TransactionTrigger 
* @author           Rohit  
* @date created     13-FEB-2020
* @last change
**/
public class TransactionTriggerHandler extends TriggerHandler {
    public override void beforeInsert(){}
    public override void afterInsert(){}
    public override void beforeUpdate(){}
    public override void afterUpdate(){
    	set<id>transIdsSet = new set<Id>();
    	set<id>finalTransIdsSet = new set<Id>();
    	if(Trigger.new != null && !Trigger.new.isEmpty()){
    		for(Transaction__c trans: (list<Transaction__c>)Trigger.new){
    			system.debug('trans--'+ trans);
    			if(trans.Transaction_Count__c == trans.Related_Transaction_Count__c){
    				finalTransIdsSet.add(trans.id);
    			}
    		}
    	}
		if(!finalTransIdsSet.isEmpty()){
    		sendTransactionItems(finalTransIdsSet);
    	}
    }
    public override void afterUndelete(){}

    public static void sendTransactionItems(set<Id> transactionIdsSet){
    	INTEG_TransactionItem_OB_ServiceHandler.sendTransactionItems(transactionIdsSet, Constants.TRANSACTIONITEM_OBJ_API_NAME);
    }
}