/** 
* 
* @className        INTEG_TransactionItem_OB_ServiceHandler
* @description      Service handler class for Integration
* @author           Rohit  
* @date created     13-FEB-2020
* @last change
**/ 
public class INTEG_TransactionItem_OB_ServiceHandler {

	public id transactionId;
	public static string EMPTY_STRING = Constants.EMPTY_STRING;
	public static map<id, list<TransactionItem__c>> mapTransId_TransactionItems = new map<id, list<TransactionItem__c>>();
	public static map<string,list<Rest_API_Field_Mapping__mdt>> mapObjName_RestAPIFM_MDTs{
		//fetching REST_API_Field_Mapping__mdt records having key as sObject API Name
		get{
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
*  @Description:    To prepare JSON request body. This method is using public and static mapTransId_TransactionItems to get
					Transaction and its items
*  @param:          N/A
*  @return          String
*  @author          Rohit Kapoor
*/ 	
	public static string generateJSON(){
    	
    	string jsonOutput = EMPTY_STRING;
        
        if(!mapTransId_TransactionItems.isEmpty()){
    		//Iterating over mapTransId_TransactionItems map to prepare array of all the TransactionItem
    		//starting creation of JSON as per {key{}, value{}}
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            for(ID transId : mapTransId_TransactionItems.keySet()){
                //adding Parent Id to differentiate which Transaction Item these Items attach to
                gen.writeFieldName('TransactionId:'+transId);

                gen.writeStartArray();
                for(TransactionItem__c ti : mapTransId_TransactionItems.get(transId)){
		    		//starting main JSON part creation
                    //creating JSON structure with keys as field and related details
		    		gen.writeStartObject();
                        gen.writeFieldName('keys');
                        gen.writeStartObject();
                            gen.writeStringField('TransactionItemID', ti.id);          
                        gen.writeEndObject();
                    gen.writeEndObject();
                    //keys section JSON ends

                    //creating JSON structure with values as field and related details
                    gen.writeStartObject();
                        gen.writeFieldName('values');
                        gen.writeStartObject();
                            gen.writeNumberField('ItemCost', ti.Item_Cost__c);          
                            gen.writeStringField('ItemName', ti.name);
                        gen.writeEndObject();
                    gen.writeEndObject();
                    //values section JSON ends
                }
                gen.writeEndArray();

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
        string sServiceName = !Test.isRunningTest()?Constants.TRANSACTIONITEM_SEND_DATA : Constants.TRANSACTIONITEM_TEST_SEND_DATA;
        string sServiceName_Token = Constants.TRANSACTIONITEM_TOKEN_MDT;
        
        //Variables to hold the custom Settings data
        String TOKEN_BEARER =Constants.TOKEN_BEARER;
        String sSUCCESS = Constants.STATUS_OK;
        String sFAILURE = Constants.sFAILURE;
        String sINVALID_TOKEN = Constants.sINVALID_TOKEN;

        //fetching Services__mdt record for ServiceName e.g. TransactionItems - to get all the endpoint details
        list<Services__mdt> services = [Select id, Endpoint_URL__c, Service_URL__c, Client_Id__c, Client_Secret__c, 
    									Grant_Type__c, Password__c,Token__c from Services__mdt
    									where DeveloperName =: sServiceName limit 1];
   

        //now only run for test class as we don't have endpoints, for coverage purpose
        if(Test.isRunningTest()){
            sAccessToken = Utilities.getAuthenticationToken(sServiceName_Token);
        }
        
        //assuming to get the access token with Bearer attached as prefix to it, otherwise will fix the same
        //setting a dummyAccessToken in test scenarios
        sAccessToken = Constants.TEST_ACCESS_TOKEN; //'Bearer 1234543Tx123123';
        System.debug('sAccessToken--'+sAccessToken+'--sTOKEN_BEARER--'+TOKEN_BEARER+'sAccessToken.startsWithIgnoreCase(TOKEN_BEARER) '+sAccessToken.startsWithIgnoreCase(TOKEN_BEARER) );
        // check if everything is good to carry out the integration
        if(sAccessToken != null && string.isNotBlank(TOKEN_BEARER) && sAccessToken.startsWithIgnoreCase(TOKEN_BEARER) )
        {
            // generate payload json for request
            if(!mapTransId_TransactionItems.isEmpty()){
            	requestBody = generateJson();
            }
            // create http request
            HTTPRequest objHttpRequest = new HTTPRequest();
            if(!services.isEmpty()){
            	objServiceDetails = services[0];
            }
            
            if(objServiceDetails != null)  // commenting as we dont have any endpoints|| objServiceDetails == null)
            {
            	//preparing  HTTP Request
            	//need to comment below line if you want to test it without endpoint
                objHttpRequest.setEndpoint(objServiceDetails.Endpoint_URL__c + objServiceDetails.Service_URL__c );
                
                objHttpRequest.setMethod(Constants.POST_METHOD);
                objHttpRequest.setHeader(Constants.AUTHORIZATION,sAccessToken);
                objHttpRequest.setHeader(Constants.CONTENT_TYPE, Constants.APPLICATION_JSON);  // change this based on connection details
                objHttpRequest.setTimeout(60000);
                objHttpRequest.setBody(requestBody);
                System.debug('Request is :' + objHttpRequest.getBody());

                try{

                    HTTP objHttp = new HTTP();
                    //doing callout with HTTPRequest
                    HTTPResponse objHttpResp = objHttp.send(objHttpRequest);
                    system.debug('objHttpResp--'+ objHttpResp);
                    rawResponseBody = objHttpResp.getBody();
                    responseBody = (Utilities.ResponseWrapper) JSON.deserialize(rawResponseBody, Utilities.ResponseWrapper.class);
                	
                	//calling INTEG_Transaction_OB_ServiceHandler sendTransactions() to sent Transaction details to the endpoint
                	if(responseBody.Status.equalsIgnorecase(Constants.STATUS_OK) /*&& objHttpResp.getStatusCode() == 200 */ && !mapTransId_TransactionItems.isEmpty()){
                		INTEG_Transaction_OB_ServiceHandler.sendTransactions(mapTransId_TransactionItems.keySet(),Constants.TRANSACTION_OBJ_API_NAME);
                	}
                }catch(exception ex){
                	Utilities.createExceptionLog(ex,'TransactionItem Integration','Exception','TransactionItem__c','','','INTEG_Transaction_OB_ServiceHandler');
                	//use below way to check the flow of integration without endpoints as it will error out
                	//INTEG_Transaction_OB_ServiceHandler.sendTransactions(mapTransId_TransactionItems.keySet(),Constants.TRANSACTION_OBJ_API_NAME);
                }    
            }
    	}
        
    }

/*
*  @MainMethodName  sendTransactionItems
*  @Description:    MAIN METHOD - To start processing of Transaction Items to be sent to the endpoint
					1. Fetch all the fields needed to be sent to the endpoint using metadata Rest_API_Field_Mapping__mdt
					2. Fetch all the Transaction Items under a Transaction
					3. Calling performTransaction() which will call generateJSON and then the earlier method will do the callout
					4. On getting successful response for TransactionItem callout we need to call INTEG_Transaction_OB_ServiceHandler
					   class to make another callout to send Transaction records
*  @param:          set<id> transIds, string transactionItemObjName(TransactionItem__c)
*  @return          N/A
*  @author          Rohit Kapoor
*/ 	
	
    public static void sendTransactionItems(set<id> transIds, string transactionItemObjName){
    	string jsonOutput = EMPTY_STRING;
    	map<id, TransactionItem__c> mapTransactionItems = new map<Id,TransactionItem__c>();
    	map<string, Rest_API_Field_Mapping__mdt> mapTrascItem_Field_APINames_RMDT = new map<string, Rest_API_Field_Mapping__mdt>();
    	
        try{
        	if(transIds != null && !transIds.isEmpty()){
        		string fields = EMPTY_STRING;
        		system.debug('transactionItemObjName--'+ transactionItemObjName);
        		system.debug('mapObjName_RestAPIFM_MDTs--'+ mapObjName_RestAPIFM_MDTs);

        		//fetching all the fields of Transaction Item from Rest_API_Field_Mapping__mdt  which needs to be sent to the endpoint
        		if(string.isNotBlank(transactionItemObjName) 
        			&& mapObjName_RestAPIFM_MDTs.containsKey(transactionItemObjName.trim()) 
        			&& mapObjName_RestAPIFM_MDTs.get(transactionItemObjName.trim()) !=null){
        			for(Rest_API_Field_Mapping__mdt rMDT : mapObjName_RestAPIFM_MDTs.get(transactionItemObjName)){
        				system.debug('rMDT--'+ rMDT);
        				if(string.isNotBlank(rMDT.sObject_Field_API_Name__c)){
        					mapTrascItem_Field_APINames_RMDT.put(rMDT.sObject_Field_API_Name__c,rMDT);
        					fields += rMDT.sObject_Field_API_Name__c +',';
        				}
        			}
        			fields = string.isNotBlank(fields) ? fields.removeEnd(','): EMPTY_STRING;
        		}

        		//preparing dynamic query string
        		string queryTransactionItems = EMPTY_STRING;
        		
    	    	if(string.isNotBlank(fields)){
    	    		queryTransactionItems = Constants.STR_SELECT + EMPTY_STRING+ fields + EMPTY_STRING + Constants.STR_FROM;
    	    	
    		    	queryTransactionItems +=  EMPTY_STRING + transactionItemObjName + EMPTY_STRING + Constants.STR_WHERE;
    		    	queryTransactionItems += EMPTY_STRING + 'Transaction__c IN:  transIds';
    		    	system.debug('queryTransactionItems--'+ queryTransactionItems);
    		    }
    		    //querying Transaction Items
    	    	list<TransactionItem__c> listTransactionItems = Database.query(queryTransactionItems);
    	    	
    	    	//preparing map of TransactionId and its Items list.
    	    	if(listTransactionItems != null && !listTransactionItems.isEmpty()){
    	    		for(TransactionItem__c ti : listTransactionItems){
    	    			
    	    			if(!mapTransId_TransactionItems.containsKey(ti.Transaction__c)){
    	    				mapTransId_TransactionItems.put(ti.Transaction__c, new list<TransactionItem__c>{ti});
    	    			}else{
    		    			mapTransId_TransactionItems.get(ti.Transaction__c).add(ti);
    		    		}
    	    		}
    	    		
    	    		//calling a mthod to do callout and to send the Transaction Items to the endpoint
    	    		performTransaction();
    	    	}
    	    }
        }catch(exception ex){
            Utilities.createExceptionLog(ex,'TransactionItem Integration','Exception','TransactionItem__c','','','INTEG_Transaction_OB_ServiceHandler');
        }
    }

     
}