public With Sharing class FirstQueueableForFromNumberGrouping implements Queueable, Database.AllowsCallouts {
    public List<sObject> recordsToProcess;
    public String selectedObject; 
    Map<Id,S2V__Airwaves360_Active_Schedule__c> mapOfRecANDASId = new Map<Id,S2V__Airwaves360_Active_Schedule__c>();
    LIST<S2V__Future_Voicemails__c> listToInsertFV = new List<S2V__Future_Voicemails__c>();
    Map<Id, Id> MapOfRecIdandReferenceId = new Map<Id, Id>();
    Map<Id,List<S2V__Future_Voicemails__c>> MapOfIdAsANDLstOfFVObj = new Map<Id,List<S2V__Future_Voicemails__c>>();
    
    // Constructor to initialize with object type, records, old records (for update), and operation type 
    public FirstQueueableForFromNumberGrouping(List<sObject> recordsToProcessAhead,string selectedObject,Map<Id,S2V__Airwaves360_Active_Schedule__c> mapOfRecANDASId) {
        
        this.recordsToProcess = recordsToProcessAhead;
        this.selectedObject = selectedObject;
        this.mapOfRecANDASId = mapOfRecANDASId;
        
    }
    public void execute(QueueableContext context) {
        system.debug('@@recordsToProcess--'+recordsToProcess);
        system.debug('@@recordsToProcess--'+recordsToProcess.size());
        system.debug('@@selectedObject--'+selectedObject);
        system.debug('@@mapOfRecANDASId--'+mapOfRecANDASId);
        List<S2V__Airwaves360_Active_Schedule__c> LstOfASObj = new List<S2V__Airwaves360_Active_Schedule__c>();
        String objectName;
        if(selectedObject != null && selectedObject != ''){
            objectName = String.escapeSingleQuotes(selectedObject);  //PREVENT SOQL INJECTION
        }
        if(recordsToProcess.size()>0){
            for(sObject obj : recordsToProcess) {
                Boolean isSMS = true;
                if(mapOfRecANDASId.containsKey(obj.id) && mapOfRecANDASId.get(obj.id) != null){
                    LstOfASObj.add(mapOfRecANDASId.get(obj.id));   
                }
                if(Schema.sObjectType.S2V__Future_Voicemails__c.isCreateable()
                   && Schema.sObjectType.S2V__Future_Voicemails__c.fields.S2V__Record_Id__c.isCreateable()
                   && Schema.sObjectType.S2V__Future_Voicemails__c.fields.S2V__Sobject_Name__c.isCreateable()
                   && Schema.sObjectType.S2V__Future_Voicemails__c.fields.S2V__Status__c.isCreateable()
                   && Schema.sObjectType.S2V__Future_Voicemails__c.fields.S2V__Sending_method__c.isCreateable()
                   && Schema.sObjectType.S2V__Future_Voicemails__c.fields.S2V__ContactId__c.isCreateable()
                   && Schema.sObjectType.S2V__Future_Voicemails__c.fields.S2V__LeadId__c.isCreateable()
                   && Schema.sObjectType.S2V__Future_Voicemails__c.fields.S2V__ActiveScheduleRecordId__c.isCreateable()) {
                       S2V__Future_Voicemails__c fvObj = new S2V__Future_Voicemails__c();
                       fvObj.S2V__Record_Id__c = obj.id;
                       if (obj instanceof Task) {
                           Id whoId = (Id) obj.get('WhoId');
                           fvObj.S2V__Related_to_Id__c = whoId;
                           if (obj.get('WhoId') != null && mapOfRecANDASId.get(obj.id).S2V__Reference_Field__c != null) {
                               string refferenceField = mapOfRecANDASId.get(obj.id).S2V__Reference_Field__c;
                               if(obj.get(refferenceField) != null && obj.get(refferenceField) != ''){
                                   MapOfRecIdandReferenceId.put(obj.Id,(Id)obj.get(refferenceField)); 
                               }
                           }
                       }
                       //added by foram
                       if(mapOfRecANDASId.get(obj.id).S2V__SMS_Template_Name__c != null){
                           fvObj.S2V__SMS_Template_Name__c = mapOfRecANDASId.get(obj.id).S2V__SMS_Template_Name__c;
                       }
                       if(mapOfRecANDASId.get(obj.id).S2V__SMS_Template_Body_New__c != null){
                           fvObj.S2V__SMS_Template_Description__c = mapOfRecANDASId.get(obj.id).S2V__SMS_Template_Body_New__c;
                       }
                       fvObj.S2V__Sobject_Name__c = selectedObject;
                       fvObj.S2V__Status__c = 'Queue';
                       if(isSMS == true){
                           fvObj.S2V__Sending_method__c = 'SMS';
                       }else if(isSMS == false){
                           fvObj.S2V__Sending_method__c = 'Voicemail';
                       }
                       fvObj.S2V__ActiveScheduleRecordId__c = mapOfRecANDASId.get(obj.id).id;
                       if(selectedObject == 'Contact')
                       {
                           fvObj.S2V__ContactId__c = obj.id;
                       }
                       else if(selectedObject == 'Lead')
                       {
                           fvObj.S2V__LeadId__c = obj.id;
                       }
                       if(mapOfRecANDASId.get(obj.id).S2V__Option_Schedule__c == 'Future Call' && mapOfRecANDASId.get(obj.id).S2V__Sending_method__c == 'SMS'){
                           fvObj.S2V__Option_Schedule__c = mapOfRecANDASId.get(obj.id).S2V__Option_Schedule__c;
                           if(mapOfRecANDASId.get(obj.id).S2V__Schedule_Time__c != null){
                               fvObj.S2V__Schedule_Time__c = mapOfRecANDASId.get(obj.id).S2V__Schedule_Time__c;
                           }
                           if(mapOfRecANDASId.get(obj.id).S2V__Schedule_TIme_textBox__c != null){
                               fvObj.S2V__Schedule_TIme_textBox__c = mapOfRecANDASId.get(obj.id).S2V__Schedule_TIme_textBox__c;
                           }
                       }
                       listToInsertFV.add(fvObj);
                   }
            }
        }
        if(listToInsertFV!=NULL && listToInsertFV.size()>0  && Schema.sObjectType.S2V__Future_Voicemails__c.isCreateable()
           && Schema.sObjectType.S2V__Future_Voicemails__c.fields.S2V__Record_Id__c.isCreateable()
           && Schema.sObjectType.S2V__Future_Voicemails__c.fields.S2V__Sobject_Name__c.isCreateable()
           && Schema.sObjectType.S2V__Future_Voicemails__c.fields.S2V__Status__c.isCreateable()
           && Schema.sObjectType.S2V__Future_Voicemails__c.fields.S2V__Sending_method__c.isCreateable()
           && Schema.sObjectType.S2V__Future_Voicemails__c.fields.S2V__ContactId__c.isCreateable()
           && Schema.sObjectType.S2V__Future_Voicemails__c.fields.S2V__LeadId__c.isCreateable()
           && Schema.sObjectType.S2V__Future_Voicemails__c.fields.S2V__ActiveScheduleRecordId__c.isCreateable())
        {
            insert listToInsertFV;
            if(LstOfASObj != null && LstOfASObj.size()>0){
                //Batch that updates FV status and creates Activity for the successful VM Campaign creation in Airwaves
                Database.executeBatch(new BatchClassForFVUpdate(true, listToInsertFV,LstOfASObj), 200);  
            }
        }
        //Creates map of User and respective Future Voicemail records which are triggered by that user
        for(S2V__Future_Voicemails__c FVs : listToInsertFV){
            
            if(MapOfRecIdandReferenceId.containsKey(FVs.S2V__Record_Id__c)){
                if(MapOfIdAsANDLstOfFVObj.containsKey(MapOfRecIdandReferenceId.get(FVs.S2V__Record_Id__c))){
                    MapOfIdAsANDLstOfFVObj.get(MapOfRecIdandReferenceId.get(FVs.S2V__Record_Id__c)).add(FVs);
                }else{
                    List<S2V__Future_Voicemails__c> lstoffvtrmp = new List <S2V__Future_Voicemails__c>();
                    lstoffvtrmp.add(FVs);
                    MapOfIdAsANDLstOfFVObj.put(MapOfRecIdandReferenceId.get(FVs.S2V__Record_Id__c),lstoffvtrmp);
                } 
            }
        }
        if(!Test.IsRunningTest()) {
            //Second Queueable for creating sms in Airwaves
           System.enqueueJob(new SecondQueueableForAutomation(MapOfIdAsANDLstOfFVObj,selectedObject));
        }
    }
}