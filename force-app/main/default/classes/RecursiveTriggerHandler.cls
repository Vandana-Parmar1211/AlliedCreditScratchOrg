//THIS CLASS IS DESIGNED TO PREVENT RECURSIVE EXECUTION OF TRIGGERS
Global with sharing class RecursiveTriggerHandler{
    
    global Static boolean isFirstTime = true;
    
    global static void stopTrigger(){
        isFirstTime = false;        
    }
    
    global static boolean canIRun(){
        return isFirstTime;        
    }
}