public with sharing class SMSTemplateTriggerHandler {
    
    public static void handleAfterUpdate(List<S2V__SMS_Template__c> newRecords, Map<Id, S2V__SMS_Template__c> oldMap) {
        
        // List to store the active schedules to update
        List<S2V__Airwaves360_Active_Schedule__c> activeSchedulesToUpdate = new List<S2V__Airwaves360_Active_Schedule__c>();
        
        // Collect template names whose body has changed
        Set<String> updatedTemplateNames = new Set<String>();
        
        // Step 1: Identify changed templates
        for(S2V__SMS_Template__c newRecord : newRecords) {
            if(oldMap.containsKey(newRecord.Id)) {
                S2V__SMS_Template__c oldRecord = oldMap.get(newRecord.Id);
                // If Template Body has changed, track the template name
                if(oldRecord.S2V__Template_Body__c != newRecord.S2V__Template_Body__c) {
                    updatedTemplateNames.add(newRecord.S2V__Template_Name__c);
                }
            }
        }
        
        // Step 2: Query all active schedules associated with updated templates
        List<S2V__Airwaves360_Active_Schedule__c> activeSchedules = new List<S2V__Airwaves360_Active_Schedule__c>();
        
        if(!updatedTemplateNames.isEmpty()) {
            activeSchedules = [
                SELECT Id, S2V__SMS_Template_Name__c, S2V__SMS_Template_Body_New__c
                FROM S2V__Airwaves360_Active_Schedule__c
                WHERE S2V__SMS_Template_Name__c IN :updatedTemplateNames
                AND S2V__Is_Active__c = true WITH SECURITY_ENFORCED
            ];
        }
        
        // Create a map to associate updated templates by their name
        Map<String, S2V__SMS_Template__c> templateMap = new Map<String, S2V__SMS_Template__c>();
        for(S2V__SMS_Template__c template : newRecords) {
            templateMap.put(template.S2V__Template_Name__c, template);
        }
        
        // Step 3: Update the body of the active schedules
        for(S2V__Airwaves360_Active_Schedule__c schedule : activeSchedules) {
            // Check if the templateMap contains the template name key before accessing it
            if (templateMap.containsKey(schedule.S2V__SMS_Template_Name__c)) {
                // Find the corresponding updated template from the map
                S2V__SMS_Template__c updatedTemplate = templateMap.get(schedule.S2V__SMS_Template_Name__c);
                
                // If template is found, update the schedule
                if (updatedTemplate != null && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.isUpdateable() 
                    && Schema.sObjectType.S2V__SMS_Template__c.fields.S2V__Template_Body__c.isAccessible() 
                    && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.fields.S2V__SMS_Template_Body_New__c.isUpdateable()) {
                      schedule.S2V__SMS_Template_Body_New__c = updatedTemplate.S2V__Template_Body__c;
                      activeSchedulesToUpdate.add(schedule);
                }
            }
        }
        // Step 4: Perform DML update if necessary
        
        if(!activeSchedulesToUpdate.isEmpty() && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.isUpdateable() && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.fields.S2V__SMS_Template_Name__c.isUpdateable()
           && Schema.sObjectType.S2V__SMS_Template__c.fields.S2V__Template_Body__c.isAccessible()  && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.fields.S2V__SMS_Template_Body_New__c.isUpdateable()) {
               update activeSchedulesToUpdate;
           }
    }
}