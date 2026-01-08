public With Sharing class BatchClassForFVUpdate implements Database.Batchable<SObject> {
    
    public Boolean isSuccess;
    public List<S2V__Future_Voicemails__c> lstOfInsertedFV;
    List<S2V__Future_Voicemails__c> LstOfFVToUpdate = new List<S2V__Future_Voicemails__c>();
    List<Task> lstOftasktoInsert = new List<Task>();
    public List<S2V__Airwaves360_Active_Schedule__c> LstOfASObj;
    
    public BatchClassForFVUpdate(Boolean isSuccess , List<S2V__Future_Voicemails__c> lstOfInsertedFV,List<S2V__Airwaves360_Active_Schedule__c> LstOfASObj) {
        this.isSuccess = isSuccess;
        this.lstOfInsertedFV = lstOfInsertedFV;
        this.LstOfASObj = LstOfASObj;
    }
    public  Iterable<SObject> start(Database.BatchableContext BC) {
        return lstOfInsertedFV;
    }
    
    public void execute(Database.BatchableContext BC, List<S2V__Future_Voicemails__c> lstOfInsertedFV) {
        Map<Id,S2V__Airwaves360_Active_Schedule__c> MapOfIdAndASRecord = new Map<Id,S2V__Airwaves360_Active_Schedule__c>();
        MapOfIdAndASRecord = new Map<Id, S2V__Airwaves360_Active_Schedule__c>(
                [SELECT Id, S2V__Activity_History__c, S2V__Sending_Method__c FROM S2V__Airwaves360_Active_Schedule__c WHERE Id IN :LstOfASObj]
            );
        
        if(lstOfInsertedFV.size()>0){
            for(S2V__Future_Voicemails__c ObjFV : lstOfInsertedFV) {
                       //UPDATES THE FUTURE VOICEMAIL RECORDS STATUS AS SENT
                       if(isSuccess ==TRUE) {
                           
                           if(MapOfIdAndASRecord.size()>0 && MapOfIdAndASRecord.ContainsKey(ObjFV.S2V__ActiveScheduleRecordId__c)){
                               if(MapOfIdAndASRecord.get(ObjFV.S2V__ActiveScheduleRecordId__c).S2V__Activity_History__c == true){
                                   
                                   if(MapOfIdAndASRecord.get(ObjFV.S2V__ActiveScheduleRecordId__c).S2V__Sending_Method__c == 'SMS' ) 
                                   {
                                       Task tsk = new Task();
                                       tsk.Status = 'completed';
                                       tsk.Subject = Commonconstant.smstitle;
                                       tsk.WhoId = ObjFV.S2V__Related_to_Id__c;
                                       tsk.S2V__SMS_Template_Name__c = ObjFV.S2V__SMS_Template_Name__c;
                                       tsk.Description = ObjFV.S2V__SMS_Template_Description__c;
                                       if(!lstOftasktoInsert.contains(tsk)){
                                           lstOftasktoInsert.add(tsk); 
                                       }
                                   } 
                               }
                           }
                       }
            }
        }
       
        
        if(lstOftasktoInsert.size()>0)
        {
            //INSERTS TASK IN SALESFORCE
            if (!Test.isRunningTest()) {
                CommonHandlerForTriggers.isAlreadyInserted = true;
                //Insert lstOftasktoInsert;
                SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, lstOftasktoInsert);
                insert securityDecision.getRecords();
                
            }
        }
    }
    public void finish(Database.BatchableContext BC) {}
}