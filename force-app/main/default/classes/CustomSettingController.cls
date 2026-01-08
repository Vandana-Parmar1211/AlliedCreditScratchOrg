/*
CreatedBY VANDANA PARMAR
Date 10TH JUNE 2024
Controller class for Airwaves360 Credential Information VF page 
*/
public with sharing class CustomSettingController {
    
    public String APIValue { get; set; }
    public String OrgIdValue { get; set; }
    public String decryptedAPIValue { get; set; }
    public String decryptedOrgIdValue { get; set; }
    Public boolean falg { get; set; }
    private String ENCRYPTION_KEY;
    
    //CONTROLLER
    public CustomSettingController() {
        
        List<S2V__Airwaves360_settings__c>  ExistingSetting = new List<S2V__Airwaves360_settings__c>();
        
        if(Schema.SObjectType.S2V__Airwaves360_settings__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.Id.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__OrganizationId__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__XapiKey__c.isAccessible()) {
               
               ExistingSetting = [SELECT Id,S2V__XapiKey__c,S2V__OrganizationId__c  FROM S2V__Airwaves360_settings__c LIMIT 1];
           }
        
        if(ExistingSetting.size()>0) {
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Record already exist please delete to create new'));
            falg = true;
            decryptedAPIValue = ExistingSetting[0].S2V__XapiKey__c;
            decryptedOrgIdValue = ExistingSetting[0].S2V__OrganizationId__c;
            
        }else{
            
            APIValue = '';
            OrgIdValue = '';
        }
        
        List<S2V__Encrypted_Key__c>  ExistingKeySetting = new List<S2V__Encrypted_Key__c>();
        
        if (Schema.SObjectType.S2V__Encrypted_Key__c.isAccessible()
            && Schema.sObjectType.S2V__Encrypted_Key__c.fields.Id.isAccessible()
            && Schema.sObjectType.S2V__Encrypted_Key__c.fields.S2V__Key_Details__c.isAccessible()) {
                
                ExistingKeySetting = [SELECT Id, S2V__Key_Details__c FROM S2V__Encrypted_Key__c LIMIT 1];
            }
        
        if(ExistingKeySetting.size() > 0){
            
            ENCRYPTION_KEY = ExistingKeySetting[0].S2V__Key_Details__c;
        }
    }
    
    //METHOD THAT CRATES CUSTOM SETTING RECORD
    public void processInput() {
        
        if (String.isBlank(decryptedAPIValue) || String.isBlank(decryptedOrgIdValue)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Both API Key and Organization Id are required.'));
            return;
        }
        
        List<S2V__Airwaves360_settings__c>  ExistingSetting = new List<S2V__Airwaves360_settings__c>();
        
        if(Schema.SObjectType.S2V__Airwaves360_settings__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.Id.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__OrganizationId__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__XapiKey__c.isAccessible()) {
               
               ExistingSetting = [SELECT Id,S2V__XapiKey__c,S2V__OrganizationId__c  FROM S2V__Airwaves360_settings__c LIMIT 1];
           }
        
        if(ExistingSetting.size()>0){
            
            S2V__Airwaves360_settings__c csetting = new S2V__Airwaves360_settings__c();
            
            if(Schema.SObjectType.S2V__Airwaves360_settings__c.isUpdateable()
               && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__OrganizationId__c.isUpdateable()
               && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__XapiKey__c.isUpdateable()) {
                   
                   csetting.Id = ExistingSetting[0].Id;
                   csetting.S2V__XapiKey__c = encryptValue(decryptedAPIValue);
                   csetting.S2V__OrganizationId__c = encryptValue(decryptedOrgIdValue);
               } 
            
            if(Schema.SObjectType.S2V__Airwaves360_settings__c.isUpdateable()
               && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__OrganizationId__c.isUpdateable()
               && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__XapiKey__c.isUpdateable()) {
                   
                   update csetting;
               } 
        }
        else{
            S2V__Airwaves360_settings__c csetting = new S2V__Airwaves360_settings__c();
            
            if(Schema.SObjectType.S2V__Airwaves360_settings__c.isCreateable()
               && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__OrganizationId__c.isCreateable()
               && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__XapiKey__c.isCreateable()) {
                   
                   csetting.S2V__XapiKey__c = encryptValue(decryptedAPIValue);
                   csetting.S2V__OrganizationId__c = encryptValue(decryptedOrgIdValue);
               }  
            
            if(csetting != null && Schema.SObjectType.S2V__Airwaves360_settings__c.isCreateable()
               && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__OrganizationId__c.isCreateable()
               && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__XapiKey__c.isCreateable()) {
                   
                   insert csetting; 
               }
        }
    }
    
    //METHOD THAT DELETES CUSTOM SETTING RECORD
    public void clearInput() {
        
        List<S2V__Airwaves360_settings__c> ExistingSetting = new List<S2V__Airwaves360_settings__c>();
        
        if (Schema.SObjectType.S2V__Airwaves360_settings__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.Id.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__OrganizationId__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__XapiKey__c.isAccessible()) {
                
                ExistingSetting = [SELECT Id, S2V__XapiKey__c, S2V__OrganizationId__c FROM S2V__Airwaves360_settings__c LIMIT 1];
            }
        
        if (ExistingSetting.size() > 0) {
            
            S2V__Airwaves360_settings__c csetting = ExistingSetting[0];
            if (S2V__Airwaves360_settings__c.sObjectType.getDescribe().isDeletable()) {
                delete csetting;
            }
        }
        
        APIValue = '';
        OrgIdValue = '';
    }
    
    //METHOD THAT ENCRYPTS VALUE
    private String encryptValue(String value) {
        
        if (String.isBlank(value)) return null;
        Blob data = Blob.valueOf(value);
        Blob encryptedData = Crypto.encryptWithManagedIV('AES128', Blob.valueOf(ENCRYPTION_KEY), data);
        
        return EncodingUtil.base64Encode(encryptedData);
    }
}