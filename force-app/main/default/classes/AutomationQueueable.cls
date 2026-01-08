public With Sharing class AutomationQueueable implements Queueable, Database.AllowsCallouts{
	Public Map<String, List<Future_Voicemails__c>> MapOfConditionAndFV; // Define the map to be used as a parameter
    S2V__Airwaves360_settings__c settings;
    Public static Set<Id> lstOfConWithBlankMobile = new Set<Id>();
    Public static List<Id> LstOfContactIds = new List<Id>();
    
    
    public AutomationQueueable(Map<String, List<Future_Voicemails__c>> MapOfConditionAndFV) {
        this.MapOfConditionAndFV = MapOfConditionAndFV;
        
        if(Schema.SObjectType.S2V__Airwaves360_settings__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.Id.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__OrganizationId__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_settings__c.fields.S2V__XapiKey__c.isAccessible()) {
               
               settings =[SELECT id,S2V__OrganizationId__c,S2V__XapiKey__c  FROM S2V__Airwaves360_settings__c LIMIT 1]; //yabbar_settings__c.getInstance();  
           } 
    }
    
    public void execute(QueueableContext context) {
        
        string XAPIkey;
        string OrgId;
        List<Id> LstOfObjIds = new List<Id>(); 
        List<Id> LstOfActiveScheduleRecordId = new List<Id>();
        Boolean retValGet;
        
        for (String key : MapOfConditionAndFV.keySet()) {
            List<S2V__Future_Voicemails__c> lstOfFutureVM = new List<S2V__Future_Voicemails__c>();
            lstOfFutureVM = MapOfConditionAndFV.get(key);
            
            if(settings != null){
                if(settings.S2V__XapiKey__c != null) {
                    XAPIkey = KeyDecryptionClass.decryptValue(settings.S2V__XapiKey__c);
                }
                if(settings.S2V__OrganizationId__c != null) {
                    OrgId = KeyDecryptionClass.decryptValue(settings.S2V__OrganizationId__c);  
                }
            }
            
            if(lstOfFutureVM.size() > 0 ) {
                
                Integer NumberOfFutureVoicemails = 0;
                List<S2V__Future_Voicemails__c> ListOffvcNumbers = new List<S2V__Future_Voicemails__c>();
                for(S2V__Future_Voicemails__c ObjFV : lstOfFutureVM) {
                    
                    if(ObjFV.Sending_Method__c =='SMS' &&  ObjFV.S2V__Status__c == 'Queue'){
                        ListOffvcNumbers.add(ObjFV); 
                    }
                    
                    LstOfObjIds.add(ObjFV.S2V__Record_Id__c);
                    LstOfActiveScheduleRecordId.add(ObjFV.S2V__ActiveScheduleRecordId__c);
                }    
                NumberOfFutureVoicemails = ListOffvcNumbers.size();
                if (Test.isRunningTest()) {
                    retValGet = true;
                    
                } else {
                    // METHOD THAT CREATES SMS/VM IN AIRWAVES
                    if(lstOfFutureVM.size()>0){
                        retValGet = MethodForAutomationCallout(LstOfObjIds , lstOfFutureVM[0].S2V__Sobject_Name__c, XAPIkey, OrgId,NumberOfFutureVoicemails,LstOfActiveScheduleRecordId,lstOfFutureVM); 
                    } 
                }
            }
        }
    }
    
    //METHOD THAT FETCHES VALUES FROM ACTIVE SCHEDULE AND CALLS ANOTHER METHOD FOR SMS/VM SENDING 
    Public static Boolean MethodForAutomationCallout(List<id> lstSobjRcrds, String ObjectName,string XAPIkey, string OrgId,Integer NumberOfFutureVoicemails,List<Id> ActiveScheduleRecordId,List<S2V__Future_Voicemails__c> lstOfObjFV) {
        
        Boolean retVal = false;
        
        
        return retVal;
    }
  
    
 
  
}