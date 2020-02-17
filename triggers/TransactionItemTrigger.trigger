/** 
* 
* @TriggerName      TransactionItemTrigger
* @description      Trigger on TransactionItem__c 
* @author           Rohit  
* @date created     13-FEB-2020
* @last change
**/            
trigger TransactionItemTrigger on TransactionItem__c(before insert,after insert, before update, after update, after delete, after undelete) {
    new TransactionItemTriggerHandler().run();
}
