trigger SMSTemplateTrigger on S2V__SMS_Template__c (after update) {

    if(Trigger.isAfter && Trigger.isUpdate) {
        SMSTemplateTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}