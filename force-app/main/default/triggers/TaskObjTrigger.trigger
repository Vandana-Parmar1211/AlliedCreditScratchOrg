trigger TaskObjTrigger on Task (after insert, after update) {
    // Filter out tasks with Type = 'Email'
    List<S2V__Trigger_Handler__c> existingRecords = [SELECT Id,S2V__CampaignMemberObjTrigger__c,S2V__ContactObjTrigger__c,S2V__LeadObjTrigger__c,
                                                     S2V__OpportunityObjTrigger__c,S2V__SMSTemplateTrigger__c, S2V__TaskObjTrigger__c FROM S2V__Trigger_Handler__c limit 1];
    
    if (!existingRecords.isEmpty()) {
        if(existingRecords[0].S2V__TaskObjTrigger__c == true){
            List<Task> filteredTasks = new List<Task>();
            Map<Id, Task> oldMapFiltered = Trigger.isUpdate ? new Map<Id, Task>() : null;
            
            for (Task ObjTsk : Trigger.new) {
                if (ObjTsk.Type != 'Email') {
                    if(ObjTsk.S2V__Airwaves_Message__c == true && ObjTsk.S2V__Airwaves_Message_Sent__c == false){
                        filteredTasks.add(ObjTsk);
                        if (Trigger.isUpdate && Trigger.oldMap.containsKey(ObjTsk.Id)) {
                            oldMapFiltered.put(ObjTsk.Id, Trigger.oldMap.get(ObjTsk.Id));
                        }   
                    }
                    
                }else{
                    system.debug('Type email');
                }
            }
            // Proceed only if there's any relevant task to process
            if (!filteredTasks.isEmpty()) {
                CommonHandlerForTriggers.handleTrigger(
                    filteredTasks,
                    Trigger.isUpdate ? oldMapFiltered : null,
                    'Task',
                    Trigger.isUpdate,
                    Trigger.isInsert
                );
            }
        }
    }
}