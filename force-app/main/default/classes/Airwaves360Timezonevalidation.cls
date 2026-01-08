/*
* Created by: Vandana Parmar
* Date: 12-03-2024
*/

global with sharing class Airwaves360Timezonevalidation {
    
    public static Boolean hasRunOnce = false;
    
    //Method that creates Future voicemails for sending SMS/VM
    global static void insertFutureSMS_VMMethod(String objName, Boolean IsSMS, List<Id> listofRecIds, String fieldType, String fieldName, String ActiveScheduleId, List<S2V__Airwaves360_Active_Schedule__c> activelist) {
        
        if(listofRecIds != NULL) {
            String objectName = String.escapeSingleQuotes(objName);  //PREVENT SOQL INJECTION
            system.debug('activelist'+activelist);
            LIST<Future_Voicemails__c> listToInsertFV = new List<Future_Voicemails__c>();
            
            for(ID objId : listofRecIds) {
                if(Schema.sObjectType.Future_Voicemails__c.isCreateable()
                   && Schema.sObjectType.Future_Voicemails__c.fields.Record_Id__c.isCreateable()
                   && Schema.sObjectType.Future_Voicemails__c.fields.Sobject_Name__c.isCreateable()
                   && Schema.sObjectType.Future_Voicemails__c.fields.Status__c.isCreateable()
                   && Schema.sObjectType.Future_Voicemails__c.fields.S2V__Sending_method__c.isCreateable()
                   && Schema.sObjectType.Future_Voicemails__c.fields.ContactId__c.isCreateable()
                   && Schema.sObjectType.Future_Voicemails__c.fields.LeadId__c.isCreateable()
                   && Schema.sObjectType.Future_Voicemails__c.fields.S2V__ActiveScheduleRecordId__c.isCreateable()) {
                       Future_Voicemails__c fvObj = new Future_Voicemails__c();
                       fvObj.Record_Id__c = objId;
                       fvObj.Sobject_Name__c = objName;
                       fvObj.Status__c = 'Queue';
                       if(IsSMS == true){
                           fvObj.S2V__Sending_method__c = 'SMS';
                       }else if(IsSMS == false){
                           fvObj.S2V__Sending_method__c = 'Voicemail';
                       }
                       
                       fvObj.S2V__ActiveScheduleRecordId__c = ActiveScheduleId;
                       
                       if(objName == 'Contact')
                       {
                           fvObj.ContactId__c = objId;
                       }
                       else if(objName == 'Lead')
                       {
                           fvObj.LeadId__c = objId;
                       }
                       listToInsertFV.add(fvObj);
                   }
            }
            
            String idString = '\'' + String.join(listofRecIds, '\',\'') + '\'';
            
            
            if(listToInsertFV!=NULL && listToInsertFV.size()>0  && Schema.sObjectType.Future_Voicemails__c.isCreateable()
               && Schema.sObjectType.Future_Voicemails__c.fields.Record_Id__c.isCreateable()
               && Schema.sObjectType.Future_Voicemails__c.fields.Sobject_Name__c.isCreateable()
               && Schema.sObjectType.Future_Voicemails__c.fields.Status__c.isCreateable()
               && Schema.sObjectType.Future_Voicemails__c.fields.S2V__Sending_method__c.isCreateable()
               && Schema.sObjectType.Future_Voicemails__c.fields.ContactId__c.isCreateable()
               && Schema.sObjectType.Future_Voicemails__c.fields.LeadId__c.isCreateable()
               && Schema.sObjectType.Future_Voicemails__c.fields.S2V__ActiveScheduleRecordId__c.isCreateable())
            {
                insert listToInsertFV;
                
                // Construct the SOQL query
                String soql = 'SELECT Id, S2V__Record_Id__c, S2V__Sobject_Name__c, S2V__Status__c, S2V__ActiveScheduleRecordId__c, CreatedDate';
                soql += ' FROM S2V__Future_Voicemails__c';
                soql += ' WHERE S2V__Status__c = ' + '\'' + CommonConstant.status + '\'';
                soql += ' AND S2V__Record_Id__c IN (' + idString + ')';
                soql += ' AND S2V__Record_Id__c != NULL';
                
                if(hasRunOnce == false) {
                    hasRunOnce = true;
                    callbatchMethod(soql);
                }
            }    
        }
    }
    
    //Method that calls batch class
    public static void callbatchMethod(string queryString) {
        Airwaves360FutureVoicemailBatch batch = new Airwaves360FutureVoicemailBatch(queryString);
        Database.executebatch(batch, 1);
    } 
    
    // ( Method Not in used)
    global static Boolean isValidForSendVM(String TimeZoneName)
    {
        Boolean retVal;
        return retVal;
    }
    
    
    // ( Method Not in used)
    global static void insertQueueRecords(String objName,String objId, String fieldType, String fieldName, String Country)
    {
    }
    
    // ( Method Not in used)
    global static void insertQueueRecordsvoicemail(String objName, Boolean voicemail, String objId, String fieldType, String fieldName, String Country)
    {        
    }
    
    // ( Method Not in used)
    global static void insertQueueRecordsSMS(String objName, Boolean SMS, String objId, String fieldType, String fieldName, String Country)
    {        
    }
    
    // ( Method Not in used)
    global static Boolean isValidForSendVM1(Set<String> listTimeZone)
    {
        Boolean retVal = false;
        return retVal;
    }
    
    // ( Method Not in used)
    global static void insertFutureVoicemails(String objName, Boolean voicemail, list<id> listofRecIds, String fieldType, String fieldName, String Country)
    {    
    }
    
    // ( Method Not in used)
    global static void insertFutureVoicemailsNew(String objName, Boolean voicemail, List<id> listofRecIds, String fieldType, String fieldName)
    {   
    }
    
    // ( Method Not in used)
    global static void insertFutureVoicemailsFinal(String objName, Boolean voicemail, List<id> listofRecIds, String fieldType, String fieldName, String ActiveScheduleId)
    {   
    }
    
    // ( Method Not in used)
    global static void insertFutureVoicemailsFinal2(String objName, Boolean voicemail, List<id> listofRecIds, String fieldType, String fieldName, String ActiveScheduleId,List<S2V__Airwaves360_Active_Schedule__c> activelist)
    {   
    }
    
    // ( Method Not in used)
    global static void insertFutureSMS(String objName, Boolean SMS, List<Id> listOfRecIds, String fieldType, String fieldName, String Country)
    {
    }
    
    // ( Method Not in used)
    global static void insertFutureSMSNew(String objName, Boolean SMS, List<Id> listOfRecIds, String fieldType, String fieldName)
    {
    }
    
    // ( Method Not in used)
    global static void insertFutureSMSNewFinal(String objName, Boolean SMS, List<Id> listOfRecIds, String fieldType, String fieldName, String ActiveScheduleId)
    {
    }
    
    // ( Method Not in used)
    global static void insertFutureSMSNewFinal2(String objName, Boolean SMS, List<Id> listofRecIds, String fieldType, String fieldName, String ActiveScheduleId, List<S2V__Airwaves360_Active_Schedule__c> activelist) {
        
    }
    
    // ( Method Not in used)
    global static boolean isItBatchContact(String selectedObject, Sobject obj) {
        Boolean isNotBatchRecord = true;
        return isNotBatchRecord;
    }
    
}