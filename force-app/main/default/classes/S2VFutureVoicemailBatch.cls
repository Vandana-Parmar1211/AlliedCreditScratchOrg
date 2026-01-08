/*
 * Created By: Dhairya Shah
 * Desc: Inserting the records in future voicemails tab when records are not in valid timezone
 * updated 8th aug 2019
 */

//***********THIS CLASS IS NOT IN USED*****************************//
global with sharing class S2VFutureVoicemailBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    private String query;
    
    //SOQL
    global S2VFutureVoicemailBatch (String soql)
    {
        query = soql;
    }
    
    //QUERY LOCATOR
    global Database.Querylocator start(Database.BatchableContext bc)
    {   
        return Database.getQuerylocator(query);
    } 
    
    //SCOPE
    global void execute(Database.BatchableContext bc, List<sObject> scope)
    {}
    
    //FINISH
    global void finish(Database.BatchableContext bc)
    {
    }
}