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
   
