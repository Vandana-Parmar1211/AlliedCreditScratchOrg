trigger LeadObjTrigger on Lead (after insert,after update) {
    
    List<S2V__Trigger_Handler__c> existingRecords = [SELECT Id,S2V__CampaignMemberObjTrigger__c,S2V__ContactObjTrigger__c,S2V__LeadObjTrigger__c,
                                                     S2V__OpportunityObjTrigger__c,S2V__SMSTemplateTrigger__c, S2V__TaskObjTrigger__c FROM S2V__Trigger_Handler__c limit 1];
    
    if (!existingRecords.isEmpty() && existingRecords[0].S2V__LeadObjTrigger__c == true ) {
        
        CommonHandlerForTriggers.handleTrigger(
            Trigger.new,
            Trigger.isUpdate ? Trigger.oldMap : null,
            'Lead',
            Trigger.isUpdate,
            Trigger.isInsert
        );
    }
}