public  with Sharing class ChatZIPController {

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getContactDetails(Id contactId) {
        System.debug('contactId...'+contactId);
        Contact con = [SELECT MobilePhone, Phone FROM Contact WHERE Id = :contactId WITH SECURITY_ENFORCED LIMIT 1];
         User loggedInUser = [SELECT S2V__Airwaves_Verified_Number__c FROM User WHERE Id = :UserInfo.getUserId() WITH SECURITY_ENFORCED LIMIT 1];

        String toNumber = String.isNotBlank(con.MobilePhone) ? con.MobilePhone : con.Phone;
        System.debug('toNumber-->'+toNumber);
        String fromNumber = loggedInUser.S2V__Airwaves_Verified_Number__c;
        System.debug('fromNumber-->'+fromNumber);

        S2V__Airwaves360_settings__c settings;
        string APIkey;
        string OrgId;
        STRING phoneListFinalSMS;
        if(Schema.SObjectType.S2V__Airwaves360_settings__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.Id.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__OrganizationId__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__XapiKey__c.isAccessible()){
               settings =[select id,S2V__OrganizationId__c,S2V__XapiKey__c  from S2V__Airwaves360_settings__c limit 1]; //yabbar_settings__c.getInstance();  
           } 
        if(settings != null){
            APIkey = KeyDecryptionClass.decryptValue(settings.S2V__XapiKey__c);
            System.debug('APIkey...'+APIkey);
            OrgId = KeyDecryptionClass.decryptValue(settings.S2V__OrganizationId__c);
            System.debug('OrgId...'+OrgId);
            
        }
        return new Map<String, String>{
            'toNumber' => toNumber,
            'fromNumber' => fromNumber, 
            'apiKey' => OrgId
        };
    }
   
}