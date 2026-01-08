public with sharing class Airwaves360IOCallerController {
    
    public String callerIDNumber{get;set;}
    public String callerCodeOption {get;set;}
    //public Boolean loginFlag{get;set;} 
    //public String authorizationHeader{get; private set;}
    //public String CallerIDCode {get;set;}
    public String jsonResponse { get; set; }
    public List<String> selectedSenderIdsList { get; set; }
    public String selectedSenderIdsJSON { get; set; }
    
    //CONSTRUCTOR
    public Airwaves360IOCallerController() {
        
        string key;
        string OrgId;
        string commonURL = System.Label.CommonURL;
        S2V__Airwaves360_settings__c settings;
        
        if(Schema.SObjectType.S2V__Airwaves360_settings__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.Id.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__OrganizationId__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__XapiKey__c.isAccessible()) {
               
               settings =[SELECT id,S2V__OrganizationId__c,S2V__XapiKey__c FROM S2V__Airwaves360_settings__c LIMIT 1]; 
               
           }
        
        if(settings != null) {
            
            key = KeyDecryptionClass.decryptValue(settings.S2V__XapiKey__c);
            OrgId =  KeyDecryptionClass.decryptValue(settings.S2V__OrganizationId__c);
        }
        
        String endpoint = commonURL+OrgId+'/config/sms';
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET'); 
        request.setHeader('Accept', 'application/json');
        request.setHeader('x-api-key', key);
        
        HttpResponse response = new Http().send(request);
        jsonResponse = response.getBody();
        
         //STORES THE RESPONSE IN WRAPPER CLASS INSTANCE
        YabbrIOcalledIdWrapper responseWrapper = (YabbrIOcalledIdWrapper)JSON.deserialize(jsonResponse, YabbrIOcalledIdWrapper.class);
        selectedSenderIdsList = new List<String>();
        selectedSenderIdsList = responseWrapper.config.selectedSenderIds;
        selectedSenderIdsJSON = JSON.serialize(selectedSenderIdsList);
    }
    
    // FETCH ALL THE AVAILABLE CALLER IDS FROM AIRWAVES.
    public void FetchSenderIDs() {
        
        string key;
        string OrgId;
        S2V__Airwaves360_settings__c settings;
        
        if(Schema.SObjectType.S2V__Airwaves360_settings__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.Id.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__OrganizationId__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__XapiKey__c.isAccessible()) {
               
               settings =[SELECT id,S2V__OrganizationId__c,S2V__XapiKey__c FROM S2V__Airwaves360_settings__c  LIMIT 1]; //yabbar_settings__c.getInstance();
               
           }
        
        if(settings != null) {
            
             key = KeyDecryptionClass.decryptValue(settings.S2V__XapiKey__c);
            OrgId =  KeyDecryptionClass.decryptValue(settings.S2V__OrganizationId__c);
            
        }
        
        string CommonURL = System.Label.CommonURL;
        list<string> exsselectedSenderIdsList = new List<string>();
        String endpoint = CommonURL+OrgId+'/config/sms';
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET'); 
        request.setHeader('Accept', 'application/json');
        request.setHeader('x-api-key', key);
        
        HttpResponse response = new Http().send(request);
        
        if (response.getStatusCode() == 200) {
            
            //STORES THE RESPONSE IN WRAPPER CLASS INSTANCE
            YabbrIOcalledIdWrapper responseWrapper = (YabbrIOcalledIdWrapper)JSON.deserialize( response.getBody(), YabbrIOcalledIdWrapper.class);
            exsselectedSenderIdsList = responseWrapper.config.selectedSenderIds;
            if(callerCodeOption == 'CA-US') {
                callerCodeOption = 'CA';
            } 
            
            if(callerIDNumber.isNumeric() == true) {
                string callerIDNumber = string.valueOf(callerIDNumber);
                exsselectedSenderIdsList.add(callerIDNumber);
                List<string>  finalSenderIds = exsselectedSenderIdsList;
                Boolean IsSuccess;
                UploadSenderIdtoYabbr(finalSenderIds);
                
            } else {
                
                ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Please enter only numeric values');
                ApexPages.addMessage(myMsg);
            }
        }
    }
    
    //CREATING NEW CALLER ID IN AIRWAVES
    public static void UploadSenderIdtoYabbr(List<string> callerIDNumber) {
        
        String formattedString = '';
        string key;
        string OrgId;
        S2V__Airwaves360_settings__c settings;
        string CommonURL = System.Label.CommonURL;
        Boolean IsSuccess;
        
        for(Integer i = 0; i < callerIDNumber.size(); i++) {
            
            formattedString += '"' + callerIDNumber[i] + '"';
            if(i < callerIDNumber.size() - 1) {
                formattedString += ', ';
            }
        }
        
        if(Schema.SObjectType.S2V__Airwaves360_settings__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.Id.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__OrganizationId__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__XapiKey__c.isAccessible()) {
               
               settings =[SELECT id,S2V__OrganizationId__c,S2V__XapiKey__c FROM S2V__Airwaves360_settings__c LIMIT 1]; //yabbar_settings__c.getInstance();
               
           }
        if(settings != null){
            
             key = KeyDecryptionClass.decryptValue(settings.S2V__XapiKey__c);
            OrgId =  KeyDecryptionClass.decryptValue(settings.S2V__OrganizationId__c);
            
        }
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CommonURL+OrgId+'/config/sms');
        req.setMethod('POST');
        req.setHeader('x-api-key', key);
        req.setHeader('Content-Type', 'application/json');
        
        String body = '{'+
            '"selectedSenderIds": ['+
            +formattedString+
            ']'+
            '}';
        
        req.setBody(body);
        // Create a new HTTP object to send the request
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            IsSuccess = true;
        } else {
            IsSuccess = false;
        }
    }
    
}