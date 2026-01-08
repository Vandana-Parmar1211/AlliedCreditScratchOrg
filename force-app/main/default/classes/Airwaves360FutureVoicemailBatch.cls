/*
* Created By: Vandana Parmar
* Desc: Inserting the records in future voicemails tab when records are not in valid timezone

*/
global with sharing class Airwaves360FutureVoicemailBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
     String query;
    private static Boolean hasRunInThisTransaction = false;
      LIST<Future_Voicemails__c> listToInsertFV = new LIST<Future_Voicemails__c>();
    
    //SOQL
    global Airwaves360FutureVoicemailBatch (String soql)
    {
        query = soql;
    }
    
    global Airwaves360FutureVoicemailBatch (String soql, LIST<Future_Voicemails__c> listToInsertFV2)
    {
        query = soql;
        System.debug('@@@ listToInsertFV2  = '+listToInsertFV2);
        listToInsertFV = listToInsertFV2;
    }
    
   
    
    //QUERY LOCATOR
    global Database.Querylocator start(Database.BatchableContext bc)
    {
        system.debug('start method');
        System.debug('@@@ listToInsertFV  = '+listToInsertFV);
         
        system.debug('query == '+Database.getQuerylocator(query));
        return Database.getQuerylocator(query);
        
    } 
    
    //SCOPE
    global void execute(Database.BatchableContext bc, List<sObject> scope)
    {
         system.debug('execute method');
        map<string,list<id>> map_SObjectTypeRecordId = new map<string,list<id>>();
        Map<String,Id> mapObjNameToId = new Map<String,Id>();
        Set<String> setOfTimeZone = new Set<String>();
        Set<Id> recordsid = new Set<Id>();
       
        }
    //}
    
    //FINISH
    global void finish(Database.BatchableContext bc)
    {
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()];
       
    }
}