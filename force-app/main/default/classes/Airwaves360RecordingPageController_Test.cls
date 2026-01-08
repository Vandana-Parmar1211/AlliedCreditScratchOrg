@isTest
public class Airwaves360RecordingPageController_Test {
    
    @isTest
    static void testConstructor() {
        // Test Setup
        List<S2V__Airwaves360_Drip_Recording_Description__c> testDescriptions = new List<S2V__Airwaves360_Drip_Recording_Description__c>();
        for(Integer i = 1; i <= 10; i++) {
            S2V__Airwaves360_Drip_Recording_Description__c description = new S2V__Airwaves360_Drip_Recording_Description__c();
            description.S2V__Recording_Number__c = i;
            testDescriptions.add(description);
        }
        insert testDescriptions;

        S2V__Airwaves360_Personal_Recording__c apr = new S2V__Airwaves360_Personal_Recording__c();
        apr.S2V__Description__c = 'description';
        apr.S2V__Recording_Number__c = 3;
        apr.S2V__yabbrFileID__c = '345678';
        //apr.CreatedById = UserInfo.getUserId();
        insert apr;
        
       S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();

        
        // Test Execution
        Test.startTest();
        Airwaves360RecordingPageController controller = new Airwaves360RecordingPageController();
        Test.stopTest();
        
        // Test Assertion
        // Assert that the controller initialized as expected
        System.assertEquals(true, controller.isdisplayvfp);
        System.assertEquals('', controller.indexval);
        System.assertEquals('', controller.notesvalue);
        System.assertNotEquals(null, controller.discriptionmap);
        //System.assertNotEquals(null, controller.notesmap);
        System.assertNotEquals(null, controller.rcrdings);
        System.assertNotEquals(null, controller.avairecordid);
        System.assertNotEquals(null, controller.numbers);
        
    }
    @isTest
    static void testUpdateIsAudiochekox() {
        // Test Setup
        // Create test data for S2V__Airwaves360_Drip_Recording_Description__c
        S2V__Airwaves360_Drip_Recording_Description__c description = new S2V__Airwaves360_Drip_Recording_Description__c();
        // Populate required fields for the description
        // Ensure that the recording number matches the one used in the method
        description.S2V__Recording_Number__c = 1;
        // Insert the description record 
        insert description;
        
         S2V__Airwaves360_Personal_Recording__c apr = new S2V__Airwaves360_Personal_Recording__c();
        apr.S2V__Description__c = 'description';
        apr.S2V__Recording_Number__c = 3;
        apr.S2V__yabbrFileID__c = '345678';
        //apr.CreatedById = UserInfo.getUserId();
        insert apr;
        
         String fileId;
        // Test Execution
        Test.startTest();
       
          fileId = Airwaves360RecordingPageController.updateIsAudiochekox('fileId', true, 3, fileId);
        Test.stopTest();
        
        // Test Assertion
        // Query the updated description record and verify that the fields were updated as expected
        S2V__Airwaves360_Drip_Recording_Description__c updatedDescription = [SELECT S2V__isWithAudio__c, S2V__yabbrFileID__c FROM S2V__Airwaves360_Drip_Recording_Description__c WHERE Id = :description.Id];
        //System.assertEquals(, updatedDescription.S2V__isWithAudio__c);
        System.assertEquals(null, fileId);
    }
    
     @isTest
    static void testDeletePersonalRecording() {
        // Setup test data
        User testUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];

        S2V__Airwaves360_Personal_Recording__c recording1 = new S2V__Airwaves360_Personal_Recording__c(
            Name = 'Test Recording 1',
            S2V__Description__c = 'Test Description 1',
            S2V__Recording_Number__c = 1,
            S2V__Notes__c = 'Test Notes 1',
            S2V__isWithAudio__c = true,
            S2V__yabbrFileID__c = 'TestFileId1'
            
        );
        
        S2V__Airwaves360_Personal_Recording__c recording2 = new S2V__Airwaves360_Personal_Recording__c(
            Name = 'Test Recording 2',
            S2V__Description__c = 'Test Description 2',
            S2V__Recording_Number__c = 2,
            S2V__Notes__c = 'Test Notes 2',
            S2V__isWithAudio__c = true,
            S2V__yabbrFileID__c = 'TestFileId2'
            
        );
        
