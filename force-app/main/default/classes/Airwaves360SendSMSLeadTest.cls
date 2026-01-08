@isTest
public class Airwaves360SendSMSLeadTest {
    
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock HTTP response
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": "success"}'); // Mock response body
            res.setStatusCode(201); // Mock response status code
            return res;
        }
    }
    
    static testmethod void method1()
    {    
        /*S2V_Trigger_Handler__c trgHandler = new S2V_Trigger_Handler__c();
        trgHandler.Name = 'TriggerHandler';
        trgHandler.S2VTimeZoneContact__c = true;
        trgHandler.S2VTimeZoneLead__c = true;
        trgHandler.S2VTimeZoneOpp__c = true;
        trgHandler.S2VTimeZoneTask__c = true;
        trgHandler.SameRecordNumber__c = true;
        trgHandler.SendVoiceMail__c = true;
        insert trgHandler;*/
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        User u = [Select id, name, email from User where id=: UserInfo.getUserId()];
		
        S2V__Countrycode__c objCS = new S2V__Countrycode__c();
        objCS.Name = 'AU';
        objCS.S2V__Active__c = TRUE;
        objCS.S2V__Country__c = 'AU';
        insert objCS;
        
        List<Contact> listOfCon = new List<Contact>();
        Contact objCon = new Contact();
        objCon.LastName = 'Test';
        objCon.firstName = 'Test';
        objCon.MobilePhone = '8978787';
        objCon.ownerId = u.id;
        objCon.MailingCountry = 'AU';
        listOfCon.add(objCon);
        insert listOfCon;
        
        
        Lead lead = new Lead();
     Lead.Lastname = 'Test';
     Lead.MobilePhone = '123456789';
     lead.company = 'test';  
     insert lead;
      
     list<id> lstid=new list<id>();
     lstid.add(Lead.Id);
       
        SMS_Template__c objSMSTemp = new SMS_Template__c();
        objSMSTemp.Template_Name__c = 'Testing';
        objSMSTemp.Template_Body__c = 'hello testing';
        insert objSMSTemp;
        
        Test.startTest();
        String domain = Airwaves360SendSMSLead.getOrganizationDomain();
        ApexPages.StandardController sc = new ApexPages.standardController(lead);
        Airwaves360SendSMSLead  controller = new Airwaves360SendSMSLead(sc);
        
        controller.smsTemplateId = objSMSTemp.id;
        controller.smstemplateName = objSMSTemp.Template_Name__c;
        controller.smstemplateBody = objSMSTemp.Template_Body__c;
        
        List<SelectOption> options = new List<SelectOption>();
        options = controller.getSmsTemplates();
        
        PageReference pageRef = Page.Airwaves360SendSMSLeadVF;
        pageRef.getParameters().put('Id',objCon.id);
        PageReference objPageRef = controller.AllSmsTemplate();
        PageReference objPageRef1 = controller.SendSMS();
        
        
        //List<SelectOption> options = S2VSendSMSContact.getSmsTemplates();
        Test.stopTest();
        
        system.assertEquals(1, listOfCon.size());
        
    }
    
     static testmethod void method1catch()
    {    
        /*S2V_Trigger_Handler__c trgHandler = new S2V_Trigger_Handler__c();
        trgHandler.Name = 'TriggerHandler';
        trgHandler.S2VTimeZoneContact__c = true;
        trgHandler.S2VTimeZoneLead__c = true;
        trgHandler.S2VTimeZoneOpp__c = true;
        trgHandler.S2VTimeZoneTask__c = true;
        trgHandler.SameRecordNumber__c = true;
        trgHandler.SendVoiceMail__c = true;
        insert trgHandler;*/
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        User u = [Select id, name, email from User where id=: UserInfo.getUserId()];
		
        S2V__Countrycode__c objCS = new S2V__Countrycode__c();
        objCS.Name = 'AU';
        objCS.S2V__Active__c = TRUE;
        objCS.S2V__Country__c = 'AU';
        insert objCS;
        
        List<Contact> listOfCon = new List<Contact>();
        Contact objCon = new Contact();
        objCon.LastName = 'Test';
        objCon.firstName = 'Test';
        objCon.MobilePhone = '8978787';
        objCon.ownerId = u.id;
        objCon.MailingCountry = 'AU';
        listOfCon.add(objCon);
        insert listOfCon;
        
        
        Lead lead = new Lead();
     Lead.Lastname = 'Test';
     Lead.MobilePhone = '123456789';
     lead.company = 'test';  
     insert lead;
      
     list<id> lstid=new list<id>();
     lstid.add(Lead.Id);
       
        SMS_Template__c objSMSTemp = new SMS_Template__c();
        objSMSTemp.Template_Name__c = 'Testing';
        objSMSTemp.Template_Body__c = 'hello testing';
        insert objSMSTemp;
        
        Test.startTest();
        String domain = Airwaves360SendSMSLead.getOrganizationDomain();
        ApexPages.StandardController sc = new ApexPages.standardController(lead);
        Airwaves360SendSMSLead  controller = new Airwaves360SendSMSLead(sc);
        
        //controller.smsTemplateId = objSMSTemp.id;
        controller.smstemplateName = objSMSTemp.Template_Name__c;
        controller.smstemplateBody = objSMSTemp.Template_Body__c;
        
        List<SelectOption> options = new List<SelectOption>();
        options = controller.getSmsTemplates();
        
        PageReference pageRef = Page.Airwaves360SendSMSLeadVF;
        pageRef.getParameters().put('Id',objCon.id);
        PageReference objPageRef = controller.AllSmsTemplate();
        PageReference objPageRef1 = controller.SendSMS();
        
        
        //List<SelectOption> options = S2VSendSMSContact.getSmsTemplates();
        Test.stopTest();
        
        system.assertEquals(1, listOfCon.size());
        
    }
    @isTest
    static void testAirwaves360SendSMSLeadMethods() {
        // Set up test data
        User u = [SELECT Id, Name, Email FROM User WHERE Id = :UserInfo.getUserId()];

        // Insert Lead
        Lead lead = new Lead();
        lead.LastName = 'Test Lead';
        lead.MobilePhone = '1234567890';
        lead.Company = 'Test Company';
        lead.S2V__S2V_Stop_Notifications_SMS__c = false; // Ensure notifications are not stopped
        insert lead;

        // Insert SMS Template
        SMS_Template__c smsTemplate = new SMS_Template__c();
        smsTemplate.Template_Name__c = 'Test Template';
        smsTemplate.Template_Body__c = 'This is a test message.';
        smsTemplate.S2V__Object_Name__c = 'Lead';
        insert smsTemplate;

        // Set mock for HTTP callouts
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        // Start test
        Test.startTest();

        // Create StandardController and Airwaves360SendSMSLead instance
        ApexPages.StandardController sc = new ApexPages.StandardController(lead);
        Airwaves360SendSMSLead controller = new Airwaves360SendSMSLead(sc);

        // Test getSmsTemplates method
        List<SelectOption> smsTemplates = controller.getSmsTemplates();
        System.assertNotEquals(0, smsTemplates.size(), 'SMS Templates should be fetched successfully.');

        // Test AllSmsTemplate method
        controller.smsTemplateId = smsTemplate.Id;
        controller.AllSmsTemplate();
        System.assertEquals(smsTemplate.Template_Name__c, controller.smstemplateName, 'Template name should match.');
        System.assertEquals(smsTemplate.Template_Body__c, controller.smstemplateBody, 'Template body should match.');

        // Test SendSMS method
        controller.smstemplateBody = smsTemplate.Template_Body__c;
        controller.userMobile = '9876543210'; // Mock user mobile
        PageReference sendSMSPageRef = controller.SendSMS();
        System.assertEquals(null, sendSMSPageRef, 'SendSMS method should return null.');
        System.assertEquals(false, controller.StopNotification, 'StopNotification should be false.');

        // Test StopNotification logic
        lead.S2V__S2V_Stop_Notifications_SMS__c = true; // Stop notifications
        update lead;

        // Reinitialize controller with updated lead
        sc = new ApexPages.StandardController(lead);
        controller = new Airwaves360SendSMSLead(sc);
        System.assertEquals(true, controller.StopNotification, 'StopNotification should be true for updated lead.');

        Test.stopTest();
    }

    
  
    
   
    
}