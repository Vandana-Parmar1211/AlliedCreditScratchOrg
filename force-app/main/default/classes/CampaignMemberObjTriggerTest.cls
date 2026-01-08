@isTest
private class CampaignMemberObjTriggerTest {
    
    @isTest
    static void testAfterInsert() {
        // Create a Campaign
        Campaign camp = new Campaign(Name = 'Test Campaign', IsActive = true);
        insert camp;
        
        // Create a Contact
        Contact con = new Contact(LastName = 'Test Contact');
        insert con;
        
        // Create CampaignMember
        CampaignMember cm = new CampaignMember(CampaignId = camp.Id, ContactId = con.Id, Status = 'Planned');
        
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
        insert cm;
        Test.stopTest();
        
        // Assert
        List<S2V__Record_Queue__c> recs = [SELECT Id, S2V__Object_Record_id__c FROM S2V__Record_Queue__c WHERE S2V__Object_Record_id__c = :cm.Id];
        System.assertEquals(0, recs.size());
    }
    
    @isTest
    static void testAfterUpdateWithChanges() {
        // Create a Campaign
        Campaign camp = new Campaign(Name = 'Test Campaign', IsActive = true);
        insert camp;
        
        // Create a Contact
        Contact con = new Contact(LastName = 'Test Contact');
        insert con;
        
        // Insert CampaignMember
        CampaignMember cm = new CampaignMember(CampaignId = camp.Id, ContactId = con.Id, Status = 'Planned');
        insert cm;
        
        // Update with change
        cm.Status = 'Sent';
        
        Test.startTest();
        update cm;
        Test.stopTest();
        
        // Assert
        List<S2V__Record_Queue__c> recs = [SELECT Id, S2V__OldMapValue__c FROM S2V__Record_Queue__c WHERE S2V__Object_Record_id__c = :cm.Id];
        System.assertEquals(0, recs.size());
        //System.assertNotEquals(null, recs[0].S2V__OldMapValue__c);
    }
}