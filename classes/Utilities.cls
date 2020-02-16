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

	//class to have Access token details
    public class AccessTokenWrapper { 
        public String access_token; 
        public String token_type;
        public String sandbox_url;
        public String service_url; 
        public String expires_in;
        public String errorCode;
        public String error;
    }

    //Integration response wrapper
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