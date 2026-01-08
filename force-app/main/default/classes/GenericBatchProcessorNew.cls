Global with sharing class GenericBatchProcessorNew implements Database.Batchable<sObject>, Database.Stateful {
    PUBLIC List<sObject> recordsToProcess;  // List to hold records of any object type
    PUBLIC Map<Id, sObject> oldRecordsMap;  // Holds the old records map (for update)
    PUBLIC String objectType;  // The object type (e.g., 'Task', 'Contact', etc.)
    PUBLIC Boolean isInsert;  // Flag for insert or update
    PUBLIC Map<String, S2V__Airwaves360_Active_Schedule__c> ActiveScheduleMap = new Map<String, S2V__Airwaves360_Active_Schedule__c>();
    PUBLIC Map<String, String> mapActivescheduleIdString = new Map<String, String>();
    
    Global static Boolean hasRunOnce = false;
    private String StringOfIds;
    
    // Constructor to initialize with object type, records, old records (for update), and operation type
    Global GenericBatchProcessorNew(List<sObject> records, String objType, Boolean isInsertFlag, Map<Id, sObject> oldMap) {
        system.debug('@@records'+records);
        System.debug('@@@ isInsertFlag = '+isInsertFlag);
        this.recordsToProcess = records;
        this.objectType = objType;
        this.isInsert = isInsertFlag;
        this.oldRecordsMap = oldMap;  // Holds old records map for update scenarios
    }
    
    // Start method: Query all active schedules related to the object type
    Global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query active schedules for the specific object type
      /*  List<S2V__Airwaves360_Active_Schedule__c> lstOfActiveSchedule = [
            SELECT Id,  S2V__Object_Name__c, S2V__Sending_Method__c, S2V__S2vQuery__c, S2V__Option_Schedule__c,S2V__Schedule_Time__c,S2V__Schedule_TIme_textBox__c
            FROM S2V__Airwaves360_Active_Schedule__c
            WHERE S2V__Object_Name__c = :objectType
        ];
        // Loop through and store active schedules in the map
        if (lstOfActiveSchedule != null && lstOfActiveSchedule.size() > 0) {
            
            for (S2V__Airwaves360_Active_Schedule__c activeschedule : lstOfActiveSchedule) {
                String whereclause = S2V.QueryParserClass.getWhereClause(activeschedule.S2V__S2vQuery__c);
                mapActivescheduleIdString.put(activeschedule.Id, whereclause);
                ActiveScheduleMap.put(activeschedule.Id, activeschedule);
            }
        }*/
        return Database.getQueryLocator(
            'SELECT Id FROM ' + objectType + ' WHERE Id in : recordsToProcess' 
        );
    }
    
    // Execute method: Process the records (tasks, contacts, etc.)
    Global void execute(Database.BatchableContext BC, List<sObject> recordsInBatch) {
        List<Id> lstOfObjIds = new List<Id>();
        LIST<Future_Voicemails__c> listToInsertFV = new List<Future_Voicemails__c>();
     /*   for (sObject record : recordsToProcess) {
            
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
                    if(wholeCondition.contains('!=') || wholeCondition.contains('>=') || wholeCondition.contains('<=') || wholeCondition.contains('<')|| wholeCondition.contains('>')){
                        system.debug('Not equals to');
                        mapOfFieldAndValOfASQueryNotEqual = S2V.QueryParserClass.getWhereClauseFieldsAndItsValues(wholeCondition);
                    }else if (!wholeCondition.contains('!=') || !wholeCondition.contains('>=') || !wholeCondition.contains('<=') || !wholeCondition.contains('<')|| !wholeCondition.contains('>')){
                        mapOfFieldAndValOfASQuery = S2V.QueryParserClass.getWhereClauseFieldsAndItsValues(wholeCondition);
                    }
                }
                
                if(mapOfFieldAndValOfASQueryNotEqual != null && mapOfFieldAndValOfASQueryNotEqual.size()>0){
                    system.debug('in if condition');
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
                            system.debug('@@mapOfFieldAndValOfASQueryNotEqual-->'+mapOfFieldAndValOfASQueryNotEqual);
                            if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#!=#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#!=#', '');
                                if (recordFieldValue1 != valueOfmap) {
                                    system.debug('@@recordFieldValue1'+recordFieldValue1);
                                    countOfMatchingValues++;
                                } 
                                
                            }else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#<=#')){
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
                                
                            }else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#>=#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#>=#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if (recordFieldValue1 >= valueOfmap) {
                                        system.debug('@@recordFieldValue1'+recordFieldValue1);
                                        countOfMatchingValues++;
                                    }
                                } else{
                                    if (decimal.valueOf(recordFieldValue1) >= decimal.valueOf(valueOfmap)) {
                                        system.debug('@@recordFieldValue1'+recordFieldValue1);
                                        countOfMatchingValues++;
                                    } 
                                }
                            }else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#>#')){
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
                            }else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#<#')){
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
                            else {
                                system.debug('@@FinalrecordFieldValue1 -- '+recordFieldValue1);
                                system.debug('@@mapOfFieldAndValOfASQueryNotEqual.get(field) --'+mapOfFieldAndValOfASQueryNotEqual.get(field));
                                if(fieldResult1.getType() == Schema.DisplayType.Integer || fieldResult1.getType() == Schema.DisplayType.CURRENCY ||
                                   fieldResult1.getType() == Schema.DisplayType.DOUBLE || fieldResult1.getType() == Schema.DisplayType.PERCENT){
                                       if (decimal.valueOf(recordFieldValue1) == decimal.valueOf(mapOfFieldAndValOfASQueryNotEqual.get(field))) {
                                           system.debug('@@recordFieldValue1'+recordFieldValue1);
                                           countOfMatchingValues++;
                                       }  
                                       
                                   }else{
                                       if (recordFieldValue1 == mapOfFieldAndValOfASQueryNotEqual.get(field)) {
                                           system.debug('@@recordFieldValue1'+recordFieldValue1);
                                           countOfMatchingValues++;
                                       }  
                                   }
                                
                            }
                            
                        } else {
                            system.debug('recordFieldValue1 ! '+recordFieldValue1 );
                            system.debug('mapOfFieldAndValOfASQueryNotEqual.get(field) ! '+mapOfFieldAndValOfASQueryNotEqual.get(field) );
                            if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#!=#')){
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                system.debug('recordFieldValue1 ! '+recordFieldValue1 );
                                system.debug('valueOfmap ! '+valueOfmap );
                                valueOfmap = valueOfmap.replace('#!=#', '');
                                if (recordFieldValue1 != valueOfmap) {
                                    system.debug('add 1');
                                    mapSizeCount++; 
                                }
                                
                            }else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#>=#')){
                                system.debug('2 ' );
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#>=#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if (recordFieldValue1 >= valueOfmap) {
                                        system.debug('add 2 if');
                                        mapSizeCount++; 
                                    } 
                                    
                                }else{
                                    if (decimal.valueOf(recordFieldValue1) >= decimal.valueOf(valueOfmap)) {
                                        system.debug('add 2 else');
                                        mapSizeCount++; 
                                    } 
                                }
                                
                                
                            }else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#<=#')){
                                system.debug('3 ' );
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#<=#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if (recordFieldValue1 <= valueOfmap) {
                                        system.debug('add 3 if');
                                        mapSizeCount++; 
                                    } 
                                    
                                }else{
                                    if (decimal.valueOf(recordFieldValue1) <= decimal.valueOf(valueOfmap)) {
                                        system.debug('add 3 else');
                                        mapSizeCount++; 
                                    }
                                }
                            }else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#<#')){
                                system.debug('4 ' );
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#<#', '');
                                
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if (recordFieldValue1 < valueOfmap) {
                                        system.debug('add 4 if');
                                        mapSizeCount++; 
                                    } 
                                    
                                }else{
                                    if (decimal.valueOf(recordFieldValue1) < decimal.valueOf(valueOfmap)) {
                                        system.debug('add 4 if');
                                        mapSizeCount++; 
                                    }
                                }
                            }else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#>#')){
                                system.debug('5 ' );
                                String valueOfmap = mapOfFieldAndValOfASQueryNotEqual.get(field);
                                valueOfmap = valueOfmap.replace('#>#', '');
                                if(fieldResult1.getType() == Schema.DisplayType.Date){
                                    if (recordFieldValue1 > valueOfmap) {
                                        system.debug('add 5 if');
                                        mapSizeCount++; 
                                    } 
                                    
                                }else{
                                    if (decimal.valueOf(recordFieldValue1) > decimal.valueOf(valueOfmap)) {
                                        system.debug('add 5 if');
                                        mapSizeCount++; 
                                    }
                                }
                            } else{
                                system.debug('recordFieldValue1 ! '+recordFieldValue1 );
                                system.debug('mapOfFieldAndValOfASQueryNotEqual.get(field) ! '+mapOfFieldAndValOfASQueryNotEqual.get(field) );
                                
                                if(fieldResult1.getType() == Schema.DisplayType.Integer || fieldResult1.getType() == Schema.DisplayType.CURRENCY ||
                                   fieldResult1.getType() == Schema.DisplayType.DOUBLE || fieldResult1.getType() == Schema.DisplayType.PERCENT){
                                       if (decimal.valueOf(recordFieldValue1) == decimal.valueOf(mapOfFieldAndValOfASQueryNotEqual.get(field))) {
                                           system.debug('add 1- 4 times');
                                           mapSizeCount++; 
                                       } 
                                       
                                   }else{
                                       if (recordFieldValue1 == mapOfFieldAndValOfASQueryNotEqual.get(field)) {
                                           system.debug('add 1- 4 times');
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
                                
                            }else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#>=#')){
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
                            }else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#<=#')){
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
                            }else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#>#')){
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
                            }else if(mapOfFieldAndValOfASQueryNotEqual.get(field).contains('#<#')){
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
                            } else{
                                if(fieldResult1.getType() == Schema.DisplayType.Integer || fieldResult1.getType() == Schema.DisplayType.CURRENCY ||
                                   fieldResult1.getType() == Schema.DisplayType.DOUBLE || fieldResult1.getType() == Schema.DisplayType.PERCENT){
                                       if ((decimal.valueOf(recordFieldValue1) == decimal.valueOf(mapOfFieldAndValOfASQueryNotEqual.get(field))) && (record.get(field) != oldRecord.get(field))) {
                                           countOfMatchingValues++;
                                       }
                                       
                                   }else{
                                       if ((recordFieldValue1 == mapOfFieldAndValOfASQueryNotEqual.get(field)) && (record.get(field) != oldRecord.get(field))) {
                                           countOfMatchingValues++;
                                       }
                                   }
                                
                            }
                        }
                    }
                }
                else{
                    if(mapOfFieldAndValOfASQuery != null && mapOfFieldAndValOfASQuery.size()>0){
                        system.debug('in else condition');
                        sizeOfConditionMap = mapOfFieldAndValOfASQuery.size();
                        for (String field : mapOfFieldAndValOfASQuery.keySet()) {
                            Schema.SObjectField fieldToken = record.getSObjectType().getDescribe().fields.getMap().get(field);
                            Schema.DescribeFieldResult fieldResult = fieldToken.getDescribe();
                            String recordFieldValue;
                            system.debug('@@fieldResult.getType()'+fieldResult.getType());
                            if (fieldResult.getType() == Schema.DisplayType.Boolean) {
                                Boolean booleanValue = (Boolean) record.get(field);
                                recordFieldValue = booleanValue ? 'true' : 'false';
                            } else if(fieldResult.getType() == Schema.DisplayType.Date ){
                                Date  dateVal = (Date ) record.get(field);
                                Datetime dateTimeVal;
                                if(dateVal != null){
                                    Date selectedDate = Date.valueOf(dateVal);
                                    DateTime dateTimeValue = DateTime.newInstance(selectedDate.year(), selectedDate.month(), selectedDate.day());
                                    recordFieldValue =  dateTimeValue.format('yyyy-MM-dd');
                                    //dateTimeVal = Datetime.newInstance(dateVal.year(), dateVal.month(), dateVal.day(), 0, 0, 0);
                                    //recordFieldValue = dateTimeVal.format('dd/MM/yyyy');
                                }
                                
                            } else {
                                recordFieldValue = String.valueOf(record.get(field));
                            }
                            system.debug('@@recordFieldValue'+recordFieldValue);
                            system.debug('@@mapOfFieldAndValOfASQuery.get(field)'+mapOfFieldAndValOfASQuery.get(field));
                            if (isInsert) {
                                if(recordFieldValue == null && mapOfFieldAndValOfASQuery.get(field) == 'null' ){
                                    system.debug('@@nullvalue');
                                    countOfMatchingValues++;
                                }
                                
                                if (recordFieldValue == mapOfFieldAndValOfASQuery.get(field)) {
                                    system.debug('@@recordFieldValue'+recordFieldValue);
                                    countOfMatchingValues++;
                                }
                            } else {
                                if (recordFieldValue == mapOfFieldAndValOfASQuery.get(field)) {
                                    mapSizeCount++;
                                }
                                
                                if(recordFieldValue == null && mapOfFieldAndValOfASQuery.get(field) == 'null' ){
                                    system.debug('@@nullvalue');
                                    mapSizeCount++;
                                    countOfMatchingValues++;
                                }
                                
                                if ((recordFieldValue == mapOfFieldAndValOfASQuery.get(field)) && (record.get(field) != oldRecord.get(field))) {
                                    countOfMatchingValues++;
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
                    }
                } else {
                    if (countOfMatchingValues > 0 && sizeOfConditionMap == mapSizeCount) {
                        activelist.add(activeschedule);
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
        
        StringOfIds =  '\'' + String.join(lstOfObjIds, '\',\'') + '\'';*/
    }
    
    Global void finish(Database.BatchableContext BC) {
     /*   String soql = 'SELECT Id, S2V__Record_Id__c, S2V__Sobject_Name__c, S2V__Status__c,S2V__ActiveScheduleRecordId__c,CreatedDate';
        soql += ' FROM S2V__Future_Voicemails__c';
        soql += ' WHERE S2V__Status__c = '+ '\''+ CommonConstant.status + '\' AND S2V__Record_Id__c  IN (' + StringOfIds + ') AND S2V__Schedule_TIme_textBox__c = NULL ';
        
        if(!Test.isrunningTest()) {
            Airwaves360FutureVoicemailBatchNew batch = new Airwaves360FutureVoicemailBatchNew(soql);
            Database.executebatch(batch, 10); 
        }*/
        
    }
    
    
    
}