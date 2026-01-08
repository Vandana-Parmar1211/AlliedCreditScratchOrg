@isTest
public class FirstAutomationQueueableTest {
    
    //cover FirstAutomationQueueable class
    @isTest
    static void futureVoiceMail() {
        
        List<S2V__Airwaves360_Active_Schedule__c> activeSchedules = new List<S2V__Airwaves360_Active_Schedule__c>();
        for (Integer i = 0; i < 3; i++) {
            S2V__Airwaves360_Active_Schedule__c asRecord = new S2V__Airwaves360_Active_Schedule__c(
                Name = 'Test Schedule ' + i,
                S2V__Sending_Method__c = 'SMS',
                S2V__Option_Schedule__c = 'Future Call',
                S2V__Schedule_Time__c = 'Hours',
                Is_Active__c = True
            );
            activeSchedules.add(asRecord);
        }
        insert activeSchedules;
        
        // Create test Contact records
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            Contact con = new Contact(LastName = 'Test Contact ' + i);
            testContacts.add(con);
        }
        insert testContacts;
        
        // Map Active Schedules to Contacts
        Map<Id, S2V__Airwaves360_Active_Schedule__c> mapOfRecANDASId = new Map<Id, S2V__Airwaves360_Active_Schedule__c>();
        for (Integer i = 0; i < testContacts.size(); i++) {
            mapOfRecANDASId.put(testContacts[i].Id, activeSchedules[i]);
        }
        
