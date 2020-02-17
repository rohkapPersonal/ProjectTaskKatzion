/**
* =====================================================================================
* @className       TriggerHandler
* @description     Trigger framework class
* @author          Rohit Kapoor
* @email           
* @test class      TriggerHandler_Test
* @date created    13-FEB-2020
* @last change     
* =====================================================================================
*/
public virtual class TriggerHandler {
    
    // static map of handlername, times run() was invoked
    private static Map<String, LoopCount> loopCountMap;
    private static Set<String> bypassedHandlers;
    public static Set<String> setReUseIDs;
    public static String sReleaseID;
    public static String DMLOperationType;
    public static Map<String, Map<id, sObject>> MapSObjectDML = new Map<String, Map<id, sObject>>();
    public static List<sObject> listSObject ;
    // the current context of the trigger, overridable in tests
    @TestVisible
    private TriggerContext context;
    
    // the current context of the trigger, overridable in tests
    @TestVisible
    private Boolean isTriggerExecuting;
    
    // static initialization
    static {
        loopCountMap = new Map<String, LoopCount>();
        bypassedHandlers = new Set<String>();
        setReUseIDs = new Set<String>();
        listSObject = new List<sObject>();
    }
    
    // constructor
    public TriggerHandler() {
        this.setTriggerContext();
    }
    
/***************************************
* public instance methods
***************************************/
    
    // main method that will be called during execution
    public void run() {
        if (!validateRun()) return;
        addToLoopCount();
        // dispatch to the correct handler method
        if (this.context == TriggerContext.BEFORE_INSERT) {
            this.beforeInsert();
        }
        else
            if (this.context == TriggerContext.BEFORE_UPDATE) {
                this.beforeUpdate();
            }
        else
            if (this.context == TriggerContext.BEFORE_DELETE) {
                this.beforeDelete();
            }
        else
            if (this.context == TriggerContext.AFTER_INSERT) {
                this.afterInsert();
            }
        else
            if (this.context == TriggerContext.AFTER_UPDATE) {
                this.afterUpdate();
            }
        else
            if (this.context == TriggerContext.AFTER_DELETE) {
                this.afterDelete();
            }
        else
            if (this.context == TriggerContext.AFTER_UNDELETE) {
                this.afterUndelete();
            }
        executeDMLs();
    }
    
    public void setMaxLoopCount(Integer max) {
        String handlerName = getHandlerName();
        if (!TriggerHandler.loopCountMap.containsKey(handlerName)) {
            TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
        }
        else {
            TriggerHandler.loopCountMap.get(handlerName).setMax(max);
        }
    }
    
    public void clearMaxLoopCount() {
        this.setMaxLoopCount(-1);
    }
    
/***************************************
* public static methods
***************************************/
    
    public static void bypass(String handlerName) {
        TriggerHandler.bypassedHandlers.add(handlerName);
    }
    
    public static void clearBypass(String handlerName) {
        TriggerHandler.bypassedHandlers.remove(handlerName);
    }
    
    public static Boolean isBypassed(String handlerName) {
        return TriggerHandler.bypassedHandlers.contains(handlerName);
    }
    
    public static void clearAllBypasses() {
        TriggerHandler.bypassedHandlers.clear();
    }
    
 /***************************************
* private instancemethods
***************************************/
    
    @TestVisible
    private void setTriggerContext() {
        this.setTriggerContext(null, false);
    }
    
    @TestVisible
    private void setTriggerContext(String ctx, Boolean testMode) {
        String beforeInsert = Constants.sTriggerBeforeInsert;
        String beforeUpdate = Constants.sTriggerBeforeUpdate;
        String beforeDelete = Constants.sTriggerBeforeDelete;
        String afterInsert = Constants.sTriggerAfterInsert;
        String afterUpdate = Constants.sTriggerAfterUpdate;
        String afterDelete = Constants.sTriggerAfterDelete;
        String afterUndelete = Constants.sTriggerAfterUndelete;
        if (!Trigger.isExecuting && !testMode) {
            this.isTriggerExecuting = false;
            return;
        }
        else {
            this.isTriggerExecuting = true;
        }
        if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) ||
            (ctx != null && ctx == beforeInsert)) {
                this.context = TriggerContext.BEFORE_INSERT;
            }
        else
            if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||
                (ctx != null && ctx == beforeUpdate)) {
                    this.context = TriggerContext.BEFORE_UPDATE;
                }
        else
            if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) ||
                (ctx != null && ctx == beforeDelete)) {
                    this.context = TriggerContext.BEFORE_DELETE;
                }
        else
            if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||
                (ctx != null && ctx == afterInsert)) {
                    this.context = TriggerContext.AFTER_INSERT;
                }
        else
            if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) ||
                (ctx != null && ctx == afterUpdate)) {
                    this.context = TriggerContext.AFTER_UPDATE;
                }
        else
            if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) ||
                (ctx != null && ctx == afterDelete)) {
                    this.context = TriggerContext.AFTER_DELETE;
                }
        else
            if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) ||
                (ctx != null && ctx == afterUndelete)) {
                    this.context = TriggerContext.AFTER_UNDELETE;
                }
    }
    
    // increment the loop count
    @TestVisible
    private void addToLoopCount() {
        String handlerName = getHandlerName();
        if (TriggerHandler.loopCountMap.containsKey(handlerName)) {
            Boolean exceeded = TriggerHandler.loopCountMap.get(handlerName).increment();
            if (exceeded) {
                Integer max = TriggerHandler.loopCountMap.get(handlerName).max;
                throw new TriggerHandlerException(Constants.Trigger_Handler_Exception_Message_Max_Loop + String.valueOf(max) +  Constants.REACHED_MESSAGE + handlerName);
            }
        }
    }
    protected virtual void executeDMLs() {
    }
    // make sure this trigger should continue to run
    @TestVisible
    private Boolean validateRun() {
        if (!this.isTriggerExecuting || this.context == null) {
            throw new TriggerHandlerException(Constants.Trigger_Handler_Exception_Message);
        }
        if (TriggerHandler.bypassedHandlers.contains(getHandlerName())) {
            return false;
        }
        return true;
    }
    
    @TestVisible
    private String getHandlerName() {
    	system.debug('this--'+ this);
        return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
    }
    
