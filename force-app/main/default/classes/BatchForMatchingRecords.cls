/*** description : This batch will  
fetch the task record and check if record stisfy the 
Active schedule condition, if yes then it create Future voicemail 
and store record id and matched active schedule id
***/

public With Sharing class BatchForMatchingRecords implements Database.Batchable<sObject>, Database.Stateful {
    
    //public List<sObject> recordsToProcess;
    public String objectType;  // The object type (e.g., 'Task', 'Contact', etc.)
    public Boolean isInsert = false;  // Flag for insert or update
    public Map<String, S2V__Airwaves360_Active_Schedule__c> ActiveScheduleMap = new Map<String, S2V__Airwaves360_Active_Schedule__c>();
    public Map<String, String> mapActivescheduleIdString = new Map<String, String>();
    List<sObject> recordsToProcessAhead = new List<sObject>();
    List<S2V__Record_Queue__c> LstOfQueueRecords = new List<S2V__Record_Queue__c>(); 
    Map<Id,S2V__Airwaves360_Active_Schedule__c> mapOfRecANDASId = new Map<Id,S2V__Airwaves360_Active_Schedule__c>(); 
    public Map<String, Object> oldValuesMap = New Map<String, Object>();
    
    // Constructor to initialize with object type, records, old records (for update), and operation type
    public BatchForMatchingRecords(Boolean isInserted, string ObjName) {
        this.isInsert = isInserted;
        this.objectType = ObjName;
        
        // Query active schedules for the specific object type
        List<S2V__Airwaves360_Active_Schedule__c> lstOfActiveSchedule = [SELECT Id,  S2V__Object_Name__c, S2V__Sending_Method__c, S2V__S2vQuery__c, 
                                                                         S2V__Option_Schedule__c,S2V__Schedule_Time__c,S2V__Schedule_TIme_textBox__c, 
                                                                         S2V__SMS_Template_Body_New__c, S2V__SMS_Template_Name__c,S2V__Reference_Field__c,
                                                                         S2V__Activity_History__c,S2V__Recording_Number__c FROM S2V__Airwaves360_Active_Schedule__c
                                                                         WHERE S2V__Object_Name__c = :ObjName AND S2V__Is_Active__c = true ];
        
        // Loop through and store active schedules in the map
        if (lstOfActiveSchedule != null && lstOfActiveSchedule.size() > 0) {
            for (S2V__Airwaves360_Active_Schedule__c activeschedule : lstOfActiveSchedule) {
                String whereclause;
                if(activeschedule.S2V__S2vQuery__c != null && activeschedule.S2V__S2vQuery__c != ''){
                    whereclause = S2V.QueryParserClass.getWhereClause(activeschedule.S2V__S2vQuery__c);
                }
                if(whereclause != null && whereclause != ''){
                    mapActivescheduleIdString.put(activeschedule.Id, whereclause);  
                }
                ActiveScheduleMap.put(activeschedule.Id, activeschedule);
            }
        }
    }
    
    public Iterable<SObject> start(Database.BatchableContext BC) {
        
        LstOfQueueRecords = [SELECT Id,S2V__Object_Record_id__c,S2V__OldMapValue__c FROM S2V__Record_Queue__c where S2V__Is_Processed__c = false LIMIT 10000];
        List<Id> lstOfObjRecordIds = new List<Id>();
        if(LstOfQueueRecords != null && LstOfQueueRecords.size()>0){
            for (S2V__Record_Queue__c record : LstOfQueueRecords) {
                lstOfObjRecordIds.add(record.S2V__Object_Record_id__c);
                record.S2V__Is_Processed__c = true;
                if (isInsert == false) {
                    if(record.S2V__OldMapValue__c != null && record.S2V__OldMapValue__c != ''){
                        oldValuesMap = (Map<String, Object>) JSON.deserializeUntyped(record.S2V__OldMapValue__c);  
                    }
                }
            }   
        }
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType objType = schemaMap.get(objectType);
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
        Set<String> fieldNames = new Set<String>(fieldMap.keySet());
        
         if(LstOfQueueRecords.size()>0 ){
                Database.update(LstOfQueueRecords, false);
            }
        
        // Construct the SOQL query dynamically
        String query = 'SELECT ' + String.join(fieldNames, ', ') + ' FROM ' + objectType + ' WHERE Id IN :lstOfObjRecordIds';
        // Execute the dynamic SOQL query
        return Database.query(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> recordsToProcess) {
        
        if(recordsToProcess.size()>0){
            for (sObject record : recordsToProcess) {
                for (String activescheduleId : mapActivescheduleIdString.keySet()) {
                    
                    Map<String, String> mapOfFieldAndValOfASQuery = new Map<String, String>();
                    Integer sizeOfConditionMap= 0;
                    Integer countOfMatchingValues = 0;
                    Integer mapSizeCount = 0;
                    List<S2V__Airwaves360_Active_Schedule__c> MatchedActiveSchedulelist = new List<S2V__Airwaves360_Active_Schedule__c>();
                    S2V__Airwaves360_Active_Schedule__c ASRecord = new S2V__Airwaves360_Active_Schedule__c();
                    if(ActiveScheduleMap.ContainsKey(activescheduleId)){
                        ASRecord = ActiveScheduleMap.get(activescheduleId);
                    }
                    String wholeCondition;
                    if(mapActivescheduleIdString.containsKey(activescheduleId)) {
                        wholeCondition =  mapActivescheduleIdString.get(activescheduleId);
                    }
                    if(wholeCondition != null) {
                        mapOfFieldAndValOfASQuery = S2V.QueryParserClass.getWhereClauseFieldsAndItsValuesForAllOp(wholeCondition);
                    }
                    //This will check the records fields values with Available AS's conditions and creates map of Record id and matching As's Id to Process further
                    if(mapOfFieldAndValOfASQuery != null && mapOfFieldAndValOfASQuery.size()>0){
                        sizeOfConditionMap = mapOfFieldAndValOfASQuery.size();
                        for (String field : mapOfFieldAndValOfASQuery.keySet()) {
                            Schema.SObjectField fieldToken = record.getSObjectType().getDescribe().fields.getMap().get(field);
                            Schema.DescribeFieldResult fieldResult = fieldToken.getDescribe();
                            String recordFieldValue;
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
                                }
                            } else {
                                recordFieldValue = String.valueOf(record.get(field));
                            }
                            //On insert Functionality
                            if (isInsert) {
                                if(recordFieldValue == null && mapOfFieldAndValOfASQuery.get(field) == 'null' ){
                                    countOfMatchingValues++;
                                }
                                if(recordFieldValue != null){
                                    
                                    //checks for '!=' in where clause of Active schedule query 
                                    if(mapOfFieldAndValOfASQuery.get(field).contains('#!=#')){
                                        String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                        valueOfmap = valueOfmap.replace('#!=#', '');
                                        if (recordFieldValue != valueOfmap) {
                                            countOfMatchingValues++;
                                        }
                                    }
                                    //checks for '<=' in where clause of Active schedule query 
                                    else if(mapOfFieldAndValOfASQuery.get(field).contains('#<=#')){
                                        String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                        valueOfmap = valueOfmap.replace('#<=#', '');
                                        if(fieldResult.getType() == Schema.DisplayType.Date){
                                            if (recordFieldValue <= valueOfmap) {
                                                countOfMatchingValues++;
                                            }
                                        } else{
                                            if (decimal.valueOf(recordFieldValue) <= decimal.valueOf(valueOfmap)) {
                                                countOfMatchingValues++;
                                            }
                                        }
                                    }
                                    //checks for '>=' in where clause of Active schedule query
                                    else if(mapOfFieldAndValOfASQuery.get(field).contains('#>=#')){
                                        String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                        valueOfmap = valueOfmap.replace('#>=#', '');
                                        if(fieldResult.getType() == Schema.DisplayType.Date){
                                            if (recordFieldValue >= valueOfmap) {
                                                countOfMatchingValues++;
                                            }
                                        } else{
                                            if (decimal.valueOf(recordFieldValue) >= decimal.valueOf(valueOfmap)) {
                                                countOfMatchingValues++;
                                            }
                                        }
                                    }
                                    //checks for '>' in where clause of Active schedule query
                                    else if(mapOfFieldAndValOfASQuery.get(field).contains('#>#')){
                                        String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                        valueOfmap = valueOfmap.replace('#>#', '');
                                        if(fieldResult.getType() == Schema.DisplayType.Date){
                                            if (recordFieldValue > valueOfmap) {
                                                countOfMatchingValues++;
                                            }
                                        } else{
                                            if (decimal.valueOf(recordFieldValue) > decimal.valueOf(valueOfmap)) {
                                                countOfMatchingValues++;
                                            }
                                        }
                                    }
                                    //checks for '<' in where clause of Active schedule query
                                    else if(mapOfFieldAndValOfASQuery.get(field).contains('#<#')){
                                        String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                        valueOfmap = valueOfmap.replace('#<#', '');
                                        if(fieldResult.getType() == Schema.DisplayType.Date){
                                            if (recordFieldValue < valueOfmap) {
                                                countOfMatchingValues++;
                                            }
                                        } else{
                                            if (decimal.valueOf(recordFieldValue) < decimal.valueOf(valueOfmap)) {
                                                countOfMatchingValues++;
                                            }
                                        }
                                    }
                                    //checks for '=' in where clause of Active schedule query
                                    else if(mapOfFieldAndValOfASQuery.get(field).contains('#=#')){
                                        String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                        valueOfmap = valueOfmap.replace('#=#', '');
                                        valueOfmap = valueOfmap.substring(1, valueOfmap.length() - 1); 
                                        
                                        if(fieldResult.getType() == Schema.DisplayType.Integer || fieldResult.getType() == Schema.DisplayType.CURRENCY ||
                                           fieldResult.getType() == Schema.DisplayType.DOUBLE || fieldResult.getType() == Schema.DisplayType.PERCENT){
                                               if (decimal.valueOf(recordFieldValue) == decimal.valueOf(valueOfmap)) {
                                                   countOfMatchingValues++;
                                               }
                                           }else{
                                               if (recordFieldValue == valueOfmap) {
                                                   countOfMatchingValues++;
                                               }
                                           }
                                    }
                                }
                            } 
                            else { //On update Functionality
                                if(oldValuesMap != null && oldValuesMap.size() > 0){
                                    if(recordFieldValue != null){
                                    //checks for '!=' in where clause of Active schedule query
                                    if(mapOfFieldAndValOfASQuery.get(field).contains('#!=#')){
                                        String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                        valueOfmap = valueOfmap.replace('#!=#', '');
                                        if (recordFieldValue != valueOfmap) {
                                            mapSizeCount++;
                                        }
                                    }
                                    //checks for '>=' in where clause of Active schedule query
                                    else if(mapOfFieldAndValOfASQuery.get(field).contains('#>=#')){
                                        String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                        valueOfmap = valueOfmap.replace('#>=#', '');
                                        if(fieldResult.getType() == Schema.DisplayType.Date){
                                            if (recordFieldValue >= valueOfmap) {
                                                mapSizeCount++;
                                            }
                                        }else{
                                            if (decimal.valueOf(recordFieldValue) >= decimal.valueOf(valueOfmap)) {
                                                mapSizeCount++;
                                            }
                                        }
                                    }
                                    //checks for '<=' in where clause of Active schedule query
                                    else if(mapOfFieldAndValOfASQuery.get(field).contains('#<=#')){
                                        String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                        valueOfmap = valueOfmap.replace('#<=#', '');
                                        if(fieldResult.getType() == Schema.DisplayType.Date){
                                            if (recordFieldValue <= valueOfmap) {
                                                mapSizeCount++;
                                            }
                                        }else{
                                            if (decimal.valueOf(recordFieldValue) <= decimal.valueOf(valueOfmap)) {
                                                mapSizeCount++;
                                            }
                                        }
                                    }
                                    //checks for '<' in where clause of Active schedule query
                                    else if(mapOfFieldAndValOfASQuery.get(field).contains('#<#')){
                                        String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                        valueOfmap = valueOfmap.replace('#<#', '');
                                        if(fieldResult.getType() == Schema.DisplayType.Date){
                                            if (recordFieldValue < valueOfmap) {
                                                mapSizeCount++;
                                            }
                                        }else{
                                            if (decimal.valueOf(recordFieldValue) < decimal.valueOf(valueOfmap)) {
                                                mapSizeCount++;
                                            }
                                        }
                                    }
                                    //checks for '>' in where clause of Active schedule query
                                    else if(mapOfFieldAndValOfASQuery.get(field).contains('#>#')){
                                        String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                        valueOfmap = valueOfmap.replace('#>#', '');
                                        if(fieldResult.getType() == Schema.DisplayType.Date){
                                            if (recordFieldValue > valueOfmap) {
                                                mapSizeCount++;
                                            }
                                        }else{
                                            if (decimal.valueOf(recordFieldValue) > decimal.valueOf(valueOfmap)) {
                                                mapSizeCount++;
                                            }
                                        }
                                    }
                                    //checks for '=' in where clause of Active schedule query
                                    else if(mapOfFieldAndValOfASQuery.get(field).contains('#=#')){
                                        
                                        String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                        valueOfmap = valueOfmap.replace('#=#', '');
                                        valueOfmap = valueOfmap.substring(1, valueOfmap.length() - 1); 
                                        if(fieldResult.getType() == Schema.DisplayType.Integer || fieldResult.getType() == Schema.DisplayType.CURRENCY ||
                                           fieldResult.getType() == Schema.DisplayType.DOUBLE || fieldResult.getType() == Schema.DisplayType.PERCENT){
                                               if (decimal.valueOf(recordFieldValue) == decimal.valueOf(valueOfmap)) {
                                                   mapSizeCount++;
                                               }
                                           }else{
                                               if (recordFieldValue == valueOfmap) {
                                                   mapSizeCount++;
                                               }
                                           }
                                    }
                                    }
                                    if(recordFieldValue == null && mapOfFieldAndValOfASQuery.get(field) == 'null' ){
                                        mapSizeCount++;
                                        countOfMatchingValues++;
                                    }
                                    if(recordFieldValue != null){
                                        //checks for '!=' in where clause of Active schedule query and old and New Value for Update
                                        if(mapOfFieldAndValOfASQuery.get(field).contains('#!=#')){
                                            String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                            valueOfmap = valueOfmap.replace('#!=#', '');
                                            if ((recordFieldValue != valueOfmap) && (record.get(field) != oldValuesMap.get(field.toLowerCase()))) {
                                                countOfMatchingValues++;
                                            }
                                        }
                                        //checks for '>=' in where clause of Active schedule query and old and New Value for Update
                                        else if(mapOfFieldAndValOfASQuery.get(field).contains('#>=#')){
                                            String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                            valueOfmap = valueOfmap.replace('#>=#', '');
                                            if(fieldResult.getType() == Schema.DisplayType.Date){
                                                if ((recordFieldValue >= valueOfmap) && (record.get(field) != oldValuesMap.get(field.toLowerCase()))) {
                                                    countOfMatchingValues++;
                                                }
                                            }else{
                                                if ((decimal.valueOf(recordFieldValue) >= decimal.valueOf(valueOfmap)) && (record.get(field) != oldValuesMap.get(field.toLowerCase()))) {
                                                    countOfMatchingValues++;
                                                }
                                            }
                                        }
                                        //checks for '<=' in where clause of Active schedule query and old and New Value for Update
                                        else if(mapOfFieldAndValOfASQuery.get(field).contains('#<=#')){
                                            String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                            valueOfmap = valueOfmap.replace('#<=#', '');
                                            if(fieldResult.getType() == Schema.DisplayType.Date){
                                                if ((recordFieldValue <= valueOfmap) && (record.get(field) != oldValuesMap.get(field.toLowerCase()))) {
                                                    countOfMatchingValues++;
                                                }
                                            }else{
                                                if ((decimal.valueOf(recordFieldValue) <= decimal.valueOf(valueOfmap)) && (record.get(field) != oldValuesMap.get(field.toLowerCase()))) {
                                                    countOfMatchingValues++;
                                                }
                                            }
                                        }
                                        //checks for '>' in where clause of Active schedule query and old and New Value for Update
                                        else if(mapOfFieldAndValOfASQuery.get(field).contains('#>#')){
                                            String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                            valueOfmap = valueOfmap.replace('#>#', '');
                                            if(fieldResult.getType() == Schema.DisplayType.Date){
                                                if ((recordFieldValue > valueOfmap) && (record.get(field) != oldValuesMap.get(field.toLowerCase()))) {
                                                    countOfMatchingValues++;
                                                }
                                            }else{
                                                if ((decimal.valueOf(recordFieldValue) > decimal.valueOf(valueOfmap)) && (record.get(field) != oldValuesMap.get(field.toLowerCase()))) {
                                                    countOfMatchingValues++;
                                                }
                                            }
                                        }
                                        //checks for '<' in where clause of Active schedule query and old and New Value for Update
                                        else if(mapOfFieldAndValOfASQuery.get(field).contains('#<#')){
                                            String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                            valueOfmap = valueOfmap.replace('#<#', '');
                                            if(fieldResult.getType() == Schema.DisplayType.Date){
                                                if ((recordFieldValue < valueOfmap) && (record.get(field) != oldValuesMap.get(field.toLowerCase()))) {
                                                    countOfMatchingValues++;
                                                }
                                            }else{
                                                if ((decimal.valueOf(recordFieldValue) < decimal.valueOf(valueOfmap)) && (record.get(field) != oldValuesMap.get(field.toLowerCase()))) {
                                                    countOfMatchingValues++;
                                                }
                                            }
                                        } 
                                        //checks for '=' in where clause of Active schedule query and old and New Value for Update
                                        else if(mapOfFieldAndValOfASQuery.get(field).contains('#=#')){
                                            String valueOfmap = mapOfFieldAndValOfASQuery.get(field);
                                            valueOfmap = valueOfmap.replace('#=#', '');
                                            valueOfmap = valueOfmap.substring(1, valueOfmap.length() - 1); 
                                            if(fieldResult.getType() == Schema.DisplayType.Integer || fieldResult.getType() == Schema.DisplayType.CURRENCY ||
                                               fieldResult.getType() == Schema.DisplayType.DOUBLE || fieldResult.getType() == Schema.DisplayType.PERCENT){
                                                   if ((decimal.valueOf(recordFieldValue) == decimal.valueOf(valueOfmap)) && (record.get(field) != oldValuesMap.get(field.toLowerCase())) && oldValuesMap.get(field.toLowerCase()) != null) {
                                                       countOfMatchingValues++;
                                                   }
                                               }else{
                                                   if ((recordFieldValue == valueOfmap) && (record.get(field) != oldValuesMap.get(field.toLowerCase())) && oldValuesMap.get(field.toLowerCase()) != null) {
                                                       countOfMatchingValues++;
                                                   }
                                               }
                                        }
                                    }  
                                }      
                            }
                        }
                    }
                    if (isInsert) {
                        if (sizeOfConditionMap == countOfMatchingValues) {
                            MatchedActiveSchedulelist.add(ASRecord);
                            
                        }
                    } else {
                        if (countOfMatchingValues > 0 && sizeOfConditionMap == mapSizeCount) {
                            MatchedActiveSchedulelist.add(ASRecord);
                            
                        }
                    }
                    if (MatchedActiveSchedulelist.size() > 0) {
                        if(!recordsToProcessAhead.contains(Record)){
                            recordsToProcessAhead.add(Record); 
                            mapOfRecANDASId.put(Record.id,MatchedActiveSchedulelist[0]);
                        }
                    }
                }
            }
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        try {
            system.debug('@@LstOfQueueRecords-->'+LstOfQueueRecords.size());
            if(LstOfQueueRecords.size()>0 && Schema.sObjectType.S2V__Record_Queue__c.isDeletable()){
                Database.delete(LstOfQueueRecords, false);
            }
            System.enqueueJob(new FirstQueueableForFromNumberGrouping(recordsToProcessAhead,objectType,mapOfRecANDASId));
        } catch (DmlException e) {
            System.debug('Error: ' + e.getMessage());
        }
    }
}