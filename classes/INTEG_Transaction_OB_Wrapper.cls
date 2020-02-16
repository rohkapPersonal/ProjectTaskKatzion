/** 
* 
* @className        INTEG_Transaction_OB_Wrapper
* @description      Wrapper class to create JSON for Transaction
* @author           Rohit  
* @date created     15-FEB-2020
* @last change
**/
public class INTEG_Transaction_OB_Wrapper {
    public keysSection keys;
    public valuesSection values;
    
 /*
 *  @name keysSection
 *  @Description  class to store JSON keys section
 *  @author Rohit 
 */
    public class keysSection{
        public string id{get; set;}
    }

/*
 *  @name valuesSection
 *  @Description  class to store JSON values section
 *  @author Rohit 
*/
    public class valuesSection{
        public string TotalCost{get; set;}
        public string TotalDiscount{get; set;}
        public date TransactionDate{get; set;}
        public string TotalCount{get; set;}
        
    } 
}