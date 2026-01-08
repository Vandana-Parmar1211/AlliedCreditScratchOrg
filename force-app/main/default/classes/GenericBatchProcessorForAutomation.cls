Global with sharing class GenericBatchProcessorForAutomation implements Database.Batchable<sObject>, Database.Stateful {
    PUBLIC List<sObject> recordsToProcess;  // List to hold records of any object type
    PUBLIC Map<Id, sObject> oldRecordsMap;  // Holds the old records map (for update)
    PUBLIC String objectType;  // The object type (e.g., 'Task', 'Contact', etc.)
    PUBLIC Boolean isInsert;  // Flag for insert or update
    PUBLIC Map<String, S2V__Airwaves360_Active_Schedule__c> ActiveScheduleMap = new Map<String, S2V__Airwaves360_Active_Schedule__c>();
    PUBLIC Map<String, String> mapActivescheduleIdString = new Map<String, String>();
    PUBLIC List<Id> lstOfObjIds = new List<Id>();
    PUBLIC LIST<Future_Voicemails__c> listToInsertFV = new List<Future_Voicemails__c>();
     PUBLIC Map<String,LIST<Future_Voicemails__c>> MapOfConditionAndFV = new Map<String,LIST<Future_Voicemails__c>> ();
    Global static Boolean hasRunOnceFlag = false;
    Global String StringOfIds;
    List<S2V__Airwaves360_Active_Schedule__c> lstOfMatchAC = new List<S2V__Airwaves360_Active_Schedule__c>();
    Map<Id,String> MapOfIdStrOfAs = new Map<Id,String>();
        Set<Id> LstOfASIds = new Set<Id>();
    
    // Constructor to initialize with object type, records, old records (for update), and operation type
    Global GenericBatchProcessorForAutomation(List<sObject> records, String objType, Boolean isInsertFlag, Map<Id, sObject> oldMap) {
        system.debug('@@records'+records);
        System.debug('@@@ isInsertFlag = '+isInsertFlag);
        this.recordsToProcess = records;
        this.objectType = objType;
        this.isInsert = isInsertFlag;
        this.oldRecordsMap = oldMap;  // Holds old records map for update scenarios
    }
    // Start method: Query all active schedules related to the object type
    Global Iterable<SObject> start(Database.BatchableContext BC) {
        // Query active schedules for the specific object type
        List<S2V__Airwaves360_Active_Schedule__c> lstOfActiveSchedule = [
            SELECT Id,  S2V__Object_Name__c, S2V__Sending_Method__c, S2V__S2vQuery__c, S2V__Option_Schedule__c,S2V__Schedule_Time__c,S2V__Schedule_TIme_textBox__c
            FROM S2V__Airwaves360_Active_Schedule__c
            WHERE S2V__Object_Name__c = :objectType WITH SECURITY_ENFORCED
        ];
        // Loop through and store active schedules in the map
        if (lstOfActiveSchedule != null && lstOfActiveSchedule.size() > 0) {
            for (S2V__Airwaves360_Active_Schedule__c activeschedule : lstOfActiveSchedule) {
                String whereclause = S2V.QueryParserClass.getWhereClause(activeschedule.S2V__S2vQuery__c);
                mapActivescheduleIdString.put(activeschedule.Id, whereclause);
                ActiveScheduleMap.put(activeschedule.Id, activeschedule);
            }
        }
        return recordsToProcess;
    }
    
    // Execute method: Process the records (tasks, contacts, etc.)
    Global void execute(Database.BatchableContext BC, List<sObject> recordsToProcess) {
        for (sObject record : recordsToProcess) {
            sObject oldRecord = null;
            if (!isInsert) {
                oldRecord = oldRecordsMap.get(record.Id);
            }
            system.debug('@@mapActivescheduleIdString'+mapActivescheduleIdString);
            for (String activescheduleId : mapActivescheduleIdString.keySet()) {
                Map<String, String> mapOfFieldAndValOfASQuery = new Map<String, String>();
                Map<String, String> mapOfFieldAndValOfASQueryNotEqual = new Map<String, String>();
                Integer sizeOfConditionMap= 0;
                Integer countOfMatchingValues = 0;
                Integer mapSizeCount = 0;
                mapOfFieldAndValOfASQueryNotEqual.clear();
                mapOfFieldAndValOfASQuery.clear();
                List<S2V__Airwaves360_Active_Schedule__c> activelist = new List<S2V__Airwaves360_Active_Schedule__c>();
                S2V__Airwaves360_Active_Schedule__c activeschedule = new S2V__Airwaves360_Active_Schedule__c();
                if(ActiveScheduleMap.ContainsKey(activescheduleId)){
                    activeschedule = ActiveScheduleMap.get(activescheduleId);
                }
                String wholeCondition;
                if(mapActivescheduleIdString.containsKey(activescheduleId)) {
                    wholeCondition =  mapActivescheduleIdString.get(activescheduleId);
                }
                system.debug('@@wholeCondition '+wholeCondition);
                 if(wholeCondition != null) {
                    if(wholeCondition.contains('!=') || wholeCondition.contains('>=') || wholeCondition.contains('<=') || wholeCondition.contains('<')|| wholeCondition.contains('>') || wholeCondition.contains('=')){
                        mapOfFieldAndValOfASQueryNotEqual = S2V.QueryParserClass.getWhereClauseFieldsAndItsValuesForAllOp(wholeCondition);
                    }
                }
                if(mapOfFieldAndValOfASQueryNotEqual != null && mapOfFieldAndValOfASQueryNotEqual.size()>0){
                    sizeOfConditionMap = mapOfFieldAndValOfASQueryNotEqual.size();
                    system.debug('mapOfFieldAndValOfASQueryNotEqual.size()'+mapOfFieldAndValOfASQueryNotEqual.size());
                    for (String field : mapOfFieldAndValOfASQueryNotEqual.keySet()) {
                        Schema.SObjectField fieldToken1 = record.getSObjectType().getDescribe().fields.getMap().get(field);
                        Schema.DescribeFieldResult fieldResult1 = fieldToken1.getDescribe();
                        String recordFieldValue1;
                        if (fieldResult1.getType() == Schema.DisplayType.Boolean) {
                            Boolean booleanValue = (Boolean) record.get(field);
                            recordFieldValue1 = booleanValue ? 'true' : 'false';
                        } else if(fieldResult1.getType() == Schema.DisplayType.Date ){
                            Date  dateVal = (Date ) record.get(field);
                            Datetime dateTimeVal;
                            if(dateVal != null){
                                Date selectedDate = Date.valueOf(dateVal);
                                DateTime dateTimeValue = DateTime.newInstance(selectedDate.year(), selectedDate.month(), selectedDate.day());
                                recordFieldValue1 =  dateTimeValue.format('yyyy-MM-dd');
                            }
                        } else {
                            recordFieldValue1 = String.valueOf(record.get(field));
                        }
                        if (isInsert) {
                            if(recordFieldValue1 == null && mapOfFieldAndValOfASQueryNotEqual.get(field) == 'null' ){
                                system.debug('@@nullvalue');
                                countOfMatchingValues++;
                            }
                            if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#!=#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#!=#', '');
                                if (recordFieldValue1 != valueOfmap) {
                                    system.debug('@@recordFieldValue1'+recordFieldValue1);
                                    countOfMatchingValues++;
                                }
                            }
                            else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#<=#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#<=#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if (recordFieldValue1 <= valueOfmap) {
                                        system.debug('@@recordFieldValue1'+recordFieldValue1);
                                        countOfMatchingValues++;
                                    }
                                } else{
                                    if (decimal.valueOf(recordFieldValue1) <= decimal.valueOf(valueOfmap)) {
                                        system.debug('@@recordFieldValue1'+recordFieldValue1);
                                        countOfMatchingValues++;
                                    }
                                }
                            }
                            else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#>=#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#>=#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if (recordFieldValue1 >= valueOfmap) {
                                        countOfMatchingValues++;
                                    }
                                } else{
                                    if (decimal.valueOf(recordFieldValue1) >= decimal.valueOf(valueOfmap)) {
                                        countOfMatchingValues++;
                                    }
                                }
                            }
                            else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#>#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#>#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if (recordFieldValue1 > valueOfmap) {
                                        system.debug('@@recordFieldValue1'+recordFieldValue1);
                                        countOfMatchingValues++;
                                    }
                                } else{
                                    if (decimal.valueOf(recordFieldValue1) > decimal.valueOf(valueOfmap)) {
                                        system.debug('@@recordFieldValue1'+recordFieldValue1);
                                        countOfMatchingValues++;
                                    }
                                }
                            }
                            else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#<#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#<#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if (recordFieldValue1 < valueOfmap) {
                                        system.debug('@@recordFieldValue1'+recordFieldValue1);
                                        countOfMatchingValues++;
                                    }
                                } else{
                                    if (decimal.valueOf(recordFieldValue1) < decimal.valueOf(valueOfmap)) {
                                        system.debug('@@recordFieldValue1'+recordFieldValue1);
                                        countOfMatchingValues++;
                                    }
                                }
                            }
                            else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#=#')){
                                system.debug('@@mapOfFieldAndValOfASQueryNotEqual.get(field)'+mapOfFieldAndValOfASQueryNotEqual.get(field));
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#=#', '');
                                
                                valueOfmap = valueOfmap.substring(1, valueOfmap.length() - 1); 
                                
                                
                                system.debug('@@valueOfmap'+valueOfmap);
                                system.debug('@@recordFieldValue1'+recordFieldValue1);
                                if(fieldResult1.getType() == Schema.DisplayType.Integer || fieldResult1.getType() == Schema.DisplayType.CURRENCY ||
                                   fieldResult1.getType() == Schema.DisplayType.DOUBLE || fieldResult1.getType() == Schema.DisplayType.PERCENT){
                                       if (decimal.valueOf(recordFieldValue1) == decimal.valueOf(valueOfmap)) {
                                           system.debug('@@recordFieldValue1'+recordFieldValue1);
                                           countOfMatchingValues++;
                                       }
                                   }else{
                                       if (recordFieldValue1 == valueOfmap) {
                                           system.debug('@@recordFieldValue1'+recordFieldValue1);
                                           countOfMatchingValues++;
                                       }
                                   }
                            }
                        } else {
                            if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#!=#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#!=#', '');
                                if (recordFieldValue1 != valueOfmap) {
                                    mapSizeCount++;
                                }
                            }
                            else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#>=#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#>=#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if (recordFieldValue1 >= valueOfmap) {
                                        mapSizeCount++;
                                    }
                                }else{
                                    if (decimal.valueOf(recordFieldValue1) >= decimal.valueOf(valueOfmap)) {
                                        mapSizeCount++;
                                    }
                                }
                            }
                            else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#<=#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#<=#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if (recordFieldValue1 <= valueOfmap) {
                                        mapSizeCount++;
                                    }
                                }else{
                                    if (decimal.valueOf(recordFieldValue1) <= decimal.valueOf(valueOfmap)) {
                                        mapSizeCount++;
                                    }
                                }
                            }
                            else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#<#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#<#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if (recordFieldValue1 < valueOfmap) {
                                        mapSizeCount++;
                                    }
                                }else{
                                    if (decimal.valueOf(recordFieldValue1) < decimal.valueOf(valueOfmap)) {
                                        mapSizeCount++;
                                    }
                                }
                            }
                            else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#>#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#>#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if (recordFieldValue1 > valueOfmap) {
                                        mapSizeCount++;
                                    }
                                }else{
                                    if (decimal.valueOf(recordFieldValue1) > decimal.valueOf(valueOfmap)) {
                                        mapSizeCount++;
                                    }
                                }
                            } 
                            else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#=#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#=#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Integer || fieldResult1.getType() == Schema.DisplayType.CURRENCY ||
                                   fieldResult1.getType() == Schema.DisplayType.DOUBLE || fieldResult1.getType() == Schema.DisplayType.PERCENT){
                                       if (decimal.valueOf(recordFieldValue1) == decimal.valueOf(valueOfmap)) {
                                           mapSizeCount++;
                                       }
                                   }else{
                                       if (recordFieldValue1 == valueOfmap) {
                                           mapSizeCount++;
                                       }
                                   }
                            }
                            
                            if(recordFieldValue1 == null && mapOfFieldAndValOfASQueryNotEqual.get(field) == 'null' ){
                                system.debug('@@nullvalue');
                                mapSizeCount++;
                                countOfMatchingValues++;
                            }
                            if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#!=#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#!=#', '');
                                if ((recordFieldValue1 != valueOfmap) && (record.get(field) != oldRecord.get(field))) {
                                    system.debug('@@recordFieldValue1-->'+recordFieldValue1);
                                    system.debug('@@valueOfmap-->'+valueOfmap);
                                    countOfMatchingValues++;
                                }
                            }
                            else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#>=#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#>=#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if ((recordFieldValue1 >= valueOfmap) && (record.get(field) != oldRecord.get(field))) {
                                        countOfMatchingValues++;
                                    }
                                }else{
                                    if ((decimal.valueOf(recordFieldValue1) >= decimal.valueOf(valueOfmap)) && (record.get(field) != oldRecord.get(field))) {
                                        countOfMatchingValues++;
                                    }
                                }
                            }
                            else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#<=#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#<=#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if ((recordFieldValue1 <= valueOfmap) && (record.get(field) != oldRecord.get(field))) {
                                        countOfMatchingValues++;
                                    }
                                }else{
                                    if ((decimal.valueOf(recordFieldValue1) <= decimal.valueOf(valueOfmap)) && (record.get(field) != oldRecord.get(field))) {
                                        countOfMatchingValues++;
                                    }
                                }
                            }
                            else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#>#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#>#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if ((recordFieldValue1 > valueOfmap) && (record.get(field) != oldRecord.get(field))) {
                                        countOfMatchingValues++;
                                    }
                                }else{
                                    if ((decimal.valueOf(recordFieldValue1) > decimal.valueOf(valueOfmap)) && (record.get(field) != oldRecord.get(field))) {
                                        countOfMatchingValues++;
                                    }
                                }
                            }
                            else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#<#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#<#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if ((recordFieldValue1 < valueOfmap) && (record.get(field) != oldRecord.get(field))) {
                                        countOfMatchingValues++;
                                    }
                                }else{
                                    if ((decimal.valueOf(recordFieldValue1) < decimal.valueOf(valueOfmap)) && (record.get(field) != oldRecord.get(field))) {
                                        countOfMatchingValues++;
                                    }
                                }
                            } 
                            else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#=#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#=#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Integer || fieldResult1.getType() == Schema.DisplayType.CURRENCY ||
                                   fieldResult1.getType() == Schema.DisplayType.DOUBLE || fieldResult1.getType() == Schema.DisplayType.PERCENT){
                                       if ((decimal.valueOf(recordFieldValue1) == decimal.valueOf(valueOfmap)) && (record.get(field) != oldRecord.get(field))) {
                                           countOfMatchingValues++;
                                       }
                                   }else{
                                       if ((recordFieldValue1 == valueOfmap) && (record.get(field) != oldRecord.get(field))) {
                                           countOfMatchingValues++;
                                       }
                                   }
                            }
                        }
                    }
                }
                system.debug('@@sizeOfConditionMap'+sizeOfConditionMap);
                system.debug('@@mapSizeCount'+mapSizeCount);
                system.debug('@@countOfMatchingValues'+countOfMatchingValues);
                if (isInsert) {
                    if (sizeOfConditionMap == countOfMatchingValues) {
                        activelist.add(activeschedule);
                        lstOfMatchAC.add(activeschedule);
                    }
                } else {
                    if (countOfMatchingValues > 0 && sizeOfConditionMap == mapSizeCount) {
                        activelist.add(activeschedule);
                        lstOfMatchAC.add(activeschedule);
                    }
                }
                system.debug('@@activelist'+activelist);
                system.debug('@@record.Id'+record.Id);
                if (activelist.size() > 0) {
                    Boolean isSMS = activelist[0].S2V__Sending_Method__c == 'SMS';
                    //S2V.Airwaves360Timezonevalidation.insertFutureSMS_VMMethod(objectType, isSMS, new List<Id>{record.Id}, 'Contact', 'WhoId', activescheduleId, activelist);
                    if(record.Id != NULL) {
                        lstOfObjIds.add(record.id);
                        String objectName = String.escapeSingleQuotes(objectType);  //PREVENT SOQL INJECTION
                        //for(ID objId : record.Id) {
                        if(Schema.sObjectType.Future_Voicemails__c.isCreateable()
                           && Schema.sObjectType.Future_Voicemails__c.fields.Record_Id__c.isCreateable()
                           && Schema.sObjectType.Future_Voicemails__c.fields.Sobject_Name__c.isCreateable()
                           && Schema.sObjectType.Future_Voicemails__c.fields.Status__c.isCreateable()
                           && Schema.sObjectType.Future_Voicemails__c.fields.S2V__Sending_method__c.isCreateable()
                           && Schema.sObjectType.Future_Voicemails__c.fields.ContactId__c.isCreateable()
                           && Schema.sObjectType.Future_Voicemails__c.fields.LeadId__c.isCreateable()
                           && Schema.sObjectType.Future_Voicemails__c.fields.S2V__ActiveScheduleRecordId__c.isCreateable()) {
                               Future_Voicemails__c fvObj = new Future_Voicemails__c();
                               fvObj.Record_Id__c = record.Id;
                               fvObj.Sobject_Name__c = objectType;
                               fvObj.Status__c = 'Queue';
                               if(IsSMS == true){
                                   fvObj.S2V__Sending_method__c = 'SMS';
                               }else if(IsSMS == false){
                                   fvObj.S2V__Sending_method__c = 'Voicemail';
                               }
                               fvObj.S2V__ActiveScheduleRecordId__c = ActiveScheduleId;
                               if(objectType == 'Contact')
                               {
                                   fvObj.ContactId__c = record.Id;
                               }
                               else if(objectType == 'Lead')
                               {
                                   fvObj.LeadId__c = record.Id;
                               }
                               if(activelist[0].S2V__Option_Schedule__c == 'Future Call' && activelist[0].S2V__Sending_method__c == 'SMS'){
                                   fvObj.S2V__Option_Schedule__c = activelist[0].S2V__Option_Schedule__c;
                                   if(activelist[0].S2V__Schedule_Time__c != null){
                                       fvObj.S2V__Schedule_Time__c = activelist[0].S2V__Schedule_Time__c;
                                   }
                                   if(activelist[0].S2V__Schedule_TIme_textBox__c != null){
                                       fvObj.S2V__Schedule_TIme_textBox__c = activelist[0].S2V__Schedule_TIme_textBox__c;
                                   }
                               }
                               listToInsertFV.add(fvObj);
                           }
                        // }
                    }
                    
                }
            }
        }
        system.debug('@@listToInsertFV'+listToInsertFV.size());
        if(listToInsertFV!=NULL && listToInsertFV.size()>0  && Schema.sObjectType.Future_Voicemails__c.isCreateable()
           && Schema.sObjectType.Future_Voicemails__c.fields.Record_Id__c.isCreateable()
           && Schema.sObjectType.Future_Voicemails__c.fields.Sobject_Name__c.isCreateable()
           && Schema.sObjectType.Future_Voicemails__c.fields.Status__c.isCreateable()
           && Schema.sObjectType.Future_Voicemails__c.fields.S2V__Sending_method__c.isCreateable()
           && Schema.sObjectType.Future_Voicemails__c.fields.ContactId__c.isCreateable()
           && Schema.sObjectType.Future_Voicemails__c.fields.LeadId__c.isCreateable()
           && Schema.sObjectType.Future_Voicemails__c.fields.S2V__ActiveScheduleRecordId__c.isCreateable())
        {
            insert listToInsertFV;
        }
       // StringOfIds =  '\'' + String.join(lstOfObjIds, '\',\'') + '\'';
       
    }
    
    Global void finish(Database.BatchableContext BC) {
        String soql = 'SELECT Id, S2V__Record_Id__c, S2V__Sobject_Name__c, S2V__Status__c,S2V__ActiveScheduleRecordId__c,CreatedDate';
        soql += ' FROM S2V__Future_Voicemails__c';
        soql += ' WHERE S2V__Status__c = '+ '\''+ CommonConstant.status + '\' AND S2V__Record_Id__c  IN (' + StringOfIds + ') AND S2V__Schedule_TIme_textBox__c = NULL ';
        //if(!Test.isrunningTest()) {
            // Airwaves360FutureVoicemailBatchNew batch = new Airwaves360FutureVoicemailBatchNew(soql);
            // Database.executebatch(batch, 2000);
       // }
       
      /*  S2V__CountTotalCallout__c  CTC = [SELECT Id, S2V__countCallout__c FROM S2V__CountTotalCallout__c  LIMIT 1];
        if (CTC != null) {
            CTC.S2V__countCallout__c += 1; // Increment the counter
            update CTC; // Save the updated value
        }*/
        system.debug('@@listToInsertFV in Finish'+listToInsertFV.size());
        for(Future_Voicemails__c FVs : listToInsertFV){
            LstOfASIds.add(FVs.S2V__ActiveScheduleRecordId__c);
        }
        
        for(S2V__Airwaves360_Active_Schedule__c ASObj :lstOfMatchAC){
            String whereclause = S2V.QueryParserClass.getWhereClause(ASObj.S2V__S2vQuery__c);
            MapOfIdStrOfAs.put(ASObj.id,whereclause);
        }
        List<Future_Voicemails__c> lstofFv = new List<Future_Voicemails__c>();
        for(Future_Voicemails__c FVs : listToInsertFV){
            if (MapOfIdStrOfAs.containsKey(FVs.S2V__ActiveScheduleRecordId__c)) {
                String whereclause = MapOfIdStrOfAs.get(FVs.S2V__ActiveScheduleRecordId__c);
                lstofFv.add(FVs);
                MapOfConditionAndFV.put(whereclause,lstofFv);// status= completed ,
            }
        }
        
       // System.enqueueJob(new QueueableForAutomation(MapOfConditionAndFV));
    }
}