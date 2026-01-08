@isTest
private class Airwaves360IOCallerControllerTest {
    
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a new HTTPResponse object
            HTTPResponse res = new HTTPResponse();
            // Set mock response status code
            res.setStatusCode(200);
            // Set mock response body
            res.setBody('{"status":"success","config":{"approvedSenderIds":["123456"],"selectedSenderIds":["123456"]}}');
            return res;
        }
    }
    
    @isTest
    static void testConstructor() {
        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();
        
        Test.startTest();
        Airwaves360IOCallerController controller = new Airwaves360IOCallerController();
        Test.stopTest();
        // Perform assertions to verify the behavior of the constructor
        System.assertEquals('{"status":"success","config":{"approvedSenderIds":["123456"],"selectedSenderIds":["123456"]}}', controller.jsonResponse);
        // Add more assertions as needed
    }
    @isTest
    static void testFetchSenderIDs() {
        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;  
        
        
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c ='MyS3cur3K3y12333';        
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();
        
        Test.startTest();
        Airwaves360IOCallerController controller = new Airwaves360IOCallerController();
        Test.stopTest();
        // Set up any required input parameters
        controller.callerCodeOption = 'CA-US';
        controller.callerIDNumber = '123456';
        System.assertEquals('CA-US', controller.callerCodeOption);
        System.assertEquals('123456', controller.callerIDNumber);
        // Call the method to be tested
        
        controller.FetchSenderIDs();
        
        
    }
    
}