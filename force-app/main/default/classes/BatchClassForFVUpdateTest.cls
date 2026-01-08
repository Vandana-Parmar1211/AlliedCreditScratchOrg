@isTest
public class BatchClassForFVUpdateTest {
    
    @testSetup
    static void setupTestData() {
        List<S2V__Future_Voicemails__c> fvRecords = new List<S2V__Future_Voicemails__c>();
        List<Airwaves360_Active_Schedule__c> ASRecords = new List<Airwaves360_Active_Schedule__c>();

        Contact c = new Contact();
        c.lastname = 'testrcs';
        insert c;
        
        Airwaves360_Active_Schedule__c ASRecord = new Airwaves360_Active_Schedule__c();
        ASRecord.S2V__Activity_History__c = true;
        ASRecord.S2V__Sending_Method__c = 'SMS';
        ASRecords.add(ASRecord);
        
        insert ASRecords;
        
        for (Integer i = 0; i < 5; i++) { // Use a batch size-friendly count
            S2V__Future_Voicemails__c fv = new S2V__Future_Voicemails__c(
                S2V__Status__c = 'Sent',
                S2V__Related_to_Id__c = c.id, // Replace with a valid Contact or Lead ID
                S2V__SMS_Template_Name__c = 'Test Template ' + i,
                S2V__SMS_Template_Description__c = 'Test Description ' + i,
                S2V__ActiveScheduleRecordId__c = ASRecord.id
            );
            fvRecords.add(fv);
        }
        insert fvRecords;
    }

    @isTest
    static void testBatchSuccessScenario() {
        // Fetch records for batch processing
        List<S2V__Future_Voicemails__c> fvRecords = [SELECT Id, S2V__Status__c, S2V__Related_to_Id__c,S2V__ActiveScheduleRecordId__c, 
                                                     S2V__SMS_Template_Name__c, S2V__SMS_Template_Description__c 
                                                     FROM S2V__Future_Voicemails__c];
        
         List<Airwaves360_Active_Schedule__c> ASRecords = [SELECT Id,S2V__Activity_History__c, S2V__Sending_Method__c,S2V__Recording_Number__c
                                                     FROM Airwaves360_Active_Schedule__c];


        // Instantiate batch with success = TRUE
        BatchClassForFVUpdate batchJob = new BatchClassForFVUpdate(true, fvRecords,ASRecords);
		 System.assertEquals(ASRecords.size(),1);
        Test.startTest();
        Database.executeBatch(batchJob, 5); // Ensuring the batch processes in one execution
        Test.stopTest();

    }

    @isTest
    static void testBatchFailureScenario() {
        // Fetch records for batch processing
        List<S2V__Future_Voicemails__c> fvRecords = [SELECT Id, S2V__Status__c FROM S2V__Future_Voicemails__c];
        List<Airwaves360_Active_Schedule__c> ASRecords = [SELECT Id,S2V__Activity_History__c, S2V__Sending_Method__c
                                                     FROM Airwaves360_Active_Schedule__c];


        // Instantiate batch with success = FALSE
        BatchClassForFVUpdate batchJob = new BatchClassForFVUpdate(false, fvRecords,ASRecords);
		System.assertEquals(ASRecords.size(),1);
        Test.startTest();
        Database.executeBatch(batchJob, 5); // Ensuring the batch processes in one execution
        Test.stopTest();

        
    }
}