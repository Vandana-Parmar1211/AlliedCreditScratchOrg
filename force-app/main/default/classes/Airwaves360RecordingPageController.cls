@RestResource(urlMapping='/audioUpload/*')
Global with sharing  class Airwaves360RecordingPageController {
    
    public Boolean isdisplayvfp{get;set;}
    public String indexval{get;set;}
    public String notesvalue{get;set;}
    //public List<IORecording.RObject> objects{get;set;}
    public List<Integer> numbers {get;set;}
    public List<String> rcrdings {get;set;}
    
    //public Boolean loginFlag{get;set;}
    //public IOVDAccount acc {get; set;} 
    //public IORecording rec {get;set;}
    //public S2V_Settings__c setting{get; private set;}
    //public String authorizationHeader{get; private set;}
    //public String phoneNumberVoice {get;set;}
    public String recName {get;set;}
    //public String callerCodeOption {get;set;}
    //public String recrddltid{get;set;}
    //public string next{get;set;}
    //public string prev{get;set;}
    public map<String,RecordingWrapper> avairecordid {get;set;}
    public string avairecordidduplicate {get;private set;}
    //private static integer recsPerPage = 10;
    public Map<String,String> discriptionmap {get;set;}
    //public Map<String,String> notesmap {get;set;}
    Profile p = [SELECT Id, Name FROM Profile WHERE Id=:Userinfo.getProfileId() WITH SECURITY_ENFORCED LIMIT 1];
    //public Integer numberOfFiles {get;set;}
    //public List<String> Lstofrecordings {get;set;}
    public S2V__Airwaves360_settings__c settings { get; private set; }
    public string keyval { get; private set; }
     public string OrgId { get; private set; }
     public string CommonURL { get; private set; }
    
    //CONTROLLER
    public Airwaves360RecordingPageController()
    { 
        isdisplayvfp = TRUE;
        indexval = '';
        notesvalue = '';
        discriptionmap = new Map<String,String>();
       // notesmap = new Map<String,String>();
        rcrdings = new List<String>();
        //Lstofrecordings = new List<String>();
        avairecordid = new map<String,RecordingWrapper>();
        numbers = new List<Integer>();
        CommonURL = System.Label.CommonURL;

        settings = [SELECT Id, S2V__OrganizationId__c, S2V__XapiKey__c  
                    FROM S2V__Airwaves360_settings__c 
                    WITH SECURITY_ENFORCED LIMIT 1];
        
        if(settings != null) {
             keyval= KeyDecryptionClass.decryptValue(settings.S2V__XapiKey__c);
             OrgId = KeyDecryptionClass.decryptValue(settings.S2V__OrganizationId__c);
        }
       
        for(Integer i=1;i<11;i++)
        {
            numbers.add(i);
        }
        
        List<S2V__Airwaves360_Drip_Recording_Description__c> lstdiscription = [SELECT Id,S2V__Description__c,S2V__Recording_Number__c,S2V__Personal__c, S2V__Notes__c,
                                                                                S2V__isWithAudio__c,S2V__yabbrFileID__c 
                                                                                FROM S2V__Airwaves360_Drip_Recording_Description__c
                                                                                WHERE S2V__Recording_Number__c!=null 
                                                                                AND S2V__Personal__c = FALSE WITH SECURITY_ENFORCED ORDER BY S2V__Recording_Number__c ASC];
        if(lstdiscription.size() > 0) {         
            for(S2V__Airwaves360_Drip_Recording_Description__c s2vdisc : lstdiscription)
            {     
                if(s2vdisc.S2V__Description__c != Null && s2vdisc.S2V__Description__c != '') {
                    discriptionmap.put(String.valueOf(s2vdisc.S2V__Recording_Number__c),s2vdisc.S2V__Description__c);
                }   
                //Commented by Vandana 16-12-2024
                /* if(s2vdisc.S2V__Notes__c != Null && s2vdisc.S2V__Notes__c != '') {
                    notesmap.put(String.valueOf(s2vdisc.S2V__Recording_Number__c),s2vdisc.S2V__Notes__c);
                } */
            }
        }

        List<S2V__Airwaves360_Personal_Recording__c> personalRecordingList = [SELECT Id,S2V__Description__c,S2V__Recording_Number__c, 
                                                                                S2V__Notes__c,S2V__yabbrFileID__c ,S2V__isWithAudio__c 
                                                                                FROM S2V__Airwaves360_Personal_Recording__c WHERE S2V__Recording_Number__c!= NULL 
                                                                                AND CreatedById =: UserInfo.getUserId() WITH SECURITY_ENFORCED ORDER BY S2V__Recording_Number__c ASC];
        if(personalRecordingList.size() > 0) {
            
            for(S2V__Airwaves360_Personal_Recording__c s2vPersonalRecording : personalRecordingList)
            {
                RecordingWrapper wrapper = new RecordingWrapper();
                wrapper.audio_file = s2vPersonalRecording.S2V__yabbrFileID__c;
                wrapper.recordingNumber = String.ValueOf(s2vPersonalRecording.S2V__Recording_Number__c);
                wrapper.hasFile = s2vPersonalRecording.S2V__isWithAudio__c;
                
                if(s2vPersonalRecording.S2V__isWithAudio__c == true){
                    wrapper.isPlaybtn = false;
                }else{
                    wrapper.isPlaybtn = true;
                }
                rcrdings.add(wrapper.recordingNumber);
                //Lstofrecordings.add(wrapper.recordingNumber);
                avairecordid.put(wrapper.recordingNumber,wrapper);
                avairecordidduplicate = JSON.serialize(avairecordid);
            }
        }
        
    }
    
    //METHOD CREATES PERSONAL RECORDING OBJECT RECORD WHEN AUDIO SAVED FROM UI. 
    @RemoteAction
    public static String updateIsAudiochekox(String fileName, boolean isAudio,integer recordingNumber, string fileId) {
        
        if (Schema.SObjectType.S2V__Airwaves360_Drip_Recording_Description__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.Id.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.Name.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.S2V__Description__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.S2V__Recording_Number__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.S2V__Personal__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.S2V__Notes__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.S2V__isWithAudio__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.S2V__yabbrFileID__c.isAccessible()) {
                
                List<S2V__Airwaves360_Drip_Recording_Description__c> lstOfval = new List<S2V__Airwaves360_Drip_Recording_Description__c>();
                
                lstOfval = [SELECT Id,Name,S2V__Description__c,S2V__Recording_Number__c,S2V__Personal__c, S2V__Notes__c, S2V__isWithAudio__c,S2V__yabbrFileID__c  
                            FROM S2V__Airwaves360_Drip_Recording_Description__c 
                            WHERE S2V__Recording_Number__c!=NULL AND S2V__Recording_Number__c =: recordingNumber  AND S2V__Personal__c = FALSE WITH SECURITY_ENFORCED ORDER BY S2V__Recording_Number__c ASC];
                
                if(lstOfval.size() > 0 && Schema.SObjectType.S2V__Airwaves360_Personal_Recording__c.isCreateable() 
                   && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.Name.isCreateable() 
                   && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.S2V__Recording_Number__c.isCreateable() 
                   && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.S2V__Description__c.isCreateable() 
                   && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.S2V__Notes__c.isCreateable() 
                   && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.S2V__yabbrFileID__c.isCreateable() 
                   && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.S2V__isWithAudio__c.isCreateable()) {

                    S2V__Airwaves360_Personal_Recording__c personalRecording= new S2V__Airwaves360_Personal_Recording__c();
                    personalRecording.Name= fileName;
                    personalRecording.S2V__Recording_Number__c=recordingNumber;	
                    personalRecording.S2V__Description__c=lstOfval[0].S2V__Description__c;
                    personalRecording.S2V__Notes__c=lstOfval[0].S2V__Notes__c;
                    personalRecording.S2V__yabbrFileID__c=fileId;
                    personalRecording.S2V__isWithAudio__c=isAudio;
                    insert personalRecording;  
                }
                return null;
            }else{
                return 'FLS violation detected. Access to the object or one or more fields is not permitted.';
            }
    }

    //METHOD THAT DELETES RECORDING FROM UI
    @RemoteAction
    public static String deletePersonalRecording(boolean isAudio,integer recordingNumber, string fileId) {

        if (Schema.SObjectType.S2V__Airwaves360_Personal_Recording__c.isAccessible()
                && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.Id.isAccessible()
                && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.Name.isAccessible()
                && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.CreatedById.isAccessible()
                && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.S2V__Description__c.isAccessible()
                && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.S2V__Recording_Number__c.isAccessible()
                && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.S2V__Notes__c.isAccessible()
                && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.S2V__yabbrFileID__c.isAccessible()
                && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.S2V__isWithAudio__c.isAccessible()) {

                List<S2V__Airwaves360_Personal_Recording__c> personalRecordingList = [SELECT Id,Name,S2V__Description__c,S2V__Recording_Number__c, 
                                                                                      S2V__Notes__c, S2V__isWithAudio__c,S2V__yabbrFileID__c  FROM
                                                                                      S2V__Airwaves360_Personal_Recording__c WHERE S2V__Recording_Number__c!=NULL
                                                                                      AND S2V__Recording_Number__c =: recordingNumber AND CreatedById =: UserInfo.getUserId() ORDER BY S2V__Recording_Number__c ASC];
                
                if(personalRecordingList.size() > 0) {
                    
                    List<S2V__Airwaves360_Personal_Recording__c> recordsToDelete = new List<S2V__Airwaves360_Personal_Recording__c>();
                    
                    for(S2V__Airwaves360_Personal_Recording__c recording : personalRecordingList) {
                        if (S2V__Airwaves360_Personal_Recording__c.sObjectType.getDescribe().isDeletable()) {
                            recordsToDelete.add(recording);
                        }
                    }  
                    
                    if(!recordsToDelete.isEmpty()) {
                        
                        if (S2V__Airwaves360_Personal_Recording__c.sObjectType.getDescribe().isDeletable()) {
                            Database.DeleteResult[] deleteResults = Database.delete(recordsToDelete, false);
                        }
                    }
                }
                return null;
            }else{
                return 'FLS violation detected. Access to the object or one or more fields is not permitted.';
            }
    }
    
    //METHOD THAT SHOWS AVAILABLE RECORDINGS ON UI
    @RemoteAction
    public static String getAudioFileIds(Integer recordingNumber) {
        
        if (Schema.SObjectType.S2V__Airwaves360_Personal_Recording__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.Id.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.S2V__Description__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.S2V__Recording_Number__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.S2V__Notes__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.S2V__yabbrFileID__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.CreatedById.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.Name.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Personal_Recording__c.fields.S2V__isWithAudio__c.isAccessible()) {
                
                List<S2V__Airwaves360_Personal_Recording__c> personalRecordingFileIdsList = [SELECT Id,Name,S2V__Description__c,S2V__Notes__c, S2V__Recording_Number__c,
                                                                                             S2V__isWithAudio__c,S2V__yabbrFileID__c FROM S2V__Airwaves360_Personal_Recording__c 
                                                                                             WHERE S2V__Recording_Number__c=: recordingNumber AND CreatedById =: UserInfo.getUserId() 
                                                                                             order by S2V__Recording_Number__c  ASC];
                
                return personalRecordingFileIdsList[0].S2V__yabbrFileID__c;
                
            }else{
                
                return 'FLS violation detected. Access to the object or one or more fields is not permitted.';
            }
    }

    //METHOD THAT UPLOADS FILE NAME AND DURATION IN AIRWAVES
    @RemoteAction
    public static void uploadFileonYabbrFirstCall(String fileName,integer duration, String base64String, Integer indx) {
        
        Date d = Date.today();
        String audioFileName=getUserName()+'-'+indx+'-'+ Datetime.newInstance(d.year(), d.month(), d.day()).format('yyy-MM-dd');
        string returnval = 'return val ';
       
        string CommonURL = System.Label.CommonURL; 
       
        
        S2V__Airwaves360_settings__c settings=[select id,S2V__OrganizationId__c,S2V__XapiKey__c from S2V__Airwaves360_settings__c WITH SECURITY_ENFORCED limit 1]; 
 
        string key = KeyDecryptionClass.decryptValue(settings.S2V__XapiKey__c);
        string OrgId = KeyDecryptionClass.decryptValue(settings.S2V__OrganizationId__c);
        String endpoint = CommonURL+OrgId+'/files/aud';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('x-api-key', key);
        req.setHeader('Content-Type', 'application/json');
        
        String payload = '{'+
            '"name": "'+audioFileName+'",'+
            '"duration": '+duration+','+
            '"uploadMethod": "PUT",'+
            '"contentType": "audio/wav"'+
            '}';
        
        req.setBody(payload);
        
        Http http = new Http();
        
        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                String url = (String) responseMap.get('url');
                String fileId = (String) responseMap.get('id');
                uploadFileonYabbrSecondCall(audioFileName,url,base64String,fileId,indx);
                
            } 
        } catch (Exception e) {
            system.debug('Exception: ' + e.getMessage());
        }
    }
    
    //METHOD THAT USES URL FROM PREVIOUS METHOS RESPONSE AND USES THAT FOR ACTUAL AUDIO UPLOAD ON AIRWAVES  
    public static void uploadFileonYabbrSecondCall(String audioFileName,string url,string base64String,string fileId, Integer indx ) {

        string CommonURL = System.Label.CommonURL;
        String endpoint =url;
        
        S2V__Airwaves360_settings__c settings =[SELECT id,S2V__OrganizationId__c,S2V__XapiKey__c FROM S2V__Airwaves360_settings__c WITH SECURITY_ENFORCED LIMIT 1]; 
        string key = KeyDecryptionClass.decryptValue(settings.S2V__XapiKey__c);
     
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('PUT');
        req.setHeader('x-api-key', key);
        req.setHeader('Content-Type', 'audio/wav');
        Blob requestBodyBlob = EncodingUtil.base64Decode(base64String);
        req.setBodyAsBlob(requestBodyBlob);
        Http http = new Http();
        
        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                updateIsAudiochekox(audioFileName, true,indx,fileId);
            } 
        } catch (Exception e) {
            system.debug('Exception: ' + e.getMessage());
        }
        
    }
    
    //METHOD THAT UPDATES NOTES ON AIRWAVES360 DRIP RECORDING DESCRIPTION OBJECT
    public void updateNotes() {

    if (indexval != null && indexval != '') { 
            
        Integer recordingnum = Integer.valueOf(indexval);
            
        if (Schema.sObjectType.S2V__Airwaves360_Drip_Recording_Description__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.Id.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.S2V__Description__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.S2V__Recording_Number__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.S2V__Personal__c.isAccessible()
            && Schema.sObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.S2V__Notes__c.isAccessible()) {

                List<S2V__Airwaves360_Drip_Recording_Description__c> lstRecordingToUpdate = [SELECT Id,S2V__Description__c,S2V__Recording_Number__c,S2V__Personal__c, S2V__Notes__c  
                                                                                            FROM S2V__Airwaves360_Drip_Recording_Description__c 
                                                                                            WHERE S2V__Recording_Number__c =: recordingnum AND CreatedById =: UserInfo.getUserId()];
                if (lstRecordingToUpdate.size() > 0) {
                    
                    List<S2V__Airwaves360_Drip_Recording_Description__c> recordingToUpdate = new List<S2V__Airwaves360_Drip_Recording_Description__c>();
                    
                    for(S2V__Airwaves360_Drip_Recording_Description__c recording : lstRecordingToUpdate) {
                        if (Schema.sObjectType.S2V__Airwaves360_Drip_Recording_Description__c.isUpdateable() 
                            && Schema.SObjectType.S2V__Airwaves360_Drip_Recording_Description__c.fields.S2V__Notes__c.isUpdateable()) {
                            recording.S2V__Notes__c = notesvalue;
                            recordingToUpdate.add(recording);
                        }
                    }  
                    if(!recordingToUpdate.isEmpty()) {
                        update recordingToUpdate;
                    }
                }
        }else{
            System.debug('FLS violation detected. Access to the object or one or more fields is not permitted.');
        }
    } else {
        System.debug('indexval is null. Unable to convert to Decimal.');
    }
       
    }
    
    
    // Wrapper class for Recording object
    public class RecordingWrapper {
        public string audio_file { get; set; }
        public String recordingNumber { get; set; }
        public Boolean hasFile { get; set; }
        public Boolean isPlaybtn { get; set; }
    }
    
    //METHOD THAT RETURNS CURRENT LOGGEDIN USER'S NAME  
    public static String getUserName(){
        
        String currentUserFirstName;
        if (Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.fields.Id.isAccessible() 
            && Schema.sObjectType.User.fields.FirstName.isAccessible()) {
                
            Id currentUserId = UserInfo.getUserId();
            User currentUser = [SELECT FirstName FROM User WHERE Id = :currentUserId WITH SECURITY_ENFORCED LIMIT 1];
                
                if(currentUser != NULL){
                    currentUserFirstName = currentUser.FirstName;
                }
            return currentUserFirstName; 
        }else{
            return 'FLS violation detected.';
        }
	}
}