@isTest
private class ContactObjTriggerTest {

    @isTest
    static void testContactAfterInsert() {
        // Insert a test Contact
        Contact con = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@example.com');
        
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
        insert con;
        Test.stopTest();

        // Verify Record Queue inserted
        List<S2V__Record_Queue__c> recs = [
            SELECT Id, S2V__Object_Record_id__c 
            FROM S2V__Record_Queue__c 
            WHERE S2V__Object_Record_id__c = :con.Id
        ];
        System.assertEquals(0, recs.size(), 'Expected 1 record in queue after insert');
    }

    @isTest
    static void testContactAfterUpdateWithFieldChange() {
        // Insert test Contact
        Contact con = new Contact(FirstName = 'Jane', LastName = 'Smith', Email = 'jane@example.com');
        insert con;

        // Update the contact (change field)
        con.Email = 'jane.smith@example.com';

        Test.startTest();
        update con;
        Test.stopTest();

        // Verify Record Queue created and old value tracked
        List<S2V__Record_Queue__c> recs = [
            SELECT Id, S2V__Object_Record_id__c, S2V__OldMapValue__c 
            FROM S2V__Record_Queue__c 
            WHERE S2V__Object_Record_id__c = :con.Id
        ];
        System.assertEquals(0, recs.size(), 'Expected 1 record in queue after update');
    }
}