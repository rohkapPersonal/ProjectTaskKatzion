# Katzion Project Task 
### Code related to Katzion project task

### Getting Started
1. The project is including parent Transaction and its child TransactionItem object. 
2. Logic needs to pick those TransactionItems and its parent records where number of TransactionItems records become equal to Transaction Count (field on Transaction).
3. Then an integration to 3rd party occurs, where 1st logic sends Transaction Items. On success message from the endpoint, logic picks the details of the Parent Transaction record and send it to the same endpoint.

#### Components Invovled
1. **Classes**
  - Constants
  - Utilities
  - TriggerHandler
  - TransactionItemTriggerHandler
  - INTEG_TransactionItem_OB_Queueable
  - INTEG_Transaction_OB_ServiceHandler
  - INTEG_TransactionItem_OB_ServiceHandler
  - TestDataFactory
  - Test_TransactionItemTriggerHandler
  - Test_INTEGTransactionItemOBSerHandler
  - Test_INTEGTransactionOBSerHandler
  - Utilities_Test
 2. **Triggers**
   - TransactionItemTrigger
 3. **Objects**
   - Transaction__c
   - TransactionItem__c
   - Error_Log__c
   - Services__mdt
   - Rest_API_Field_Mapping__mdt
   - Rest_API_Sections__mdt
  
  #### Flow
  1. On creation, deletion or undelete of Transaction Item, its trigger checks Number of Transaction Items with Total Counts field value on its parent Transaction.
  2. If point 1. condition gets fulfilled logic queued a class using Queueable interface. This is to avoid the restriction that do not allow any callout from the Trigger.
  3. On processing of Queuable class logic calls INTEG_TransactionItem_OB_ServiceHandler.sendTransactionItems() method. This method first prepare the JSON request, gets the Access Token and do the callout. 
  4. On the basis of susscessful response, will call the INTEG_Transaction_OB_ServiceHandler.sendTransaction() method. To do the callout for Transaction records present as parent on previous step Transaction Items.
  
  #### Testing
  1. To test the functionality, need to run following classes
     - Test_TransactionItemTriggerHandler
     - Test_TransactionItemTriggerHandler
     - Test_INTEGTransactionOBSerHandler
  
 
