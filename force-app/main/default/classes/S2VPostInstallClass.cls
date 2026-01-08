/*
* App Name: Straight 2 voice
* Desc: Inserting 10 'Airwaves360 drip recording description' records after installing the package
* updated on 7th June 2024
*/

global with sharing class S2VPostInstallClass implements InstallHandler
{
    global void onInstall(InstallContext context)
    { 
        List<S2V__Airwaves360_Drip_Recording_Description__c> lstofS2VRec = new  List<S2V__Airwaves360_Drip_Recording_Description__c>();
        
        for(Integer i = 1 ; i<=10;i++) {
            
            if(Schema.SObjectType.S2V__Airwaves360_Drip_Recording_Description__c.isCreateable() 
               && Schema.SObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.S2V__Recording_Number__c.isCreateable()
               && Schema.SObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.S2V__Description__c.isCreateable()) {
                   
                   S2V__Airwaves360_Drip_Recording_Description__c s2vrec = new S2V__Airwaves360_Drip_Recording_Description__c();
                   s2vrec.S2V__Recording_Number__c = i;
                   s2vrec.S2V__Description__c = 'Description - '+i;
                   
                   lstofS2VRec.add(s2vrec);
                   
               }
        }
        if(lstofS2VRec.size() > 0 && Schema.SObjectType.S2V__Airwaves360_Drip_Recording_Description__c.isCreateable() 
           && Schema.SObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.S2V__Recording_Number__c.isCreateable()
           && Schema.SObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.S2V__Description__c.isCreateable()){
               //INSERT  'Airwaves360 drip recording description' RECORDS 
               //INSERT lstofS2VRec;
           }
        
        List<S2V__Trigger_Handler__c> existingRecords = [SELECT Id,S2V__CampaignMemberObjTrigger__c,S2V__ContactObjTrigger__c,S2V__LeadObjTrigger__c,
                                                         S2V__OpportunityObjTrigger__c,S2V__SMSTemplateTrigger__c, S2V__TaskObjTrigger__c FROM S2V__Trigger_Handler__c ];
        
        if (existingRecords.isEmpty()) {
            S2V__Trigger_Handler__c setting = new S2V__Trigger_Handler__c();
            setting.Name = 'ApexTriggerHandlerCS';
            setting.S2V__CampaignMemberObjTrigger__c = true;
            setting.S2V__ContactObjTrigger__c = true;
            setting.S2V__LeadObjTrigger__c = true;
            setting.S2V__OpportunityObjTrigger__c = true;
            setting.S2V__TaskObjTrigger__c = true;
            setting.S2V__SMSTemplateTrigger__c = true;
            insert setting;
        }
    }
}