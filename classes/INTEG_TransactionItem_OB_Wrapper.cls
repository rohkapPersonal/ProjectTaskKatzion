/** 
* 
* @className        INTEG_TransactionItem_OB_Wrapper
* @description      Wrapper class to create JSON for TransactionItem
* @author           Rohit  
* @date created     15-FEB-2020
* @last change
**/
public class INTEG_TransactionItem_OB_Wrapper{ //implements Comparable {
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
    	public decimal ItemCost{get; set;}
    	public string ItemName{get; set;}
    } 


/*
 *  @methodName compareTo
 *  @Description  method from Comparable interface to do the custom object sorting
 *  @author Rohit 
*/
    /*public Integer compareTo(Object ObjToCompare)
    {
        INTEG_TransactionItem_OB_Wrapper compareTo = (INTEG_TransactionItem_OB_Wrapper)ObjToCompare;
        if(keys == compareTo.keys){
        	return 0;
        }else if(values == compareTo.values){
        	return 1;
        }
        return -1;
    }*/
}