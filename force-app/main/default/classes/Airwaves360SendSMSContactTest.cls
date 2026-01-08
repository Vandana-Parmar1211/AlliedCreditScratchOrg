/*
 * updated on 8th aug 2019
 */ 
@isTest
public class Airwaves360SendSMSContactTest {
    
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
       
        SMS_Template__c objSMSTemp = new SMS_Template__c();
        objSMSTemp.Template_Name__c = 'Testing';
        objSMSTemp.Template_Body__c = 'hello testing';
        insert objSMSTemp;
        
        Test.startTest();
         String domain = Airwaves360SendSMSContact.getOrganizationDomain();
        ApexPages.StandardController sc = new ApexPages.standardController(objCon);
        Airwaves360SendSMSContact  controller = new Airwaves360SendSMSContact(sc);
        
        controller.smsTemplateId = objSMSTemp.id;
        controller.smstemplateName = objSMSTemp.Template_Name__c;
        controller.smstemplateBody = objSMSTemp.Template_Body__c;
        
        List<SelectOption> options = new List<SelectOption>();
        options = controller.getSmsTemplates();
        
        PageReference pageRef = Page.Airwaves360SendSMSContactVF;
        pageRef.getParameters().put('Id',objCon.id);
        PageReference objPageRef = controller.AllSmsTemplate();
        PageReference objPageRef1 = controller.SendSMS();
        
        
        //List<SelectOption> options = S2VSendSMSContact.getSmsTemplates();
        Test.stopTest();
        
        system.assertEquals(1, listOfCon.size());
        
    }
    
    static testmethod void method1atcatch()
    {    
        
        
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
       
        SMS_Template__c objSMSTemp = new SMS_Template__c();
        objSMSTemp.Template_Name__c = 'Testing';
        objSMSTemp.Template_Body__c = 'hello testing';
        insert objSMSTemp;
        
        Test.startTest();
         String domain = Airwaves360SendSMSContact.getOrganizationDomain();
        ApexPages.StandardController sc = new ApexPages.standardController(objCon);
        Airwaves360SendSMSContact  controller = new Airwaves360SendSMSContact(sc);
        
       // controller.smsTemplateId = objSMSTemp.id;
        controller.smstemplateName = objSMSTemp.Template_Name__c;
        controller.smstemplateBody = objSMSTemp.Template_Body__c;
        
        List<SelectOption> options = new List<SelectOption>();
        options = controller.getSmsTemplates();
        
        PageReference pageRef = Page.Airwaves360SendSMSContactVF;
        pageRef.getParameters().put('Id',objCon.id);
        PageReference objPageRef = controller.AllSmsTemplate();
        PageReference objPageRef1 = controller.SendSMS();
      
        
        //List<SelectOption> options = S2VSendSMSContact.getSmsTemplates();
        Test.stopTest();
        
        system.assertEquals(1, listOfCon.size());
        
    }
    
    
 
 

    
}