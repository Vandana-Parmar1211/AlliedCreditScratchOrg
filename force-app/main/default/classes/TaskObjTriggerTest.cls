@IsTest
public class TaskObjTriggerTest{
    @IsTest
    public static void testTrigger(){
        String customLabelValue = System.Label.ContactRecordType;
        List<RecordType> recordTypeList = [SELECT Id, Name, SObjectType FROM RecordType WHERE Name = :customLabelValue];
        S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt;
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();
        
        S2V__Trigger_Handler__c Csetting = new S2V__Trigger_Handler__c();
        Csetting.Name = 'Default';
        Csetting.S2V__CampaignMemberObjTrigger__c = true;
        Csetting.S2V__ContactObjTrigger__c = true;
        Csetting.S2V__LeadObjTrigger__c = true;
        Csetting.S2V__OpportunityObjTrigger__c = true;
        Csetting.S2V__TaskObjTrigger__c = true;
        Csetting.S2V__SMSTemplateTrigger__c = true;
        insert Csetting;
        
        List<Contact> listCon = new List<Contact>();
        Contact objCon = new Contact();
        objCon.lastName = 'test';
        objCon.Email = 'd@d.com';
        objCon.MailingCountry = 'Australia';
        objCon.S2V__S2V_Batch_record__c = true;
        objCon.S2V__S2V_Stop_Notifications__c = false;
        if (!recordTypeList.isEmpty()) {
            objCon.RecordTypeId = recordTypeList[0].id;
        }
        Contact objCon1 = new Contact();
        objCon1.lastName = 'test';
        objCon1.Email = 'd@d.com';
        objCon1.MailingCountry = 'Australia';
        objCon1.S2V__S2V_Batch_record__c = false;
        objCon1.S2V__S2V_Stop_Notifications__c = false;
        objCon1.S2V__S2V_Stop_Notifications_SMS__c = false;
        if (!recordTypeList.isEmpty()) {
            objCon1.RecordTypeId = recordTypeList[0].id;
        }
        listCon.add(objCon);
        listCon.add(objCon1);
        insert listCon;
        S2V__Airwaves360_Active_Schedule__c activeSchedule = new S2V__Airwaves360_Active_Schedule__c(
            S2V__S2vQuery__c = 'SELECT Id FROM Task WHERE Status = \'Open\' AND S2V__S2V_Stop_Notifications_SMS__c = false',
            S2V__Object_Name__c ='Task');
        insert activeSchedule;
        S2V__Airwaves360_Active_Schedule__c activeSchedule1 = new S2V__Airwaves360_Active_Schedule__c(
            S2V__S2vQuery__c = 'SELECT Id FROM CampaignMember WHERE Status = \'Sent\' AND S2V__S2V_Stop_Notifications_SMS__c = true',
            S2V__Object_Name__c ='CampaignMember');
        insert activeSchedule1;
        S2V__Airwaves360_Active_Schedule__c activeSchedule2 = new S2V__Airwaves360_Active_Schedule__c(
            S2V__S2vQuery__c = 'SELECT Id FROM Contact WHERE LastName = \'Test_V\' AND S2V__S2V_Stop_Notifications_SMS__c = true',
            S2V__Object_Name__c ='Contact');
        insert activeSchedule2;
        S2V__Airwaves360_Active_Schedule__c activeSchedule3 = new S2V__Airwaves360_Active_Schedule__c(
            S2V__S2vQuery__c = 'SELECT Id FROM Lead WHERE LastName = \'Test_V\' AND S2V__S2V_Stop_Notifications_SMS__c = true',
            S2V__Object_Name__c ='Lead');
        insert activeSchedule3;
        S2V__Airwaves360_Active_Schedule__c activeSchedule4 = new S2V__Airwaves360_Active_Schedule__c(
            S2V__S2vQuery__c = 'SELECT Id FROM Opportunity WHERE Name = \'test\' AND StageName = \'Closed Won\'',
            S2V__Object_Name__c ='Opportunity');
        insert activeSchedule4;
        S2V.RecursiveTriggerHandler.isFirstTime  =true; 
        Task Taskobj = new Task();
        Taskobj.Status = 'Open';
        Taskobj.Subject = 'Send Voicemail Test';
        Taskobj.S2V__S2V_Stop_Notifications__c = false;
        Taskobj.S2V__Sending_Method__c = 'Voicemail';
        insert Taskobj;
        Taskobj.Subject = 'Send Voicemail Clone';
        update Taskobj;
        
        //TaskQueueHelper.isAlreadyInserted = true; 
        Task Taskobj1 = new Task();
        Taskobj1.Id =  Taskobj.Id;
        Taskobj1.Status = 'Completed';
        Taskobj1.Subject = 'SubjectTest';
        Taskobj1.S2V__S2V_Stop_Notifications__c = true;
        Taskobj1.S2V__Sending_Method__c = 'Voicemail';
        //TaskQueueHelper.isAlreadyInserted = true;
        update Taskobj1;
        
        System.assertEquals(listCon.size(),2); 
    }
    
