public With Sharing class CommonHandlerForTriggers {
    private static Boolean isBatchExecuted = false; // Static Variable
    public static Boolean isAlreadyInserted = false;
    
    public static void handleTrigger(List<SObject> newList, Map<Id, SObject> oldMap, String objectName, Boolean isUpdate, Boolean isInsert) {
        if (isAlreadyInserted == false) {
            List<S2V__Record_Queue__c> lstRecQueue = new List<S2V__Record_Queue__c>();
            Set<String> normalizedSystemFields = matchsystemFields();
            
            for (SObject objNew : newList) {
                S2V__Record_Queue__c objRec = new S2V__Record_Queue__c();
                objRec.S2V__Object_Record_id__c = (String)objNew.get('Id');
                
                if (isUpdate && oldMap != null && oldMap.containsKey((Id)objNew.get('Id'))) {
                    SObject objOld = oldMap.get((Id)objNew.get('Id'));
                    
                    Schema.DescribeSObjectResult objDescribe = objNew.getSObjectType().getDescribe();
                    Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
                    Map<String, Object> changedFields = new Map<String, Object>();
                    
                    for (String fieldName : fieldMap.keySet()) {
                        if (!normalizedSystemFields.contains(fieldName)) {
                            Object oldValue = objOld.get(fieldName);
                            Object newValue = objNew.get(fieldName);
                            if (oldValue != newValue) {
                                changedFields.put(fieldName, oldValue);
                            }
                        }
                    }
                    
                    if (!changedFields.isEmpty()) {
                        objRec.S2V__OldMapValue__c = JSON.serialize(changedFields);
                    }
                }
                lstRecQueue.add(objRec);
            }
            
            if (!lstRecQueue.isEmpty()) {
                SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, lstRecQueue);
                insert securityDecision.getRecords();
            }
            
           // if (!System.isFuture() && !System.isQueueable() && !System.isBatch()) {
                ExecuteBatchMethod(isInsert, objectName);
           // }
        }
    }
    
    public static Set<String> matchsystemFields(){
        
        Set<String> normalizedSystemFields = new Set<String>();
        String systemfieldsString = System.Label.systemFields; // lastmodifieddate,systemmodstamp,CreatedDate,IsDeleted,reminderdatetime,isclosed
        if(systemfieldsString != null){
            List<String> systemFields = systemfieldsString.split(',');
            
            if(!systemFields.isEmpty()){
                for (String field : systemFields) {
                    normalizedSystemFields.add(field.toLowerCase());
                }   
            }   
        }
        return  normalizedSystemFields;   
    }
    
    public static void ExecuteBatchMethod(Boolean isInserted,string ObjName) {
       // if (!isBatchExecuted) {
            Database.executeBatch(new BatchForMatchingRecords(isInserted,ObjName), 200);
           // isBatchExecuted = true; // Prevent multiple executions
      //  }
    }
}