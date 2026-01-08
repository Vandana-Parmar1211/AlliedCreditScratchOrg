public with sharing class Airwaves360SMSTemplatesCtrl {
    
    Public String SMSTemplateName {get;set;}
    Public String SMSTemplateType {get;set;}
    Public String SMSTemplateSource {get;set;}
    Public String SMSTemplateBody {get;set;}
    Public String SelectedField   {get;set;}
    Public String SelectedFieldToInsert {get;set;}    
    
    Public Boolean isListView {get;set;}
    Public Boolean isNewtemplate {get;set;}  
    Public Boolean showErrorMessage {get;set;}
    
    Public Id deleteTempId {get;set;}
    Public Id editTemplateId {get;set;}
    
    Public List<Selectoption> lstSources {get;set;}
    Public List<Selectoption> lstFields {get;set;}
    Public List<SMS_Template__c> lst_SMSTemplates {get;set;}
    //public Integer sizeOfTemplates {get;set;}
    
    Public Map<Id, SMS_Template__c> mapIdToTemplates;
    
    //CONTROLLER 
    public Airwaves360SMSTemplatesCtrl()
    {
        SMSTemplateType = 'Lead';
        SMSTemplateSource = 'Lead';
        
        SMSTemplateName = '';
        SMSTemplateBody = '';
        SelectedField = ''; 
        SelectedFieldToInsert = '';  
        
        isListView = true;
        isNewtemplate = false;
        showErrorMessage = true;
        
        lstSources = new List<selectoption>();
        lstFields = new List<selectoption>();
        lst_SMSTemplates = new List<SMS_Template__c>();
        
        mapIdToTemplates = new Map<Id, SMS_Template__c>();
        
        getSMSTemplateList();
    }
    
    //METHOD THAT FETCHES ALL THE SMS TEMPLATE RECORDS AND CREATES IT'S MAP 
    public void getSMSTemplateList()
    {
        if(Schema.sObjectType.SMS_Template__c.isAccessible() 
           && Schema.sObjectType.SMS_Template__c.fields.Id.isAccessible() 
           && Schema.sObjectType.SMS_Template__c.fields.Name.isAccessible() 
           && Schema.sObjectType.SMS_Template__c.fields.Template_Name__c.isAccessible()
           && Schema.sObjectType.SMS_Template__c.fields.Object_Name__c.isAccessible() 
           && Schema.sObjectType.SMS_Template__c.fields.CreatedDate.isAccessible() 
           && Schema.sObjectType.SMS_Template__c.fields.LastModifiedDate.isAccessible() 
           && Schema.sObjectType.SMS_Template__c.fields.Template_Body__c.isAccessible())
        {
            lst_SMSTemplates = [SELECT Id, Name, Template_Name__c, Object_Name__c, Template_Body__c, CreatedDate, LastModifiedDate FROM SMS_Template__c LIMIT 50000 ];
            
            if(lst_SMSTemplates != null && lst_SMSTemplates.size() > 0)
            {
                //sizeOfTemplates = lst_SMSTemplates.size();
                for(SMS_Template__c tempVar : lst_SMSTemplates)
                {
                    mapIdToTemplates.put(tempVar.Id, tempVar);
                }
            }    
        }
    }
    
    //METHOD THAT RESETS VARIABLES ON UI FOR NEW TEMPLATE CREATION 
    public void displayNewTemplate()
    {
        isListView = false;
        isNewtemplate = true;
        showErrorMessage = false;
        
        SMSTemplateType = 'Lead';
        SMSTemplateSource = 'Lead';
        
        SMSTemplateName = '';
        SMSTemplateBody = '';
        SelectedField = ''; 
        SelectedFieldToInsert = '';  
    }
    
    //METHOD THAT SHOWS TEMPLATE IN EDITABLE FORM 
    public void displayEditTemplate()
    {
        string tempASeditId = String.escapeSingleQuotes(editTemplateId);
        
        isListView = false;
        isNewtemplate = false;
        
        if(mapIdToTemplates.containsKey(tempASeditId))
        {            
            SMS_Template__c smsTemp = mapIdToTemplates.get(tempASeditId);
            SMSTemplateType = smsTemp.Object_Name__c;
            SMSTemplateSource = smsTemp.Object_Name__c;
            SMSTemplateName = smsTemp.Template_Name__c;
            SMSTemplateBody = smsTemp.Template_Body__c;
        }  
    }
    
    //METHOD TO CANCEL THE CHANGES
    public void cancelTemplate()
    {
        isListView = true;
        isNewtemplate = false;
        deleteTempId = null;
        editTemplateId = null;
    }
    //GET METHOD FOR SMS TEMPLATE TYPE
    public void getSMSTemplateType()
    {
        SMSTemplateSource = SMSTemplateType;
        SelectedField = ''; 
        SelectedFieldToInsert = '';
    }
    
    //GET METHOD FOR SMS TEMPLATE SOURCE 
    public void getSMSTemplateSource()
    {
        SelectedField = '';
        SelectedFieldToInsert = '';
    }    
    
    //METHOD THAT RETURNS AVILABLE FIELD TYPES AT STEP 3 
    public List<Selectoption> getAllSourceNames()
    {
        lstSources = new List<selectoption>();
        lstSources.add(new SelectOption(SMSTemplateType,SMSTemplateType));
        lstSources.add(new SelectOption('User','$User'));
        lstSources.add(new SelectOption('Organization','$Organization'));
        return lstSources;
        
    }
    //METHOD THAT RETURNS MERGE FIELD
    public void getSelectedField()
    {
        SelectedFieldToInsert = '{!'+SMSTemplateSource+'.'+ SelectedField + '}';
    }
    
    // METHOD THAT FETCHES ALL THE FIELDS OF SELECTED OBJECT (CONTACT/LEAD)
    public List<Selectoption> getAllFields()
    {
        lstFields = new List<selectoption>();
        
        Map<String, Schema.SObjectField> mapOfFieldVsAPIName =Schema.getGlobalDescribe().get(SMSTemplateSource).getDescribe().fields.getMap();
        
        for(String str : mapOfFieldVsAPIName.keyset())
        {
            lstFields.add(new SelectOption(str,str));
        }
        return lstFields;
    }
    
    // METHOD THAT DELETES SMS TEMPLATE 
    public void deleteSMSTemplate()
    {
        string tempASDeleteId = String.escapeSingleQuotes(deleteTempId);
        
        if(tempASDeleteId != null 
           && Schema.sObjectType.SMS_Template__c.isAccessible() 
           && Schema.sObjectType.SMS_Template__c.fields.id.isAccessible() 
           && SMS_Template__c.sObjectType.getDescribe().isDeletable())
        {
            SMS_Template__c smsTemp = new SMS_Template__c(id=tempASDeleteId);
            delete smsTemp;
        }
        tempASDeleteId = null;
    }
    
    // METHOD THAT CREATES SMS TEMPLATE
    public void saveSMSTemplate()
    {
        if(Schema.sObjectType.SMS_Template__c.isCreateable() 
           && Schema.sObjectType.SMS_Template__c.fields.Template_Name__c.isCreateable()
           && Schema.sObjectType.SMS_Template__c.fields.Object_Name__c.isCreateable() 
           && Schema.sObjectType.SMS_Template__c.fields.Template_Body__c.isCreateable())
        {
            SMS_Template__c smsTemp = new SMS_Template__c();   
            if(SMSTemplateType == 'Contact')
            {
                smsTemp.Template_Name__c  = 'CON-'+SMSTemplateName;
            }
            else
            {
                smsTemp.Template_Name__c  = 'LEAD-'+SMSTemplateName;
            }
            
            smsTemp.Object_Name__c   = SMSTemplateType;
            smsTemp.Template_Body__c    = SMSTemplateBody;
            
            if(smsTemp != null)
            {
                if(isNewtemplate)
                {
                    if(lst_SMSTemplates != null  && Schema.sObjectType.SMS_Template__c.isCreateable())
                    {
                        Insert smsTemp;
                    }
                }
                else
                { 
                    if(Schema.sObjectType.SMS_Template__c.isUpdateable()
                       && Schema.sObjectType.SMS_Template__c.fields.Template_Name__c.isUpdateable()
                       && Schema.sObjectType.SMS_Template__c.fields.Object_Name__c.isUpdateable() 
                       && Schema.sObjectType.SMS_Template__c.fields.Template_Body__c.isUpdateable())
                    {
                        smsTemp.Id = editTemplateId; 
                          smsTemp.Template_Name__c  = SMSTemplateName;
                          smsTemp.Object_Name__c   = SMSTemplateType;
                        smsTemp.Template_Body__c    = SMSTemplateBody;
                        
                        Update smsTemp;  
                    }
                }
            }
        }
        
        lst_SMSTemplates = new List<SMS_Template__c>();
        mapIdToTemplates = new Map<Id, SMS_Template__c>();
        getSMSTemplateList();
        isListView = true;
        isNewtemplate = false;
        editTemplateId = null;
        SMSTemplateName = '';
        SMSTemplateBody = '';
        SelectedField = ''; 
        SelectedFieldToInsert = ''; 
    }
}