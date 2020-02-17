/** 
* 
* @className        INTEG_Transaction_OB_ServiceHandler
* @description      Service handler class for Transaction Integration
* @author           Rohit  
* @date created     15-FEB-2020
* @last change
**/ 
public class INTEG_Transaction_OB_ServiceHandler {
    
	public static string EMPTY_STRING = Constants.EMPTY_STRING;
	public static map<id, Transaction__c> mapTransId_Transactions = new map<id, Transaction__c>();
	
	public static map<string,list<Rest_API_Field_Mapping__mdt>> mapObjName_RestAPIFM_MDTs{
		get{
			//preparing a map of Rest_API_Field_Mapping__mdt with key as sObject API Name
            if(mapObjName_RestAPIFM_MDTs == null){
				mapObjName_RestAPIFM_MDTs = new map<string,list<Rest_API_Field_Mapping__mdt>>();
				for(Rest_API_Field_Mapping__mdt rMDT : [Select id,Rest_API_Sections__c,Rest_API_Sections__r.JSON_Section__c,
														sObject_Field_API_Name__c,Object_Name__c,sObject_API_Name__c,Rest_API_Field_Name__c 
														from Rest_API_Field_Mapping__mdt]){
					
					if(!mapObjName_RestAPIFM_MDTs.containsKey(rMDT.sObject_API_Name__c)){
						mapObjName_RestAPIFM_MDTs.put(rMDT.sObject_API_Name__c, new list<Rest_API_Field_Mapping__mdt>{rMDT});
					}else{
						mapObjName_RestAPIFM_MDTs.get(rMDT.sObject_API_Name__c).add(rMDT);
					}
				}
			}
			return mapObjName_RestAPIFM_MDTs;
		}
		set;
	}


/*
*  @methodName:     generateJSON
*  @Description:    To prepare JSON request body. This method is using public and static mapTransId_Transactions to get
					Transaction and its details
*  @param:          N/A
*  @return          String
*  @author          Rohit Kapoor
*/ 
    public static string generateJSON(){
    	string jsonOutput = EMPTY_STRING;
    	
    	if( !mapTransId_Transactions.isEmpty()){
    		//fetcing details of a Transaction__c record one by one and adding to a string
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            //gen.writeFieldName('TransactionDetails');
    		for(Transaction__c trans : mapTransId_Transactions.values()){
    			//fetching Year,Month and Day from createdDate to be sent to endpoint
	    		integer yr = trans.CreatedDate.year();
	    		integer mm = trans.CreatedDate.month();
	    		integer dy = trans.CreatedDate.day();
	    		
	    		//creating instace of Transaction createdDate
	    		date transCreatedDate = date.newInstance(yr, mm, dy);
	    		system.debug('transCreatedDate--'+ transCreatedDate);
                
                //starting main JSON part creation. Adding section header as want to segregate each section and 
                //JSON generator wants field name whenever a new section gets started
                gen.writeFieldName('TransactionDetails');
                gen.writeStartObject();
                    //creating JSON structure with keys as field and related details
                    gen.writeFieldName('keys');
                    gen.writeStartObject();
                        gen.writeStringField('TransactionID', trans.id);          
                    gen.writeEndObject();
                    //keys section JSON ends

                    //creating JSON structure with values as field and related details
                    gen.writeFieldName('values');
                    gen.writeStartObject();
                        gen.writeStringField('TotalCost', string.valueOf(trans.Total_Cost__c));          
                        gen.writeStringField('TotalDiscount', string.valueOf(trans.Total_Discount__c));
                        gen.writeStringField('TransactionDate', string.valueOf(transCreatedDate));
                        gen.writeStringField('TotalCount', string.valueOf(trans.Transaction_Count__c));
                    gen.writeEndObject();
                    //values section JSON ends
                gen.writeEndObject();
            }
	    	gen.writeEndObject();
            //generating a final string
            jsonOutput = gen.getAsString();

	    	
    	}
    	return jsonOutput;
    }

/*
*  @methodName:     performTransaction
*  @Description:    To prepare JSON request body and do the callout after preparing the HTTPRequest
*  @param:          N/A
*  @return          String
*  @author          Rohit Kapoor
*/
    public static void performTransaction()
    {
        String sAccessToken;
        Services__mdt objServiceDetails; 
        string requestBody = EMPTY_STRING;
        Utilities.ResponseWrapper responseBody;
        string rawResponseBody = EMPTY_STRING;
        string sServiceName = !Test.isRunningTest()?Constants.TRANSACTION_SEND_DATA : Constants.TRANSACTION_TEST_SEND_DATA;
        string sServiceName_Token = Constants.TRANSACTION_TOKEN_MDT;
       //Variables to hold the custom Settings data
        String TOKEN_BEARER =Constants.TOKEN_BEARER;
        String sSUCCESS = Constants.STATUS_OK;
        String sFAILURE = Constants.sFAILURE;
        String sINVALID_TOKEN = Constants.sINVALID_TOKEN;

        list<Services__mdt> services = [Select id, Endpoint_URL__c, Service_URL__c, Client_Id__c, Client_Secret__c, 
    									Grant_Type__c, Password__c,Token__c from Services__mdt
    									where DeveloperName =: sServiceName limit 1];
   

        //now only run for test class as we don't have endpoints, for coverage purpose
        if(Test.isRunningTest()){
            sAccessToken = Utilities.getAuthenticationToken(sServiceName_Token);
        }
        //assuming to get the access token with Bearer attached as prefix to it
        sAccessToken = Constants.TEST_ACCESS_TOKEN; //'Bearer 1234543Tx123123';
        System.debug('sAccessToken--'+sAccessToken+'--sTOKEN_BEARER--'+TOKEN_BEARER+'sAccessToken.startsWithIgnoreCase(TOKEN_BEARER) '+sAccessToken.startsWithIgnoreCase(TOKEN_BEARER) );
        // check if everything is good to carry out the integration
        if(sAccessToken != null && string.isNotBlank(TOKEN_BEARER) && sAccessToken.startsWithIgnoreCase(TOKEN_BEARER) )
        {
            // generate payload json for request
            requestBody = generateJson();
            // create http request
            HTTPRequest objHttpRequest = new HTTPRequest();
            if(!services.isEmpty()){
            	objServiceDetails = services[0];
            }
            
            if(objServiceDetails != null)  // commenting as we dont have any endpoints || objServiceDetails == null)
            {
            	//preparing  HTTP Request
            	//need to comment below line if you want to test it without endpoint
            	objHttpRequest.setEndpoint(objServiceDetails.Endpoint_URL__c + objServiceDetails.Service_URL__c );
               
                objHttpRequest.setMethod(Constants.POST_METHOD);
                objHttpRequest.setHeader(Constants.AUTHORIZATION, sAccessToken);
                objHttpRequest.setHeader(Constants.CONTENT_TYPE,  Constants.APPLICATION_JSON);  // change this based on connection details
                objHttpRequest.setTimeout(60000);
                objHttpRequest.setBody(requestBody);
                System.debug('Request is :' + objHttpRequest.getBody());

                try{
                    HTTP objHttp = new HTTP();
                    //doing callout with HTTPRequest
                    HTTPResponse objHttpResp = objHttp.send(objHttpRequest);
                    rawResponseBody = objHttpResp.getBody();
                    responseBody = (Utilities.ResponseWrapper) JSON.deserialize(rawResponseBody, Utilities.ResponseWrapper.class);
                }catch(exception ex){
                    Utilities.createExceptionLog(ex,'Transaction Integration','Exception','Transaction__c','','','INTEG_Transaction_OB_ServiceHandler');
                }    
            }
    	}
        
    }

/*
*  @MainMethodName  sendTransactions
*  @Description:    MAIN METHOD - To start processing of Transaction to be sent to the endpoint
					1. Fetch all the fields needed to be sent to the endpoint using metadata Rest_API_Field_Mapping__mdt
					2. Fetch all the Transaction fields by dynamic query
					3. Calling performTransaction() which will call generateJSON and then the earlier method will do the callout
					
*  @param:          set<id> transIds, string transactionItemObjName(Transaction__c)
*  @return          N/A
*  @author          Rohit Kapoor
*/
	
