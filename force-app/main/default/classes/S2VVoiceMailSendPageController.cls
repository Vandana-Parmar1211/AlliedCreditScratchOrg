/*
* CREATED BY: DHAIRYA SHAH
* DATE: 20/09/2018
* DESC: CLASS WHERE VOICEMAIL REQUEST IS SENT AND RESPONSE IS RECIEVED
* updated on 7th aug 2019
*/ 


//***********THIS CLASS IS NOT IN USED*****************************//
Global with sharing class S2VVoiceMailSendPageController 
{    
    
    //CONSTRUCTOR STARTS
    public S2VVoiceMailSendPageController()
    {
    }
    
    //METHOD WHICH IS CALLING FROM TRIGGER ALLOW TO MAKE VOICE MAIL TO INSERTED CONTACT OR LEAD FOR SPECIFIC QUERY CRITERIA
    @Deprecated
    Global static Boolean CallFutureMethod(List<id> lstSobjRcrds, String ObjectName)
    {
        return null;
    }
    
    
    //WE ARE NOT USING THIS METHOD AS IT IS NOT POSSIBLE TO REMOVE THIS METHOD FROM MANAGED PACKAGE 
    //WE ARE USING makeGeneralCallOut1 METHOD INSTEAD OF THIS.
    @future (Callout = True)
    Global static void makeGeneralCallOut( List<id> lstSobjRcrds, String ObjectName){
    }
 
    
    //THIS METHOD IS CALLED FROM BATCH CLASS S2VFUTUREVOICEMAILBATCH
    Global static Boolean CallFutureMethodBatch(List<id> lstSobjRcrds, String ObjectName)
    {
        Boolean retVal = false;
        return retVal;
    }

    
    //PASS ALL SELECTED VALUES IN TO S2VM SYSTEM TO MAKE VOICE MAIL OR SCHEDULE IN FUTURE 
    //THIS METHOD IS USED FOR SENDING SINGLE VOICEMAIL FROM CONTACT OR LEAD S2VSendVoiceSMSContact
    Global static Boolean sendmailmethod(Date startDate,String ObjectName,String selectedVoice,String phoneListFinal,
                                         String callerId,Integer optionSchedule,String ScheduleFreq,String selectedTime1,String useridreference, Boolean isRecordingname)
    {
        Boolean isSusccess = False;
        return isSusccess;
    }
    
    //PASS ALL SELECTED VALUES IN TO S2VM SYSTEM TO MAKE VOICE MAIL OR SCHEDULE IN FUTURE 
    //THIS METHOD IS USED FOR SENDING VOICEMAIL From Campaign
    //This method is created from above method by Uttpal for tracking voicemail
    Global static List<String> sendmailmethodtest(Date startDate,String ObjectName,String selectedVoice,List<String> phoneListFinal,String callerId,
                                                  Integer optionSchedule,String ScheduleFreq,String selectedTime1,String useridreference, Boolean isRecordingname)
    {
        List<String> isSusccess = new List<String>();        
        return isSusccess;
    }
    
    //PASS ALL SELECTED VALUES IN TO S2VM SYSTEM TO MAKE VOICE MAIL OR SCHEDULE IN FUTURE 
    //USE THIS METHOD
    Global static Boolean sendmailmethod1(String ObjectName, String selectedVoice, String phoneListFinal,
                                          String countryCode, String callerId, Integer optionSchedule, String ScheduleFreq,
                                          String selectedTime, String useridreference, List<id> lstSobjRcrds, Boolean isRecordingname)
    {
         Boolean isSusccess = False;
        return isSusccess;
    }
    
    
    //SMS REQUEST METHOD
    
    Global static Boolean sendSMSMethod (String objectName, String selectedTemplate,String TemplateName,String phoneListFinalSMS,String FromNumber, Id activeVoice, List<Id> listOfContactId)
    {
         Boolean isSusccess = False;
        return isSusccess;
    }
    
    //SMS REQUEST METHOD
    Global static Boolean sendBulkSMSMethod (String objectName, String selectedTemplate,String TemplateName,List<String> phoneListFinalSMS,String FromNumber, List<Id> listOfleadId)
    {
        Boolean isSusccess = False;
        return isSusccess;
    }
    
    //SENDING MESSAGE SINGLE FROM CONTACT OR LEAD
    Global static Boolean sendSMSMethodSingle (String objectName, String fromNumber, String toNumber, String message, id recordid)
    {
       Boolean isSusccess = False;
        return isSusccess;
    }
    
    //***USING THIS METHOD INSTEAD OF SENDSMSMETHIDSINGLE
    Global static Boolean sendSMSMethodSingle1 (String objectName, String fromNumber, String toNumber, String message, id recordid, String countryCode)
    {
        Boolean isSusccess = False;
        return isSusccess;
    }
    
    //SEND SMS 2 WAY TWO WAY SMS WILL NOT REQUIRE ANY CALLER ID IN THE LAST AS WE ARE HAVING FOR THE SINGLE SMS FUNCTIONALITY
    Global static Boolean sendSMSMethodSingle2Way (String objectName, String fromNumber, String toNumber, String message, id recordid)
    {
       Boolean isSusccess = False;
        return isSusccess;
    }
    
    //GETING ALL MOBILE NUMBERS OF INSERTED CONTACT AND SEND TO THE S2V SYSTEM TO MAKE VOICE MAIL
    Global static String Phonelist(List<Id> lstCntIds,String ObjectName)
    {
        String phoneListFinal;
        return phoneListFinal;
    }
    
    Global static String PhonelistSMS(List<Id> lstCntIds,String ObjectName )
    {
        String phoneListFinalSMS ;
       return phoneListFinalSMS;
    }
    
    //GETING ALL COUNTRY CODES OF INSERTED CONTACT AND SEND TO THE S2V SYSTEM TO MAKE VOICE MAIL
    Global static String CountryCodeList(List<Id> lstCntIds,String ObjectName)
    {
        string CountryCode;
        return CountryCode;
    }
}