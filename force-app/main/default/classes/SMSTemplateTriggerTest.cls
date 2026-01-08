@isTest
private class SMSTemplateTriggerTest {

    @isTest
    static void testHandleAfterUpdate() {
        // Step 1: Create a test SMS template
        S2V__SMS_Template__c smsTemplate = new S2V__SMS_Template__c(
            S2V__Template_Name__c = 'Template_1',
            S2V__Template_Body__c = 'Initial Body'
        );
        insert smsTemplate;

        // Step 2: Create a test active schedule related to this template
        S2V__Airwaves360_Active_Schedule__c activeSchedule = new S2V__Airwaves360_Active_Schedule__c(
            S2V__SMS_Template_Name__c = smsTemplate.S2V__Template_Name__c,
            S2V__Is_Active__c = true,
            S2V__SMS_Template_Body__c = 'Initial Body',
            S2V__SMS_Template_Body_New__c = 'Old Body'
        );
        insert activeSchedule;

        // Step 3: Update the SMS template (this should trigger the handler logic)
        smsTemplate.S2V__Template_Body__c = 'Updated Body';
        update smsTemplate;

        // Step 4: Verify that the active schedule's body has been updated correctly
        List<S2V__Airwaves360_Active_Schedule__c> updatedSchedules = [
            SELECT S2V__SMS_Template_Body_New__c, S2V__SMS_Template_Name__c
            FROM S2V__Airwaves360_Active_Schedule__c
            WHERE S2V__SMS_Template_Name__c = :smsTemplate.S2V__Template_Name__c
        ];

        // Assert that the new body is applied to the active schedule's 'Body_New' field
        System.assertEquals('Updated Body', updatedSchedules[0].S2V__SMS_Template_Body_New__c, 
            'The active schedule body should have been updated to the new template body.');
    }

    @isTest
    static void testNoUpdateWhenBodyIsSame() {
        // Step 1: Create a test SMS template
        S2V__SMS_Template__c smsTemplate = new S2V__SMS_Template__c(
            S2V__Template_Name__c = 'Template_1',
            S2V__Template_Body__c = 'Initial Body'
        );
        insert smsTemplate;

        // Step 2: Create a test active schedule related to this template
        S2V__Airwaves360_Active_Schedule__c activeSchedule = new S2V__Airwaves360_Active_Schedule__c(
            S2V__SMS_Template_Name__c = smsTemplate.S2V__Template_Name__c,
            S2V__Is_Active__c = true,
            S2V__SMS_Template_Body__c = 'Initial Body',
            S2V__SMS_Template_Body_New__c = 'Old Body'
        );
        insert activeSchedule;

        // Step 3: Update the SMS template without changing the body
        smsTemplate.S2V__Template_Body__c = 'Initial Body'; // Same body
        update smsTemplate;

        // Step 4: Verify that the active schedule's body was NOT updated
        List<S2V__Airwaves360_Active_Schedule__c> updatedSchedules = [
            SELECT S2V__SMS_Template_Body_New__c
            FROM S2V__Airwaves360_Active_Schedule__c
            WHERE S2V__SMS_Template_Name__c = :smsTemplate.S2V__Template_Name__c
        ];

        // Assert that the body was not updated
        System.assertEquals('Old Body', updatedSchedules[0].S2V__SMS_Template_Body_New__c, 
            'The active schedule body should not have been updated.');
    }
}