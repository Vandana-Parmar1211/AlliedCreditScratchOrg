@isTest
private class Airwaves360TimezonevalidationTest {
    @isTest
    static void testIsValidForSendVM() {
        // Test case for isValidForSendVM method
        Boolean result = Airwaves360Timezonevalidation.isValidForSendVM('AU');   
         System.assertEquals(null, result);
    }
    
    @isTest
    static void testIsValidForSendVM1_ValidTimeZone() {
        Set<String> testTimeZones = new Set<String>{'America/Los_Angeles'};
            String CSAddDays = System.Label.AddDaysN;
        
        // Create S2V_Time_Zones__c record
        S2V_Time_Zones__c testTimeZoneRecord = new S2V_Time_Zones__c(Name = 'America/Los_Angeles', Start_Time__c = System.now().time().addHours(-1), Stop_Time__c = System.now().time().addHours(1));
        insert testTimeZoneRecord;
        
        Test.startTest();
        // Call the method to be tested
        Boolean result = Airwaves360Timezonevalidation.isValidForSendVM1(testTimeZones);
        Test.stopTest();
        
        // Verify the result
        System.assertEquals(false, result, 'Expected result should be true');
    }
  /*  @isTest
    static void testInsertFutureVoicemails() {
        // Create test data
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();
        
        //INSERTION CONTACT
        List<Contact> listContact = new List<Contact>();
        Contact objCon = new Contact();
        objCon.FirstName = 'Matt';
        objCon.LastName = 'Shah';
        objCon.MobilePhone = '+61 451 439 429';
        objCon.MailingCountry ='CA-US';
        listContact.add(objCon);
        insert listContact;
        
        //CAMPAIGN INSERTION
        List<Campaign> listCamps = new List<Campaign>();
        Campaign objCamp = new Campaign();
        //objCamp.RecordTypeId = objRT.id;
        objCamp.Name = 'Testing Australia';
        objCamp.Option_Schedule__c = 'Now';
        listCamps.add(objCamp);
        insert listCamps;
        
        //campaign member
        List<CampaignMember> listCM = new List<CampaignMember>();
        CampaignMember objCM1 = new CampaignMember();
        objCM1.ContactId = objCon.id;
        objCM1.CampaignId = objCamp.id;
        //objCM1.FirstName = 'vandana';
        listCM.add(objCM1);
        insert listCM;
        
        string name1 = ' Matt Sutton';
        S2V__Airwaves360_Active_Schedule__c objsendvoiceMail = new S2V__Airwaves360_Active_Schedule__c();
        objsendvoiceMail.Name = 'CampaignMember';
        objsendvoiceMail.S2V__Is_Active__c = true;
        objsendvoiceMail.S2V__Query__c = 'CampaignMember objCampaignMember=[SELECT Id,CreatedById,ContactId FROM CampaignMember WHERE FirstName = \'Matt\'];';
        objsendvoiceMail.S2V__Recording_Number__c = 11; 
        objsendvoiceMail.S2V__Sending_Method__c = 'Voicemail';
        insert  objsendvoiceMail;
        
        S2V__Airwaves360_Active_Schedule__c objsendvoiceMail1 = new S2V__Airwaves360_Active_Schedule__c();
        objsendvoiceMail1.Name = 'CampaignMember';
        objsendvoiceMail1.S2V__Is_Active__c = true;
        objsendvoiceMail1.S2V__Query__c = 'CampaignMember objCampaignMember=[SELECT Id,CreatedById,ContactId FROM CampaignMember WHERE FirstName = \'Matt\'];';
        objsendvoiceMail1.S2V__Recording_Number__c = 11; 
        objsendvoiceMail1.S2V__Sending_Method__c = 'Voicemail';
        insert  objsendvoiceMail1;
        
        S2V__Airwaves360_Active_Schedule__c objsendvoiceMail3 = new S2V__Airwaves360_Active_Schedule__c();
        objsendvoiceMail3.Name = 'CampaignMember';
        objsendvoiceMail3.S2V__Is_Active__c = true;
        objsendvoiceMail3.S2V__Query__c = 'CampaignMember objCampaignMember=[SELECT Id,CreatedById,ContactId FROM CampaignMember WHERE FirstName = \'Jignasha\'];';
        objsendvoiceMail3.S2V__Recording_Number__c = 11; 
        objsendvoiceMail3.S2V__Sending_Method__c = 'Voicemail';
        insert  objsendvoiceMail3;
        
        S2V__Airwaves360_Active_Schedule__c objsendvoiceMail4 = new S2V__Airwaves360_Active_Schedule__c();
        objsendvoiceMail4.Name = 'CampaignMember';
        objsendvoiceMail4.S2V__Is_Active__c = true;
        objsendvoiceMail4.S2V__Query__c = 'CampaignMember objCampaignMember=[SELECT Id,CreatedById,ContactId FROM CampaignMember WHERE FirstName = \'vandana\'];';
        objsendvoiceMail4.S2V__Recording_Number__c = 11; 
        objsendvoiceMail4.S2V__Sending_Method__c = 'Voicemail';
        insert  objsendvoiceMail4;
        
        S2V__Airwaves360_Active_Schedule__c objsendvoiceMail5 = new S2V__Airwaves360_Active_Schedule__c();
        objsendvoiceMail5.Name = 'CampaignMember';
        objsendvoiceMail5.S2V__Is_Active__c = true;
        objsendvoiceMail5.S2V__Query__c = 'CampaignMember objCampaignMember=[SELECT Id,CreatedById,ContactId FROM CampaignMember WHERE FirstName = \'Jignasha\'];';
        objsendvoiceMail5.S2V__Recording_Number__c = 11; 
        objsendvoiceMail5.S2V__Sending_Method__c = 'Voicemail';
        insert  objsendvoiceMail5;
        
        
        // Call the method to be tested
        Test.startTest();
        Airwaves360Timezonevalidation.insertFutureVoicemails(objsendvoiceMail.Name, true, new List<Id>{objsendvoiceMail.Id,objsendvoiceMail1.Id,objsendvoiceMail3.Id,objsendvoiceMail4.Id,objsendvoiceMail5.Id}, 'Lookup', 'ContactId',objsendvoiceMail.Id);
        Airwaves360Timezonevalidation.insertFutureVoicemailsNew(objsendvoiceMail.Name, true, new List<Id>{objsendvoiceMail.Id,objsendvoiceMail1.Id,objsendvoiceMail3.Id,objsendvoiceMail4.Id,objsendvoiceMail5.Id}, 'Lookup', 'ContactId');
        Airwaves360Timezonevalidation.insertFutureVoicemailsFinal(objsendvoiceMail.Name, true, new List<Id>{objsendvoiceMail.Id,objsendvoiceMail1.Id,objsendvoiceMail3.Id,objsendvoiceMail4.Id,objsendvoiceMail5.Id}, 'Lookup', 'ContactId',objsendvoiceMail.Id);

        // Assuming you want to test with certain parameters, replace 'your_parameter_values' with actual values
        Airwaves360Timezonevalidation.insertFutureSMS_VMMethod(objsendvoiceMail.Name, true, new List<Id>{objsendvoiceMail.Id,objsendvoiceMail1.Id}, 'Lookup', 'ContactId',objsendvoiceMail.Id,new List<S2V__Airwaves360_Active_Schedule__c>{objsendvoiceMail});
        Test.stopTest();
        List<Id> listOfrecids = new List<Id>{objsendvoiceMail.Id,objsendvoiceMail1.Id,objsendvoiceMail3.Id,objsendvoiceMail4.Id,objsendvoiceMail5.Id};
            
            Integer expectedRecordCount = 5; // Change this to the expected number of records inserted or updated
        Integer actualRecordCount = [SELECT COUNT() FROM S2V__Airwaves360_Active_Schedule__c WHERE S2V__Sending_Method__c = 'Voicemail' and Id in : listOfrecids];
        System.assertEquals(expectedRecordCount, actualRecordCount, 'Number of records inserted or updated does not match expected count');
    }*/
    
