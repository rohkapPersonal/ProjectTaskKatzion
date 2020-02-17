/** 
* 
* @className        Constants
* @description      Constants class to have all the constants being used in the system
* @author           Rohit  
* @date created     13-FEB-2020
* @last change
**/ 
public class Constants {

	//Global constants
	public static final String EMPTY_STRING = ' ';

	//Trigger context variables
	public static final String sTriggerBeforeInsert= 'before insert';
    public static final String sTriggerBeforeUpdate= 'before update';
    public static final String sTriggerBeforeDelete= 'before delete';
    public static final String sTriggerAfterInsert= 'after insert';
    public static final String sTriggerAfterUpdate= 'after update';
    public static final String sTriggerAfterDelete= 'after delete';
    public static final String sTriggerAfterUndelete = 'after undelete';
    //Trigger context variables - ends

    //Trigger handler class constants
    public static final String Trigger_Handler_Exception_Message_Max_Loop = 'Maximum loop count of';
    public static final String Trigger_Handler_Exception_Message ='Trigger handler called outside of Trigger execution.';
    public static final String REACHED_MESSAGE ='reached in';
    //Trigger handler class constants - ends

    //Object label/API Name constants
    public static final String TRANSACTION_OBJ_API_NAME ='Transaction__c';
    public static final String TRANSACTIONITEM_OBJ_API_NAME ='TransactionItem__c';
    //Object label/API Name constants - ends

    //SOQL section
    public static final String STR_SELECT ='Select';
    public static final String STR_FROM ='From';
    public static final String STR_WHERE ='Where';
    //SOQL section - ends

    //Integration constants
    public static final String TOKEN_BEARER = 'Bearer';
    public static final String STATUS_OK = 'OK';
    public static final String sFailure = 'Failue';
    public static final String sINVALID_TOKEN = 'Invalid Access Token Or Invalid txnResponse data sent';
    public static final String POST_METHOD = 'Post';
    public static final String AUTHORIZATION = 'Authorization';
    public static final String CONTENT_TYPE = 'Content-Type';
    public static final String GRANT_TYPE ='Grant-type';
    public static final String CLIENT_ID ='client-Id';
    public static final String CLIENT_SECRET ='client-secret';
    public static final String URL_ENCODED = 'application/x-www-form-urlencoded';
    public static final String APPLICATION_JSON = 'application/json';
    public static final String TRANSACTIONITEM_TOKEN_MDT = 'TransactionItem_Token';
    public static final String TRANSACTION_TOKEN_MDT = 'Transaction_Token';
    public static final String TRANSACTIONITEM_SEND_DATA= 'TransactionItem_Send_Data';
    public static final String TRANSACTION_SEND_DATA = 'Transaction_Send_Data';

    //Test constants
    public static final String TRANSACTIONITEM_TEST_SEND_DATA = 'TransactionItem_Send_DummyData';
    public static final String TRANSACTION_TEST_SEND_DATA = 'Transaction_Send_DummyData';
    public static final String TEST_ACCESS_TOKEN = 'Bearer 1234543Tx123123';
    //Integration constants - ends

    //test constants
    public static final String TRIGGER_ERROR_MSG ='Trigger handler called outside of Trigger execution';
    public static final String sTriggerBeforeInsertMethod= 'beforeInsert';
    public static final String sTriggerBeforeUpdateMethod= 'beforeUpdate';
    public static final String sTriggerBeforeDeleteMethod= 'beforeDelete';
    public static final String sTriggerAfterInsertMethod= 'afterInsert';
    public static final String sTriggerAfterUpdateMethod= 'afterUpdate';
    public static final String sTriggerAfterDeleteMethod= 'afterDelete';
    public static final String sTriggerAfterUndeleteMethod = 'afterUndelete';
}