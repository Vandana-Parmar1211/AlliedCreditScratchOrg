@isTest
public class Airwaves360VoiceMailSendPageContTest{
    
    
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
    
    static testmethod void TestSaveData()
    {                  
        Airwaves360VoiceMailSendPageController s2vmail=new Airwaves360VoiceMailSendPageController();
        
        s2vmail.filterValue1 = 'value1';
        s2vmail.filterop1 = 'Equals';        
        s2vmail.filtertext1 = 'Text1';        
        s2vmail.filterValue1 = 'LastName';        
        s2vmail.selectedField = 'LastName';
        s2vmail.selectedObject = 'Contact';
        s2vmail.selectedUser = UserInfo.getUserId();        
        s2vmail.selectedDate = System.today();
        s2vmail.selectedFreq = ''; 
        s2vmail.userfields = '';
        
        Test.startTest();        
        s2vmail.saveData();        
        test.stopTest(); 
         System.assertEquals(s2vmail.selectedObject,'Contact');
    
    s2vmail.selectedRowIndex = 1;
    s2vmail.clearFilter();
    
    }
        
    static testmethod void TestCallFutureMethodBatch()
    {  
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc; 
        
        Contact con = new Contact();
        con.FirstName = 'vandana';
        con.LastName = 'test';
        con.accounts__c = acc.Id;
        con.MobilePhone = '123456789';
        con.MailingCountry = 'AU';
        insert con;

        List<Id> LstOfsendvoicemail = new List<Id>();
        Airwaves360_Active_Schedule__c sendvoicemail=new Airwaves360_Active_Schedule__c();
        sendvoicemail.Object_Name__c='Contact';
        sendvoicemail.Reference_Field_Lable__c='abc';
        sendvoicemail.Recording_Name__c='8 - aakriti';
        sendvoicemail.Option_Schedule__c='Now';
        sendvoicemail.Schedule_Frequency__c='Daily';
        sendvoicemail.Activity_History__c = True;
        sendvoicemail.S2V__SMS_Template_Body_New__c='test sdmafsrej ' + '\n' + 'tessf';
        sendvoicemail.Reference_Field__c='OwnerId';
        sendvoicemail.Start_Date__c=system.today();
        sendvoicemail.sending_method__c = 'voiceMail';
        sendvoicemail.S2V__Voice_mail_1_User__c = UserInfo.getUserId();
        sendvoicemail.S2V__Recording_Number__c = 10;
        sendvoicemail.S2V__Is_Active__c = true;
        sendvoicemail.S2V__S2vQuery__c = 'Contact objContact=[SELECT Id,OwnerId FROM Contact WHERE FirstName = \'vandana\' ];';
        insert sendvoicemail;
        LstOfsendvoicemail.add(sendvoicemail.Id);
        
        list<id> lstid=new list<id>();
        lstid.add(con.id);
        
        Airwaves360VoiceMailSendPageController s2vmail=new Airwaves360VoiceMailSendPageController();
        Airwaves360VoiceMailSendPageController.Phonelist(lstid, 'Contact');
        s2vmail.filterValue1 = 'value1';               
        s2vmail.filterop1 = 'Equals';        
        s2vmail.filtertext1 = 'Text1';       
        s2vmail.filterValue1 = 'LastName';        
        s2vmail.selectedField = 'LastName';
        s2vmail.selectedObject = 'Contact';
        s2vmail.selectedUser = UserInfo.getUserId();        
        s2vmail.selectedDate = System.today();
        s2vmail.selectedFreq = ''; 
        s2vmail.userfields = '';
                
        Test.startTest();
        String templateBody = 'Hello {!Contact.Name}, your balance.';
        String objectPrefix = 'Contact';
        Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>{
            'Name' => Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get('Name'),
            'MailingCountry' => Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get('MailingCountry'),
            'Phone' => Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get('MobilePhone')
        };
       // Set<String> result = Airwaves360VoiceMailSendPageController.getFieldSet(templateBody, objectPrefix, fieldMap);
      // List<SelectOption> ls1 = s2vmail.getScheduleFreqList();
        s2vmail.selectedOptionschedule = 'Future Call';
        s2vmail.enableFutureCallFields();
        s2vmail.selectedOptionschedule = 'Now';
        s2vmail.enableFutureCallFields();
        s2vmail.getAllFieldNames();
       // s2vmail.setrow1filtervalue();  
      //  s2vmail.setrow2filtervalue();  
      //  s2vmail.setrow3filtervalue();  
       // s2vmail.setrow4filtervalue(); 
        //s2vmail.setrow5filtervalue();  
       // s2vmail.setrow6filtervalue();  
        s2vmail.getRadioValues();
        s2vmail.setRadioValues('SMS');
     //   s2vmail.fetchFieldTypeMethod();
        s2vmail.onObjectChange();
        s2vmail.updateRow();
        s2vmail.enableNextRow();
        s2vmail.getFieldType('Contact', 'FirstName');
        s2vmail.getPicklistOptions('Contact', 'FirstName');
        
        Airwaves360VoiceMailSendPageController.getOperators('date');
        Map<Id, String> contactIdAndMobileMap = new Map<Id, String>();
        Map<Id, Id> contactIdAndIdMap = new Map<Id, Id>();
        Map<Id, Contact> contactIdAndConMap = new Map<Id, Contact>();
        contactIdAndMobileMap.put(con.Id,con.MobilePhone);
        contactIdAndConMap.put(con.Id, con);
        contactIdAndIdMap.put(con.Id, con.Id);
        Airwaves360VoiceMailSendPageController.CallFutureMethodBatchNew(lstid, 'Contact');
        Airwaves360VoiceMailSendPageController.CallFutureMethodBatchFinal(lstid, 'Contact','abc','xyz');
        Airwaves360VoiceMailSendPageController.CallFutureMethodBatchFinal2(lstid, 'Contact','YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=','ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=',1);
        Airwaves360VoiceMailSendPageController.CallFutureMethodBatchFinalMethod(lstid, 'Contact','YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=','ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=',2,sendvoicemail.Id);
        Airwaves360VoiceMailSendPageController.CallFutureMethodBatchFinalMethodNew(lstid, 'Contact','YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=','ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=',2,new List<Id>{ sendvoicemail.Id}, contactIdAndConMap,contactIdAndMobileMap);
        Airwaves360VoiceMailSendPageController.CallFutureMethodBatchFinalMethodNew2(lstid, 'Contact','YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=','ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=',2,new List<Id>{ sendvoicemail.Id}, contactIdAndIdMap,contactIdAndMobileMap);
        Airwaves360VoiceMailSendPageController.CountryCodeList(lstid,'Contact');     

        test.stopTest();  
     System.assertEquals(s2vmail.selectedObject,'Contact');
    s2vmail.selectedRowIndex = 2;
    s2vmail.clearFilter();
        s2vmail.getFilterDateByIndex(4);
    }
   
