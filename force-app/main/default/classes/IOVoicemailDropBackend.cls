/*
* DESC: S2V PHONE BOOK APEX CLASS
UPDATED ON 6TH AUG 2019
*/

//***********THIS CLASS IS NOT IN USED*****************************//
global with sharing class IOVoicemailDropBackend {
    
    public boolean noConversation {get;set;}
    
    
    //GET ACCOUNT DETAILS HTTP REQUEST
    global static IOVDAccount getAccountDetails(String username, String password) {
                
        IOVDAccount acc = new IOVDAccount();       
        return acc;
    }
    
    //GET CALLER ID METHOD
    global static IOVDCallerID getCallerID() 
    {

        IOVDCallerID callerID;        
        return callerID; 
    }
   
    //Created by Dhrudeep FOR THE NEW RECORDING AUTOMATION
    global static IORecording getVoiceMessagesList1(String usrname,String pasword,String urls)
    {
        IORecording mRec;          
        return mRec; 
    }
    
    
    //CREATE CAMPAIGN METHOD IN S2V SITE
    global static IOVDCampaign createCampaign( String selectedCampId , String selectedVoice , String callerID)
    {
        return null;
    }
    
    //SENDING SMS FROM CAMPAIGN
    global static IOVDCampaign createCampaignSMS( String selectedCampId , String selectedMessage , String callerID)
    {
        IOVDCampaign ioCamp = new IOVDCampaign();        
        return ioCamp;
    }
    
        
}