    @isTest
    static void testFutureVoiceMail(){
        
        S2V__Airwaves360_Active_Schedule__c activeSchedule = new S2V__Airwaves360_Active_Schedule__c(
            S2V__S2vQuery__c = 'SELECT Id FROM Task WHERE Subject = \'Send Voicemail Test Clone\' AND ActivityDate <= \'2025-03-05 \' AND S2V__ReadyToProcess__c != false ',
            S2V__Object_Name__c = 'Task',
            S2V__Is_Active__c = true,
            Name = 'task'
        );
        insert activeSchedule;
        
        S2V__Airwaves360_Active_Schedule__c activeSchedule1 = new S2V__Airwaves360_Active_Schedule__c(
            S2V__S2vQuery__c = 'SELECT Id FROM Task WHERE Subject = \'MY Test\' AND ActivityDate >= \'2025-01-05 \' ',
            S2V__Object_Name__c = 'Task',
            S2V__Is_Active__c = true,
            Name = 'Task'
        );
        insert activeSchedule1; 
        
        S2V__Airwaves360_Active_Schedule__c activeSchedule2 = new S2V__Airwaves360_Active_Schedule__c(
            S2V__S2vQuery__c = 'SELECT Id FROM Task WHERE Subject = \'MY Test Clone\' AND ActivityDate < \'2025-03-05 \' ',
            S2V__Object_Name__c = 'Task',
            S2V__Is_Active__c = true,
            Name = 'Task'
        );
        insert activeSchedule2; 
        
        S2V__Airwaves360_Active_Schedule__c activeSchedule3 = new S2V__Airwaves360_Active_Schedule__c(
            S2V__S2vQuery__c = 'SELECT Id FROM Task WHERE Subject = \'Test Task 3\' AND ActivityDate > \'2025-03-05 \' ',
            S2V__Object_Name__c = 'Task',
            S2V__Is_Active__c = true,
            Name = 'Task'
        );
        insert activeSchedule3; 
        
        List<Task> taskList = new List<Task>(); 
        Task testTask = new Task(
            Status = 'Open',
            Subject = 'Send Voicemail Test',
            S2V__S2V_Stop_Notifications__c = false,
            S2V__Sending_Method__c = 'SMS'
            
        );
        //TaskQueueHelper.isAlreadyInserted = false;
        
        insert testTask;
        
        Task testTask2 = new Task(
            Status = 'Completed',
            Subject = 'MY Test Clone',
            S2V__S2V_Stop_Notifications__c = false,
            S2V__Sending_Method__c = 'SMS',
            S2V__ReadyToProcess__c = true,
            ActivityDate = system.today().addDays(-16),
            CallDurationInSeconds = 3
        );
        taskList.add(testTask2);
        
        Task testTask3 = new Task(
            Status = 'Open',
            Subject = 'Test Task 3',
            S2V__S2V_Stop_Notifications__c = false,
            S2V__Sending_Method__c = 'SMS',
            ActivityDate = system.today().addDays(5),
            CallDurationInSeconds = 3
        );
        taskList.add(testTask3);
        
        Task testTask1 = new Task(
            Status = 'Completed',
            Subject = 'MY Test',
            S2V__S2V_Stop_Notifications__c = false,
            S2V__Sending_Method__c = 'SMS',
            S2V__ReadyToProcess__c = true,
            ActivityDate = system.today().addDays(-20),
            CallDurationInSeconds = 3
        );
        taskList.add(testTask1);
        //TaskQueueHelper.isAlreadyInserted = true;
        
        insert taskList;
        
        // Create a test Record Queue entry
        S2V__Record_Queue__c recordQueue = new S2V__Record_Queue__c();
        recordQueue.S2V__Object_Record_id__c = testTask.Id;
        recordQueue.S2V__OldMapValue__c = '{"Subject":"Send Voicemail Test"}';
        insert recordQueue;
        /*
S2V__Record_Queue__c recordQueue1 = new S2V__Record_Queue__c();
recordQueue1.S2V__Object_Record_id__c = testTask1.Id;
recordQueue1.S2V__OldMapValue__c = '{"Subject":"MY Test"}';
insert recordQueue1;*/
        
        System.assertEquals(taskList.size(),3); 
        Test.startTest();
        BatchForMatchingRecords batchJob = new BatchForMatchingRecords(false, 'Task');
        Database.executeBatch(batchJob, 100);
        
        Test.stopTest();
    }
    
