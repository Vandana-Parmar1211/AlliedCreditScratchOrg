/*CREATED BY: DHAIRYA & DHRUDEEP
 *DATED: 28TH JUNE 2018
 *DESC: THIS CLASS IS USED FOR GETTING THE ACTIVE SCHEDULES PART.
 *updated on 8th aug 2019
*/
Global with sharing class S2VActiveSchedules{
    
    public String recId {get;set;}
    public List<S2V__Airwaves360_Active_Schedule__c> lstS2VVoiceMails {get;set;}
    
    //Controller
    public S2VActiveSchedules()
    {
        lstS2VVoiceMails = new List<S2V__Airwaves360_Active_Schedule__c>();
        if(Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.fields.Id.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.fields.S2V__Object_Name__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.fields.S2V__Reference_Field_Lable__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.fields.S2V__Option_Schedule__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.fields.S2V__Recording_Name__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.fields.S2V__Reference_Field__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.fields.S2V__Schedule_Frequency__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.fields.S2V__Start_Date__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.fields.S2V__CreatedBy_Name__c.isAccessible()
           && Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.fields.CreatedById.isAccessible())
        {
            lstS2VVoiceMails = [Select Id,S2V__Object_Name__c,S2V__Reference_Field_Lable__c,S2V__CreatedBy_Name__c,S2V__Option_Schedule__c,S2V__Recording_Name__c,S2V__Reference_Field__c,S2V__Schedule_Frequency__c,S2V__Start_Date__c,CreatedById from S2V__Airwaves360_Active_Schedule__c limit 50000];
        }
    }
    
    //DELETING THE RECORDS
    public PageReference deleteRecord()
    {
        string tempASId = String.escapeSingleQuotes(recId);
        
        if(tempASId != null && tempASId.trim() != ''){
            S2V__Airwaves360_Active_Schedule__c tempObj = new S2V__Airwaves360_Active_Schedule__c(Id=tempASId);
            
            if(Schema.sObjectType.S2V__Airwaves360_Active_Schedule__c.isAccessible() && S2V__Airwaves360_Active_Schedule__c.sObjectType.getDescribe().isDeletable())
            {
                delete tempObj;
            }
        }
        PageReference pgrefference = new PageReference('/apex/S2V__Airwaves360_Automation');
        pgrefference.setRedirect(true);
        return pgrefference;
    }
}