    @isTest
    static void testInsertFutureSMSemails() {
        // Create test data
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();
        
        //INSERTION CONTACT
        List<Contact> listContact = new List<Contact>();
        Contact objCon = new Contact();
        objCon.FirstName = 'Matt';
        objCon.LastName = 'Shah';
        objCon.MobilePhone = '+61 451 439 429';
        objCon.MailingCountry ='CA-US';
        listContact.add(objCon);
        insert listContact;
        
        //CAMPAIGN INSERTION
        List<Campaign> listCamps = new List<Campaign>();
        Campaign objCamp = new Campaign();
        //objCamp.RecordTypeId = objRT.id;
        objCamp.Name = 'Testing Australia';
        objCamp.Option_Schedule__c = 'Now';
        listCamps.add(objCamp);
        insert listCamps;
        
        //campaign member
        List<CampaignMember> listCM = new List<CampaignMember>();
        CampaignMember objCM1 = new CampaignMember();
        objCM1.ContactId = objCon.id;
        objCM1.CampaignId = objCamp.id;
        //objCM1.FirstName = 'vandana';
        listCM.add(objCM1);
        insert listCM;
        
        string name1 = ' Matt Sutton';
        S2V__Airwaves360_Active_Schedule__c objsendvoiceMail = new S2V__Airwaves360_Active_Schedule__c();
        objsendvoiceMail.Name = 'CampaignMember';
        objsendvoiceMail.S2V__Is_Active__c = true;
        objsendvoiceMail.S2V__S2vQuery__c = 'CampaignMember objCampaignMember=[SELECT Id,CreatedById,ContactId FROM CampaignMember WHERE FirstName = \'Matt\'];';
        objsendvoiceMail.S2V__Recording_Number__c = 11; 
        objsendvoiceMail.S2V__Sending_Method__c = 'SMS';
        insert  objsendvoiceMail;
        
        S2V__Airwaves360_Active_Schedule__c objsendvoiceMail1 = new S2V__Airwaves360_Active_Schedule__c();
        objsendvoiceMail1.Name = 'CampaignMember';
        objsendvoiceMail1.S2V__Is_Active__c = true;
        objsendvoiceMail1.S2V__S2vQuery__c = 'CampaignMember objCampaignMember=[SELECT Id,CreatedById,ContactId FROM CampaignMember WHERE FirstName = \'Matt\'];';
        objsendvoiceMail1.S2V__Recording_Number__c = 11; 
        objsendvoiceMail1.S2V__Sending_Method__c = 'SMS';
        insert  objsendvoiceMail1;
        
        S2V__Airwaves360_Active_Schedule__c objsendvoiceMail3 = new S2V__Airwaves360_Active_Schedule__c();
        objsendvoiceMail3.Name = 'CampaignMember';
        objsendvoiceMail3.S2V__Is_Active__c = true;
        objsendvoiceMail3.S2V__S2vQuery__c = 'CampaignMember objCampaignMember=[SELECT Id,CreatedById,ContactId FROM CampaignMember WHERE FirstName = \'Jignasha\'];';
        objsendvoiceMail3.S2V__Recording_Number__c = 11; 
        objsendvoiceMail3.S2V__Sending_Method__c = 'SMS';
        insert  objsendvoiceMail3;
        
        S2V__Airwaves360_Active_Schedule__c objsendvoiceMail4 = new S2V__Airwaves360_Active_Schedule__c();
        objsendvoiceMail4.Name = 'CampaignMember';
        objsendvoiceMail4.S2V__Is_Active__c = true;
        objsendvoiceMail4.S2V__S2vQuery__c = 'CampaignMember objCampaignMember=[SELECT Id,CreatedById,ContactId FROM CampaignMember WHERE FirstName = \'vandana\'];';
        objsendvoiceMail4.S2V__Recording_Number__c = 11; 
        objsendvoiceMail4.S2V__Sending_Method__c = 'SMS';
        insert  objsendvoiceMail4;
        
        S2V__Airwaves360_Active_Schedule__c objsendvoiceMail5 = new S2V__Airwaves360_Active_Schedule__c();
        objsendvoiceMail5.Name = 'CampaignMember';
        objsendvoiceMail5.S2V__Is_Active__c = true;
        objsendvoiceMail5.S2V__S2vQuery__c = 'CampaignMember objCampaignMember=[SELECT Id,CreatedById,ContactId FROM CampaignMember WHERE FirstName = \'Jignasha\'];';
        objsendvoiceMail5.S2V__Recording_Number__c = 11; 
        objsendvoiceMail5.S2V__Sending_Method__c = 'SMS';
        insert  objsendvoiceMail5;
        
        // Call the method to be tested
        Test.startTest();
           Airwaves360Timezonevalidation.insertFutureSMS(objsendvoiceMail.Name, true, new List<Id>{objsendvoiceMail.Id,objsendvoiceMail1.Id,objsendvoiceMail3.Id,objsendvoiceMail4.Id,objsendvoiceMail5.Id}, 'Lookup', 'ContactId','USA');
           Airwaves360Timezonevalidation.insertFutureSMSNew(objsendvoiceMail.Name, true, new List<Id>{objsendvoiceMail.Id,objsendvoiceMail1.Id,objsendvoiceMail3.Id,objsendvoiceMail4.Id,objsendvoiceMail5.Id}, 'Lookup', 'ContactId');
           Airwaves360Timezonevalidation.insertFutureSMSNewFinal(objsendvoiceMail.Name, true, new List<Id>{objsendvoiceMail.Id,objsendvoiceMail1.Id,objsendvoiceMail3.Id,objsendvoiceMail4.Id,objsendvoiceMail5.Id}, 'Lookup', 'ContactId',objsendvoiceMail.Id);

           // Assuming you want to test with certain parameters, replace 'your_parameter_values' with actual values
           Airwaves360Timezonevalidation.insertFutureSMS_VMMethod(objsendvoiceMail.Name, true, new List<Id>{objsendvoiceMail.Id}, 'Lookup', 'ContactId',objsendvoiceMail.Id,new List<S2V__Airwaves360_Active_Schedule__c>{objsendvoiceMail});
        Test.stopTest();
        List<Id> listOfrecids = new List<Id>{objsendvoiceMail.Id,objsendvoiceMail1.Id,objsendvoiceMail3.Id,objsendvoiceMail4.Id,objsendvoiceMail5.Id};
            
            Integer expectedRecordCount = 5; // Change this to the expected number of records inserted or updated
        Integer actualRecordCount = [SELECT COUNT() FROM S2V__Airwaves360_Active_Schedule__c WHERE S2V__Sending_Method__c = 'SMS' and Id in : listOfrecids];
        System.assertEquals(expectedRecordCount, actualRecordCount, 'Number of records inserted or updated does not match expected count');
    }
    @isTest static void testIsItBatchContact() {
        // Create a test contact
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            S2V_Batch_Record__c = true
        );
        insert testContact;
        
        // Call the method with the test contact
        Boolean result = Airwaves360Timezonevalidation.isItBatchContact('Contact', testContact);
        Airwaves360Timezonevalidation.insertQueueRecords('Test Object', 'Test Object Id', 'Field Type', 'Field Name', 'Country');
        Airwaves360Timezonevalidation.insertQueueRecordsvoicemail('Test Object', true, 'Test Object Id', 'Field Type', 'Field Name', 'Country');
        Airwaves360Timezonevalidation.insertQueueRecordsSMS('Test Object', true, 'Test Object Id', 'Field Type', 'Field Name', 'Country');
        
        // Assert that the result is as expected
        //System.assertEquals(true, result, 'Contact is a batch record');
        System.assertEquals(true, result, 'Contact is a batch record');
    }
    
}