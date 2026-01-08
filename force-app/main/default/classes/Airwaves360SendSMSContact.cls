/*
* Created By: Vandana Parmar
* Desc: Sending SMS on just a button click from Contact page layout
* Date: 18th august 2024
*/ 

global with sharing class Airwaves360SendSMSContact {
    
    public Contact objContact {get;set;}
    public String objectName {get;set;}
    public String contactid {get;set;}
    public String contactName {get;set;}
    public String contactMobile {get;set;}
    public Boolean StopNotification {get;set;}
    public String smsTemplateId {get;set;}
    public String smstemplateName {get;set;}
    public String smstemplateBody {get;set;}
    public String userMobile {get;set;}
    public Boolean retVal {get;set;}
    //public Boolean isLoggedin {get;set;}
    
    //CONTROLLER
    public Airwaves360SendSMSContact(ApexPages.StandardController controller)
    {
        retVal = false;
        this.objContact = (Contact)controller.getRecord();
        Contact objCons = [SELECT id, Name, MobilePhone ,S2V__S2V_Stop_Notifications_SMS__c FROM Contact WHERE id=:objContact.id WITH SECURITY_ENFORCED LIMIT 1];
        objectName = 'Contact';
        
        if(objCons.id!=NULL) {
            contactid = objCons.id;
        }
        
        if(objCons.Name!=NULL) {
            contactName = objCons.Name;
        }
        
        if(objCons.MobilePhone!=NULL) {
            contactMobile = objCons.MobilePhone;
        }
        
        if(objCons.S2V__S2V_Stop_Notifications_SMS__c == TRUE) {
            StopNotification = TRUE;
        } else {
            system.debug('in else');
            StopNotification = FALSE;
        }
        
        User loggedInUser = [SELECT id,Name,S2V__Airwaves_Verified_Number__c  FROM User WHERE id=:userInfo.getUserId() WITH SECURITY_ENFORCED LIMIT 1];
        if(loggedInUser != null){
            userMobile = loggedInUser.S2V__Airwaves_Verified_Number__c; 
        }
        //Commented by Vandana 19-12-2024
        /* isLoggedin =true;
S2V_Settings__c customsetting = S2V_Settings__c.getOrgDefaults();

if(customsetting.password__c != Null && customsetting.username__c != '')
{
isLoggedin = false;
}*/
        
    }
    
    //METHOD THAT FETCHES SMS TEMPLATES
    public List<SelectOption> getSmsTemplates()
    {
        try{ 
            List<SelectOption> options = new List<SelectOption>();
            List<SMS_Template__c> objListSMStemplates = [SELECT id,Template_Name__c,Template_Body__c FROM SMS_Template__c WHERE Template_Name__c != NULL AND S2V__Object_Name__c = :objectName WITH SECURITY_ENFORCED];
            options.add(new SelectOption('none','Select the SMS Template'));
            
            if((objListSMStemplates != null) && (!objListSMStemplates.isEmpty()))
            { 
                for(SMS_Template__c objEmailTemp : objListSMStemplates)
                {
                    options.add(new SelectOption(objEmailTemp.id,objEmailTemp.Template_Name__c));
                }
            }
            return options;
        }
        catch(QueryException e)
        {
            ApexPages.addMessages(e);
            return null;  
        }
    }
    
    //METHOD THAT SETS TEMPLATE NAME AND BODY 
    public PageReference AllSmsTemplate()
    {
        try
        {
            SMS_Template__c objSMSTemplate = [SELECT id,Template_Name__c,Template_Body__c FROM SMS_Template__c WHERE id=:smstemplateID WITH SECURITY_ENFORCED LIMIT 1];
            smstemplateName = objSMSTemplate.Template_Name__c;
            smstemplateBody = objSMSTemplate.Template_Body__c;
            return null;  
            
        } 
        catch(QueryException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,'Error');
            ApexPages.addMessage(myMsg); 
            return null;
        }
    }
    
    //METHOD THAT SENDS SMS FROM AIRWAVES 
    public pageReference SendSMS()
    {
        try{
            
            if(StopNotification == True) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+''+'This Contact has opted out of SMS!'));
                return null;     
            }
            if(objectName!=NULL && contactid!=NULL 
               && (smstemplateBody!=NULL || smstemplateBody!='') 
               && userMobile!=NULL && contactMobile!=NULL  
               && StopNotification == FALSE) {
                   contactMobile = contactMobile.replaceAll('\\D','');
                   userMobile = userMobile.replaceAll('\\D','');
                   if(Test.isRunningTest()){
                       retVal = true;
                   }else{
                       //retVal = Airwaves360VoiceMailSendPageController.singleSMSSending(objectName, contactid, smstemplateName, smstemplateBody, userMobile, contactMobile );
                   }
               }
            if(retVal == true) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,+''+'Your message has been sent successfully.Thank you!'));
            } 
            
        }
        catch(Exception e)
        {
            system.debug('exception:::'+e.getMessage());
        }
        return null;
    }
    
    //Commented by Vandana 19-12-2024
    @AuraEnabled
    public static String getOrganizationDomain(){
        return URL.getOrgDomainUrl().getHost();
    }
}