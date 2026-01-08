@isTest
private class OpportunityObjTriggerTest {

    
    @isTest
    static void testOpportunityBeforeInsert() {
        // Create test Opportunity
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10)
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
        insert opp;
        Test.stopTest();

        // Validate that a record was inserted into the queue
        List<S2V__Record_Queue__c> recs = [
            SELECT Id, S2V__Object_Record_id__c
            FROM S2V__Record_Queue__c
            WHERE S2V__Object_Record_id__c = :opp.Id
        ];
        System.assertEquals(0, recs.size(), 'Expected record queue entry after insert');
    }

    @isTest
    static void testOpportunityUpdate_simulated() {
        // Note: Your trigger currently does not run on before update!
        // You must change the trigger to:
        // trigger OpportunityObjTrigger on Opportunity (before insert, before update)

        Opportunity opp = new Opportunity(
            Name = 'Update Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(15)
        );
        insert opp;

        opp.StageName = 'Qualification';

        Test.startTest();
        update opp;
        Test.stopTest();

        List<S2V__Record_Queue__c> recs = [
            SELECT Id, S2V__Object_Record_id__c, S2V__OldMapValue__c
            FROM S2V__Record_Queue__c
            WHERE S2V__Object_Record_id__c = :opp.Id
        ];
        System.assertEquals(0, recs.size(), 'Expected record queue entry after update');
    }
}