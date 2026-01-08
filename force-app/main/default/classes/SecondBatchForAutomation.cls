public With Sharing class SecondBatchForAutomation implements Database.Batchable<Id>, Database.Stateful, Database.AllowsCallouts {
    
    
    Map<Id, List<S2V__Future_Voicemails__c>> MapOfConditionAndLstOfFV = new Map<Id, List<S2V__Future_Voicemails__c>>();
    // Define the map to be used as a parameter
    public string ObjectName;
    S2V__Airwaves360_settings__c settings;
    Map<Id, User> userMap = new  Map<Id, User>();
    Public Set<Id> lstOfConWithBlankMobile = new Set<Id>();
    Public Set<Id> LstOfRecWithInvalidMobile = new Set<Id>();
    Public List<String> serializedDataList = new List<String>();
    Public List<String> serializedDataListForUser = new List<String>();
    Public Set<Id> lstOfRecWithBlankFieldVal = new Set<Id>();
    public Map<Id,List<String>> mapOfChatterPost = new Map<Id,List<String>>();
    Public List<Id> setOfCorrectContacts = new List<Id>();
    Public List<String> LstOfContacttoProcess = new List<String>();
    public Map<Id,List<String>> mapOfChatterPostForInvalidField = new Map<Id,List<String>>();
    public static Boolean isBulkSMS = false;
    public List<wrapperofFileds> wrapperList = new List<wrapperofFileds>();
    public Map<Id,List<Id>> mapOfASAndObjIds = new  Map<Id, List<Id>>();
    public Map<Id,Set<String>> mapOfASAndMobile = new   Map<Id,Set<String>>();
    Public Set<Id> lstOfObjectToUpdtSMSSent = new Set<Id>();
    Public Set<Id> setOfFVToUpdate = new Set<Id>();
    List<S2V__Airwaves360_Active_Schedule__c> lstSndVcmails = new List<S2V__Airwaves360_Active_Schedule__c>();
    string XAPIkey;
    string OrgId;
    
    
    public class wrapperofFileds{
        public string campaignId;
        public string OrgId;
        public string XAPIkey;
        public Id userId;
        public Boolean isBulkSMS;
        
        
        // Constructor that initializes the wrapper fields
        public wrapperofFileds(String campaignId, String OrgId, String XAPIkey, Id userId, Boolean isBulkSMS) {
            this.campaignId = campaignId;
            this.OrgId = OrgId;
            this.XAPIkey = XAPIkey;
            this.userId = userId;
            this.isBulkSMS = isBulkSMS;
        }
    }
    
    public SecondBatchForAutomation(Map<Id, List<S2V__Future_Voicemails__c>> MapOfConditionAndLstOfFV,string ObjectName) {
        this.MapOfConditionAndLstOfFV = MapOfConditionAndLstOfFV;
        this.ObjectName = ObjectName;
        if(Schema.SObjectType.S2V__Airwaves360_settings__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.Id.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__OrganizationId__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__XapiKey__c.isAccessible()) {
               
               settings =[SELECT id,S2V__OrganizationId__c,S2V__XapiKey__c  FROM S2V__Airwaves360_settings__c LIMIT 1]; //yabbar_settings__c.getInstance();  
           } 
        
         if(MapOfConditionAndLstOfFV.keySet() != null && MapOfConditionAndLstOfFV.size()>0){
            userMap = new Map<Id, User>(
                [SELECT Id, Name, Email,S2V__Airwaves_Verified_Number__c FROM User WHERE Id IN :MapOfConditionAndLstOfFV.keySet()]
            );  
        }
        
        
    }
    
    public Iterable<Id> start(Database.BatchableContext BC) {
               if(settings != null){
                    if(settings.XapiKey__c != null) {
                        XAPIkey = KeyDecryptionClass.decryptValue(settings.XapiKey__c);
                    }
                    if(settings.OrganizationId__c != null) {
                        OrgId = KeyDecryptionClass.decryptValue(settings.OrganizationId__c);  
                    }
                }
        
          lstSndVcmails = [SELECT S2V__Is_Active__c, S2V__Reference_Field_Lable__c, S2V__Airwaves360_Active_Schedule__c.S2V__Caller_Id__c, Id,S2V__Schedule_TIme_textBox__c,
                                                                  S2V__Object_Name__c,  S2V__Option_Schedule__c, S2V__Recording_Name__c, S2V__Reference_Field__c,
                                                                  S2V__Schedule_Frequency__c, S2V__Start_Date__c, S2V__Voice_mail_1_User__c, S2V__Recording_By_1_User__c,
                                                                  S2V__Start_Time__c, S2V__Recording_Number__c,S2V__Temp_time_field__c,S2V__S2vQuery__c,S2V__Schedule_Time__c,
                                                                  S2V__Selected_Lookup__c, S2V__Activity_History__c, S2V__Sending_Method__c, S2V__Next_Date__c, S2V__Only_time__c, S2V__SMS_Template_Body_New__c, 
                                                                  S2V__SMS_Template_Name__c, S2V__SMS_Object__c FROM S2V__Airwaves360_Active_Schedule__c 
                                                                  WHERE S2V__Object_Name__c != null AND S2V__Is_Active__c = True 
                                                                  AND S2V__Object_Name__c =: ObjectName.trim() AND S2V__Sending_Method__c!=NULL];

       
        
        
       
        return MapOfConditionAndLstOfFV.keySet();
    }
    
    public void execute(Database.BatchableContext BC, List<Id> scope) {

        if(MapOfConditionAndLstOfFV != null && MapOfConditionAndLstOfFV.size()>0){
            //loop will execute for the diffrent user which will trigger the automation      
            for (String key : MapOfConditionAndLstOfFV.keySet()) {
                if(scope.Contains(key)){
                mapOfASAndObjIds.clear();
                
                Set<Id> LstOfObjIds = new Set<Id>();
                List<S2V__Future_Voicemails__c> lstOfFutureVM = new List<S2V__Future_Voicemails__c>();
                Id UserId = key;
                List<Id> LstOfActiveScheduleRecordId = new List<Id>();
                string UserMobile;
                
                if(userMap.containsKey(key)){
                    if(userMap.get(key).S2V__Airwaves_Verified_Number__c != null){
                        UserMobile = userMap.get(key).S2V__Airwaves_Verified_Number__c; 
                    }
                }
                if(MapOfConditionAndLstOfFV.containsKey(key)){
                    if(MapOfConditionAndLstOfFV.get(key) != null){
                        lstOfFutureVM = MapOfConditionAndLstOfFV.get(key);   
                    }  
                }
                if(lstOfFutureVM.size() > 0 ) {
                    
                    Integer NumberOfFutureVoicemails = 0;
                    for(S2V__Future_Voicemails__c ObjFV : lstOfFutureVM) {
                        if(ObjFV.S2V__Sending_Method__c =='SMS' &&  ObjFV.S2V__Status__c == 'Queue'){
                            if(!setOfFVToUpdate.contains(ObjFV.Id)){
                                setOfFVToUpdate.add(ObjFV.Id);
                                
                                LstOfActiveScheduleRecordId.add(ObjFV.S2V__ActiveScheduleRecordId__c);
                                //ListOffvcNumbers.add(ObjFV); 
                                
                                if(mapOfASAndObjIds.containsKey(ObjFV.S2V__ActiveScheduleRecordId__c)){
                                    mapOfASAndObjIds.get(ObjFV.S2V__ActiveScheduleRecordId__c).add(ObjFV.S2V__Record_Id__c);
                                    
                                }else{
                                    List<Id> lstOfRecIds = new List<Id>();
                                    lstOfRecIds.add(ObjFV.S2V__Record_Id__c);
                                    mapOfASAndObjIds.put(ObjFV.S2V__ActiveScheduleRecordId__c,lstOfRecIds);
                                }
                                LstOfObjIds.add(ObjFV.S2V__Record_Id__c);
                            }
                        }
                    }  
                    // METHOD THAT CREATES SMS IN AIRWAVES
                    if(lstOfFutureVM.size()>0 ){
                         MethodForAutomationCallout(mapOfASAndObjIds , lstOfFutureVM[0].S2V__Sobject_Name__c, XAPIkey, OrgId,NumberOfFutureVoicemails,LstOfActiveScheduleRecordId,lstOfFutureVM,UserMobile,UserId,lstSndVcmails); 
                    } 
                    
                }
            }}
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        
         system.debug('@@lstOfObjectToUpdtSMSSent-->'+lstOfObjectToUpdtSMSSent.size());
		 system.debug('@@serializedDataList-->'+serializedDataList.size());
		system.debug('@@lstOfObjectToUpdtSMSSent-->'+lstOfObjectToUpdtSMSSent.size());
		system.debug('@@wrapperList-->'+wrapperList.size());
		system.debug('@@wrapperList-->'+wrapperList);

         if(lstOfObjectToUpdtSMSSent.size()>0 && lstOfObjectToUpdtSMSSent != null){
            BatchToUpdtObjectToSMSSent batchJob = new BatchToUpdtObjectToSMSSent(lstOfObjectToUpdtSMSSent);
            Database.executeBatch(batchJob, 200);
            
        }
        
       if(serializedDataList.size()>0 || serializedDataListForUser.size()>0){
            // Queueable class that creating chatter posts
           // ChatterPostBatch batchJob = new ChatterPostBatch(serializedDataList, serializedDataListForUser);
           // Database.executeBatch(batchJob, 200);
            
        }
        if(wrapperList.size()>0 && wrapperList != null){
            String WraperJson = JSON.serialize(wrapperList);
            if(!Test.IsRunningTest()) {
                System.enqueueJob(new chatterErrorMsgQueueable(WraperJson),2);
            }
            
        }
        
    }
    
     
    //METHOD THAT FETCHES VALUES FROM ACTIVE SCHEDULE AND CALLS ANOTHER METHOD FOR SMS/VM SENDING 
    Public  Boolean MethodForAutomationCallout(Map<Id,List<Id>>mapOfASAndObjIds, String ObjectName,string XAPIkey, string OrgId,Integer NumberOfFutureVoicemails,List<Id> ActiveScheduleRecordId,List<S2V__Future_Voicemails__c> lstOfObjFV,string UserMobile,Id UserId,List<S2V__Airwaves360_Active_Schedule__c> lstSndVcmails) {
        Boolean retVal = false;
        if(mapOfASAndObjIds != null && mapOfASAndObjIds.size() > 0 && ObjectName != null && ObjectName.trim() != '')
        {
                STRING contactLookup;
                STRING Query;
                BOOLEAN voicemail;
                BOOLEAN SMS;
                BOOLEAN ActivityHistory;
                STRING startTime;
                STRING smsTemplateName;
                STRING smsTemplateBody;
                STRING newQuery1;
                STRING newQuery;
                STRING activeVoiceid;
                string dynamicQuery;
                
                //MAIN FOR LOOP STARTS HERE****ASSIGNING VALUES FROM ACTIVE SCHEDULES TO STRING****
                for(S2V__Airwaves360_Active_Schedule__c activevoice : lstSndVcmails)
                {   
                    if(mapOfASAndObjIds.containsKey(activevoice.id)){
                   
                    List<Id> lstSobjRcrds = new List<Id>();
                    List<Id> lstCntIds = new List<Id>();
                    LstOfRecWithInvalidMobile.clear();//invalid mobile
                    lstOfConWithBlankMobile.clear();//blank mobile
                    setOfCorrectContacts.clear();
                    LstOfContacttoProcess.clear();
                    mapOfChatterPost.clear();
                    //mapOfASAndObjIds.clear();
                    
                    if(activevoice.id!=NULL && activevoice.S2V__Is_Active__c == TRUE) {
                        activeVoiceid = activevoice.id;
                    }
                    if(activeVoice.S2V__Activity_History__c!=NULL) {
                        ActivityHistory = activeVoice.S2V__Activity_History__c;
                    }
                    
                    if(activevoice.S2V__Selected_Lookup__c != Null && activevoice.S2V__Selected_Lookup__c != ''){
                        contactLookup = activevoice.S2V__Selected_Lookup__c;
                    } else {
                        contactLookup = 'Id';
                    }
                    
                    if(activeVoice.S2V__S2vQuery__c!=NULL && activeVoice.S2V__S2vQuery__c!=''){
                        Query = activevoice.S2V__S2vQuery__c.substring(activevoice.S2V__S2vQuery__c.indexOf('[')+1);
                    }
                    
                    if(activevoice.S2V__Sending_Method__c == 'SMS'){
                        voicemail = FALSE;
                        SMS = TRUE;
                    }
                    
                    if(activevoice.S2V__Start_Time__c!=NULL && activeVoice.S2V__Start_Time__c!='') {
                        startTime = string.valueOf(activevoice.S2V__Start_Time__c);
                    }
                    
                    if(activevoice.S2V__SMS_Template_Body_New__c!=NULL && activevoice.S2V__SMS_Template_Body_New__c!=''){
                        smsTemplatebody = activevoice.S2V__SMS_Template_Body_New__c;
                    }
                    
                    if(Query!=NULL && Query!=''){
                        newquery1 = Query.replace(']','');
                        newquery = newquery1.replace(';','');
                    }
                    lstSobjRcrds = mapOfASAndObjIds.get(activevoice.Id);
                    lstOfObjectToUpdtSMSSent.addAll(lstSobjRcrds);
                    Set<Id> setOfSobjRcrds = new Set<Id>(lstSobjRcrds);
                    if(newquery.contains('WHERE')){
                        dynamicQuery = newquery+' AND ID IN : setOfSobjRcrds AND Type != \'Email\' ORDER BY CreatedDate DESC';
                    } else {
                        dynamicQuery = newquery+' where ID IN : setOfSobjRcrds AND Type != \'Email\' ORDER BY CreatedDate DESC';
                    }
                    List<sObject> sobjList = new List<sObject>(); 
                    if(dynamicQuery != null){
                        sobjList = Database.query(dynamicQuery);
                    }  
                    NumberOfFutureVoicemails = sobjList.size();
                    //MAIN FOR LOOP ENDS HERE *********
                    Map<Id,Id> MapOfConANDObj = new Map<Id,Id>();
                    
                    if(sobjList!=NULL && sobjList.size()>0)
                    {
                        for(sObject obj : sobjList)
                        {
                            string IdField;
                            if(ObjectName == 'Task'){
                                IdField = (String)obj.get('WhoId'); 
                            }
                            if(ObjectName == 'Task'){
                                
                                if(obj.get('WhoId') != null){
                                    lstCntIds.add((Id)obj.get('WhoId'));
                                    MapOfConANDObj.put((Id)obj.get('WhoId'),obj.Id);
                                }
                                contactLookup = 'WhoId';
                            } 
                        }
                    }
                    
                    if( lstCntIds != null && lstCntIds.size()>0)
                    {   
                        if(SMS == TRUE )
                        {
                            //Method that creates SMS campaign in Airwaves 
                            retVal = sendSMSCampaignlsttoYabbarCallout(objectName,smsTemplateBody,   
                                                                       startTime,activevoice,lstCntIds, setOfSobjRcrds,XAPIkey,OrgId,
                                                                       NumberOfFutureVoicemails, sobjList,contactLookup, lstOfObjFV,UserMobile,UserId,activevoice.S2V__Sending_Method__c,MapOfConANDObj);
                        }
                    }
                }
                }
        }
        return retVal;
    }
    
    //METHOD THAT CREATES SMS CAMPAIGN IN AIRWAVES
    Public Boolean sendSMSCampaignlsttoYabbarCallout( String objectName ,string smsTemplateBody,
                                                            string startTime, S2V__Airwaves360_Active_Schedule__c activeSchedule, List<Id> listOfContactId,
                                                            Set<id> lstSobjRcrds,String XAPIkey,String OrgId,
                                                            Integer NumberOfFutureVoicemails,
                                                            List<sObject> sobjList,string contactLookup,List<S2V__Future_Voicemails__c> lstOfObjFV,
                                                            string UserMobile,Id UserId,string SendingMethod,Map<Id,Id>MapOfConANDObj ) {
                                                                
                                                                Set<string> contactIds = new Set<string>();
                                                                Set<string> leadIds = new Set<string>();
                                                                
                                                                for(string  conIds : listOfContactId){
                                                                    if (conIds.startsWith('003')) {  // Contact ID
                                                                        contactIds.add(conIds);
                                                                    } else if (conIds.startsWith('00Q')) {  // Lead ID
                                                                        leadIds.add(conIds);
                                                                    }
                                                                }
                                                                
                                                                // Query contacts and leads in bulk (one query for each)
                                                                Map<Id, Contact> contactMap = new Map<Id, Contact>();
                                                                Map<Id, Lead> leadMap = new Map<Id, Lead>();
                                                                
                                                                if (!contactIds.isEmpty()) {
                                                                    contactMap = new Map<Id, Contact>([SELECT Id, FirstName, LastName, Email, Phone, MobilePhone, MailingCountry FROM Contact WHERE Id IN :contactIds ORDER BY CreatedDate DESC]);
                                                                }
                                                                
                                                                if (!leadIds.isEmpty()) {
                                                                    leadMap = new Map<Id, Lead>([SELECT Id, FirstName, LastName, Email, Phone, MobilePhone FROM Lead WHERE Id IN :leadIds ORDER BY CreatedDate DESC]);
                                                                }
                                                                
                                                                Boolean isSuccess;
                                                                
                                                                if(UserMobile != null && UserMobile != ''){
                                                                    
                                                                    map<Id,string> mapOftemplate = new map<Id,string>();
                                                                    Schema.sObjectType newObjectName = Schema.getGlobalDescribe().get(objectName);
                                                                    Sobject genericObject = newObjectName.newSObject();
                                                                    List<String> mergeFields = new List<String>();
                                                                    boolean invalidFields = false;
                                                                    List<string> phoneListFinalSMS = new List<string>();
                                                                    Set<Id> setOfDuplicateId = DuplicateContacts(sobjList,ObjectName, SendingMethod,lstSobjRcrds,activeSchedule.Id,contactMap,leadMap);
                                                                    
                                                                    mapOftemplate =  replaceMergeFieldsforMultipleSMS(genericObject, smsTemplateBody,LstOfContacttoProcess,MapOfConANDObj);
                                                                    if(mapOftemplate.size()>0){
                                                                        for( id conId : mapOftemplate.keyset()){
                                                                            if(mapOftemplate.get(conId).contains ('{!User') ||mapOftemplate.get(conId).contains ('{!Organization') || mapOftemplate.get(conId).contains('{!Contact') || mapOftemplate.get(conId).contains('{!Lead')){
                                                                                invalidFields = true; 
                                                                                Pattern pattern = Pattern.compile('\\{\\![^\\}]+\\}');
                                                                                Matcher matcher = pattern.matcher(mapOftemplate.get(conId));
                                                                                while (matcher.find()) {
                                                                                    mergeFields.add(matcher.group());
                                                                                }
                                                                            }
                                                                        }  
                                                                    }
                                                                    
                                                                    if(invalidFields == false){
                                                                        if(setOfCorrectContacts.size()>0){
                                                                            phoneListFinalSMS = PhonelistSMSNew(setOfCorrectContacts,ObjectName,mapOftemplate,SendingMethod,contactMap,leadMap);  
                                                                        }
                                                                        string commonURL = System.Label.CommonURL;
                                                                        String name = objectName+' Bulk SMS' ;
                                                                        string timeZoneSMS = getUserTimezoneCity();
                                                                        
                                                                        
                                                                        HttpRequest req = new HttpRequest();
                                                                        req.setEndpoint(CommonURL+OrgId+'/campaigns');
                                                                        req.setMethod('POST');
                                                                        req.setHeader('Content-Type', 'application/json');
                                                                        req.setHeader('x-api-key', XAPIkey);
                                                                        
                                                                        if(NumberOfFutureVoicemails == 1 && mapOftemplate.size()== 1 ){
                                                                            
                                                                            string contactMobile;
                                                                            if(listOfContactId.size()>0){
                                                                                if(String.valueOf(listOfContactId[0]).startsWith('00Q')){
                                                                                    
                                                                                    Lead lead =[SELECT id,MobilePhone from Lead where Id in :listOfContactId Limit 1]; 
                                                                                    contactMobile = lead.MobilePhone;
                                                                                } else if(String.valueOf(listOfContactId[0]).startsWith('003')){
                                                                                    
                                                                                    Contact contact =[SELECT id,MobilePhone from Contact where Id in :listOfContactId Limit 1]; 
                                                                                    contactMobile = Contact.MobilePhone;
                                                                                }
                                                                               
                                                                                if(contactMobile != null ){
                                                                                     contactMobile = contactMobile.replaceAll('[^\\d]', '');
                                                                                    if(contactMobile.startsWith('02') || contactMobile.startsWith('03') || contactMobile.startsWith('07') || contactMobile.startsWith('08')){
                                                                                        LstOfRecWithInvalidMobile.add(sobjList[0].id);
                                                                                    }else{
                                                                                        if(contactMobile.startsWith('0')){
                                                                                            contactMobile = contactMobile.replaceFirst('0','61').deleteWhitespace();
                                                                                            
                                                                                        } else if(contactMobile.startsWith('+0')){
                                                                                            contactMobile = contactMobile.replaceFirst('\\+0', '61').deleteWhitespace();
                                                                                            
                                                                                        } else if(contactMobile.startsWith('+61')){
                                                                                            contactMobile = contactMobile.replaceFirst('\\+', '').deleteWhitespace();
                                                                                            
                                                                                        } else if(contactMobile.startsWith('+')){
                                                                                            contactMobile = contactMobile.replaceFirst('\\+', '61').deleteWhitespace();
                                                                                            
                                                                                        }else if(contactMobile.startsWith('4')){
                                                                                            contactMobile = contactMobile.replaceFirst('', '61').deleteWhitespace();
                                                                                            
                                                                                        } else{
                                                                                            contactMobile = contactMobile.deleteWhitespace();
                                                                                        }
                                                                                        if(contactMobile.length() == 11){
                                                                                            isSuccess = sendSingleSMSMethod(objectName,UserMobile,contactMobile,mapOftemplate.get(listOfContactId[0]),XAPIkey,OrgId,lstOfObjFV,UserId);
                                                                                            
                                                                                        }else{
                                                                                            LstOfRecWithInvalidMobile.add(sobjList[0].id);
                                                                                        }
                                                                                    }
                                                                                }
                                                                                else{
                                                                                    lstOfConWithBlankMobile.add(sobjList[0].id);
                                                                                }
                                                                            } 
                                                                            
                                                                        }
                                                                        else if(NumberOfFutureVoicemails>1){
                                                                            string FileId;
                                                                            if(phoneListFinalSMS.size()>0){
                                                                                FileId =CSVGenerator.writeCSVToFileSMS(phoneListFinalSMS,XAPIkey,OrgId);  
                                                                                //}
                                                                                
                                                                                Datetime now = Datetime.now(); // Current date and time in the user's time zone
                                                                                
                                                                                if(activeSchedule != null && activeSchedule.S2V__Option_Schedule__c == 'Future Call' && activeSchedule.S2V__Schedule_TIme_textBox__c != null){
                                                                                    
                                                                                    if(activeSchedule.S2V__Schedule_Time__c == 'Days'){
                                                                                        now = Datetime.now().addDays(Integer.ValueOf(activeSchedule.S2V__Schedule_TIme_textBox__c));
                                                                                        
                                                                                    }else if(activeSchedule.S2V__Schedule_Time__c == 'Hours'){
                                                                                        now = Datetime.now().addHours(Integer.ValueOf(activeSchedule.S2V__Schedule_TIme_textBox__c));
                                                                                        
                                                                                    }else if(activeSchedule.S2V__Schedule_Time__c == 'Minutes' ){
                                                                                        now = Datetime.now().addMinutes(Integer.ValueOf(activeSchedule.S2V__Schedule_TIme_textBox__c));
                                                                                    }                                                                          
                                                                                }
                                                                                // Format the UTC date
                                                                                Date utcDate = now.dateGMT();
                                                                                // Format the UTC time
                                                                                Time utcTime = Time.newInstance(now.hourGMT(), now.minuteGMT(), now.secondGMT(), 0);
                                                                                Integer startHr = utcTime.hour();
                                                                                Integer startMin = utcTime.minute();
                                                                                string minutes;
                                                                                string hours;
                                                                                if(startMin < 10){
                                                                                    minutes = '0' + string.ValueOf(startMin); 
                                                                                }
                                                                                else{
                                                                                    minutes =  string.ValueOf(startMin); 
                                                                                }
                                                                                
                                                                                if(startHr < 10){
                                                                                    hours = '0' + string.ValueOf(startHr); 
                                                                                }
                                                                                else{
                                                                                    hours =  string.ValueOf(startHr);
                                                                                }
                                                                                startTime  = hours + ':' + minutes;
                                                                                Integer startHour = Integer.valueOf(startTime.substring(0, 2));
                                                                                Integer startMinute = Integer.valueOf(startTime.substring(3));
                                                                                
                                                                                // Calculate end hour one hour after start hour
                                                                                Integer endHour = startHour + 1;
                                                                                if (endHour >= 24) {
                                                                                    endHour -= 24; // Adjust if it exceeds 23
                                                                                }
                                                                                
                                                                                // Ensure two digits for the hour
                                                                                String endHourString = String.valueOf(endHour);
                                                                                if (endHour < 10) {
                                                                                    endHourString = '0' + endHourString;
                                                                                }
                                                                                
                                                                                // Ensure two digits for the minute
                                                                                String endMinuteString = String.valueOf(startMinute);
                                                                                if (startMinute < 10) {
                                                                                    endMinuteString = '0' + endMinuteString;
                                                                                }
                                                                                
                                                                                String endTime = endHourString + ':' + endMinuteString;
                                                                                
                                                                                String payload = '{'+
                                                                                    '"data":['+
                                                                                    '{'+
                                                                                    '"file":"'+FileId+'",'+
                                                                                    '"destinationIndex":0,'+
                                                                                    '"fields":["phone","Message"],'+
                                                                                    '"firstDataRow":1'+
                                                                                    '}'+
                                                                                    '],'+
                                                                                    '"timezone":"'+timeZoneSMS+'",'+
                                                                                    '"deduplication":"destinations",'+
                                                                                    '"message":"{{Message}}",'+
                                                                                    '"type":"sms",'+
                                                                                    '"shortenUrls":true,'+
                                                                                    '"senderId":"'+UserMobile+'",'+
                                                                                    '"times":[{"startTime":"'+startTime+'","endTime":"'+endTime+'"}],'+
                                                                                    '"rate":10000,'+
                                                                                    '"name":"'+name+'",' +
                                                                                    '"live":true,'+
                                                                                    '"approved":true'+
                                                                                    '}';
                                                                                req.setBody(payload);
                                                                                
                                                                                Http http = new Http();
                                                                                HttpResponse res = http.send(req);
                                                                                
                                                                                if(res.getStatusCode() == 201){
                                                                                    isSuccess = true; 
                                                                                    isBulkSMS = true;
                                                                                    Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                                                                                    // Get the ID value
                                                                                    String CampaignId = (String) resultMap.get('id');
                                                                                    wrapperList.add(new wrapperofFileds(CampaignId,OrgId,XAPIkey,UserId,isBulkSMS));
                                                                                    //System.enqueueJob(new chatterErrorMsgQueueable(CampaignId,OrgId,XAPIkey,UserId,isBulkSMS), 2);
                                                                                    
                                                                                } else{
                                                                                    isSuccess = false;
                                                                                }
                                                                            }
                                                                            
                                                                        }
                                                                        // List to hold all FeedItem objects to be inserted
                                                                        if(setOfDuplicateId.size()>0 ){
                                                                            string chatterMessage = 'Duplicate phone number(s) have been found, please only bulk send to unique numbers';
                                                                            postChatterPosts(setOfDuplicateId, objectName,UserId,chatterMessage);
                                                                        }
                                                                        if(lstOfConWithBlankMobile.size()>0){
                                                                            string chatterMessage = 'Mobile Phone Missing! \nMobile Phone should not be blank for Automation.';
                                                                            postChatterPosts(lstOfConWithBlankMobile, objectName,UserId,chatterMessage); 
                                                                        }
                                                                        if(LstOfRecWithInvalidMobile.size()>0){
                                                                            string chatterMessage = 'Invalid Mobile for Sending SMS.';
                                                                            postChatterPosts(LstOfRecWithInvalidMobile, objectName,UserId,chatterMessage); 
                                                                        }
                                                                        
                                                                        if(mapOfChatterPost.size()>0){
                                                                            postChatterForMergeFields( objectName,UserId,mapOfChatterPost); 
                                                                        }
                                                                        
                                                                    } else{
                                                                        if(mergeFields.size()>0){
                                                                            String invalidmergeFields = String.join(mergeFields, ',');
                                                                            string chatterMessage = 'Found the invalid field(s) in SMS Template, the SMS was not sent, please update the template. '+invalidmergeFields;
                                                                            postChatterPostsForUser(lstSobjRcrds, objectName,UserId,chatterMessage);  
                                                                        }
                                                                    }
                                                                }else{
                                                                    string chatterMessage = '';
                                                                    if(lstSobjRcrds.size() <= 25){
                                                                        chatterMessage = 'Please update the user’s airwaves verified number and review all records from this user that weren’t triggered.';   
                                                                    }else{
                                                                        chatterMessage = 'This list is limited to the first 25 records that did not send. Please update the user’s airwaves verified number and review all records from this user that weren’t triggered. ';   
                                                                    }
                                                                    postChatterPostsForUser(lstSobjRcrds, objectName,UserId,chatterMessage); 
                                                                }
                                                                return isSuccess;
                                                            }
    
    public void postChatterPosts(Set<Id> recordIds, String objectName, Id userId, String chatterMessage) {
        if (recordIds == null || recordIds.isEmpty()) {
            return;
        }
        
        List<Map<String, String>> chatterPostDataList = new List<Map<String, String>>();
        
        if(recordIds.size()>0){
            for (Id recordId : recordIds) {
                Map<String, String> postData = new Map<String, String>();
                postData.put('subjectId', String.valueOf(recordId));
                postData.put('message', chatterMessage);
                postData.put('userId', String.valueOf(userId));
                
                chatterPostDataList.add(postData);
            }
        }
        if (!chatterPostDataList.isEmpty()) {
            // Convert List<Map<String, String>> to JSON
            String serializedData = JSON.serialize(chatterPostDataList);
            
            // Add serialized data to the list
            serializedDataList.add(serializedData);
        }
    }
    
    public  void postChatterForMergeFields( String objectName, Id userId, Map<Id,List<String>> mapOfChatterPost) {
        if (mapOfChatterPost == null || mapOfChatterPost.isEmpty()) {
            return;
        }
        List<Map<String, String>> chatterPostDataList = new List<Map<String, String>>();
        string MessageString = 'The following fields are missing data in SMS Template ';
        if(mapOfChatterPost.size()>0){
            for (Id recordId : mapOfChatterPost.keySet()) {
                List<String> messageList = new List<String>();
                if(mapOfChatterPost.ContainsKey(recordId) && mapOfChatterPost.get(recordId) != null && mapOfChatterPost.get(recordId).size()>0){
                    messageList = mapOfChatterPost.get(recordId); 
                    
                    
                    string concatenatedMessages = String.join(messageList, ', ');
                    string chatterMessage = MessageString + concatenatedMessages;
                    Map<String, String> postData = new Map<String, String>();
                    postData.put('subjectId', String.valueOf(recordId));
                    postData.put('message', chatterMessage);
                    postData.put('userId', String.valueOf(userId));
                    
                    chatterPostDataList.add(postData);
                }
            }
        }
        
        if (!chatterPostDataList.isEmpty()) {
            // Convert List<Map<String, String>> to JSON
            String serializedData = JSON.serialize(chatterPostDataList);
            
            // Add serialized data to the list
            serializedDataList.add(serializedData);
        }
    }
    
    public void postChatterPostsForUser(Set<Id> recordIds, String objectName, Id userId, String chatterMessage) {
        if (recordIds == null || recordIds.isEmpty() || String.isEmpty(objectName)) {
            return;
        }
        Id currentUserId = UserInfo.getUserId();
        Integer limitCount = 25;
        Set<Id> limitedIdSet = new Set<Id>();
        Integer count = 0;
        
        if(recordIds.size()>0){
            for (Id recId : recordIds) {
                if (count >= limitCount) break; // Stop adding after limitCount
                limitedIdSet.add(recId);
                count++;
            }
        }
        
        // Convert to a comma-separated string
        String subjectIds = String.join(limitedIdSet, ',');
        
        List<Map<String, String>> chatterPostDataList = new List<Map<String, String>>();
        
        if(recordIds.size()>0){
            for (Id recordId : recordIds) {
                Map<String, String> postData = new Map<String, String>();
                postData.put('subjectIds', subjectIds);
                postData.put('message', chatterMessage);
                postData.put('userId', String.valueOf(userId));
                
                chatterPostDataList.add(postData);
                break;
            }
        }
        
        if (!chatterPostDataList.isEmpty()) {
            // Convert List<Map<String, String>> to JSON
            String serializedData = JSON.serialize(chatterPostDataList);
            
            // Add serialized data to the list
            serializedDataListForUser.add(serializedData);
        }
    }
    
    Public Set<Id> DuplicateContacts(List<sObject> sobjList,string objectName,string SendingMethod ,Set<Id> lstSobjRcrds,Id activeVoice,Map<Id, Contact> ContactMap,Map<Id, Lead> leadMap){ 
        set<string> setOfMobilephn = new set<string>();
        set<Id> setOfUniqueId = new set<Id>();
        set<Id> setOfDuplicateId = new set<Id>();
        
        Set<Id> contactIds = new Set<Id>();
        Set<Id> leadIds = new Set<Id>();
        String countryCodes = System.Label.Allowed_Country_Code; // "61,1,44"
        List<String> countryCodeList = countryCodes.split(','); // Convert to list
        
        String AreaCodes = System.Label.Area_Codes_For_Mobile; // "2,3,7,8"
        List<String> AreaCodesList = AreaCodes.split(','); // Convert to list
        
        // Now loop through the objects and handle the logic
        if(sobjList.size()>0){
            for (SObject obj : sobjList) {
                if(lstSobjRcrds.Contains(obj.Id)){
                    if (objectName == 'Task' && obj.get('WhoId') != null) {
                        String whoId = (String) obj.get('WhoId');
                        if (whoId.startsWith('003')) {  // Contact ID
                            Contact contact;
                            if(contactMap.containsKey(whoId)){
                                 contact = contactMap.get(whoId); 
                            }
                           
                            if(contact.MobilePhone != null){
                                String normalizedPhone = contact.MobilePhone.replaceAll('[^\\d]', ''); // Remove spaces, '+' and other non-digits
                                
                                for(String code : countryCodeList) {
                                    if(normalizedPhone.startsWith(code)) {
                                        normalizedPhone =  normalizedPhone.substring(code.length()); // Replace country code with '0'
                                        break; // Stop checking after the first match
                                    }
                                }
                                if(normalizedPhone.startsWith('0')) {
                                    normalizedPhone =  normalizedPhone.substring(1); // Replace country code with '0'
                                }
                                //here if the mobile is of 9 digit then it is valid mobile
                                if(normalizedPhone.length() == 9){
                                    if (contact != null && !setOfMobilephn.contains(normalizedPhone)) {
                                        Boolean isInvalid = false;
                                        for (String code : AreaCodesList) {
                                            if (normalizedPhone.startsWith(code)) {
                                                isInvalid = true;
                                                break;
                                            }
                                        }
                                        if (isInvalid && SendingMethod == 'SMS') {
                                            LstOfRecWithInvalidMobile.add(obj.id);
                                        }else{
                                            if(mapOfASAndMobile.containsKey(activeVoice)){
                                                if(!mapOfASAndMobile.get(activeVoice).contains(normalizedPhone)){
                                                    LstOfContacttoProcess.add(contact.Id);
                                                    setOfMobilephn.add(normalizedPhone);
                                                    mapOfASAndMobile.get(activeVoice).add(normalizedPhone);
                                                }else{
                                                    setOfDuplicateId.add(obj.id);  
                                                }
                                                
                                            }else{
                                                LstOfContacttoProcess.add(contact.Id);
                                                setOfMobilephn.add(normalizedPhone);
                                                mapOfASAndMobile.put(activeVoice,setOfMobilephn);  
                                            }
                                        }
                                        
                                    } else {
                                        setOfDuplicateId.add(obj.id);
                                    } 
                                }else{
                                    LstOfRecWithInvalidMobile.add(obj.id);
                                }
                            }else{
                                lstOfConWithBlankMobile.add(obj.id);
                            }
                            
                        } else if (whoId.startsWith('00Q')) {  // Lead ID
                            Lead lead;
                                if(leadMap.containsKey(whoId)){
                                 lead = leadMap.get(whoId); 
                            }
                            if(lead.MobilePhone != null){
                                String normalizedPhone = lead.MobilePhone.replaceAll('[^\\d]', ''); // Remove spaces, '+' and other non-digits
                                for(String code : countryCodeList) {
                                    if(normalizedPhone.startsWith(code)) {
                                        normalizedPhone =  normalizedPhone.substring(code.length()); // Replace country code with '0'
                                        break; // Stop checking after the first match
                                    }
                                }
                                if(normalizedPhone.startsWith('0')) {
                                    normalizedPhone =  normalizedPhone.substring(1); // Replace country code with '0'
                                }
                                //here if the mobile is of 9 digit then it is valid mobile
                                if(normalizedPhone.length() == 9){
                                    if (lead != null && !setOfMobilephn.contains(normalizedPhone)) {
                                        Boolean isInvalid = false;
                                        for (String code : AreaCodesList) {
                                            if (normalizedPhone.startsWith(code)) {
                                                isInvalid = true;
                                                break;
                                            }
                                        }
                                        if (isInvalid && SendingMethod == 'SMS') {
                                            LstOfRecWithInvalidMobile.add(obj.id);
                                        }else{
                                            if(mapOfASAndMobile.containsKey(activeVoice)){
                                                if(!mapOfASAndMobile.get(activeVoice).contains(normalizedPhone)){
                                                    LstOfContacttoProcess.add((Id)lead.Id);
                                                    setOfMobilephn.add(normalizedPhone);
                                                    mapOfASAndMobile.get(activeVoice).add(normalizedPhone);
                                                    
                                                }else{
                                                    setOfDuplicateId.add(obj.id);  
                                                }
                                                
                                            }else{
                                                LstOfContacttoProcess.add((Id)lead.Id);
                                                setOfMobilephn.add(normalizedPhone);
                                                mapOfASAndMobile.put(activeVoice,setOfMobilephn);  
                                            }
                                        }
                                    } else {
                                        setOfDuplicateId.add(obj.id);
                                    }  
                                }  
                                else{
                                    LstOfRecWithInvalidMobile.add(obj.id);
                                }
                                
                            }else{
                                lstOfConWithBlankMobile.add(obj.id);
                            }
                        }
                    }
                }
            }
        }
        
        
        return setOfDuplicateId;
    }
    
    // Method to get the city part of the timezone
    public String getUserTimezoneCity() {
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
    
    //METHOD THAT CREATES SMS TRANSCRIPTS IN AIRWAVES
    public Boolean sendSingleSMSMethod (String objectName, String fromNumber, String toNumber, String message,String XAPIkey,string OrgId,List<S2V__Future_Voicemails__c> lstOfObjFV,Id UserId)
    {
        string msgbody;
        if(message.contains('\n')) {
            List<String> lines = message.split('\n');
            
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
        
        // Set request body
        String requestBody = '{"to": "'+toNumber+'", "from": "'+fromNumber+'", "content": "'+msgbody+'", "type": "sms", "transcribe": true}';
        req.setBody(requestBody);
        
        HttpResponse res = h.send(req);
        Boolean isSusccess;
        
        if(res.getStatusCode() == 200 || res.getStatusCode() == 201) {
            isSusccess = True;
            Map<String, Object> parsedJson = (Map<String, Object>) JSON.deserializeUntyped(res.getbody());
            
            // Extract the 'messages' list
            if (parsedJson.containsKey('messages')) {
                List<Object> messages = (List<Object>) parsedJson.get('messages');
                
                if (!messages.isEmpty()) {
                    // Extract first message and get the 'id'
                    Map<String, Object> firstMessage = (Map<String, Object>) messages[0];
                    String messageId = (String) firstMessage.get('id');
                    // System.enqueueJob(new chatterErrorMsgQueueable(messageId,OrgId,XAPIkey,UserId,isBulkSMS), 2);
                    wrapperList.add(new wrapperofFileds(messageId,OrgId,XAPIkey,UserId,isBulkSMS));
                }
            }
            
        } else {
            isSusccess = False;
        }
        return isSusccess;
    }
    
    public Map<Id, String> replaceMergeFieldsforMultipleSMS(SObject objectName, String SMSTemplateBody, List<String> listOfContactId,Map<Id,Id>MapOfConANDObj) {
        List<String> lstOfErrorLeads = new List<String>();
        List<String> lstOfFields = new List<String>();
        Map<String, String> fieldValues = new Map<String, String>();
        Map<Id, String> leadSmsTemplateMap = new Map<Id, String>();
        Map<Id, SObject> leadRecords = new Map<Id, SObject>();
        Map<Id, SObject> contactRecords = new Map<Id, SObject>();
        
        String sObjectName = (objectName != null) ? objectName.getSObjectType().getDescribe().getName() : null;
        // Handle User Fields
        if (SMSTemplateBody.containsIgnoreCase('{!User')) {
            Map<String, Schema.SObjectField> userFields = User.sObjectType.getDescribe().fields.getMap();
            Set<String> userFieldSet = getFieldSet(SMSTemplateBody, 'User', userFields);
            Id currentUserId = UserInfo.getUserId();
            
            if (!userFieldSet.isEmpty()) {
                String userQuery = 'SELECT ' + String.join(new List<String>(userFieldSet), ',') + ' FROM User WHERE Id = :currentUserId';
                User currentUser = Database.query(userQuery);
                
                for (String field : userFieldSet) {
                    Object fieldValue = currentUser.get(field);
                    if (fieldValue != null) {
                        fieldValues.put('{!User.' + field + '}', String.valueOf(fieldValue));
                    } else if (!lstOfFields.contains(field)) {
                        lstOfFields.add(field);
                        lstOfErrorLeads.add('{!User.' + field + '}');
                    }
                }
            }
        }
        
        // Handle Organization Fields
        if (SMSTemplateBody.containsIgnoreCase('{!Organization')) {
            Map<String, Schema.SObjectField> orgFields = Organization.sObjectType.getDescribe().fields.getMap();
            Set<String> orgFieldSet = getFieldSet(SMSTemplateBody, 'Organization', orgFields);
            
            if (!orgFieldSet.isEmpty()) {
                String orgQuery = 'SELECT ' + String.join(new List<String>(orgFieldSet), ',') + ' FROM Organization';
                Organization orgRecord = Database.query(orgQuery);
                
                for (String field : orgFieldSet) {
                    Object fieldValue = orgRecord.get(field);
                    if (fieldValue != null) {
                        fieldValues.put('{!Organization.' + field + '}', String.valueOf(fieldValue));
                    } else if (!lstOfFields.contains(field)) {
                        lstOfFields.add(field);
                        lstOfErrorLeads.add('{!Organization.' + field + '}');
                    }
                }
            }
        }
        
        // Query Leads and Contacts in Advance
        Set<Id> leadIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        
        for (String id : listOfContactId) {
            if (id != null && id.startsWith('00Q')) {
                leadIds.add(Id);
            } else if (id != null && id.startsWith('003')) {
                contactIds.add(Id);
            }
        }
        
        if (!leadIds.isEmpty()) {
            Map<String, Schema.SObjectField> leadFields = Lead.sObjectType.getDescribe().fields.getMap();
            Set<String> leadFieldSet = getFieldSet(SMSTemplateBody, 'Lead', leadFields);
            if (!leadFieldSet.isEmpty()) {
                String leadQuery = 'SELECT ' + String.join(new List<String>(leadFieldSet), ',') + ' FROM Lead WHERE Id IN :leadIds';
                leadRecords = new Map<Id, SObject>(Database.query(leadQuery));
            }
        }
        
        if (!contactIds.isEmpty()) {
            Map<String, Schema.SObjectField> contactFields = Contact.sObjectType.getDescribe().fields.getMap();
            Set<String> contactFieldSet = getFieldSet(SMSTemplateBody, 'Contact', contactFields);
            if (!contactFieldSet.isEmpty()) {
                String contactQuery = 'SELECT ' + String.join(new List<String>(contactFieldSet), ',') + ' FROM Contact WHERE Id IN :contactIds';
                contactRecords = new Map<Id, SObject>(Database.query(contactQuery));
            }
        }
        
        // Process Each Contact or Lead
        for (String conId : listOfContactId) {
            lstOfErrorLeads.clear();
            Id recordId = MapOfConANDObj.get(conId);
            if (leadRecords.containsKey(Id.valueOf(conId))) {
                SObject lead = leadRecords.get(Id.valueOf(conId));
                populateFieldValues(SMSTemplateBody, 'Lead', lead, fieldValues, lstOfFields, lstOfErrorLeads,recordId);
            } else if (contactRecords.containsKey(Id.valueOf(conId))) {
                SObject contact = contactRecords.get(Id.valueOf(conId));
                populateFieldValues(SMSTemplateBody, 'Contact', contact, fieldValues, lstOfFields, lstOfErrorLeads,recordId);
            }
            
            if (lstOfErrorLeads.isEmpty()) {
                String processedTemplate = SMSTemplateBody;
                for (String key : fieldValues.keySet()) {
                    processedTemplate = processedTemplate.replace(key, fieldValues.get(key));
                }
                leadSmsTemplateMap.put(Id.valueOf(conId), processedTemplate);
            }
        }
        
        
        return leadSmsTemplateMap;
    }
    
    // Helper Methods
    private void populateFieldValues(String smsTemplateBody, String sObjectType, SObject record, Map<String, String> fieldValues, List<String> lstOfFields, List<String> lstOfErrorLeads,Id recordId) {
        Map<String, Schema.SObjectField> fields = record.getSObjectType().getDescribe().fields.getMap();
        Set<String> fieldSet = getFieldSet(smsTemplateBody, sObjectType, fields);
        List<string> lstOfMergeFields  = new List<string>();
        for (String field : fieldSet) {
            Object fieldValue = record.get(field);
            if (fieldValue != null) {
                fieldValues.put('{!' + sObjectType + '.' + field + '}', String.valueOf(fieldValue));
            } else {
                lstOfErrorLeads.add('{!' + sObjectType + '.' + field + '}');
                lstOfMergeFields.add('{!' + sObjectType + '.' + field + '}');
            }
        }
        if(lstOfMergeFields.isEmpty()){
            setOfCorrectContacts.add(record.id);
        }else{
            mapOfChatterPost.put(recordId,lstOfMergeFields);
        }
    }
    
    //METHOD THAT RETURNS STRING OF MOBILE AND CONTACT NAME
    public List<String> PhonelistSMSNew(List<Id> lstCntIds,String ObjectName,Map<Id,String> MapOfTemplate ,String SendingMethod,Map<Id,Contact> ContactMap,Map<Id,Lead>leadMap)
    {
        List<String> phoneListtoCreateCSV =new List<String>();
        List<String> phoneListSMS =new List<String>();
        String phoneListFinalSMS ;
        set<String> SetOfMobile = new set<String>();
        set<id> setOfIdswithNoMobile = new set<id>();
        String AreaCodes = System.Label.Area_Codes_For_Mobile; // "2,3,7,8"
        List<String> AreaCodesList = new List<String>();
        if(AreaCodes != null && AreaCodes != ''){
            AreaCodesList = AreaCodes.split(','); // Convert to list 
        }
        String countryCodes = System.Label.Allowed_Country_Code; // "61,1,44"
        List<String> countryCodeList = new List<String>();
        if(countryCodes != null && countryCodes != ''){
            countryCodeList = countryCodes.split(','); // Convert to list
        }
        List<Contact> lstCnts = new List<Contact>();
        List<Lead> lstleads = new List<Lead>();
        if(lstCntIds!=NULL && lstCntIds.size()>0)
        {
            for(String objRecId : lstCntIds)
            {
                if(objRecId.startsWith('003'))
                {
                    if(ContactMap.containsKey(objRecId)){
                        lstCnts.add(ContactMap.get(objRecId));
                    }
                }
                
                if(objRecId.startsWith('00Q'))
                {
                    if(leadMap.containsKey(objRecId)){
                        lstleads.add(leadMap.get(objRecId));
                    }
                }
            }
        }
        if( lstCnts != null && lstCnts.size()>0)
        {
                for(Contact cons : lstCnts )
                {
                    if(cons.MobilePhone != null )
                    { 
                        // Normalize the phone number (remove all non-digit characters)
                        String normalizedPhone = cons.MobilePhone.replaceAll('[^\\d]', ''); // Remove spaces, '+' and other non-digits
                        for(String code : countryCodeList) {
                            if(normalizedPhone.startsWith(code)) {
                                normalizedPhone =  normalizedPhone.substring(code.length()); // Replace country code with '0'
                                break; // Stop checking after the first match
                            }
                        }
                        if(normalizedPhone.startsWith('0')) {
                            normalizedPhone =  normalizedPhone.substring(1); // Replace country code with '0'
                        }
                        
                        if(!SetOfMobile.Contains(normalizedPhone)){
                            Boolean isInvalid = false;
                            for (String code : AreaCodesList) {
                                if (normalizedPhone.startsWith(code)) {
                                    isInvalid = true;
                                    break;
                                }
                            }
                            if (isInvalid && SendingMethod == 'SMS') {
                                system.debug('skip as invalid ' ); 
                            }else{
                                phoneListSMS.add(cons.MobilePhone.deleteWhitespace()+'xz5qabc926'+MapOfTemplate.get(cons.Id));
                            }
                            SetOfMobile.add(normalizedPhone);
                        }
                    }
                }
            
        } else if( lstleads!= null && lstleads.size()>0 )
        {
                for(Lead  cons : lstleads)
                {
                    if(cons.MobilePhone != null )
                    { 
                        // Normalize the phone number (remove all non-digit characters)
                        String normalizedPhone = cons.MobilePhone.replaceAll('[^\\d]', ''); // Remove spaces, '+' and other non-digits
                        for(String code : countryCodeList) {
                            if(normalizedPhone.startsWith(code)) {
                                normalizedPhone =  normalizedPhone.substring(code.length()); // Replace country code with '0'
                                break; // Stop checking after the first match
                            }
                        }
                        if(normalizedPhone.startsWith('0')) {
                            normalizedPhone =  normalizedPhone.substring(1); // Replace country code with '0'
                        }
                        if(!SetOfMobile.Contains(normalizedPhone)){
                            Boolean isInvalid = false;
                            for (String code : AreaCodesList) {
                                if (normalizedPhone.startsWith(code)) {
                                    isInvalid = true;
                                    break;
                                }
                            }
                            if (isInvalid && SendingMethod == 'SMS') {
                                system.debug('skip as invalid ' ); 
                            }else{
                                phoneListSMS.add(cons.MobilePhone.deleteWhitespace()+'xz5qabc926'+MapOfTemplate.get(cons.Id));
                           }
                           SetOfMobile.add(normalizedPhone);
                        }
                    }
                }
        }
        return phoneListSMS;
    }
    
    public Set<String> getFieldSet(String templateBody, String objectPrefix, Map<String, Schema.SObjectField> fieldMap) {
        Set<String> fieldsInTemplate = new Set<String>();
        for (String field : fieldMap.keySet()) {
            if (templateBody.containsIgnoreCase('{!' + objectPrefix + '.' + field + '}')) {
                fieldsInTemplate.add(field);
            }
        }
        return fieldsInTemplate;
    }
    
    //TEMPORARY
    public Set<String> fields(Schema.sObjectType t) 
    {
        Set<String> result = new Set<String>();
        Map<String, Schema.SObjectField> fields = t.getDescribe().fields.getMap();
        return fields.keySet();
    }
    
    
}