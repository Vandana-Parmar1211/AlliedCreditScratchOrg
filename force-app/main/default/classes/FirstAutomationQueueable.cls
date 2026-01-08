public With Sharing class FirstAutomationQueueable implements Queueable, Database.AllowsCallouts {
    public List<sObject> recordsToProcess;  // List to hold records of any object type
    public String selectedObject;  // The object type (e.g., 'Task', 'Contact', etc.)
    public List<S2V__Airwaves360_Active_Schedule__c> activelist;
    List<sObject> GetUpdatedRecord = new List<sObject>();
    Map<Id,S2V__Airwaves360_Active_Schedule__c> mapOfRecANDASId = new Map<Id,S2V__Airwaves360_Active_Schedule__c>(); 
    
    // Constructor to initialize with object type, records, old records (for update), and operation type 
    public FirstAutomationQueueable(List<S2V__Airwaves360_Active_Schedule__c> activelist,string selectedObject,List<sObject> GetUpdatedRecord,Map<Id,S2V__Airwaves360_Active_Schedule__c> mapOfRecANDASId) {
        
        this.activelist = activelist;
        this.recordsToProcess = GetUpdatedRecord;
        this.selectedObject = selectedObject;
        this.mapOfRecANDASId = mapOfRecANDASId;
    }
    
    public void execute(QueueableContext context) {
       
    }
}