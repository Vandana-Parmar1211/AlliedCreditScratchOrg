@isTest
public with sharing class CustomSettingControllerTest {
    
    @testSetup
    static void setup() {
       
        S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();    }
    
    @isTest
    static void testConstructorWithExistingSettings() {
        Test.startTest();
        CustomSettingController controller = new CustomSettingController();
        Test.stopTest();
        
        System.assertNotEquals('testApiKey', controller.APIValue);
        System.assertNotEquals('testOrgId', controller.OrgIdValue);
    }
    
    @isTest
    static void testConstructorWithoutExistingSettings() {

        Test.startTest();
        delete [SELECT Id FROM S2V__Airwaves360_settings__c];
        CustomSettingController controller = new CustomSettingController();
        Test.stopTest();
        
        System.assertEquals('', controller.APIValue);
        System.assertEquals('', controller.OrgIdValue);
    }
    
    @isTest
    static void testProcessInputWithBlankValues() {

        Test.startTest();
        CustomSettingController controller = new CustomSettingController();
        controller.APIValue = '';
        controller.OrgIdValue = '';
        controller.processInput();
        Test.stopTest();
        
        System.assertEquals(1, ApexPages.getMessages().size());
        System.assertEquals(ApexPages.Severity.ERROR, ApexPages.getMessages()[0].getSeverity());
    }
    
    @isTest
    static void testProcessInputWithExistingSettings() {

        Test.startTest();
        CustomSettingController controller = new CustomSettingController();
        controller.APIValue = 'newApiKey';
        controller.OrgIdValue = 'newOrgId';
        controller.processInput();
        Test.stopTest();
        
        S2V__Airwaves360_settings__c updatedSetting = [SELECT S2V__XapiKey__c, S2V__OrganizationId__c FROM S2V__Airwaves360_settings__c LIMIT 1];
        System.assertNotEquals('newApiKey', updatedSetting.S2V__XapiKey__c);
        System.assertNotEquals('newOrgId', updatedSetting.S2V__OrganizationId__c);
    }
    
  
    @isTest
    static void testClearInputWithExistingSettings() {

        Test.startTest();
        CustomSettingController controller = new CustomSettingController();
        controller.clearInput();
        Test.stopTest();
        
        Integer settingsCount = [SELECT COUNT() FROM S2V__Airwaves360_settings__c];
        System.assertEquals(0, settingsCount);
        System.assertEquals('', controller.APIValue);
        System.assertEquals('', controller.OrgIdValue);
    }
    
    @isTest
    static void testClearInputWithoutExistingSettings() {

        Test.startTest();
        delete [SELECT Id FROM S2V__Airwaves360_settings__c];
        
        CustomSettingController controller = new CustomSettingController();
        controller.clearInput();
        Test.stopTest();
        
        Integer settingsCount = [SELECT COUNT() FROM S2V__Airwaves360_settings__c];
        System.assertEquals(0, settingsCount);
        System.assertEquals('', controller.APIValue);
        System.assertEquals('', controller.OrgIdValue);
    }
}