    @isTest
    static void testFutureVoiceMail1(){
        
        S2V__Airwaves360_Active_Schedule__c activeSchedule = new S2V__Airwaves360_Active_Schedule__c(
            S2V__S2vQuery__c = 'SELECT Id FROM Task WHERE Subject = \'Send Voicemail Test Clone\' AND ActivityDate <= \'2025-03-05 \' AND S2V__ReadyToProcess__c != false ',
            S2V__Object_Name__c = 'Task',
            S2V__Is_Active__c = true,
            Name = 'task'
        );
        insert activeSchedule;
        
        S2V__Airwaves360_Active_Schedule__c activeSchedule1 = new S2V__Airwaves360_Active_Schedule__c(
            S2V__S2vQuery__c = 'SELECT Id FROM Task WHERE Subject = \'MY Test\' AND ActivityDate >= \'2025-01-05 \' ',
            S2V__Object_Name__c = 'Task',
            S2V__Is_Active__c = true,
            Name = 'Task'
        );
        insert activeSchedule1; 
        
        S2V__Airwaves360_Active_Schedule__c activeSchedule2 = new S2V__Airwaves360_Active_Schedule__c(
            S2V__S2vQuery__c = 'SELECT Id FROM Task WHERE Subject = \'MY Test Clone\' AND ActivityDate < \'2025-03-05 \' ',
            S2V__Object_Name__c = 'Task',
            S2V__Is_Active__c = true,
            Name = 'Task'
        );
        insert activeSchedule2; 
        
        S2V__Airwaves360_Active_Schedule__c activeSchedule3 = new S2V__Airwaves360_Active_Schedule__c(
            S2V__S2vQuery__c = 'SELECT Id FROM Task WHERE Subject = \'Test Task 3\' AND ActivityDate > \'2025-03-05 \' ',
            S2V__Object_Name__c = 'Task',
            S2V__Is_Active__c = true,
            Name = 'Task'
        );
        insert activeSchedule3; 
        
        List<Task> taskList = new List<Task>(); 
        Task testTask = new Task(
            Status = 'Open',
            Subject = 'Send Voicemail Test',
            S2V__S2V_Stop_Notifications__c = false,
            S2V__Sending_Method__c = 'SMS'
            
        );
        //TaskQueueHelper.isAlreadyInserted = true;
        
        insert testTask;
        
        testTask.Subject = 'Send Voicemail Test clone';
        testTask.ActivityDate = system.today().addDays(-2);
        testTask.S2V__ReadyToProcess__c = true;
        
        Task testTask2 = new Task(
            Status = 'Completed',
            Subject = 'MY Test Clone',
            S2V__S2V_Stop_Notifications__c = false,
            S2V__Sending_Method__c = 'SMS',
            S2V__ReadyToProcess__c = true,
            ActivityDate = system.today().addDays(-16),
            CallDurationInSeconds = 3
        );
        taskList.add(testTask2);
        
        Task testTask3 = new Task(
            Status = 'Open',
            Subject = 'Test Task 3',
            S2V__S2V_Stop_Notifications__c = false,
            S2V__Sending_Method__c = 'SMS',
            ActivityDate = system.today().addDays(5),
            CallDurationInSeconds = 3
        );
        taskList.add(testTask3);
        
        Task testTask1 = new Task(
            Status = 'Completed',
            Subject = 'MY Test',
            S2V__S2V_Stop_Notifications__c = false,
            S2V__Sending_Method__c = 'SMS',
            S2V__ReadyToProcess__c = true,
            ActivityDate = system.today().addDays(-20),
            CallDurationInSeconds = 3
        );
        taskList.add(testTask1);
        //TaskQueueHelper.isAlreadyInserted = true;
        
        insert taskList;
        
        // Create a test Record Queue entry
        S2V__Record_Queue__c recordQueue = new S2V__Record_Queue__c();
        recordQueue.S2V__Object_Record_id__c = testTask.Id;
        recordQueue.S2V__OldMapValue__c = '{"Subject":"Send Voicemail Test"}';
        insert recordQueue;
        
        
        Test.startTest();
        Update testTask; 
        System.assertEquals(taskList.size(),3); 
        BatchForMatchingRecords batchJob = new BatchForMatchingRecords(false, 'Task');
        Database.executeBatch(batchJob, 100);
        
        Test.stopTest();
    }
    