        insert new List<S2V__Airwaves360_Personal_Recording__c>{recording1, recording2};

        // Perform the delete operation
        Test.startTest();
        String result = Airwaves360RecordingPageController.deletePersonalRecording(true, 1, 'TestFileId1');
        Test.stopTest();
        
        // Assert results
        List<S2V__Airwaves360_Personal_Recording__c> remainingRecordings = [
            SELECT Id, Name FROM S2V__Airwaves360_Personal_Recording__c
        ];

        System.assertEquals(1, remainingRecordings.size(), 'One recording should remain.');
        System.assertEquals('Test Recording 2', remainingRecordings[0].Name, 'The remaining recording should be "Test Recording 2".');

        System.assertEquals(null, result, 'The result should be null when no FLS violation occurs.');
    }

    
    @isTest
    static void testGetAudioFileIds() {
        S2V__Airwaves360_Drip_Recording_Description__c description = new S2V__Airwaves360_Drip_Recording_Description__c();
        // Populate required fields for the description
        // Ensure that the recording number matches the one used in the method
        description.S2V__Recording_Number__c = 1;
        description.S2V__yabbrFileID__c = 'testFileId';
        // Insert the description record
        insert description;
        
         S2V__Airwaves360_Personal_Recording__c apr = new S2V__Airwaves360_Personal_Recording__c();
        apr.S2V__Description__c = 'description';
        apr.S2V__Recording_Number__c = 3;
        apr.S2V__yabbrFileID__c = '345678';
        //apr.CreatedById = UserInfo.getUserId();
        insert apr;
        
        
        // Test Execution
        Test.startTest();
        String fileId = Airwaves360RecordingPageController.getAudioFileIds(3);
        Test.stopTest();
        
        // Test Assertion
        // Assert that the correct file ID is returned
        System.assertEquals('345678', fileId);
    }
    // Define a mock HTTP callout class
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake HTTP response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
             
            res.setBody('{"url": "https://example.com"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    static void testUploadFileonYabbrFirstCall() {
        // Test Setup
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         String fileId = 'testFileId';
        // Test Execution
        Test.startTest();
        
        S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();

         
        Airwaves360RecordingPageController.uploadFileonYabbrFirstCall('TestFile.wav', 60, 'base64String',5);
       // Airwaves360RecordingPageController.uploadFileonYabbrSecondCall('TestFile.wav', 'stringtest', 'base64String','stringtest1',1);
       
        Test.stopTest();
         System.assertEquals('testFileId', fileId);
        
    }
    
       @isTest
    static void testUploadFileonYabbrSecondCall() {
        // Test Setup
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         String fileId = 'testFileId';
        // Test Execution
        Test.startTest();
        
        S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();

         
       // Airwaves360RecordingPageController.uploadFileonYabbrFirstCall('TestFile.wav', 60, 'base64String',5);
        Airwaves360RecordingPageController.uploadFileonYabbrSecondCall('TestFile.wav', 'stringtest', 'base64String','stringtest1',1);
       
        Test.stopTest();
         System.assertEquals('testFileId', fileId);
        
    }

        @isTest
    static void testUpdateNotes() {
        S2V__Airwaves360_Drip_Recording_Description__c description = new S2V__Airwaves360_Drip_Recording_Description__c();
        // Ensure that the recording number matches the one used in the method
        description.S2V__Recording_Number__c = 1;
        // Insert the description record
        insert description;
        
        S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();


        // Test Execution
        Test.startTest();
        Airwaves360RecordingPageController controller = new Airwaves360RecordingPageController();
        controller.indexval = '1'; // Set the indexval to match the recording number
        controller.notesvalue = 'Test notes'; // Set the notesvalue for testing
        controller.updateNotes();
        Test.stopTest();

        // Test Assertion
        // Query the updated description record and verify that the fields were updated as expected
        S2V__Airwaves360_Drip_Recording_Description__c updatedDescription = [SELECT S2V__Notes__c FROM S2V__Airwaves360_Drip_Recording_Description__c WHERE Id = :description.Id];
        System.assertEquals('Test notes', updatedDescription.S2V__Notes__c);
    }
}