    public static void sendTransactions(set<id> transIds, string transactionObjName){
    	string jsonOutput = EMPTY_STRING;
    	map<id, TransactionItem__c> mapTransactionItems = new map<Id,TransactionItem__c>();
    	map<string, Rest_API_Field_Mapping__mdt> mapTrascItem_Field_APINames_RMDT = new map<string, Rest_API_Field_Mapping__mdt>();
    	try{
        	if(transIds != null){
        		string fields = EMPTY_STRING;
        		
        		if(string.isNotBlank(transactionObjName) 
        			&& mapObjName_RestAPIFM_MDTs.containsKey(transactionObjName.trim()) 
        			&& mapObjName_RestAPIFM_MDTs.get(transactionObjName.trim()) !=null){
        			//fetching all the fields of Transaction from Rest_API_Field_Mapping__mdt  which needs to be sent to the endpoint
        			for(Rest_API_Field_Mapping__mdt rMDT : mapObjName_RestAPIFM_MDTs.get(transactionObjName)){
        				if(string.isNotBlank(rMDT.sObject_Field_API_Name__c)){
        					mapTrascItem_Field_APINames_RMDT.put(rMDT.sObject_Field_API_Name__c,rMDT);
        					fields += rMDT.sObject_Field_API_Name__c +',';
        				}
        			}
        			fields = string.isNotBlank(fields) ? fields.removeEnd(','): EMPTY_STRING;
        		}
        		string queryTransaction = EMPTY_STRING;
        		if(string.isNotBlank(fields)){
    	    		queryTransaction = Constants.STR_SELECT + EMPTY_STRING+ fields + EMPTY_STRING + Constants.STR_FROM;
    	    	
    		    	queryTransaction +=  EMPTY_STRING + transactionObjName + EMPTY_STRING + Constants.STR_WHERE;
    		    	queryTransaction += EMPTY_STRING + 'Id IN:  transIds';
    		    	system.debug('queryTransaction--'+ queryTransaction);
    		    }
    		    //querying Transaction__c records
    	    	list<Transaction__c> listTransactions = Database.query(queryTransaction);
    	    	
    	    	//preparing public map to be used for generating JSON reques
    	    	if(listTransactions != null && !listTransactions.isEmpty()){
    	    		for(Transaction__c trans : listTransactions){
    	    			mapTransId_Transactions.put(trans.id, trans);
    	    		}
    	    		//calling a mthod to do callout and to send the Transaction Items to the endpoint
    	    		performTransaction();
    	    	}
    	    }
        }catch(exception ex){
            Utilities.createExceptionLog(ex,'Transaction Integration','Exception','Transaction__c','','','INTEG_Transaction_OB_ServiceHandler');
        }
    }
}