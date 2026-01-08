global with sharing class BatchOnFutureSMS implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    public S2V__Airwaves360_settings__c settings;
    public static string XAPIkey;
    public static string OrgId;
    public static Map<String, S2V__Airwaves360_Active_Schedule__c> ActiveScheduleMap = new Map<String, S2V__Airwaves360_Active_Schedule__c>();
    public static Map<Id, User> userMap;
    
    
    global Database.Querylocator start(Database.BatchableContext bc)
    {   
        if(Schema.SObjectType.S2V__Airwaves360_settings__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.Id.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__OrganizationId__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__XapiKey__c.isAccessible()){
               settings =[select id,S2V__OrganizationId__c,S2V__XapiKey__c  from S2V__Airwaves360_settings__c limit 1]; //yabbar_settings__c.getInstance();  
           } 
        if(settings != null){
            XAPIkey = KeyDecryptionClass.decryptValue(settings.S2V__XapiKey__c);
            OrgId = KeyDecryptionClass.decryptValue(settings.S2V__OrganizationId__c);
            
        } 
        system.debug('@@XAPIkey'+XAPIkey);
        // Query active schedules for the specific object type
        List<S2V__Airwaves360_Active_Schedule__c> lstOfActiveSchedule = [SELECT Id,  S2V__Object_Name__c, S2V__Sending_Method__c, S2V__S2vQuery__c, 
                                                                         S2V__Option_Schedule__c,S2V__Schedule_Time__c,S2V__Schedule_TIme_textBox__c,S2V__Selected_Lookup__c, 
                                                                         S2V__SMS_Template_Body_New__c, S2V__SMS_Template_Name__c,S2V__Reference_Field__c,S2V__SMS_Object__c,
                                                                         S2V__Activity_History__c,S2V__Recording_Number__c FROM S2V__Airwaves360_Active_Schedule__c
                                                                         WHERE S2V__Option_Schedule__c = 'Future Call'  AND S2V__Is_Active__c = true WITH SECURITY_ENFORCED];
        system.debug('@@lstOfActiveSchedule'+lstOfActiveSchedule);
        // Loop through and store active schedules in the map
        if (lstOfActiveSchedule != null && lstOfActiveSchedule.size() > 0) {
            for (S2V__Airwaves360_Active_Schedule__c activeschedule : lstOfActiveSchedule) {
                ActiveScheduleMap.put(activeschedule.Id, activeschedule);
            }
        }
        system.debug('@@ActiveScheduleMap'+ActiveScheduleMap);
        userMap = new Map<Id, User>(
            [SELECT Id, Name, Email,S2V__Airwaves_Verified_Number__c FROM User WITH SECURITY_ENFORCED limit 1000]
        );
        system.debug('@@userMap'+userMap);
        String query = 'SELECT Id, S2V__Status__c, S2V__Sending_method__c, S2V__Record_Id__c, S2V__Sobject_Name__c, S2V__ActiveScheduleRecordId__c,CreatedDate,S2V__Option_Schedule__c,S2V__Schedule_Time__c,S2V__Schedule_TIme_textBox__c ,S2V__Related_to_Id__c,S2V__SMS_Template_Name__c,S2V__SMS_Template_Description__c ' +
            'FROM S2V__Future_Voicemails__c WHERE S2V__Status__c = \'Queue\' and S2V__Option_Schedule__c =\'Future Call\' and S2V__Schedule_Time__c != null And S2V__Schedule_TIme_textBox__c != null';
        
        return Database.getQueryLocator(query);       
        
    }  
    
    global void execute(Database.BatchableContext bc, List<S2V__Future_Voicemails__c> scope)
    {
        system.debug('@@userMap'+userMap);
         system.debug('@@XAPIkey'+XAPIkey);
        dateTime SendingTime;
        string UserField;
        Id userIdReference;
        string verifiedNumber;
        Date currentDate = Date.today();
        Time currentTime = DateTime.now().time();
        DateTime currentDateTime = DateTime.now();
        DateTime createddate;
        List<S2V__Future_Voicemails__c> lstOfFVtoSendSMS = new List<S2V__Future_Voicemails__c>();
        List<S2V__Future_Voicemails__c> lstOfFVtoUpdt = new List<S2V__Future_Voicemails__c>();
        List<Task> lstOftasktoInsert = new List<Task>();
        Map<Id, Lead> leadMap;// = new Map<Id, Lead>();
        Map<Id, Contact> contactMap;// = new Map<Id, Contact>();
        
        string objectName;
        string smsTemplateBody;
        string lstQuery;
        STRING newQuery1;
        STRING newQuery;
        string str;
        STRING contactLookup;
        List<sObject> sobjList;
        List<String> lstCntIds =  new List<String>();
        List<String> lstOfQueryStr = new List<String>();
        Boolean isSuccess;
        
        for (S2V__Future_Voicemails__c obj : scope) {
            createddate = obj.CreatedDate; 
            
            if(obj.S2V__Option_Schedule__c != null && obj.S2V__Option_Schedule__c != ''){
                
                if (obj.S2V__Option_Schedule__c == 'Future Call') {
                    if(obj.S2V__Schedule_Time__c == 'Days'){
                        SendingTime = createddate.addDays(Integer.valueOf(obj.S2V__Schedule_TIme_textBox__c));
                    }
                    if(obj.S2V__Schedule_Time__c == 'Minutes'){
                        SendingTime = createddate.addMinutes(Integer.valueOf(obj.S2V__Schedule_TIme_textBox__c));
                    }
                    if(obj.S2V__Schedule_Time__c == 'Hours'){
                        SendingTime = createddate.addHours(Integer.valueOf(obj.S2V__Schedule_TIme_textBox__c));
                    }
                    String timeToSend = SendingTime.format('HH:mm');
                    String currentime = DateTime.now().format('HH:mm');
                    if (Test.isRunningTest()) {
                        lstOfFVtoSendSMS.add(obj);
                    }else{
                        if(timeToSend == currentime){
                            lstOfFVtoSendSMS.add(obj);
                        }
                    }
                }
            }
        }
        system.debug('@@lstOfFVtoSendSMS'+lstOfFVtoSendSMS);
        if(lstOfFVtoSendSMS.size()>0){
            for(S2V__Future_Voicemails__c objFV : lstOfFVtoSendSMS){
                Map<String, Object> recordFields = getAllFieldsAsMap(objFV.S2V__Record_Id__c);
                S2V__Airwaves360_Active_Schedule__c ActiveScheduleRec = new S2V__Airwaves360_Active_Schedule__c();
                
                system.debug('@@lstOfFVtoSendSMS'+lstOfFVtoSendSMS);
                system.debug('@@ActiveScheduleMap'+ActiveScheduleMap);
                if(ActiveScheduleMap.ContainsKey(objFV.S2V__ActiveScheduleRecordId__c)){
                    ActiveScheduleRec = ActiveScheduleMap.get(objFV.S2V__ActiveScheduleRecordId__c);
                }
                 system.debug('@@ActiveScheduleRec'+ActiveScheduleRec);
                if(ActiveScheduleRec.Reference_Field__c != Null && ActiveScheduleRec.Reference_Field__c != ''){
                    UserField = ActiveScheduleRec.Reference_Field__c;
                    if(UserField != Null && UserField != '')
                    {
                        system.debug('@@UserField'+UserField);
                        system.debug('@@recordFields'+recordFields);
                        if(recordFields != null ){
                            userIdReference = (Id)recordFields.get(UserField.toLowerCase());
                            system.debug('@@userMap'+userMap);
                            system.debug('@@userIdReference'+userIdReference);
                            User usr = userMap.get(userIdReference); //[SELECT id, S2V__Airwaves_Verified_Number__c FROM User WHERE Id=:userIdReference LIMIT 1];
                            system.debug('@@usr'+usr);
                            if(usr!= null && usr.S2V__Airwaves_Verified_Number__c!= null){
                                verifiedNumber = usr.S2V__Airwaves_Verified_Number__c; 
                            }
                        }
                    }
                }
                if(ActiveScheduleRec.S2V__Object_Name__c != Null )
                {
                    objectName = ActiveScheduleRec.S2V__Object_Name__c;
                }
                if(ActiveScheduleRec.S2V__SMS_Template_Body_New__c != Null )
                {
                    smsTemplateBody = ActiveScheduleRec.S2V__SMS_Template_Body_New__c;
                }
                if(ActiveScheduleRec.S2V__Selected_Lookup__c != Null )
                {
                    contactLookup = ActiveScheduleRec.S2V__Selected_Lookup__c;
                }
                if(ActiveScheduleRec.S2V__S2vQuery__c!=NULL){
                    lstQuery = ActiveScheduleRec.S2V__S2vQuery__c.substring(ActiveScheduleRec.S2V__S2vQuery__c.indexOf('[')+1);
                }
                if(lstQuery!=NULL && lstQuery!=''){
                    newquery1 = lstQuery.replace(']','');
                    newquery = newquery1.replace(';','');
                }
                List<String> lstSobjRcrds = new List<String>();
                lstSobjRcrds.add(objFV.S2V__Record_Id__c);
                if(newquery.contains('WHERE')){
                    str = newquery+' AND ID IN : lstSobjRcrds ORDER BY CreatedDate DESC';
                } else {
                    str = newquery+' where ID IN : lstSobjRcrds ORDER BY CreatedDate DESC';
                }
                lstOfQueryStr.add(str);
                if(!lstOfQueryStr.isEmpty())
                {
                    for(string strg : lstOfQueryStr){
                        sobjList = new List<sObject>();                    
                        sobjList = Database.query(strg);
                    }
                }
                if(sobjList!=NULL && sobjList.size()>0)
                {
                    for(sObject obj : sobjList)
                    {
                        
                        string IdField;
                        if(ObjectName == 'Task'){
                            IdField = (String)obj.get('WhoId'); 
                        }
                        if (obj.getSObjectType().getDescribe().fields.getMap().containsKey('LeadId') && contactLookup == 'LeadId') {
                            lstCntIds.add((String)obj.get('LeadId'));
                        } else if(obj.getSObjectType().getDescribe().fields.getMap().containsKey('ContactId') && contactLookup == 'ContactId') {
                            lstCntIds.add((String)obj.get('ContactId'));
                        }else if(ObjectName == 'Task' &&( ActiveScheduleRec.S2V__SMS_Object__c == 'Contact' && IdField.startsWith('003')||ActiveScheduleRec.S2V__SMS_Object__c == 'Lead' && IdField.startsWith('00Q'))){
                            lstCntIds.add((String)obj.get('WhoId'));
                        }else if(ObjectName != 'Task' && ObjectName != 'Contact' && ObjectName != 'Lead'){
                            lstCntIds.add((String)obj.get(contactLookup));
                        }
                        else if(ObjectName == 'Contact' || ObjectName == 'Lead'){
                            lstCntIds.add((String)obj.get('Id'));
                        }
                    }
                }
            }
        }
        if(String.valueOf(lstCntIds[0]).startsWith('00Q')){
            leadMap = new Map<Id, Lead>([SELECT id,MobilePhone from Lead where Id in :lstCntIds Limit 1]);
        }
        if(String.valueOf(lstCntIds[0]).startsWith('003')){
            contactMap =new Map<Id, Contact>([SELECT id,MobilePhone from Contact where Id in :lstCntIds Limit 1]);
        }
        
        for(S2V__Future_Voicemails__c objFV : lstOfFVtoSendSMS){
            if(lstCntIds != null && lstCntIds.size() > 0){
                string contactMobile;
                map<Id,string> mapOftemplate = new map<Id,string>();
                if(String.valueOf(lstCntIds[0]).startsWith('00Q')){
                    Lead lead =leadMap.get(lstCntIds[0]);//([SELECT id,MobilePhone from Lead where Id in :lstCntIds Limit 1]); 
                    contactMobile = lead.MobilePhone;
                }
                else if(String.valueOf(lstCntIds[0]).startsWith('003')){
                    Contact contact =contactMap.get(lstCntIds[0]);//([SELECT id,MobilePhone from Contact where Id in :lstCntIds Limit 1]); 
                    contactMobile = Contact.MobilePhone;
                }
                
                if(contactMobile.startsWith('0'))
                {
                    contactMobile = contactMobile.replaceFirst('0','61');
                }
                else if(contactMobile.startsWith('+')){
                    contactMobile = contactMobile.replaceFirst('+','');
                }
                
                Schema.sObjectType newObjectName = Schema.getGlobalDescribe().get(objectName);
                Sobject genericObject = newObjectName.newSObject();
                //mapOftemplate =  Airwaves360SendSMSContact.replaceMergeFieldsforMultipleSMS(genericObject, smsTemplateBody,lstCntIds);
                if(mapOftemplate.size()>0 && mapOftemplate.ContainsKey(lstCntIds[0])){
                    system.debug('objectName'+objectName);
                    system.debug('verifiedNumber'+verifiedNumber);
                    system.debug('contactMobile'+contactMobile);
                    system.debug('mapOftemplate.get(lstCntIds[0])'+mapOftemplate.get(lstCntIds[0]));
                    system.debug('XAPIkey'+XAPIkey);
                    //isSuccess = Airwaves360SendSMSContact.sendSingleSMSMethod(objectName,verifiedNumber,contactMobile,mapOftemplate.get(lstCntIds[0]),XAPIkey);
                    
                }
                
                if(isSuccess ==TRUE)
                {
                    ObjFV.S2V__Status__c = 'Sent';
                    lstOfFVtoUpdt.add(ObjFV);
                    
                    Task tsk = new Task();
                    tsk.Status = 'completed';
                    tsk.Subject = Commonconstant.smstitle;
                    if(ObjFV.S2V__Related_to_Id__c != null && ObjFV.S2V__Related_to_Id__c != ''){
                        tsk.WhoId = ObjFV.S2V__Related_to_Id__c;   
                    }
                    
                    if(ObjFV.S2V__SMS_Template_Name__c != null && ObjFV.S2V__SMS_Template_Name__c != ''){
                        tsk.SMS_Template_Name__c = ObjFV.S2V__SMS_Template_Name__c;
                    }
                    
                    if(ObjFV.S2V__SMS_Template_Description__c != null && ObjFV.S2V__SMS_Template_Description__c != ''){
                        tsk.Description = ObjFV.S2V__SMS_Template_Description__c;
                    }
                    
                    if(!lstOftasktoInsert.contains(tsk)){
                        lstOftasktoInsert.add(tsk); 
                    }
                }
                else 
                {
                    objFV.S2V__Status__c = 'Failed';
                    lstOfFVtoUpdt.add(objFV);
                }
            }
        }
        //}
        
        if(lstOfFVtoUpdt.size() > 0 
           && Schema.SObjectType.Future_Voicemails__c.fields.S2V__Status__c.isUpdateable() 
           && Schema.SObjectType.S2V__Future_Voicemails__c.isUpdateable()
           && Schema.SObjectType.S2V__Future_Voicemails__c.fields.S2V__Error__c.isUpdateable())
        {   
            update lstOfFVtoUpdt;
        }
        if(lstOftasktoInsert.size()>0)
        {
            //INSERTS TASK IN SALESFORCE
            if (!Test.isRunningTest()) {
                //Insert lstOftasktoInsert;
                SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, lstOftasktoInsert);
                insert securityDecision.getRecords();
            }
        }
    }
    
    public Map<String, Object> getAllFieldsAsMap(Id recordId) {
        // Create a map to hold field-value pairs
        Map<String, Object> fieldMap = new Map<String, Object>();
        
        // Get the object type from the record ID
        String sObjectType = recordId.getSObjectType().getDescribe().getName();
        
        // Get all fields of the SObject
        Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(sObjectType).getDescribe().fields.getMap();
        
        // Construct a SOQL query dynamically
        String fieldNames = String.join(new List<String>(fieldsMap.keySet()), ',');
        String query = 'SELECT ' + fieldNames + ' FROM ' + sObjectType + ' WHERE Id = :recordId';
        
        try {
            // Query the record
            SObject record = Database.query(query);
            
            // Populate the map with field-value pairs
            for (String fieldName : fieldsMap.keySet()) {
                fieldMap.put(fieldName, record.get(fieldName));
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return fieldMap;
    }
    
    global void finish(Database.BatchableContext bc)
    {
    }
}