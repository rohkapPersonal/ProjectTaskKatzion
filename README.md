# Katzion Project Task 
### Code related to Katzion project task

### Getting Started
Project given by Katzion to perform outbound integration with 3rd party system.

#### Description
1. The project is to send Transaction and its child TransactionItem objects records to 3rd party one by one. 
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
 4. **Remote Site Settings**
    - TestURL.remoteSite (will change with real endpoints URL)
  
  #### Objects and their usages
  1. Transaction__c - Parent Object
  2. TransactionItem__c - Child of Transaction__c object
  3. Error_Log__c - To capture all the errors/exception occurred in the apex.
  4. Services_mdt - To configure all the end points and its related details
  5. Rest_API_Field_Mapping__mdt - To configure restfield mappint and sObject name, api name, its fields details. To fetch them dynamically and on the need basis. This metadata will also help when we have inbound integration to store the mapping of restfield and sObject field
  6. Rest_API_Sections__mdt - To configure which section of JSON the field is related (future enhancements)
  
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
  
 
