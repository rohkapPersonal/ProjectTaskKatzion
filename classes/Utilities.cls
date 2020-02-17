/** 
* 
* @className        Utilities
* @description      Utility class for common methods
* @author           Rohit  
* @date created     13-FEB-2020
* @last change
**/
public class Utilities {
    
/**
* @methodname getAuthenticationToken 
* @description Retrieves the OAuth Token for the HTTP callouts 
* @param    sServiceName- Name of custom Metadata record which stores the Details of OAuth end point.
* @return   Token type and Access token
*/

    private static Services__mdt objAuthService {get;set;}

    public static String getAuthenticationToken(String sServiceName){
        String status;
        list<Services__mdt> services = [Select id, Endpoint_URL__c, Service_URL__c, Client_Id__c, Client_Secret__c, 
        							Grant_Type__c, Password__c,Token__c from Services__mdt
        							where DeveloperName =: sServiceName limit 1];
        objAuthService = services[0];
        AccessTokenWrapper objWrapper = new AccessTokenWrapper();
        if(objAuthService != null){
            HttpRequest objReq = new HttpRequest();
            String sEndPoint = objAuthService.Endpoint_URL__c + objAuthService.Service_URL__c;
            //Building the http request with detials from custom settng
            objReq.setEndpoint(sEndPoint);
            objReq.setMethod(Constants.POST_METHOD);
            objReq.setBody(Constants.GRANT_TYPE + objAuthService.Grant_Type__c + 
                        Constants.CLIENT_ID + objAuthService.Client_Id__c +
                       Constants.CLIENT_SECRET + objAuthService.Client_Secret__c);
            objReq.setHeader(Constants.CONTENT_TYPE , Constants.URL_ENCODED);
            System.debug('objReq header'+objReq);
            Http objHttp = new HTTP();
            try{
                HttpResponse objRes = objHttp.send(objReq);
                String sResponseBody = objRes.getBody(); 
                
                status = objRes.getStatus();
                 System.debug('objReq header res'+objRes);
                //Assign HTTP status to global constants so that in respective class this status can be checked for success
                if (status.equalsIgnoreCase(Constants.STATUS_OK)) {
                    objWrapper = (AccessTokenWrapper)Json.deserialize( sResponseBody , AccessTokenWrapper.class );
                } 
                else {
                  return status;
                }
            }
            catch(Exception ex){
                 
                return 'Exception';
            }
        }
        //custom setting data not found, then return null
        else{
            
            return null;
        }
        //return the tokentype+ token 
        String sFinalReturnValue;
        if(objWrapper.token_type != null && objWrapper.access_token != null){
          sFinalReturnValue = objWrapper.token_type + ' ' + objWrapper.access_token;
        }
        return sFinalReturnValue;
    }

/*
*Method Name    : createExceptionLog
*Description    : Create Exception Log record
*Return Type    : void
*Parameter      : Exception e, string integrationName, string severity, string obj, string response, 
                  String request, string classTriggerName
*/
    public static void createExceptionLog(Exception e, string integrationName, string severity, string obj, string response, String request, string classTriggerName)
    {
        Error_Log__c errLog = new  Error_Log__c();
        if(e!=null){
            errLog.Exception_Error_Description__c = e.getMessage();
            errLog.Stack_Trace__c = e.getStackTraceString();
        }           
        errLog.Running_User__c = UserInfo.getUserId();       
        errLog.Integration_Name__c = integrationName;
        errLog.Severity__c = severity;
        errLog.Response__c = response;
        errLog.Request_Body__c = request;
        errLog.Object__c = obj;
        errLog.Class_Trigger_Name__c = classTriggerName;
        insert errlog;
    }


/*
*Method Name    : createExceptionLog
*Description    : Create Exception Log record
*Return Type    : void
*Parameter      : string errorMessage,string statusCode, string integrationName, string severity, 
                string obj, string response, String request, string classTriggerName
*/
    public static void createExceptionLog(string errorMessage,string statusCode, string integrationName, string severity, string obj, string response, String request, string classTriggerName)
    {
        Error_Log__c errLog = new  Error_Log__c();
        errLog.Exception_Error_Description__c = string.isNotBlank(errorMessage) ? errorMessage : '';
        errLog.Stack_Trace__c = string.isNotBlank(statusCode)? statusCode: '';
                
        errLog.Running_User__c = UserInfo.getUserId();       
        errLog.Integration_Name__c = integrationName;
        errLog.Severity__c = severity;
        errLog.Response__c = response;
        errLog.Request_Body__c = request;
        errLog.Object__c = obj;
        errLog.Class_Trigger_Name__c = classTriggerName;
        insert errlog;
    }

/*
 *  @name AccessTokenWrapper
 *  @Description  Wrapper to hold Access Token details
 *  @author Rohit 
*/
    public class AccessTokenWrapper { 
        public String access_token; 
        public String token_type;
        public String sandbox_url;
        public String service_url; 
        public String expires_in;
        public String errorCode;
        public String error;
    }

/*
 *  @name ResponseWrapper
 *  @Description  Wrapper to hold HTTP Response details
 *  @author Rohit 
*/
    public class ResponseWrapper
    {
        public string Code;
        public string Message;
        public string Exceptions;
        public string EnrollmentId;
        public string ReturnValue;
        public string Status;
        public string WarningMessage;
        public string ErrorMessage;
    }
}