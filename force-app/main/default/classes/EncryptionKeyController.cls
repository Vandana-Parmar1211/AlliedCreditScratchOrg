/*
CreatedBY VANDANA PARMAR
Date 10TH JUNE 2024
Controller class for Airwaves360 Encryption key VF page 
*/
public with sharing class EncryptionKeyController {
    
    public String encryptionKey { get; set; }
    Public boolean falg { get; set; }
   
    //CONTROLLER
    public EncryptionKeyController(){
        
        List<S2V__Encrypted_Key__c>  ExistingSetting = new List<S2V__Encrypted_Key__c>();
        
        if(Schema.SObjectType.S2V__Encrypted_Key__c.isAccessible()
           && Schema.sObjectType.S2V__Encrypted_Key__c.fields.Id.isAccessible()
           && Schema.sObjectType.S2V__Encrypted_Key__c.fields.S2V__Key_Details__c.isAccessible()){
               
               ExistingSetting = [SELECT Id, S2V__Key_Details__c FROM S2V__Encrypted_Key__c LIMIT 1];
           }
        
        if(ExistingSetting.size()>0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Record already exist please delete to create new.'));
            falg = true;
            encryptionKey = ExistingSetting[0].S2V__Key_Details__c;
        }else{
            encryptionKey = '';
        }
    }
    
     //METHOD THAT INSERTS ENCRYPTION KEY
    public void processInput() {
        
        if (String.isBlank(encryptionKey)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter value.'));
            return;
        }
        
        S2V__Encrypted_Key__c csetting = new S2V__Encrypted_Key__c();
        
        if(Schema.SObjectType.S2V__Encrypted_Key__c.isCreateable()
           && Schema.sObjectType.S2V__Encrypted_Key__c.fields.S2V__Key_Details__c.isCreateable()){
               csetting.S2V__Key_Details__c = encryptionKey;
           }  
        
        if(csetting != null && Schema.SObjectType.S2V__Encrypted_Key__c.isCreateable()
           && Schema.sObjectType.S2V__Encrypted_Key__c.fields.S2V__Key_Details__c.isCreateable()){
               insert csetting; 
           }
    }
    
    //METHOD THAT REMOVES ENCRYPTION KEY
    public void clearInput() {
        
        List<S2V__Encrypted_Key__c> ExistingSetting = new List<S2V__Encrypted_Key__c>();
        
        if (Schema.SObjectType.S2V__Encrypted_Key__c.isAccessible()
            && Schema.sObjectType.S2V__Encrypted_Key__c.fields.Id.isAccessible()
            && Schema.sObjectType.S2V__Encrypted_Key__c.fields.S2V__Key_Details__c.isAccessible()) {
                
                ExistingSetting = [SELECT Id, S2V__Key_Details__c FROM S2V__Encrypted_Key__c LIMIT 1];
            }
        
        if (ExistingSetting.size() > 0) {
            
            S2V__Encrypted_Key__c csetting = ExistingSetting[0];
            if (S2V__Encrypted_Key__c.sObjectType.getDescribe().isDeletable()) {
                delete csetting;
            }
        }
        encryptionKey = '';
    }
}