//***********THIS CLASS IS NOT IN USED*****************************// 
global with sharing class S2VSendVoiceMailBatch implements Database.Batchable<SObject>  {
    private String finalQuery;
    global S2VSendVoiceMailBatch(String finalQuery, String voiceMailFile, String fieldName){
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)  {
        if (Test.isRunningTest()) {
            String finalQuery = 'SELECT Id FROM Lead WHERE Company = \'rcs\'';
            return Database.getQueryLocator(finalQuery);
        } else {
            return Database.getQueryLocator(finalQuery);
        }
        
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> scope)  {
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
}