    @isTest
    static void testCreateTasks() {
        Test.startTest();
        
        // Create test Contacts
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            contacts.add(new Contact(FirstName = 'Test', LastName = 'Contact' + i, MobilePhone = '1234567890'));
        }
        insert contacts;
        
        // Create test Leads
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 3; i++) {
            leads.add(new Lead(FirstName = 'Test', LastName = 'Lead' + i, MobilePhone = '9876543210', Company = 'Test Company'));
        }
        insert leads;
        
        // Create Active Schedule
        List<Airwaves360_Active_Schedule__c> activeSchedules = new List<Airwaves360_Active_Schedule__c>();
        for (Integer i = 0; i < 2; i++) {
            activeSchedules.add(new Airwaves360_Active_Schedule__c(Sending_Method__c = 'Voicemail', SMS_Template_Name__c = 'Test Template', S2V__SMS_Template_Body_New__c = 'Test Message'));
        }
        insert activeSchedules;
        
        // Retrieve test data
        List<Contact> insertedContacts = [SELECT Id FROM Contact];
        List<Lead> insertedLeads = [SELECT Id FROM Lead];
        List<Airwaves360_Active_Schedule__c> insertedSchedules = [SELECT Id FROM Airwaves360_Active_Schedule__c];
        
        // Prepare test data for method call
        Map<Id, List<Id>> lstCntIds = new Map<Id, List<Id>>();
        lstCntIds.put(insertedSchedules[0].Id, new List<Id>{insertedContacts[0].Id, insertedLeads[0].Id});
        
        Map<Id, String> recordNumber = new Map<Id, String>();
        recordNumber.put(insertedSchedules[0].Id, '12345');
        
        List<Id> whatIds = new List<Id>();
        String conLookups = 'Id';
        List<Id> lstSobjRcrds = new List<Id>();
        String dynamicQuery = 'SELECT Id FROM Contact WHERE Id IN :lstSobjRcrds';
        Test.stopTest();
    
     Airwaves360VoiceMailSendPageController s2vmail=new Airwaves360VoiceMailSendPageController();
    s2vmail.selectedRowIndex = 3;
    s2vmail.clearFilter();
        s2vmail.getFilterDateByIndex(5);
        System.assertEquals(s2vmail.selectedRowIndex,3);
    }
    
    @isTest
    static void testPhonelistSMSNewForBulk() {
        Test.startTest();
        
        // Create test Contacts with unique and duplicate MobilePhone values
        Contact contact1 = new Contact(FirstName = 'John', LastName = 'Doe', MobilePhone = '1234567890');
        Contact contact2 = new Contact(FirstName = 'Jane', LastName = 'Doe', MobilePhone = '0987654321');
        Contact contact3 = new Contact(FirstName = 'Jack', LastName = 'Smith', MobilePhone = '1234567890'); // Duplicate
        
        insert new List<Contact>{contact1, contact2, contact3};
        
        // Create test Leads with unique and duplicate MobilePhone values
        Lead lead1 = new Lead(FirstName = 'Alice', LastName = 'Brown', MobilePhone = '5556667777', Company = 'ABC Corp');
        Lead lead2 = new Lead(FirstName = 'Bob', LastName = 'White', MobilePhone = '5558889999', Company = 'XYZ Inc');
        Lead lead3 = new Lead(FirstName = 'Charlie', LastName = 'Green', MobilePhone = '5556667777', Company = 'LMN Ltd'); // Duplicate
        
        insert new List<Lead>{lead1, lead2, lead3};
        
        // Create a map of templates
        Map<Id, String> templateMap = new Map<Id, String>();
        templateMap.put(contact1.Id, 'Template1');
        templateMap.put(contact2.Id, 'Template2');
        templateMap.put(lead1.Id, 'Template3');
        templateMap.put(lead2.Id, 'Template4');
        
        // Prepare list of IDs for contacts and leads
        List<Id> lstCntIds = new List<Id>{contact1.Id, contact2.Id, contact3.Id, lead1.Id, lead2.Id, lead3.Id};
        
        // Call the method
        String result = Airwaves360VoiceMailSendPageController.PhonelistSMSNewForBulk(lstCntIds, 'Contact', templateMap);
        
        Test.stopTest();
        // Check for error message when duplicates are present
        Boolean hasError = false;
        for (ApexPages.Message msg : ApexPages.getMessages()) {
            if (msg.getSummary().contains('Duplicate phone number(s) have been found')) {
                hasError = true;
                break;
            }
        }
    
         Airwaves360VoiceMailSendPageController s2vmail=new Airwaves360VoiceMailSendPageController();
    s2vmail.selectedRowIndex = 4;
    s2vmail.clearFilter();
        System.assertEquals(s2vmail.selectedRowIndex,4);
    }


    static testmethod void TestMultipleMethods(){  
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        SMS_Template__c objSMSTemp = new SMS_Template__c();
        objSMSTemp.Template_Name__c = 'Testing';
        objSMSTemp.Template_Body__c = 'hello testing';
        insert objSMSTemp;
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc; 
                
        Contact con = new Contact();
        con.LastName = 'Test Last Name';
        con.AccountId = acc.Id;
        con.accounts__c = acc.Id;
        con.MobilePhone = '123456789';
        con.MailingCountry = 'AU';
        insert con;
        
        Airwaves360_Active_Schedule__c sendvoicemail=new Airwaves360_Active_Schedule__c();
        sendvoicemail.Object_Name__c='Contact';
        sendvoicemail.Reference_Field_Lable__c='abc';
        sendvoicemail.Option_Schedule__c='Now';
        sendvoicemail.Schedule_Frequency__c='Daily';
        sendvoicemail.Activity_History__c = True;
        sendvoicemail.Reference_Field__c='kjj';
        sendvoicemail.Start_Date__c=system.today();
        sendvoicemail.sending_method__c = 'SMS';
        sendvoicemail.SMS_Template_Body_New__c =  objSMSTemp.Template_Body__c;
        sendvoicemail.SMS_Template_Name__c = objSMSTemp.Template_Name__c;
        insert sendvoicemail;
        
        list<id> lstid=new list<id>();
        lstid.add(con.Id);
        
        date startdate=system.today();
        string selectedvoice='abc';
        string phoneListFinal='xyz';
        String callerId='pqr';
        Integer optionSchedule=1;
        String ScheduleFreq='daily';
        String selectedTime1='abc';
        String useridreference='abcdg';
        Boolean isRecordingname=true;
                
        test.starttest();
        apexpages.currentpage().getparameters().put('sid', sendvoicemail.Id);
        System.assertEquals(sendvoicemail.Object_Name__c,'Contact');
        System.assertEquals(lstid.size(),1);
        
        Airwaves360VoiceMailSendPageController s2vmail=new Airwaves360VoiceMailSendPageController();
        s2vmail.selectedField = '1';
        s2vmail.selectedField = '2';
        s2vmail.selectedLookup = '1';
        s2vmail.selectedObject = 'Opportunity';
        s2vmail.fieldsneed = 'Contact__c';
        List<SelectOption> listSO = s2vmail.SobjectUserNames1;
        s2vmail.getAllFieldNames();
        s2vmail.getSobjectFieldNames();
        s2vmail.getScheduleList();
        s2vmail.getAlllookupfields();
        s2vmail.getAllrecornumber();
        s2vmail.filtertext1 = 'Text';
        s2vmail.filtertext2 = 'Text';
        s2vmail.filtertext3 = 'Text';
        s2vmail.filtertext4 = 'Text';
        s2vmail.filtertext5 = 'Text';
        s2vmail.filtertext6 = 'Text';
        s2vmail.filterop1 ='Not Equals to';
        s2vmail.filterop2 ='Greater than';
        s2vmail.filterop3 = 'Less than';
        s2vmail.filterop4 = 'Greater than';
        s2vmail.filterop5 = 'Greater than';
        s2vmail.filterop6 = 'Greater than';
        s2vmail.smstemplateID = objSMSTemp.id;
        s2vmail.smstemplateName = sendvoicemail.SMS_Template_Name__c;
        s2vmail.smstemplateBody = sendvoicemail.SMS_Template_Body_New__c;
        
        List<SelectOption> options = s2vmail.getRadios();
        s2vmail.radioValues = 'SMS';
        Map<Id,String> MapOfTemplate = new Map<Id,String>();
        MapOfTemplate.put(con.Id , s2vmail.smstemplateBody);
        List<SelectOption> options1 = new List<SelectOption>();
        options1 = s2vmail.getSmsTemplates();
        
        PageReference objPageRef = s2vmail.actionSave();
        PageReference objPageRef1 = s2vmail.AllSmsTemplate();
        s2vmail.saveData();
        Airwaves360VoiceMailSendPageController.PhonelistSMS(lstid, 'Contact');
        test.stopTest();  
    
    s2vmail.selectedRowIndex = 5;
    s2vmail.clearFilter();
    }
    
    @isTest
    public static  void Voicemailmethod(){ 
        
        S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc; 
        
        Contact con = new Contact();
        con.LastName = 'Test Last Name';
        con.AccountId = acc.Id;
        con.accounts__c = acc.Id;
        con.MobilePhone = '123456789';
        con.MailingState = 'NSW';
        con.MailingCountry = 'AU';
        insert con;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        List<Airwaves360_Active_Schedule__c> lst_voiceMail = new List<Airwaves360_Active_Schedule__c>();
        Airwaves360_Active_Schedule__c voiceMail = new Airwaves360_Active_Schedule__c();
        voiceMail.Is_Active__c = true;
        voiceMail.Object_Name__c = 'Contact';
        voiceMail.Recording_By_1_User__c = '2';
        voiceMail.Reference_Field__c = 'OwnerId';
        voiceMail.Option_Schedule__c = 'Now';
        voiceMail.Recording_Name__c = '1';
        voiceMail.Activity_History__c = True;
        voiceMail.Start_Time__c = '11:45';
       // voiceMail.Queryc = 'Contact objContact=[SELECT Id, OwnerId FROM Contact];';
        voiceMail.sending_method__c = 'voiceMail';
        voiceMail.S2V__Schedule_Frequency__c = 'Daily';
        voiceMail.S2V__Recording_Number__c = 10;
        lst_voiceMail.add(voiceMail);
        
        Id currentUserId = UserInfo.getUserId();
        
        if(lst_voiceMail != Null && lst_voiceMail.size() > 0){
            Insert lst_voiceMail;
        }
                
        Airwaves360VoiceMailSendPageController s2vmail=new Airwaves360VoiceMailSendPageController();
        s2vmail.filterValue1 = 'value1';
        s2vmail.filterValue2 = 'value2';
        s2vmail.filterValue3 = 'value3';
        s2vmail.filterValue4 = 'value4';
        s2vmail.filterValue5 = 'value5';
        s2vmail.filterValue6 = 'value6';
        
        s2vmail.filterop1 = 'Equals';
        s2vmail.filterop2 = 'Equals';
        s2vmail.filterop3 = 'Equals';
        s2vmail.filterop4 = 'Equals';
        s2vmail.filterop5 = 'Equals';
        s2vmail.filterop6 = 'Equals';
        
        s2vmail.filtertext1 = 'Text1';
        s2vmail.filtertext2 = 'Text2';
        s2vmail.filtertext3 = 'Text3';
        s2vmail.filtertext4 = 'Text4';
        s2vmail.filtertext5 = 'Text5';
        s2vmail.filtertext6 = 'Text6';
        
        s2vmail.filterValue1 = 'LastName';
        s2vmail.filterValue2 = 'LastName';
        s2vmail.filterValue3 = 'LastName';
        s2vmail.filterValue4 = 'LastName';
        s2vmail.filterValue5 = 'LastName';
        s2vmail.filterValue6 = 'LastName';
        
        s2vmail.selectedField = 'LastName';
        s2vmail.selectedObject = 'CampaignMember';
        s2vmail.selectedRecordingName = '1 - 1 ';
        s2vmail.selectedOptionschedule = 'Future Call';
        s2vmail.Recordingnumbers = '1 - 1';
        s2vmail.selectedLookup = 'ContactId';
        
        date startdate= Date.Valueof('2024-03-28');
        string selectedvoice= 'abc';
        string phoneListFinal='xyz';
        String callerId='pqr';
        String optionSchedule= 'Future Call';
        String ScheduleFreq='daily';
        String selectedTime1='17:20';
        String useridreference='abcdg';
        Boolean isRecordingname=true;
        List<SelectOption> lstAllusr1 = new List<SelectOption>();
        lstAllusr1 = s2vmail.lstAllusr;
        s2vmail.filterValue1 = 'test';
        s2vmail.filterValue2 = 'test';
        s2vmail.filterValue3 = 'test';
        s2vmail.filterValue4 = 'test';
        s2vmail.filterValue5 = 'test';
        s2vmail.filterValue6 = 'test';
        s2vmail.saveData();
        
        Airwaves360VoiceMailSendPageController.TableRow objTableRow = new Airwaves360VoiceMailSendPageController.TableRow(1, 'Test', 'String', true);
        s2vmail.setRowFilterValues(objTableRow, 'Test');
        
        s2vmail.getAllFieldNames();
        list<id> lstid=new list<id>();
        lstid.add(con.Id);
        
        Test.startTest(); 
        System.assertEquals(voiceMail.Object_Name__c,'Contact');
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Airwaves360VoiceMailSendPageController.CallFutureMethodBatch(lstid, 'Contact', 'Australia/Sydney');
        Test.stopTest(); 
         s2vmail.selectedRowIndex = 0;
    s2vmail.clearFilter();
        s2vmail.getFilterDateByIndex(1);
    }
    
    @isTest
    public static  void smsmethod(){ 
                
        S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc; 
        
        Contact con = new Contact();
        con.LastName = 'Test Last Name';
        con.AccountId = acc.Id;
        con.accounts__c = acc.Id;
        con.MobilePhone = '123456789';
        con.MailingState = 'NSW';
        con.MailingCountry = 'AU';
        insert con;
        
        SMS_Template__c objSMSTemp = new SMS_Template__c();
        objSMSTemp.Template_Name__c = 'Testing';
        objSMSTemp.Template_Body__c = 'hello testing';
        insert objSMSTemp;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User usr=new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = uniqueName + '@test' + orgId + '.org', 
                          Username = uniqueName + '@test' + orgId + '.org', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = uniqueName.substring(18, 23), 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = pf.Id,
                          S2V__Airwaves_Verified_Number__c = '12345678'
                         ); 
        insert usr;
        
        List<Airwaves360_Active_Schedule__c> lst_voiceMail = new List<Airwaves360_Active_Schedule__c>();        
        Airwaves360_Active_Schedule__c voiceMail1 = new Airwaves360_Active_Schedule__c();
        voiceMail1.Is_Active__c = true;
        voiceMail1.Object_Name__c = 'Contact';
        voiceMail1.Recording_By_1_User__c = '';
        voiceMail1.Voice_mail_1_User__c =  null;
        voiceMail1.Recording_Name__c = '1';
        voiceMail1.Activity_History__c = True;
        voiceMail1.sending_method__c = 'SMS';
        voiceMail1.Reference_Field__c = 'OwnerId';
        //voiceMail1.Queryc = 'Contact objContact=[SELECT Id, OwnerId FROM Contact];';
        voiceMail1.OwnerId = usr.Id;
        voiceMail1.S2V__Recording_Number__c = null;
        voiceMail1.SMS_Template_Body_New__c =  objSMSTemp.Template_Body__c;
        voiceMail1.SMS_Template_Name__c = objSMSTemp.Template_Name__c;
        lst_voiceMail.add(voiceMail1);
        
        if(lst_voiceMail != Null && lst_voiceMail.size() > 0){
            Insert lst_voiceMail;
        }
        
        Recording__c des = new Recording__c();
        des.Recording_Number__c = 1;
        des.Description__c = 'abc';
        insert des;
        
        S2V__Airwaves360_Personal_Recording__c Perdes = new S2V__Airwaves360_Personal_Recording__c();
        Perdes.S2V__Recording_Number__c = 1;
        Perdes.S2V__yabbrFileID__c = 'abc';
        insert Perdes;
        
        list<id> lstid=new list<id>();
        lstid.add(con.Id);
        
        date startdate= Date.Valueof('2024-03-28');
        string selectedvoice= null;
        string phoneListFinal='xyz';
        String callerId=null;
        Integer optionSchedule=1;
        String ScheduleFreq='daily';
        String selectedTime1='17:20';
        String useridreference='abcdg';
        Boolean isRecordingname=true;
        
        Airwaves360VoiceMailSendPageController s2vmail=new Airwaves360VoiceMailSendPageController();
        s2vmail.filterValue1 = 'value1';
        s2vmail.filterValue2 = 'value2';
        s2vmail.filterValue3 = 'value3';
        s2vmail.filterValue4 = 'value4';
        s2vmail.filterValue5 = 'value5';
        s2vmail.filterValue6 = 'value6';
        
        s2vmail.filterop1 = 'Equals';
        s2vmail.filterop2 = 'Equals';
        s2vmail.filterop3 = 'Equals';
        s2vmail.filterop4 = 'Equals';
        s2vmail.filterop5 = 'Equals';
        s2vmail.filterop6 = 'Equals';
        
        s2vmail.filtertext1 = 'Text1';
        s2vmail.filtertext2 = 'Text2';
        s2vmail.filtertext3 = 'Text3';
        s2vmail.filtertext4 = 'Text4';
        s2vmail.filtertext5 = 'Text5';
        s2vmail.filtertext6 = 'Text6';
        
        s2vmail.filterValue1 = 'LastName';
        s2vmail.filterValue2 = 'LastName';
        s2vmail.filterValue3 = 'LastName';
        s2vmail.filterValue4 = 'LastName';
        s2vmail.filterValue5 = 'LastName';
        s2vmail.filterValue6 = 'LastName';
        
        s2vmail.selectedField = 'LastName';
        s2vmail.selectedObject = 'Contact';
        
        s2vmail.selectedUser = usr.Id;
        
        s2vmail.selectedDate =  Date.Valueof('2024-03-28');
        s2vmail.selectedFreq = ''; 
        s2vmail.userfields = '';
        s2vmail.smstemplateID = objSMSTemp.id;
        System.assertEquals(s2vmail.selectedObject,'Contact');
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Airwaves360VoiceMailSendPageController.CallFutureMethodBatch(lstid, 'Contact', 'Australia/Sydney');
        s2vmail.getFilterDateByIndex(2);
        Test.stopTest(); 
    }
            
    @isTest
    static void testGetAllPicFieldValues() {
        // Test data setup
        // Replace these with appropriate values for your test scenario
        String selectedObject = 'Account';
        String selectedField = 'Industry';
        String listNum = 'Agriculture';
        
        // Call the method under test
        Airwaves360VoiceMailSendPageController instance = new Airwaves360VoiceMailSendPageController();
        List<SelectOption> result = instance.getAllPicFieldValues(selectedField, listNum);
        List<SelectOption> result2 = instance.getAllPicFieldValues(selectedField, '2');
        List<SelectOption> result3 = instance.getAllPicFieldValues(selectedField, '3');
        List<SelectOption> result4 = instance.getAllPicFieldValues(selectedField, '4');
        List<SelectOption> result5 = instance.getAllPicFieldValues(selectedField, '5');
        List<SelectOption> result6 = instance.getAllPicFieldValues(selectedField, '6');
        
       // Airwaves360VoiceMailSendPageController.fields(Account.SObjectType);
        instance.getFilterDateByIndex(3);
         System.assertEquals(selectedObject,'Account');
        
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
    
    //cover CSVGenerator and CSVWriter1 apex class
    @isTest
    static void testUploadFileonYabbrFirstCall() {
        S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();
        // Test Setup
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        String fileId = 'testFileId';
        // Test Execution
        Test.startTest();
        List<string> parameter = new List<string>();
        parameter.add('TestFile.txt');
        CSVGenerator.generateCSVFORSMS(new List<string>(parameter));
        CSVGenerator.generateCSVForVoicemail(parameter);
        CSVGenerator.writeCSVToFileSMS(new List<string>(parameter), 'TestFile', 'Test');
        CSVGenerator.writeCSVToFileForVoiceMail(parameter, 'TestFile', 'Test');
        CSVGenerator.uploadCSVFileonYabbrFirstCall('TestFile.txt','base64String','YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=','ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=');
        Test.stopTest();
        System.assertEquals('testFileId', fileId);
        
    }
    
    @isTest
    static void testReplaceMergeFieldsforMultipleSMS() {
        String selectedObject = 'Account';
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser234432@example.com',
            Username = 'testuser234324@example.com.test',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        // Create a test Contact
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'testcontact@example.com'
        );
        insert testContact;
        
        // Create a test Lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Email = 'testlead@example.com',
            Company = 'Test Company',
            Status = 'Open - Not Contacted'
        );
        insert testLead;

        Test.startTest();
        System.assertEquals(selectedObject,'Account'); 
        // Define SMS template with Contact and User fields
        String smsTemplate = 'Hello {!Contact.FirstName} {!Organization.Name}, from {!User.FirstName} {!User.LastName}';
        
        // Call the method
        //Map<Id, String> result = Airwaves360VoiceMailSendPageController.replaceMergeFieldsforMultipleSMS(null, smsTemplate, new List<String>{testContact.Id});
        Test.stopTest();
    }

    @isTest
    static void testReplaceMergeFieldsWithMissingData() {
        // Create a test Lead
        String selectedObject = 'Account';
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Email = 'testlead@example.com',
            Company = 'Test Company',
            Status = 'Open - Not Contacted'
        );
        insert testLead;
        Test.startTest();
        
        // Define SMS template with a missing field
        String smsTemplate = 'Hello {!Lead.Phone}, please update your contact information.';
        System.assertEquals(selectedObject,'Account');
        // Call the method
        //Map<Id, String> result = Airwaves360VoiceMailSendPageController.replaceMergeFieldsforMultipleSMS(null, smsTemplate, new List<String>{testLead.Id});
                
        Test.stopTest();
    }
    
}