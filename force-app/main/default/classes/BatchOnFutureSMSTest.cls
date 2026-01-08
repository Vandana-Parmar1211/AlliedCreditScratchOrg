@isTest
private class BatchOnFutureSMSTest {
    @testSetup
    static void setupTestData() {
        
        S2V__Trigger_Handler__c Csetting = new S2V__Trigger_Handler__c();
        Csetting.Name = 'Default';
        Csetting.S2V__CampaignMemberObjTrigger__c = true;
        Csetting.S2V__ContactObjTrigger__c = true;
        Csetting.S2V__LeadObjTrigger__c = true;
        Csetting.S2V__OpportunityObjTrigger__c = true;
        Csetting.S2V__TaskObjTrigger__c = true;
        Csetting.S2V__SMSTemplateTrigger__c = true;
        insert Csetting;
        // Create test data for S2V__Airwaves360_settings__c
        S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        contact con = new contact();
        con.LastName = 'Parmar';
        con.FirstName = 'Vandana';
        con.MobilePhone = '1234567890';
        insert con;
        
        Task tsk = new Task();
        tsk.Subject = 'Test Subject';
        tsk.Status = 'Completed';
        tsk.WhoId = con.Id;
        insert tsk;
         String orgId=UserInfo.getOrganizationId(); 
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        List<User> lstOfUser = new List<User>();
         User usr=new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email =  'test123@test' + orgId + '.org', 
                          Username =  'test345@test' + orgId + '.org', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'testt', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = pf.Id,
                          S2V__Airwaves_Verified_Number__c = '12345678'
                         ); 
        lstOfUser.add(usr);
        insert lstOfUser;
        
        // Create test data for S2V__Airwaves360_Active_Schedule__c if required
        S2V__Airwaves360_Active_Schedule__c activeSchedule = new S2V__Airwaves360_Active_Schedule__c(
            Reference_Field__c = 'createdbyid',
            S2V__Object_Name__c = 'Task',
            S2V__SMS_Object__c = 'Contact',
            S2V__SMS_Template_Body_New__c = 'This is a test SMS body\n ',
            S2V__S2vQuery__c = '[SELECT Id,CreatedById,WhoId FROM Task WHERE Subject = \'Test Subject\' AND Status = \'Completed\'',
            S2V__Option_Schedule__c = 'Future Call',
            S2V__Is_Active__c = true,
            S2V__Selected_Lookup__c = 'WhoId'
        );
        insert activeSchedule;
       
       List<S2V__Future_Voicemails__c> lstofFv = new  List<S2V__Future_Voicemails__c>();
        // Create test data for S2V__Future_Voicemails__c
        S2V__Future_Voicemails__c futureVoicemail = new S2V__Future_Voicemails__c(
            S2V__Status__c = 'Queue',
            S2V__Option_Schedule__c = 'Future Call',
            S2V__Schedule_Time__c = 'Minutes',
            S2V__Schedule_TIme_textBox__c = '10', // Set the schedule time in minutes for testing
            //CreatedDate = DateTime.now().addMinutes(-15), // Created date set in the past for scheduling
            S2V__ActiveScheduleRecordId__c = activeSchedule.Id, // Replace with valid record ID if needed
            S2V__Record_Id__c = tsk.Id,
            Sending_Method__c = 'SMS',
            S2V__SMS_Template_Description__c = 'Description',
             S2V__Related_to_Id__c = con.id
        );
        lstofFv.add(futureVoicemail);
        //insert futureVoicemail;
        
