global with sharing class Airwaves360FutureVoicemailBatchNew implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    String query;
    S2V__Airwaves360_settings__c settings;
    
    global Airwaves360FutureVoicemailBatchNew (String soql)
    {
        query = soql;
        if(Schema.SObjectType.S2V__Airwaves360_settings__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.Id.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__OrganizationId__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__XapiKey__c.isAccessible()) {
               
               settings =[SELECT id,S2V__OrganizationId__c,S2V__XapiKey__c  FROM S2V__Airwaves360_settings__c LIMIT 1]; //yabbar_settings__c.getInstance();  
           } 
    }
    
    global Database.Querylocator start(Database.BatchableContext bc)
    {
        return Database.getQuerylocator(query);
    } 
    
    global void execute(Database.BatchableContext bc, List<S2V__Future_Voicemails__c> lstOfFVs)
    {
        Set<Id> recordsid = new Set<Id>();
        
        string XAPIkey;
        string OrgId;
        List<S2V__Future_Voicemails__c> updateFutrLst1 = new List<S2V__Future_Voicemails__c>();
        List<Task> lsttask = new List<Task>();
        List<Id> LstOfObjIds = new List<Id>(); 
        List<Id> LstOfActiveScheduleRecordId = new List<Id>();
        Boolean retValGet;
        
        System.debug('@@lstOfFVs: ' + lstOfFVs); 
     /*   if(lstOfFVs!=NULL && lstOfFVs.size()>0) {
            
            for(S2V__Future_Voicemails__c obj : lstOfFVs) {
                
                //S2V__Future_Voicemails__c obj_FV = (S2V__Future_Voicemails__c)obj;
                recordsid.add(obj.Id);
            }
        }
        
        
        System.debug('Number of SOQL Queries used: ' + Limits.getQueries());
        System.debug('Max SOQL Queries allowed: ' + Limits.getLimitQueries());
        
        if(settings != null){
            
            if(settings.S2V__XapiKey__c != null) {
                XAPIkey = KeyDecryptionClass.decryptValue(settings.S2V__XapiKey__c);
            }
            if(settings.S2V__OrganizationId__c != null) {
                OrgId = KeyDecryptionClass.decryptValue(settings.S2V__OrganizationId__c);  
            }
        }
        system.debug('@@123');
        
        if(recordsid.size() > 0 && Schema.SObjectType.S2V__Future_Voicemails__c.isAccessible() && Schema.SObjectType.S2V__Future_Voicemails__c.isUpdateable() && Schema.SObjectType.S2V__Future_Voicemails__c.fields.S2V__Sobject_Name__c.isAccessible()
           && Schema.SObjectType.S2V__Future_Voicemails__c.fields.id.isAccessible() && Schema.SObjectType.S2V__Future_Voicemails__c.fields.S2V__Record_Id__c.isAccessible() &&
           Schema.SObjectType.S2V__Future_Voicemails__c.fields.S2V__Error__c.isAccessible() && Schema.SObjectType.S2V__Future_Voicemails__c.fields.S2V__Status__c.isAccessible() &&
           Schema.SObjectType.S2V__Future_Voicemails__c.fields.Sending_Method__c.isAccessible() && Schema.SObjectType.S2V__Future_Voicemails__c.fields.S2V__ActiveScheduleRecordId__c.isAccessible()) {
               
               List<S2V__Future_Voicemails__c> ListOffvc = [Select id,S2V__Sobject_Name__c,S2V__Record_Id__c,S2V__Error__c,S2V__Status__c,Sending_Method__c,S2V__ActiveScheduleRecordId__c from S2V__Future_Voicemails__c
                                                            where Id in :recordsid];
               List<S2V__Future_Voicemails__c> ListOffvcNumbers = new List<S2V__Future_Voicemails__c>();
               //[Select id,S2V__Sobject_Name__c,S2V__Record_Id__c,S2V__Error__c,S2V__Status__c,Sending_Method__c,S2V__ActiveScheduleRecordId__c from S2V__Future_Voicemails__c
               // where Sending_Method__c ='SMS' AND S2V__Status__c = 'Queue' AND Id in :recordsid];
               
               Integer NumberOfFutureVoicemails = 0;
               
               system.debug('@@NumberOfFutureVoicemails'+NumberOfFutureVoicemails);
               for(S2V__Future_Voicemails__c ObjFV : ListOffvc) {
                   
                   if(ObjFV.Sending_Method__c =='SMS' &&  ObjFV.S2V__Status__c == 'Queue'){
                       ListOffvcNumbers.add(ObjFV); 
                   }
                   
                   List<Id> idpass = new List<Id>();
                   LstOfObjIds.add(ObjFV.S2V__Record_Id__c);
                   LstOfActiveScheduleRecordId.add(ObjFV.S2V__ActiveScheduleRecordId__c);
                   
               }    
               
               NumberOfFutureVoicemails = ListOffvcNumbers.size();
               if (Test.isRunningTest()) {
                   retValGet = true;
                   
               } else {
                   // METHOD THAT CREATES SMS/VM IN AIRWAVES
                   if(ListOffvc.size()>0){
                       retValGet = CallFutureMethodBatchFinalMethodNew(LstOfObjIds , ListOffvc[0].S2V__Sobject_Name__c, XAPIkey, OrgId,NumberOfFutureVoicemails,LstOfActiveScheduleRecordId); 
                   } 
                   
               }
               for(S2V__Future_Voicemails__c ObjFV : ListOffvc) {
                   
                   if(Schema.SObjectType.S2V__Future_Voicemails__c.isUpdateable()
                      && Schema.SObjectType.S2V__Future_Voicemails__c.fields.S2V__Status__c.isUpdateable()) {
                          
                          //UPDATES THE FUTURE VOICEMAIL RECORDS STATUS AS SENT
                          if(retValGet ==TRUE) {
                              
                              ObjFV.S2V__Status__c = 'Sent';
                              updateFutrLst1.add(ObjFV);
                              
                              Task tsk = new Task();
                              
                              if(Schema.SObjectType.Task.fields.Status.isCreateable() && Schema.SObjectType.Task.fields.Status.isAccessible() 
                                 && Schema.SObjectType.Task.isCreateable() && Schema.SObjectType.Task.isAccessible()
                                 && Schema.SObjectType.Task.fields.Priority.isCreateable()  && Schema.SObjectType.Task.fields.Priority.isAccessible()
                                 && Schema.SObjectType.Task.fields.Subject.isCreateable() && Schema.SObjectType.Task.fields.Subject.isAccessible() 
                                 && Schema.SObjectType.Task.fields.S2V__S2V_Send_Voicemail__c.isCreateable() && Schema.SObjectType.Task.fields.S2V__S2V_Send_Voicemail__c.isAccessible() 
                                 && Schema.SObjectType.Task.fields.Recording_number__c.isCreateable() && Schema.SObjectType.Task.fields.Recording_number__c.isAccessible()
                                 && Schema.SObjectType.Task.fields.Description.isCreateable() && Schema.SObjectType.Task.fields.Description.isAccessible() 
                                 && Schema.SObjectType.Task.fields.whatId.isCreateable() && Schema.SObjectType.Task.fields.whatId.isAccessible()
                                 && Schema.SObjectType.Task.fields.Description.isCreateable() && Schema.SObjectType.Task.fields.Description.isAccessible()
                                 && Schema.SObjectType.Task.fields.S2V__S2V_Recording_Description__c.isCreateable() && Schema.SObjectType.Task.fields.S2V__S2V_Recording_Description__c.isAccessible() 
                                 && Schema.SObjectType.Task.fields.S2V__Voicemail_Status__c.isCreateable()  && Schema.SObjectType.Task.fields.S2V__Voicemail_Status__c.isAccessible()
                                 && Schema.SObjectType.Task.fields.ActivityDate.isCreateable() && Schema.SObjectType.Task.fields.ActivityDate.isAccessible() 
                                 && Schema.SObjectType.Task.fields.SMS_Template_Name__c.isCreateable() && Schema.SObjectType.Task.fields.SMS_Template_Name__c.isAccessible()
                                 && Schema.SObjectType.Task.fields.WhoId.isCreateable() && Schema.SObjectType.Task.fields.WhoId.isAccessible()) 
                              {
                                  
                                  tsk.Status = Commonconstant.completed;
                                  tsk.Priority = Commonconstant.normal;
                                  tsk.WhoId = Airwaves360VoiceMailSendPageController.WhoIdbatch;
                                  tsk.whatId = Airwaves360VoiceMailSendPageController.whatIdbatch;
                                  tsk.ActivityDate = system.today();
                                  
                                  if(ObjFV.Sending_Method__c == 'Voicemail') {
                                      tsk.Subject = Commonconstant.autosubs;
                                      tsk.S2V__Voicemail_Status__c = 'Voicemail Sent Successfully';
                                      tsk.Recording_number__c = Airwaves360VoiceMailSendPageController.Recordingbatch;
                                      tsk.S2V__S2V_Recording_Description__c = Airwaves360VoiceMailSendPageController.decriptionbatch;
                                      lsttask.add(tsk);   
                                  }
                                  
                                  if(ObjFV.Sending_Method__c == 'SMS') {
                                      tsk.Subject = Commonconstant.autosubs;
                                      tsk.SMS_Template_Name__c = Airwaves360VoiceMailSendPageController.smstemplatenamebatch;
                                      tsk.Description = Airwaves360VoiceMailSendPageController.smsmessagebatch;
                                      lsttask.add(tsk);  
                                  }
                              }
                              
                              if(ObjFV.S2V__Sobject_Name__c ==  Commonconstant.Opportunity) {
                                  
                                  
                                  tsk.WhoId = Airwaves360VoiceMailSendPageController.WhoIdbatch;
                                  if(ObjFV.Sending_Method__c == 'SMS') {
                                      tsk.Subject = Commonconstant.autosubs;
                                  }
                                  
                              }
                              else {
                                  tsk.WhoId = Airwaves360VoiceMailSendPageController.firstwhoIdbatch;
                                  if(ObjFV.Sending_Method__c == 'SMS')
                                  {
                                      tsk.Subject = Commonconstant.smstitle;
                                      lsttask.add(tsk);   
                                  }
                              }
                          }
                          else {
                              //UPDATES THE FUTURE VOICEMAIL RECORDS STATUS AS FAILED
                              ObjFV.S2V__Status__c = 'Failed';
                              updateFutrLst1.add(ObjFV);
                          }
                      }
               }
               
               System.debug('@@updateFutrLst1 ' + updateFutrLst1);
               if(updateFutrLst1.size() > 0 
                  && Schema.SObjectType.Future_Voicemails__c.fields.S2V__Status__c.isUpdateable() 
                  && Schema.SObjectType.S2V__Future_Voicemails__c.isUpdateable())
               {   
                   System.debug('Number of SOQL Queries used: ' + Limits.getQueries());
                   System.debug('Max SOQL Queries allowed: ' + Limits.getLimitQueries());
                   //UPDATES THE FUTURE VOICEMAIL RECORDS
                   update updateFutrLst1;
               }
               
               if(lsttask.size()>0 && Schema.SObjectType.Task.fields.Status.isCreateable() && Schema.SObjectType.Task.fields.Status.isAccessible()
                  && Schema.SObjectType.Task.isCreateable()  && Schema.SObjectType.Task.isAccessible()
                  && Schema.SObjectType.Task.fields.Priority.isCreateable() && Schema.SObjectType.Task.fields.Priority.isAccessible()
                  && Schema.SObjectType.Task.fields.Subject.isCreateable()  && Schema.SObjectType.Task.fields.Subject.isAccessible() 
                  && Schema.SObjectType.Task.fields.S2V__Voicemail_Status__c.isCreateable() && Schema.SObjectType.Task.fields.S2V__Voicemail_Status__c.isAccessible()
                  && Schema.SObjectType.Task.fields.S2V__S2V_Send_Voicemail__c.isCreateable() && Schema.SObjectType.Task.fields.S2V__S2V_Send_Voicemail__c.isAccessible() 
                  && Schema.SObjectType.Task.fields.S2V__S2V_Recording_Description__c.isCreateable() && Schema.SObjectType.Task.fields.S2V__S2V_Recording_Description__c.isAccessible() 
                  && Schema.SObjectType.Task.fields.Recording_number__c.isCreateable() && Schema.SObjectType.Task.fields.Recording_number__c.isAccessible()
                  && Schema.SObjectType.Task.fields.Description.isCreateable() && Schema.SObjectType.Task.fields.Description.isAccessible() 
                  && Schema.SObjectType.Task.fields.whatId.isCreateable() && Schema.SObjectType.Task.fields.whatId.isAccessible()
                  && Schema.SObjectType.Task.fields.ActivityDate.isCreateable() && Schema.SObjectType.Task.fields.ActivityDate.isAccessible() 
                  && Schema.SObjectType.Task.fields.SMS_Template_Name__c.isCreateable() && Schema.SObjectType.Task.fields.SMS_Template_Name__c.isAccessible()
                  && Schema.SObjectType.Task.fields.Description.isCreateable() && Schema.SObjectType.Task.fields.Description.isAccessible()
                  && Schema.SObjectType.Task.fields.WhoId.isCreateable() && Schema.SObjectType.Task.fields.WhoId.isAccessible())
               {
                   //INSERTS TASK IN SALESFORCE
                   if (!Test.isRunningTest()) {
                       //insert lsttask;
                       List<Task> taskList = new List<Task>();
                       Map<String, Task> taskMap = new Map<String, Task>();
                       for (Task task : lsttask) {
                           taskMap.put(task.Id, task); // Key by Subject
                       }
                       
                       // Convert the Map values back to a list for DML
                       taskList = new List<Task>(taskMap.values());
                       
                       // Perform the DML
                       GenericBatchProcessorForAutomation.hasRunOnceFlag = true; 
                       insert taskList;
                   }
               }
           }
  */  }
    
    //FINISH
    global void finish(Database.BatchableContext bc)
    {
    }
    
    
    //METHOD THAT FETCHES VALUES FROM ACTIVE SCHEDULE AND CALLS ANOTHER METHOD FOR SMS/VM SENDING 
    global static Boolean CallFutureMethodBatchFinalMethodNew(List<id> lstSobjRcrds, String ObjectName,string XAPIkey, string OrgId,Integer NumberOfFutureVoicemails,List<Id> ActiveScheduleRecordId) {
        
        System.debug('Number of SOQL Queries used12345: ' + Limits.getQueries());
        System.debug('Max SOQL Queries allowed: ' + Limits.getLimitQueries());
        Boolean retVal = false;
        
  
        return retVal;
    }
    
    //METHOD THAT CREATES VOICEMAIL CAMPAIGN IN AIRWAVES
    global static Boolean sendVoicemailCampaignlsttoYabbarCallout(String ObjectName, String selectedVoice,
                                                                  String countryCode, String callerId, Integer optionSchedule, String ScheduleFreq,
                                                                  String startTime, String useridreference, List<id> lstSobjRcrds, Boolean isRecordingname
                                                                  ,Date startDate,List<Id> listOfContactId, Id activevoice,String XAPIkey,String OrgId
                                                                  ,Integer NumberOfFutureVoicemails,List<Id>lstOfContacts,List<sObject> sobjList) {
                                                                      
                                                                   Boolean isSuccess;
                                                                      
                                                                      return isSuccess;
                                                                  }
    
    //METHOD THAT CREATES SMS CAMPAIGN IN AIRWAVES
    global static Boolean sendSMSCampaignlsttoYabbarCallout( String objectName , String selectedTemplate ,string smsTemplateBody,
                                                            string smsTemplateName, string callerId, string startTime, Id activeVoice,
                                                            List<Id> listOfContactId, List<id> lstSobjRcrds,String XAPIkey,String OrgId,
                                                            Integer NumberOfFutureVoicemails,List<Id>lstOfContacts,List<sObject> sobjList,string contactLookup) {
                                                                
Boolean isSuccess;
                                                                return isSuccess;
                                                            }
    
    //METHOD THAT CUSTOMIZE SMS TEMPLATE WITH MERGE FIELDS
    global Static Map<Id, String>  replaceMergeFieldsforMultipleSMS (SObject objectName, String SMSTemplateBody, List<string> listOfContactId){
        
        List<string> LstOfErrorLeads = new List<string>();
        List<string> lstoffields =  new List<string>();
        Map<String, String> fieldValues = new Map<String, String>();
        string returnval = '';
        Map<Id, String> leadSmsTemplateMap = new Map<Id, String>(); // To store the result
        String sobjectName = (objectName != null) ? objectName.getSObjectType().getDescribe().getName() : null;
        String sendingObject = null;
       
        return leadSmsTemplateMap;
    }
    
    //METHOD THAT RETURNS STRING OF MOBILE AND CONTACT NAME
    Global static String PhonelistSMSNew(List<Id> lstCntIds,String ObjectName,Map<Id,String> MapOfTemplate )
    {
        List<String> phoneListSMS =new List<String>();
        String phoneListFinalSMS ;
        set<String> SetOfMobile = new set<String>();
        List<id> contactids = new List<id>();
        List<id> leadIds = new List<id>();
        List<Id> duplicateMobileIds = new List<Id>();
        if(lstCntIds!=NULL && lstCntIds.size()>0)
        {
            for(String objRecId : lstCntIds)
            {
                if(objRecId.startsWith('003'))
                {
                    //contactids = new Set<id>();
                    contactids.add(objRecId);
                }
                
                if(objRecId.startsWith('00Q'))
                {
                    //leadIds = new Set<id>();
                    leadIds.add(objRecId);
                }
            }
        }
        
        //if((leadIds != null && lstCntIds.size() > 0 && ObjectName != 'Lead' )
        //&& Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.fields.id.isAccessible()
        //&& Schema.sObjectType.Contact.fields.FirstName.isAccessible() && Schema.sObjectType.Contact.fields.LastName.isAccessible()
        //&& Schema.sObjectType.Contact.fields.Email.isAccessible() && Schema.sObjectType.Contact.fields.Phone.isAccessible()
        //&& Schema.sObjectType.Contact.fields.MobilePhone.isAccessible() && Schema.sObjectType.Contact.fields.MailingCountry.isAccessible())
        if( contactids != null)
        {
            //FILTERING CONTACTS WHICH CONTAINS MOBILENUMBERS
            List<Contact> lstCnts1 = [SELECT Id,FirstName, LastName, Email, Phone, MobilePhone,MailingCountry 
                                      FROM Contact 
                                      WHERE Id IN: lstCntIds WITH SECURITY_ENFORCED ORDER BY CreatedDate DESC];
            
            if(lstCnts1 != Null && lstCnts1.size()>0)
            {
                for(Contact cons : lstCnts1 )
                {
                    if(cons.MobilePhone != null )
                    { 
                        // if(!SetOfMobile.Contains(cons.MobilePhone)){
                        //   SetOfMobile.add(cons.MobilePhone);
                        phoneListSMS.add(cons.MobilePhone.deleteWhitespace()+'/'+MapOfTemplate.get(cons.Id));
                        
                        /*  }else{
                            duplicateMobileIds.add(cons.Id);
                        }*/
                        
                    }
                }
            }
            
            if(phoneListSMS != Null)
            {
                phoneListFinalSMS = string.join(phoneListSMS,'#');
                phoneListFinalSMS = phoneListFinalSMS.replace('(','');
                phoneListFinalSMS = phoneListFinalSMS.replace(')','');
                phoneListFinalSMS = phoneListFinalSMS.replace('-','');
            }
            
        } 
        
        if( leadIds!= null)
        {
            List<Lead> lstCnts = [SELECT Id,FirstName, LastName, Email, Phone, MobilePhone
                                  FROM Lead 
                                  WHERE Id IN: lstCntIds WITH SECURITY_ENFORCED ORDER BY CreatedDate DESC];
            
            if(lstCnts != Null && lstCnts.size()>0)
            {
                for(Lead  cons : lstCnts)
                {
                    if(cons.MobilePhone != null )
                    { 
                        // if(!SetOfMobile.Contains(cons.MobilePhone)){
                        // SetOfMobile.add(cons.MobilePhone);
                        phoneListSMS.add(cons.MobilePhone.deleteWhitespace()+'/'+MapOfTemplate.get(cons.Id));
                        
                        /* }else{
duplicateMobileIds.add(cons.Id);
}*/
                        
                    }
                }
            }
        }
        if(phoneListSMS != Null)
        {
            phoneListFinalSMS = string.join(phoneListSMS,'#');
            phoneListFinalSMS = phoneListFinalSMS.replace('(','');
            phoneListFinalSMS = phoneListFinalSMS.replace(')','');
            phoneListFinalSMS = phoneListFinalSMS.replace('-','');
            if(String.ValueOf(phoneListFinalSMS).substring(0,3) != '+61' && 
               String.ValueOf(phoneListFinalSMS).substring(0,2) != '61' && 
               String.ValueOf(phoneListFinalSMS).substring(0,1) != '0')
            {
                phoneListFinalSMS = '0' + phoneListFinalSMS;
            }
        }
        system.debug('@@phoneListFinalSMS '+phoneListFinalSMS);
        return phoneListFinalSMS;
    }
    
    public static Set<String> getFieldSet(String templateBody, String objectPrefix, Map<String, Schema.SObjectField> fieldMap) {
        Set<String> fieldsInTemplate = new Set<String>();
        for (String field : fieldMap.keySet()) {
            if (templateBody.containsIgnoreCase('{!' + objectPrefix + '.' + field + '}')) {
                fieldsInTemplate.add(field);
            }
        }
        return fieldsInTemplate;
    }
    
    //TEMPORARY
    public static Set<String> fields(Schema.sObjectType t) 
    {
        Set<String> result = new Set<String>();
        Map<String, Schema.SObjectField> fields = t.getDescribe().fields.getMap();
        return fields.keySet();
    }
    
    
    //METHOD THAT CREATES SMS TRANSCRIPTS IN AIRWAVES
    Global static Boolean sendSingleSMSMethod (String objectName, String fromNumber, String toNumber, String message,String XAPIkey)
    {
        string msgbody;
        if(message.contains('\n')) {
            List<String> lines = message.split('\n');
            System.debug('lines   ' +lines.size());
            
            for(String line : lines){
                
                if(line == lines[0]){
                    msgbody = line;
                }else{
                    msgbody = msgbody + '\\n'+line;
                }
                msgbody = msgbody.trim();
            }
            
        }else{
            msgbody = message;
        }
        
        // Create a new HTTP instance
        Http h = new Http(); 
        // Define the endpoint URL
        String endpoint = System.Label.SingleSMSendpoint; //'https://api.airwaves360.com/2019-01-23/messages';
        // Create a new HTTP request
        HttpRequest req = new HttpRequest(); 
        req.setEndpoint(endpoint);
        req.setMethod('POST'); 
        req.setHeader('x-api-key', XAPIkey);
        req.setHeader('Content-Type', 'application/json');
        
        if(toNumber.startsWith('0')) {
            toNumber = toNumber.replaceFirst('0','61');
            
        } else if(toNumber.startsWith('+')){
            toNumber = toNumber.replaceFirst('+','');
        }
        // Set request body
        String requestBody = '{"to": "'+toNumber+'", "from": "'+fromNumber+'", "content": "'+msgbody+'", "type": "sms", "transcribe": true}';
        req.setBody(requestBody);
        
        HttpResponse res = h.send(req);
        Boolean isSusccess;
        
        if(res.getStatusCode() == 200 || res.getStatusCode() == 201) {
            isSusccess = True;
            
        } else {
            isSusccess = False;
        }
        return isSusccess;
    }
    
    
    // Method to get the city part of the timezone
    public static String getUserTimezoneCity() {
        String timezoneLabel = UserInfo.getTimeZone().getDisplayName();
        
        // Regular expression to match the city part within parentheses
        Pattern regex = Pattern.compile('\\(([^)]+)\\)$');
        Matcher matcher = regex.matcher(timezoneLabel);
        
        // Extract the city part
        if (matcher.find()) {
            return matcher.group(1);
        }
        // Return an empty string or a default value if the expected format is not found
        return '';
    }
    
    //METHOD THAT RETURNS CONTACT NAME
    public static String getContactName(List<Id> listOfContactId) {
        String conName;
        
        if (Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.fields.Name.isAccessible()) {
            
            List<Contact> conList = [SELECT Id, Name FROM Contact WHERE Id IN :listOfContactId LIMIT 1];
            
            if (conList.isEmpty()) {
                
                if (Schema.sObjectType.Lead.isAccessible() && Schema.sObjectType.Lead.fields.Name.isAccessible()) {
                    
                    List<Lead> leadList = [SELECT Id, Name FROM Lead WHERE Id IN :listOfContactId LIMIT 1];
                    conName = leadList.isEmpty() ? null : leadList[0].Name;
                } else {
                    conName = null;
                }
            } else {
                conName = conList[0].Name;
            }
        } else {
            conName = null;
        }
        return conName;
    }
    
    //METHOD THAT RETURNS SCHEDULE TYPE
    public static String getScheduleName(Id activevoice) {
        String ScheduleName;
        
        if (Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.fields.Name.isAccessible()) {
                
                List<S2V__Airwaves360_Active_Schedule__c> LstOfActiveSchedule = [SELECT Id, Name FROM S2V__Airwaves360_Active_Schedule__c WHERE Id = :activevoice];
                ScheduleName = !LstOfActiveSchedule.isEmpty() ? LstOfActiveSchedule[0].Name : null;
            } else {
                ScheduleName = null;
            }
        return ScheduleName;
    }
    
    //GETING ALL MOBILE NUMBERS OF INSERTED CONTACT AND SEND TO THE S2V SYSTEM TO MAKE VOICE MAIL
    Global static String Phonelist(List<Id> lstCntIds,String ObjectName)
    {
        List<String> phoneList =new List<String>();
        String phoneListFinal ;
        List<id> contactids = new List<id>();
        List<id> leadIds = new List<id>();
        
        if(lstCntIds!=NULL && lstCntIds.size()>0)
        {
            for(String objRecId : lstCntIds)
            {
                if(objRecId.startsWith('003'))
                {
                    
                    contactids.add(objRecId);
                }
                
                if(objRecId.startsWith('00Q'))
                {
                    leadIds.add(objRecId);
                }
            }
        }
        if((contactids != null && lstCntIds.size() > 0 && ObjectName != 'Lead')
           && Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.fields.id.isAccessible()
           && Schema.sObjectType.Contact.fields.FirstName.isAccessible()  && Schema.sObjectType.Contact.fields.LastName.isAccessible()
           && Schema.sObjectType.Contact.fields.Email.isAccessible() && Schema.sObjectType.Contact.fields.Phone.isAccessible()
           && Schema.sObjectType.Contact.fields.MobilePhone.isAccessible() && Schema.sObjectType.Contact.fields.MailingCountry.isAccessible())
        {
            //FILTERING CONTACTS WHICH CONTAINS MOBILENUMBERS
            List<Contact> lstCnts1 = [SELECT Id,FirstName, LastName, Email, Phone, MobilePhone, MailingCountry 
                                      FROM Contact 
                                      WHERE Id IN: lstCntIds];
            
            if(lstCnts1 != Null && lstCnts1.size()>0)
            {
                for(Contact cons : lstCnts1 )
                {
                    if(cons.MobilePhone != null)
                    { 
                        phoneList.add(cons.firstName+'/' + cons.LastName+'/' + cons.MobilePhone.deleteWhitespace());
                    }
                }
            }
            
            if(phoneList != Null)
            {
                phoneListFinal = string.join(phoneList,'#');
                phoneListFinal = phoneListFinal.replace('(','');
                phoneListFinal = phoneListFinal.replace(')','');
                phoneListFinal = phoneListFinal.replace('-','');
            }
        } 
        
        //FILTERING lEADS WHICH CONTAINS MOBILENUMBERS
        if(leadIds != null && Schema.sObjectType.Lead.isAccessible() && Schema.sObjectType.Lead.fields.id.isAccessible()
           && Schema.sObjectType.Lead.fields.FirstName.isAccessible() && Schema.sObjectType.Lead.fields.LastName.isAccessible()
           && Schema.sObjectType.Lead.fields.Email.isAccessible() && Schema.sObjectType.Lead.fields.Phone.isAccessible()
           && Schema.sObjectType.Lead.fields.MobilePhone.isAccessible())
        {
            List<Lead> lstCnts = [SELECT Id,FirstName, LastName, Email, Phone, MobilePhone
                                  FROM Lead 
                                  WHERE Id IN: lstCntIds];
            
            if(lstCnts != Null && lstCnts.size()>0)
            {
                for(Lead  cons : lstCnts )
                {
                    if(cons.MobilePhone != null)
                    { 
                        phoneList.add(cons.firstName+'/' + cons.LastName+'/' + cons.MobilePhone.deleteWhitespace());
                    }
                }
            }  
        }
        
        if(phoneList != Null)
        {
            phoneListFinal = string.join(phoneList,'#');
            phoneListFinal = phoneListFinal.replace('(','');
            phoneListFinal = phoneListFinal.replace(')','');
            phoneListFinal = phoneListFinal.replace('-','');
        }
        
        //RETURNING FINAL LIST OF MOBILENUMBERS TO SEND A VOICE MAIL
        return phoneListFinal;
    }
    
    
}