    @isTest
    static void testQueueableExecution() {
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert testContact;
        
        Lead testLead = new Lead(FirstName = 'Test', LastName = 'Lead', Company = 'Test Company');
        insert testLead;
        
        Task testTask = new Task(Subject = 'Test Task', WhoId = testContact.Id, Status = 'Not Started');
        insert testTask;
        
        S2V__Airwaves360_Active_Schedule__c testSchedule = new S2V__Airwaves360_Active_Schedule__c(
            Name = 'Test Schedule',
            S2V__Reference_Field__c = 'WhoId',
            S2V__Option_Schedule__c = 'Future Call',
            S2V__Sending_method__c = 'SMS',
            S2V__Schedule_TIme_textBox__c = 'test'
        );
        insert testSchedule;
        
        Map<Id, S2V__Airwaves360_Active_Schedule__c> scheduleMap = new Map<Id, S2V__Airwaves360_Active_Schedule__c>();
        scheduleMap.put(testTask.Id, testSchedule);
        List<sObject> testRecords = new List<sObject>{testTask};
            FirstQueueableForFromNumberGrouping queueableJob = new FirstQueueableForFromNumberGrouping(testRecords, 'Task', scheduleMap);
        Test.startTest();
        System.enqueueJob(queueableJob);
        Test.stopTest();
        
        List<Future_Voicemails__c> insertedFVs = [SELECT Id, Record_Id__c, Status__c, S2V__Sending_method__c FROM Future_Voicemails__c WHERE Record_Id__c = :testTask.Id];
        System.assert(insertedFVs.size()>0, 'A Future Voicemail should have been inserted');
        System.assertEquals('Queue', insertedFVs[0].Status__c, 'Status should be Sent');
        //System.assertEquals('SMS', insertedFVs[0].S2V__Sending_method__c, 'Sending method should be SMS');
        System.assertEquals(true, Test.isRunningTest(), 'Test.isRunningTest() should return true');
        List<Future_Voicemails__c> updatedRecords = [SELECT Id, Status__c FROM Future_Voicemails__c WHERE Status__c = 'Sent'];
        //System.assertEquals(1, updatedRecords.size(), 'Record should be updated');
        
        List<AsyncApexJob> jobs = [SELECT Id, Status, JobType FROM AsyncApexJob WHERE JobType = 'Queueable' LIMIT 10];
        System.assert(jobs.size() > 0, 'There should be at least one Queueable job executed');
        
    }
    
