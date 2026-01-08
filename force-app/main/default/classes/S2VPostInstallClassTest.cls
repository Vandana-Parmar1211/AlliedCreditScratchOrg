/*
 * App Name: Straight 2 voice
 * Desc: Inserting URL and username for demo purpose only on s2v setting (custom setting)
*/

@isTest
global with sharing  class S2VPostInstallClassTest
{
    /*static testmethod void TestInstallScript()
    {
        S2VPostInstallClass postInstall = new S2VPostInstallClass();
        //Test.testInstall(postInstall, null);
                
        
        List<CountryCode__c> listCC = [SELECT id,Name FROM CountryCode__c];
        
        List<S2V__S2V_Settings__c> listSettings = [SELECT id,username__c,password__c,url__c FROM S2V__S2V_Settings__c];
       
        List<SMS_Template__c> listST = [SELECT id FROM SMS_Template__c];
        system.assertEquals(0, listST.size());
        
        /*List<S2V__S2V_Trigger_Handler__c> listTrgHandler = [SELECT id,Name FROM S2V__S2V_Trigger_Handler__c];
        system.assertEquals(1, listTrgHandler.size());
    }*/
    
    @istest
    static void testOnInstall(){
        test.startTest();
        S2VPostInstallClass customSettingInstaller = new S2VPostInstallClass();
        customSettingInstaller.onInstall(null);
        test.stopTest();
        List<S2V__Airwaves360_Drip_Recording_Description__c> s2vRecords = [
            SELECT S2V__Recording_Number__c FROM S2V__Airwaves360_Drip_Recording_Description__c
        ];

        // Check that no records were created since context was null
        System.assertEquals(0, s2vRecords.size());
        //S2V__Airwaves360_settings__c csetting = [Select S2V__XapiKey__c,S2V__OrganizationId__c from S2V__Airwaves360_settings__c limit 1];
    }
}