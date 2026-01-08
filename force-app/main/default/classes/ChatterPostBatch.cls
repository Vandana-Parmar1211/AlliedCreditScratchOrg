global With Sharing class ChatterPostBatch implements Database.Batchable<SObject> {
    Map<Id,String> mapOfTaskIdAndErrorMsg = new Map<Id,String>();
    Map<Id,String> mapOfTaskIdAndErrorMsgDescription = new Map<Id,String>();
    
    // Constructor
    public ChatterPostBatch(Map<Id,String> mapOfTaskIdAndErrorMsg,Map<Id,String> mapOfTaskIdAndErrorMsgDescription) {
        this.mapOfTaskIdAndErrorMsg = mapOfTaskIdAndErrorMsg;
        this.mapOfTaskIdAndErrorMsgDescription = mapOfTaskIdAndErrorMsgDescription;
    }
    
    // Start Method: Returns Dummy Query (No records needed)
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id,Subject,S2V__Received_Status__c,Owner.Name,who.Name,WhoId from Task where Id in :mapOfTaskIdAndErrorMsg.keySet()]); // Dummy query
    }
    
    // Execute Method: Processes the chatter posts
    global void execute(Database.BatchableContext BC, List<SObject> lstOfTaskToUPDT) {
        string customMsg;
        Id currentUserId = UserInfo.getUserId();
        
        for (SObject sobj : lstOfTaskToUPDT) {
            Task tskObj = (Task) sobj;
            if (mapOfTaskIdAndErrorMsg.containsKey(tskObj.Id) && mapOfTaskIdAndErrorMsg.get(tskObj.Id) != null) {
                tskObj.S2V__Received_Status__c = mapOfTaskIdAndErrorMsg.get(tskObj.Id);
            }
        }
        system.debug('@@lstOfTaskToUPDT'+lstOfTaskToUPDT);
        if(lstOfTaskToUPDT.size()>0){
            Update lstOfTaskToUPDT;
        }  
    }
    // Finish Method: Runs at the end of the batch
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch ChatterPostBatch completed');
    }
}