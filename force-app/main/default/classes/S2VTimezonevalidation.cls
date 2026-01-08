/*
* Created by: Dhairya Shah
* Date: 25/09/2018
* Desc: Validating timezones of given countries in timezone tab.
*/

//***********THIS CLASS IS NOT IN USED*****************************//
global with sharing class S2VTimezonevalidation {
    
    
    //CHECKING TIMEZONE OF RECORDS.
    global static Boolean isValidForSendVM(String TimeZoneName)
    {
        Boolean retVal;
        return retVal;
    }
    
    //INSERTING RECORDS IN FUTURE VM TAB *** NOT USED ****
    global static void insertQueueRecords(String objName,String objId, String fieldType, String fieldName, String Country)
    {
    }
    
    // INSERT QUEUE RECORD FOR VM
    global static void insertQueueRecordsvoicemail(String objName, Boolean voicemail, String objId, String fieldType, String fieldName, String Country)
    {        
    }
    
    //INSERT QUEUE RECORD FOR SMS
    global static void insertQueueRecordsSMS(String objName, Boolean SMS, String objId, String fieldType, String fieldName, String Country)
    {        
    }
    
    //VALID VOICEMAL METHOD
    global static Boolean isValidForSendVM1(Set<String> listTimeZone)
    {
        Boolean retVal = false;
        return retVal;
    }
    
    //INSERT QUEUE RECORDS FOR VOICEMAIL
    
    global static void insertFutureVoicemails(String objName, Boolean voicemail, list<id> listofRecIds, String fieldType, String fieldName, String Country)
    {        
    }
    
    
    //INSERT QUEUE RECORDS FOR SMS
    global static void insertFutureSMS(String objName, Boolean SMS, List<Id> listOfRecIds, String fieldType, String fieldName, String Country)
    {
    }
    
    global static boolean isItBatchContact(String selectedObject, Sobject obj)
    {
        Boolean isNotBatchRecord = true;       
        return isNotBatchRecord;
    }
}