/***************************************
* context methods
***************************************/
    
    // context-specific methods for override
    @TestVisible
    protected virtual void beforeInsert() {}
    @TestVisible
    protected virtual void beforeUpdate() {}
    @TestVisible
    protected virtual void beforeDelete() {}
    @TestVisible
    protected virtual void afterInsert() {}
    @TestVisible
    protected virtual void afterUpdate() {}
    @TestVisible
    protected virtual void afterDelete() {}
    @TestVisible
    protected virtual void afterUndelete() {}
    
    /***************************************
* inner classes
***************************************/
    
    // inner class for managing the loop count per handler
    @TestVisible
    private class LoopCount {
        private Integer max;
        private Integer count;
        
        public LoopCount() {
            this.max = 5;
            this.count = 0;
        }
        
        public LoopCount(Integer max) {
            this.max = max;
            this.count = 0;
        }
        
        public Boolean increment() {
            this.count++;
            return this.exceeded();
        }
        
        public Boolean exceeded() {
            if (this.max < 0) return false;
            if (this.count > this.max) {
                return true;
            }
            return false;
        }
        
        public Integer getMax() {
            return this.max;
        }
        
        public Integer getCount() {
            return this.count;
        }
        
        public void setMax(Integer max) {
            this.max = max;
        }
    }
    
    // possible trigger contexts
    @TestVisible
    private enum TriggerContext {
        BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
            AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
            AFTER_UNDELETE
            }
    
    // exception class
    public class TriggerHandlerException extends Exception {}
    
}