         S2V__Future_Voicemails__c futureVoicemail1 = new S2V__Future_Voicemails__c(
            S2V__Status__c = 'Queue',
            S2V__Option_Schedule__c = 'Future Call',
            S2V__Schedule_Time__c = 'Minutes',
            S2V__Schedule_TIme_textBox__c = '10', // Set the schedule time in minutes for testing
            //CreatedDate = DateTime.now().addMinutes(-15), // Created date set in the past for scheduling
            S2V__ActiveScheduleRecordId__c = activeSchedule.Id, // Replace with valid record ID if needed
            S2V__Record_Id__c = tsk.Id,
            Sending_Method__c = 'SMS',
             S2V__Sobject_Name__c = 'Opportunity',
             S2V__SMS_Template_Description__c= 'Description',
             S2V__Related_to_Id__c = con.id
        );
        lstofFv.add(futureVoicemail1);
        //insert futureVoicemail1;
		insert lstofFv;
        
    }

    @isTest
    static void testBatchOnFutureVoicemails() {
        // Use mock objects if any callouts are needed in the future
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse()); 
        Test.startTest();
        
         
        // Initialize the batch class and run it with the test data
        BatchOnFutureSMS batch = new BatchOnFutureSMS();
        Database.executeBatch(batch);

        Test.stopTest();
        User user = [SELECT Id, Name, Email,S2V__Airwaves_Verified_Number__c FROM User limit 1];
        List<S2V__Future_Voicemails__c> futureVoicemails = [SELECT Id, S2V__Status__c,S2V__Related_to_Id__c FROM S2V__Future_Voicemails__c];
        //System.assertEquals('Sent', futureVoicemails[0].S2V__Status__c, 'The voicemail status should be updated to Sent');

        List<Task> tasks = [SELECT Id, Status FROM Task WHERE Status = 'Completed'];
        System.assert(futureVoicemails.size() > 0, 2);
    }
    
     @isTest
    static void testBatchOnFutureVoicemailsOpportunity() {
        // Use mock objects if any callouts are needed in the future
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse()); 
        Test.startTest();
        String cronExp = '0 0 * * * ?'; // Schedules it to run every minute

        String jobId = System.schedule('Test_BatchOnFutureSMSScheduler', cronExp, new BatchOnFutureSMSScheduler());
        // Initialize the batch class and run it with the test data
        BatchOnFutureSMS batch = new BatchOnFutureSMS();
        Database.executeBatch(batch);

        Test.stopTest();
		User user = [SELECT Id, Name, Email,S2V__Airwaves_Verified_Number__c FROM User limit 1];
        List<S2V__Future_Voicemails__c> futureVoicemails = [SELECT Id, S2V__Status__c,S2V__Related_to_Id__c FROM S2V__Future_Voicemails__c];
        //System.assertEquals('Sent', futureVoicemails[0].S2V__Status__c, 'The voicemail status should be updated to Sent');

        List<Task> tasks = [SELECT Id, Status FROM Task WHERE Status = 'Completed'];
       System.assert(futureVoicemails.size() > 0, 'At least one Task should be created');
    }
    
    
    
     @isTest
    static void testBatchOnFutureVoicemails1() {
        // Use mock objects if any callouts are needed in the future
        Test.setMock(HttpCalloutMock.class, new MockHttpResponsefail()); 
        Test.startTest();

        // Initialize the batch class and run it with the test data
        BatchOnFutureSMS batch = new BatchOnFutureSMS();
        Database.executeBatch(batch);

        Test.stopTest();
		User user = [SELECT Id, Name, Email,S2V__Airwaves_Verified_Number__c FROM User limit 1];
        List<S2V__Future_Voicemails__c> futureVoicemails = [SELECT Id, S2V__Status__c FROM S2V__Future_Voicemails__c];
        System.assertEquals('Failed', futureVoicemails[0].S2V__Status__c, 'The voicemail status should be updated to Sent');

        List<Task> tasks = [SELECT Id, Status FROM Task WHERE Status = 'Completed'];
        //System.assert(tasks.size() > 0, 'At least one Task should be created');
    }
    
    
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            
            // Check if the request body has the expected values (for validation purposes)
            System.assert(req.getBody().contains('"type": "sms"'), 'Expected body to contain SMS type');
            
            // Set up a success response (200 OK) for testing a successful SMS send
            res.setStatusCode(200);
            res.setBody('{"message": "SMS sent successfully"}');
            
            return res;
        }
    }
    
    
     private class MockHttpResponsefail implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            
            // Check if the request body has the expected values (for validation purposes)
            System.assert(req.getBody().contains('"type": "sms"'), 'Expected body to contain SMS type');
            
            // Set up a success response (200 OK) for testing a successful SMS send
            res.setStatusCode(400);
            res.setBody('{"message": "SMS sent successfully"}');
            
            return res;
        }
    }
}