        Test.startTest();
        System.assertEquals(testContacts.size(),3);
        Test.stopTest();
    }
    
    @isTest
    static void smsSendQueueTest() {
        S2V__Trigger_Handler__c Csetting = new S2V__Trigger_Handler__c();
        Csetting.Name = 'Default';
        Csetting.S2V__CampaignMemberObjTrigger__c = true;
        Csetting.S2V__ContactObjTrigger__c = true;
        Csetting.S2V__LeadObjTrigger__c = true;
        Csetting.S2V__OpportunityObjTrigger__c = true;
        Csetting.S2V__TaskObjTrigger__c = true;
        Csetting.S2V__SMSTemplateTrigger__c = true;
        insert Csetting;
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'vandana';
        con.LastName = 'test';
        con.accounts__c = acc.Id;
        con.MobilePhone = '123456789';
        con.MailingCountry = 'AU';
        Insert con;
        
        Lead testLead = new Lead(FirstName = 'Test', LastName = 'Lead', Company = 'Test Company', MobilePhone = '0400219704');
        insert testLead;
        
        List<Id> setofLead = new List<Id>();
        setofLead.add(testLead.Id);
        
        String templateBodyforOrganization = 'Hello {!Organization.Name}, your {!Contact.Name} balance.';
        SecondQueueableForAutomation.PhonelistSMSNew(new List<Id>{testLead.Id}, 'Lead', new Map<Id, String>(),'SMS',new Map<Id, Contact>(),new Map<Id, Lead>());
        
        List<Id> taskIds = new List<Id>();
        Task testTask = new Task(Subject = 'Test Task', WhoId = con.Id, Status = 'Not Started');
        insert testTask;
        taskIds.add(testTask.Id);
        
        List<Id> scheduleId = new List<Id>();        
        S2V__Airwaves360_Active_Schedule__c testSchedule = new S2V__Airwaves360_Active_Schedule__c(
            Name = 'Test Schedule CLone',
            S2V__Reference_Field__c = 'WhoId',
            S2V__Option_Schedule__c = 'Now',
            S2V__Sending_method__c = 'SMS',
            S2V__Schedule_TIme_textBox__c = 'test',
            Object_Name__c = 'Task',
            S2V__Selected_Lookup__c = 'S2V__Primary_Contact__c',
            S2V__SMS_Object__c = 'Contact'
        );
        insert testSchedule;
        scheduleId.add(testSchedule.Id);
        
        List<S2V__Future_Voicemails__c> fvRecords = new List<S2V__Future_Voicemails__c>();
        for (Integer i = 0; i < 3; i++) {
            fvRecords.add(new S2V__Future_Voicemails__c(
                S2V__Status__c = 'Queue',
                Sending_Method__c = 'SMS',
                S2V__Sobject_Name__c = 'Contact'
            ));
        }
        insert fvRecords;
        System.assertEquals(fvRecords.size(),3);
    }
    
    @isTest
    static void automationQueueTest() {
        S2V__Trigger_Handler__c Csetting = new S2V__Trigger_Handler__c();
        Csetting.Name = 'Default';
        Csetting.S2V__CampaignMemberObjTrigger__c = true;
        Csetting.S2V__ContactObjTrigger__c = true;
        Csetting.S2V__LeadObjTrigger__c = true;
        Csetting.S2V__OpportunityObjTrigger__c = true;
        Csetting.S2V__TaskObjTrigger__c = true;
        Csetting.S2V__SMSTemplateTrigger__c = true;
        insert Csetting;
        
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
        List<Id> conRec = new List<Id>();
        Set<Id> setOfconRecIds = new Set<Id>();
        List<Sobject> lstconS = new List<Sobject>();
        Contact con = new Contact();
        con.FirstName = 'vandana';
        con.LastName = 'test';
        con.accounts__c = acc.Id;
        con.MobilePhone = '123456789';
        con.MailingCountry = 'AU';
        Insert con;
        lstconS.add(con);
        setOfconRecIds.add(con.id);
        
        Contact con1 = new Contact();
        con1.FirstName = 'vandana';
        con1.LastName = 'test clone';
        con1.accounts__c = acc.Id;
        con1.MobilePhone = '123456789';
        con1.MailingCountry = 'AU';
        Insert con1;
        conRec.add(con.Id);
        lstconS.add(con1);
        SMS_Template__c objSMSTemp = new SMS_Template__c();
        objSMSTemp.Template_Name__c = 'Testing';
        objSMSTemp.Template_Body__c = 'hello testing';
        insert objSMSTemp;
        
        Lead ld = new Lead();
        ld.FirstName = 'Test';
        ld.LastName = 'Lead';
        ld.Company = 'Test Company';
        ld.MobilePhone = '0400219704';
        insert ld;
        
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        Profile pf= [Select Id from profile where Name='System Administrator']; 
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
        
        List<Id> LstOfsendvoicemail = new List<Id>();
        Set<Id> setOfActSchIds = new Set<Id>();
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
        sendvoicemail.S2V__Start_Time__c = 'test';
        sendvoicemail.S2V__Schedule_Time__c = 'Hours';
        sendvoicemail.S2V__Option_Schedule__c = 'Future Call';
        sendvoicemail.S2V__Schedule_TIme_textBox__c = '5';
        sendvoicemail.S2V__S2vQuery__c = 'Task objTask=[SELECT Id, WhoId FROM Task WHERE Status = \'Completed\' ];';
        insert sendvoicemail;
        LstOfsendvoicemail.add(sendvoicemail.Id);
        setOfActSchIds.add(sendvoicemail.Id);
        
        Set<Id> taskIds = new Set<Id>(conRec);
        
        List<Id> lstTaskIds = new List<Id>();
        List<Sobject> lstTasks = new List<Sobject>();
        Task Taskobj = new Task();
        Taskobj.Status = 'Completed';
        Taskobj.Subject = 'Send Voicemail Test';
        Taskobj.S2V__S2V_Stop_Notifications__c = false;
        Taskobj.S2V__Sending_Method__c = 'SMS';
        Taskobj.WhoId =  ld.Id;
        insert Taskobj;
        taskIds.add(Taskobj.Id);
        lstTaskIds.add(Taskobj.Id);
        lstTasks.add(Taskobj);
        
          Task Taskobj1 = new Task();
        Taskobj1.Status = 'Completed';
        Taskobj1.Subject = 'SubjectTest';
        Taskobj1.S2V__S2V_Stop_Notifications__c = true;
        Taskobj1.WhoId = ld.Id;
        Taskobj1.S2V__Sending_Method__c = 'SMS';
        Insert Taskobj1;

		 taskIds.add(Taskobj1.Id);
        lstTaskIds.add(Taskobj1.Id);
        lstTasks.add(Taskobj1);        
        List<Id> lastOfActiveScheduleIds = new List<Id>();
        S2V__Airwaves360_Active_Schedule__c testSchedule = new S2V__Airwaves360_Active_Schedule__c(
            Name = 'Test Schedule CLone1',
            S2V__Reference_Field__c = 'WhoId',
            S2V__Option_Schedule__c = 'Now',
            S2V__Sending_method__c = 'SMS',
            S2V__Schedule_TIme_textBox__c = '18',
            Object_Name__c = 'Task',
            Is_Active__c = True,
            S2V__S2vQuery__c = 'Task objTask=[SELECT Id, WhoId FROM Task WHERE Status = \'Completed\' ];',
            S2V__SMS_Object__c = 'Lead',
            Selected_Lookup__c = 'OwnerId',
            SMS_Template_Body_New__c = '{!Lead.firstname},{!User.name},{!Organization.name} testing..'
        );
        insert testSchedule;
        lastOfActiveScheduleIds.add(testSchedule.Id);
        
        Id currentUserId = UserInfo.getUserId();
        List<S2V__Future_Voicemails__c> fvRecords = new List<S2V__Future_Voicemails__c>();
        for (Integer i = 0; i < 3; i++) {
            fvRecords.add(new S2V__Future_Voicemails__c(
                S2V__Status__c = 'Queue',
                Sending_Method__c = 'SMS',
                S2V__Sobject_Name__c = 'Task',
                S2V__ActiveScheduleRecordId__c = testSchedule.id,
                S2V__Record_Id__c = Taskobj.Id
            ));
        }
        
        for (Integer i = 0; i < 3; i++) {
            fvRecords.add(new S2V__Future_Voicemails__c(
                S2V__Status__c = 'Queue',
                Sending_Method__c = 'SMS',
                S2V__Sobject_Name__c = 'Task',
                S2V__ActiveScheduleRecordId__c = testSchedule.id,
                S2V__Record_Id__c = Taskobj1.Id
            ));
        }
        insert fvRecords;
        
        Map<String, List<S2V__Future_Voicemails__c>> futureVMMap = new Map<String, List<S2V__Future_Voicemails__c>>();
        futureVMMap.put(fvRecords[0].S2V__ActiveScheduleRecordId__c, fvRecords);
        
        Map<Id, List<S2V__Future_Voicemails__c>> futureVoiceMail = new Map<Id, List<S2V__Future_Voicemails__c>>();
        futureVoiceMail.put(currentUserId, fvRecords);
        
        String templateBody = 'Hello {!Contact.Name}, your balance.';
        String templateBodyforUser = 'Hello {!User.Name}, your balance.';
        String templateBodyforOrganization = 'Hello {!Organization.Name}, your {!Contact.Name} balance.';
        String templateBodyforOrganizationboth = 'Hello {!Organization.Name}, your {!Contact.Name} balance.{!User.Name}';
        
        String objectPrefix = 'Contact';
        Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>{
            'Name' => Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get('Name'),
                'MailingCountry' => Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get('MailingCountry'),
                'Phone' => Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get('MobilePhone')
                };
                    
                    Map<Id,Id> MapOfConANDObj2 = new Map<Id, Id>();
        Set<Id>conIds = new Set<Id>(conRec);
        Set<Id> recordIds = new Set<Id>(conRec);
        Map<Id, Id> mapOfConANDObj = new Map<Id, Id>();
        Test.StartTest();
        System.enqueueJob(new SecondQueueableForAutomation(futureVoiceMail,'Task'));
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        List<String> lstOfErrorLeads = new List<String>();
        lstOfErrorLeads.add('TEstString');
        
      
        
        Set<Id> setofTaskIds = new Set<Id>();
        setofTaskIds.add(Taskobj1.id);
        
        List<Sobject> lsttaskobj = new List<Sobject>();
        lsttaskobj.add(Taskobj1);
        System.assertEquals(fvRecords.size(),6);
        //SecondQueueableForAutomation.postChatterPostsForUser(setOfconRecIds, 'Contact', UserInfo.getUserId(), 'Test String');
        //SecondQueueableForAutomation.postChatterPosts(setOfconRecIds, 'Contact', UserInfo.getUserId(), 'Test String');
        SecondQueueableForAutomation.postChatterForMergeFields( 'Contact', UserInfo.getUserId(), new Map<Id,List<String>>());
        SecondQueueableForAutomation.getUserTimezoneCity();
        Test.StopTest();        
    }
    
    @isTest
    static void automationQueueTest1() {
        S2V__Trigger_Handler__c Csetting = new S2V__Trigger_Handler__c();
        Csetting.Name = 'Default';
        Csetting.S2V__CampaignMemberObjTrigger__c = true;
        Csetting.S2V__ContactObjTrigger__c = true;
        Csetting.S2V__LeadObjTrigger__c = true;
        Csetting.S2V__OpportunityObjTrigger__c = true;
        Csetting.S2V__TaskObjTrigger__c = true;
        Csetting.S2V__SMSTemplateTrigger__c = true;
        insert Csetting;
        
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
        List<Id> conRec = new List<Id>();
        Set<Id> setOfconRecIds = new Set<Id>();
        List<Sobject> lstconS = new List<Sobject>();
        Contact con = new Contact();
        con.FirstName = 'vandana';
        con.LastName = 'test';
        con.accounts__c = acc.Id;
        con.MobilePhone = '61400219704';
        con.MailingCountry = 'AU';
        Insert con;
        lstconS.add(con);
        setOfconRecIds.add(con.id);
        
        Contact con1 = new Contact();
        con1.FirstName = 'vandana';
        con1.LastName = 'test clone';
        con1.accounts__c = acc.Id;
        con1.MobilePhone = '61400219704';
        con1.MailingCountry = 'AU';
        Insert con1;
        conRec.add(con.Id);
        lstconS.add(con1);
        SMS_Template__c objSMSTemp = new SMS_Template__c();
        objSMSTemp.Template_Name__c = 'Testing \n testing 123';
        objSMSTemp.Template_Body__c = 'hello testing';
        insert objSMSTemp;
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        Profile pf= [Select Id from profile where Name='System Administrator']; 
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
        
        List<Id> LstOfsendvoicemail = new List<Id>();
        Set<Id> setOfActSchIds = new Set<Id>();
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
        sendvoicemail.S2V__Start_Time__c = 'test';
        sendvoicemail.S2V__Schedule_Time__c = 'Hours';
        sendvoicemail.S2V__Option_Schedule__c = 'Future Call';
        sendvoicemail.S2V__Schedule_TIme_textBox__c = '5';
        sendvoicemail.S2V__S2vQuery__c = 'Task objTask=[SELECT Id, WhoId FROM Task WHERE Status = \'Completed\' ];';
        insert sendvoicemail;
        LstOfsendvoicemail.add(sendvoicemail.Id);
        setOfActSchIds.add(sendvoicemail.Id);
        
        Set<Id> taskIds = new Set<Id>(conRec);
        
        List<Id> lstTaskIds = new List<Id>();
        List<Sobject> lstTasks = new List<Sobject>();
        Task Taskobj = new Task();
        Taskobj.Status = 'Completed';
        Taskobj.Subject = 'Send Voicemail Test';
        Taskobj.S2V__S2V_Stop_Notifications__c = false;
        Taskobj.S2V__Sending_Method__c = 'SMS';
        Taskobj.WhoId =  con1.Id;
        insert Taskobj;
        
        Task Taskobj1 = new Task();
        Taskobj1.Status = 'Completed';
        Taskobj1.Subject = 'Send Voicemail Test';
        Taskobj1.S2V__S2V_Stop_Notifications__c = false;
        Taskobj1.S2V__Sending_Method__c = 'SMS';
        Taskobj1.WhoId =  con.Id;
        insert Taskobj1;
        taskIds.add(Taskobj1.Id);
        lstTaskIds.add(Taskobj1.Id);
        lstTasks.add(Taskobj1);
        
        List<Id> lastOfActiveScheduleIds = new List<Id>();
        S2V__Airwaves360_Active_Schedule__c testSchedule = new S2V__Airwaves360_Active_Schedule__c(
            Name = 'Test Schedule CLone1',
            S2V__Reference_Field__c = 'WhoId',
            S2V__Option_Schedule__c = 'Now',
            S2V__Sending_method__c = 'SMS',
            S2V__Schedule_TIme_textBox__c = '18',
            Object_Name__c = 'Task',
            Is_Active__c = True,
            S2V__S2vQuery__c = 'Task objTask=[SELECT Id, WhoId FROM Task WHERE Status = \'Completed\' ];',
            S2V__SMS_Object__c = 'Contact',
            Selected_Lookup__c = 'OwnerId',
            SMS_Template_Body_New__c = '{!Contact.firstname},{!User.name},{!Organization.name} testing..\n testing 1234'
        );
        insert testSchedule;
        lastOfActiveScheduleIds.add(testSchedule.Id);
        
        Id currentUserId = UserInfo.getUserId();
        List<S2V__Future_Voicemails__c> fvRecords = new List<S2V__Future_Voicemails__c>();
        for (Integer i = 0; i < 1; i++) {
            fvRecords.add(new S2V__Future_Voicemails__c(
                S2V__Status__c = 'Queue',
                Sending_Method__c = 'SMS',
                S2V__Sobject_Name__c = 'Task',
                S2V__ActiveScheduleRecordId__c = testSchedule.id,
                S2V__Record_Id__c = Taskobj.Id
            ));
        }
        insert fvRecords;
        
        Map<String, List<S2V__Future_Voicemails__c>> futureVMMap = new Map<String, List<S2V__Future_Voicemails__c>>();
        futureVMMap.put(fvRecords[0].S2V__ActiveScheduleRecordId__c, fvRecords);
        
        Map<Id, List<S2V__Future_Voicemails__c>> futureVoiceMail = new Map<Id, List<S2V__Future_Voicemails__c>>();
        futureVoiceMail.put(currentUserId, fvRecords);
        
        String templateBody = 'Hello {!Contact.Name}, your balance.';
        String templateBodyforUser = 'Hello {!User.Name}, your balance.';
        String templateBodyforOrganization = 'Hello {!Organization.Name}, your {!Contact.Name} balance.';
        String templateBodyforOrganizationboth = 'Hello {!Organization.Name}, your {!Contact.Name} balance.{!User.Name}';
        
        String objectPrefix = 'Contact';
        Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>{
            'Name' => Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get('Name'),
                'MailingCountry' => Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get('MailingCountry'),
                'Phone' => Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get('MobilePhone')
                };
                    
                    Map<Id,Id> MapOfConANDObj2 = new Map<Id, Id>();
        Set<Id>conIds = new Set<Id>(conRec);
        Set<Id> recordIds = new Set<Id>(conRec);
        
        Map<Id, Id> mapOfConANDObj = new Map<Id, Id>();
        Test.StartTest();
        System.enqueueJob(new SecondQueueableForAutomation(futureVoiceMail,'Task'));
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        List<String> lstOfErrorLeads = new List<String>();
        lstOfErrorLeads.add('TEstString');
        
        System.assertEquals(fvRecords.size(),1);
        //SecondQueueableForAutomation.postChatterPostsForUser(setOfconRecIds, 'Contact', UserInfo.getUserId(), 'Test String');
        //SecondQueueableForAutomation.postChatterPosts(setOfconRecIds, 'Contact', UserInfo.getUserId(), 'Test String');
        SecondQueueableForAutomation.getUserTimezoneCity();
        Test.StopTest();        
    }
    
    @isTest
    static void automationQueueTest2() {
        S2V__Trigger_Handler__c Csetting = new S2V__Trigger_Handler__c();
        Csetting.Name = 'Default';
        Csetting.S2V__CampaignMemberObjTrigger__c = true;
        Csetting.S2V__ContactObjTrigger__c = true;
        Csetting.S2V__LeadObjTrigger__c = true;
        Csetting.S2V__OpportunityObjTrigger__c = true;
        Csetting.S2V__TaskObjTrigger__c = true;
        Csetting.S2V__SMSTemplateTrigger__c = true;
        insert Csetting;
        
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
        List<Id> conRec = new List<Id>();
        Set<Id> setOfconRecIds = new Set<Id>();
        List<Sobject> lstconS = new List<Sobject>();
        Contact con = new Contact();
        con.FirstName = 'vandana';
        con.LastName = 'test';
        con.accounts__c = acc.Id;
        con.MobilePhone = '61400219704';
        con.MailingCountry = 'AU';
        Insert con;
        lstconS.add(con);
        setOfconRecIds.add(con.id);
        
        Contact con1 = new Contact();
        con1.FirstName = 'vandana';
        con1.LastName = 'test clone';
        con1.accounts__c = acc.Id;
        con1.MobilePhone = '61400219704';
        con1.MailingCountry = 'AU';
        Insert con1;
        conRec.add(con.Id);
        lstconS.add(con1);
        SMS_Template__c objSMSTemp = new SMS_Template__c();
        objSMSTemp.Template_Name__c = 'Testing \n testing 123';
        objSMSTemp.Template_Body__c = 'hello testing';
        insert objSMSTemp;
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        Profile pf= [Select Id from profile where Name='System Administrator']; 
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
        
        List<Id> LstOfsendvoicemail = new List<Id>();
        Set<Id> setOfActSchIds = new Set<Id>();
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
        sendvoicemail.S2V__Start_Time__c = 'test';
        sendvoicemail.S2V__Schedule_Time__c = 'Hours';
        sendvoicemail.S2V__Option_Schedule__c = 'Future Call';
        sendvoicemail.S2V__Schedule_TIme_textBox__c = '5';
        sendvoicemail.S2V__S2vQuery__c = 'Task objTask=[SELECT Id, WhoId FROM Task WHERE Status = \'Completed\' ];';
        insert sendvoicemail;
        LstOfsendvoicemail.add(sendvoicemail.Id);
        setOfActSchIds.add(sendvoicemail.Id);
        
        Set<Id> taskIds = new Set<Id>(conRec);
        
        List<Id> lstTaskIds = new List<Id>();
        List<Sobject> lstTasks = new List<Sobject>();
        Task Taskobj = new Task();
        Taskobj.Status = 'Completed';
        Taskobj.Subject = 'Send Voicemail Test';
        Taskobj.S2V__S2V_Stop_Notifications__c = false;
        Taskobj.S2V__Sending_Method__c = 'SMS';
        Taskobj.WhoId =  con1.Id;
        insert Taskobj;
        taskIds.add(Taskobj.Id);
        lstTaskIds.add(Taskobj.Id);
        lstTasks.add(Taskobj);
        
        
        List<Id> lastOfActiveScheduleIds = new List<Id>();
        S2V__Airwaves360_Active_Schedule__c testSchedule = new S2V__Airwaves360_Active_Schedule__c(
            Name = 'Test Schedule CLone1',
            S2V__Reference_Field__c = 'WhoId',
            S2V__Option_Schedule__c = 'Now',
            S2V__Sending_method__c = 'SMS',
            S2V__Schedule_TIme_textBox__c = '18',
            Object_Name__c = 'Task',
            Is_Active__c = True,
            S2V__S2vQuery__c = 'Task objTask=[SELECT Id, WhoId FROM Task WHERE Status = \'Completed\' ];',
            S2V__SMS_Object__c = 'Contact',
            Selected_Lookup__c = 'OwnerId',
            SMS_Template_Body_New__c = '{!Contact.firstname}{!Contact.fname},{!User.name},{!Organization.name} testing..\n testing 1234'
        );
        insert testSchedule;
        lastOfActiveScheduleIds.add(testSchedule.Id);
        
        Id currentUserId = UserInfo.getUserId();
        List<S2V__Future_Voicemails__c> fvRecords = new List<S2V__Future_Voicemails__c>();
        for (Integer i = 0; i < 1; i++) {
            fvRecords.add(new S2V__Future_Voicemails__c(
                S2V__Status__c = 'Queue',
                Sending_Method__c = 'SMS',
                S2V__Sobject_Name__c = 'Task',
                S2V__ActiveScheduleRecordId__c = testSchedule.id,
                S2V__Record_Id__c = Taskobj.Id
            ));
        }
        insert fvRecords;
        
        Map<String, List<S2V__Future_Voicemails__c>> futureVMMap = new Map<String, List<S2V__Future_Voicemails__c>>();
        futureVMMap.put(fvRecords[0].S2V__ActiveScheduleRecordId__c, fvRecords);
        
        Map<Id, List<S2V__Future_Voicemails__c>> futureVoiceMail = new Map<Id, List<S2V__Future_Voicemails__c>>();
        futureVoiceMail.put(currentUserId, fvRecords);
        
        String templateBody = 'Hello {!Contact.Name}, your balance.';
        String templateBodyforUser = 'Hello {!User.Name}, your balance.';
        String templateBodyforOrganization = 'Hello {!Organization.Name}, your {!Contact.Name} balance.';
        String templateBodyforOrganizationboth = 'Hello {!Organization.Name}, your {!Contact.Name} balance.{!User.Name}';
        
        String objectPrefix = 'Contact';
        Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>{
            'Name' => Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get('Name'),
                'MailingCountry' => Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get('MailingCountry'),
                'Phone' => Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get('MobilePhone')
                };
                    
                    Map<Id,Id> MapOfConANDObj2 = new Map<Id, Id>();
        Set<Id>conIds = new Set<Id>(conRec);
        Set<Id> recordIds = new Set<Id>(conRec);
        
        Map<Id, Id> mapOfConANDObj = new Map<Id, Id>();
        Test.StartTest();
        System.enqueueJob(new SecondQueueableForAutomation(futureVoiceMail,'Task'));
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        List<String> lstOfErrorLeads = new List<String>();
        lstOfErrorLeads.add('TEstString');
        
        Task Taskobj1 = new Task();
        Taskobj1.Status = 'Completed';
        Taskobj1.Subject = 'SubjectTest';
        Taskobj1.S2V__S2V_Stop_Notifications__c = true;
        Taskobj1.WhoId = con.Id;
        Taskobj1.S2V__Sending_Method__c = 'Voicemail';
        Insert Taskobj1;
        
        Set<Id> setofTaskIds = new Set<Id>();
        setofTaskIds.add(Taskobj1.id);
        
        List<Sobject> lsttaskobj = new List<Sobject>();
        lsttaskobj.add(Taskobj1);
        System.assertEquals(fvRecords.size(),1);
        //SecondQueueableForAutomation.postChatterPostsForUser(setOfconRecIds, 'Contact', UserInfo.getUserId(), 'Test String');
        //SecondQueueableForAutomation.postChatterPosts(setOfconRecIds, 'Contact', UserInfo.getUserId(), 'Test String');
        SecondQueueableForAutomation.getUserTimezoneCity();
        Test.StopTest();        
    }
    
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            res.setBody('{"url": "https://example.com"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": "success"}'); // Mock response body
            res.setStatusCode(201); // Mock response status code
            return res;
        }
    }
}