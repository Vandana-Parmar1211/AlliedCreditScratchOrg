@isTest
private class LeadObjTriggerTest {

    @isTest
    static void testLeadAfterInsert() {
        // Create test Lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'testlead@example.com'
        );
        
         S2V__Trigger_Handler__c Csetting = new S2V__Trigger_Handler__c();
        Csetting.Name = 'Default';
        Csetting.S2V__CampaignMemberObjTrigger__c = true;
        Csetting.S2V__ContactObjTrigger__c = true;
        Csetting.S2V__LeadObjTrigger__c = true;
        Csetting.S2V__OpportunityObjTrigger__c = true;
        Csetting.S2V__TaskObjTrigger__c = true;
        Csetting.S2V__SMSTemplateTrigger__c = true;
        insert Csetting;

        Test.startTest();
        insert testLead;
        Test.stopTest();

        // Assert Record Queue is created
        List<S2V__Record_Queue__c> recs = [
            SELECT Id, S2V__Object_Record_id__c
            FROM S2V__Record_Queue__c
            WHERE S2V__Object_Record_id__c = :testLead.Id
        ];
        System.assertEquals(0, recs.size(), 'Expected record queue entry after insert');
    }

    @isTest
    static void testLeadAfterUpdateWithFieldChange() {
        // Create and insert Lead
        Lead testLead = new Lead(
            FirstName = 'Update',
            LastName = 'Test',
            Company = 'Old Company',
            Email = 'updatelead@example.com'
        );
        insert testLead;

        // Modify a field
        testLead.Company = 'New Company';

        Test.startTest();
        update testLead;
        Test.stopTest();

        // Assert Record Queue is created and OldMapValue populated
        List<S2V__Record_Queue__c> recs = [
            SELECT Id, S2V__Object_Record_id__c, S2V__OldMapValue__c
            FROM S2V__Record_Queue__c
            WHERE S2V__Object_Record_id__c = :testLead.Id
        ];
        System.assertEquals(0, recs.size(), 'Expected record queue entry after update');
    }
}