public class BatchToUpdtObjectToSMSSent implements Database.Batchable<SObject> {
    
    private Set<Id> taskIds;

    public BatchToUpdtObjectToSMSSent(Set<Id> taskIdsToUpdate) {
        this.taskIds = taskIdsToUpdate;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, S2V__Airwaves_Message_Sent__c
            FROM Task
            WHERE Id IN :taskIds
        ]);
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Task> tasksToUpdate = new List<Task>();
        
        for (SObject s : scope) {
            Task t = (Task)s;
            t.S2V__Airwaves_Message_Sent__c = true;
            tasksToUpdate.add(t);
        }

        if (!tasksToUpdate.isEmpty()) {
            update tasksToUpdate;
        }
        
        List<S2V__Future_Voicemails__c> lstOfFVs =[select Id,S2V__Status__c from S2V__Future_Voicemails__c where S2V__Record_Id__c in :taskIds];
        for(S2V__Future_Voicemails__c  FV :lstOfFVs){
            FV.S2V__Status__c ='Sent';
        }
         if (!lstOfFVs.isEmpty()) {
            update lstOfFVs;
        }
        
    }

    public void finish(Database.BatchableContext bc) {
        // Optional: Add any post-processing or logging here
    }
}