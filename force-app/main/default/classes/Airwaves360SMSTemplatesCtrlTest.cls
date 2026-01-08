/*
* CREATED BY: Vandana Parmar
* DATE: 28-0302024
* DESC: TEST CLASS FOR Airwaves360SMSTemplatesCtrl APEX CLASS
* 
*/ 
@isTest
public class Airwaves360SMSTemplatesCtrlTest 
{
  @testsetup public static void testData()
    {
        SMS_Template__c smsTemplate = new SMS_Template__c();
        smsTemplate.Template_Name__c = 'Test Template';
        smsTemplate.Object_Name__c = 'Lead';
        smsTemplate.Template_Body__c = 'Test Body';
        insert smsTemplate;
        SYSTEM.assert(smsTemplate.Id!=NULL);
    }
    
    
    static testMethod void testdisplayNewTemplate()
    {
        SMS_Template__c template = [SELECT Id FROM SMS_Template__c LIMIT 1];
        Airwaves360SMSTemplatesCtrl ctrl = new Airwaves360SMSTemplatesCtrl();
        ctrl.editTemplateId = template.Id;
        ctrl.displayNewTemplate();
        ctrl.displayEditTemplate();
        ctrl.getSMSTemplateType();
        ctrl.getSMSTemplateList();
        ctrl.getAllSourceNames();
        ctrl.getAllFields();
        ctrl.getSMSTemplateSource();
        ctrl.getSelectedField();
        ctrl.saveSMSTemplate();
        
        ctrl.isNewtemplate = true;
        ctrl.saveSMSTemplate();
        ctrl.cancelTemplate();
        
        ctrl.deleteTempId = template.Id;
        ctrl.deleteSMSTemplate();
        SYSTEM.assert(template.Id!=NULL);
    }  
    
}