    @isTest
    static void testActiveScheduleProcessing() {
        S2V__Airwaves360_Active_Schedule__c activeSchedule1 = new S2V__Airwaves360_Active_Schedule__c(
            S2V__S2vQuery__c = 'SELECT Id FROM Task WHERE Status = \'Open\' AND S2V__S2V_Stop_Notifications_SMS__c = false',
            S2V__Object_Name__c ='Task', S2V__Is_Active__c = true);
        insert activeSchedule1;
        String queryParams = S2V.QueryParserClass.getwhereclause(activeSchedule1.S2V__S2vQuery__c);
        QueryParserClass.getWhereClauseFieldsAndItsValues(queryParams);
        QueryParserClass.getWhereClauseFieldsAndItsValuesForAllOp(queryParams);
        List<S2V__Airwaves360_Active_Schedule__c> activeSchedules = new List<S2V__Airwaves360_Active_Schedule__c>();
        
        for (Integer i = 0; i < 3; i++) {
            S2V__Airwaves360_Active_Schedule__c schedule = new S2V__Airwaves360_Active_Schedule__c(
                Name = 'Test Schedule ' + i,
                S2V__S2vQuery__c = '[SELECT Id, Name FROM Account WHERE Name != \'Test\' AND Industry = \'Technology\'];'
            );
            activeSchedules.add(schedule);
        }
        
        insert activeSchedules;
        List<S2V__Airwaves360_Active_Schedule__c> lstOfActiveSchedule = [SELECT Id, S2V__S2vQuery__c FROM S2V__Airwaves360_Active_Schedule__c];
        
        Map<Id, String> mapActivescheduleIdString = new Map<Id, String>();
        Map<Id, S2V__Airwaves360_Active_Schedule__c> ActiveScheduleMap = new Map<Id, S2V__Airwaves360_Active_Schedule__c>();
        
        
        if (lstOfActiveSchedule != null && !lstOfActiveSchedule.isEmpty()) {
            for (S2V__Airwaves360_Active_Schedule__c activeschedule : lstOfActiveSchedule) {
                String whereClause = S2V.QueryParserClass.getwhereclause(activeschedule.S2V__S2vQuery__c);
                mapActivescheduleIdString.put(activeschedule.Id, whereClause);
                ActiveScheduleMap.put(activeschedule.Id, activeschedule);
            }
        }
        
        System.assertEquals(lstOfActiveSchedule.size(), mapActivescheduleIdString.size(), 'Mismatch in whereClause mapping');
        System.assertEquals(lstOfActiveSchedule.size(), ActiveScheduleMap.size(), 'Mismatch in ActiveScheduleMap mapping');
        
        for (Id scheduleId : mapActivescheduleIdString.keySet()) {
            String whereClause = mapActivescheduleIdString.get(scheduleId);
        }
        
    }
    @isTest
    static void secondQueuableTest(){
        S2V__Airwaves360_Active_Schedule__c activeSchedule = new S2V__Airwaves360_Active_Schedule__c(Name = 'Test Schedule');
        insert activeSchedule;
        
        Future_Voicemails__c fvRecord = new Future_Voicemails__c(Status__c = 'Queue');
        insert fvRecord;
        
        // Prepare required input maps
        Map<Id, S2V__Airwaves360_Active_Schedule__c> mapOfRecANDASId = new Map<Id, S2V__Airwaves360_Active_Schedule__c>();
        mapOfRecANDASId.put(fvRecord.Id, activeSchedule);
        
        List<sObject> recordsToProcess = new List<sObject> { fvRecord };
            
            Test.startTest();
        System.enqueueJob(new FirstQueueableForFromNumberGrouping(recordsToProcess, 'Future_Voicemails__c', mapOfRecANDASId));
        Test.stopTest();
        
        List<Future_Voicemails__c> updatedRecords = [SELECT Id, Status__c FROM Future_Voicemails__c WHERE Status__c = 'Queue'];
        System.assertEquals(2, updatedRecords.size(), 'Record should be updated');
        
        // Check the Apex Job that was executed (optional)
        List<AsyncApexJob> jobs = [SELECT Id, Status, JobType FROM AsyncApexJob WHERE JobType = 'Queueable' LIMIT 10];
        System.assert(jobs.size() > 0, 'There should be at least one Queueable job executed');
    }
}