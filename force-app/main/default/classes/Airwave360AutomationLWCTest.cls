/**
* @File Name : Airwave360AutomationLWCTest.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : July 22, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | July 22, 2025 |   | Initial Version
**/

@isTest
public class Airwave360AutomationLWCTest {
	
    @testSetup
    static void setup() {
       
        
        // Create Active Schedule
        List<Airwaves360_Active_Schedule__c> activeSchedules = new List<Airwaves360_Active_Schedule__c>();
        for (Integer i = 0; i < 2; i++) {
            activeSchedules.add(new Airwaves360_Active_Schedule__c(Sending_Method__c = 'Voicemail', SMS_Template_Name__c = 'Test Template', S2V__SMS_Template_Body_New__c = 'Test Message'));
        }
        insert activeSchedules;

        List<S2V__SMS_Template__c> templates=new List<S2V__SMS_Template__c>();
        for(Integer i=0;i<2;i++){
            templates.add(new S2V__SMS_Template__c(S2V__Template_Name__c = 'Test SMS Template'+1, S2V__Object_Name__c='Contact', S2V__Template_Body__c='this is for testing purpose temp'+i));
        }
        insert templates;

        List<Airwaves360_Drip_Recording_Description__c> recordingDescription=new List<Airwaves360_Drip_Recording_Description__c>();
        for(Integer i=0;i<2;i++){
            recordingDescription.add(new Airwaves360_Drip_Recording_Description__c(S2V__Description__c = 'Description -', S2V__Personal__c=false, S2V__Recording_Number__c=i, S2V__isWithAudio__c=false));
        }
        insert recordingDescription;

} 
    @isTest
    public static void loadFieldOptionsTest(){
        test.startTest();
        Airwave360AutomationLWC.loadFieldOptions('Contact');
        Airwave360AutomationLWC.loadFieldOptions('CampaignMember');
        Airwave360AutomationLWC.loadFieldOptions('Contact');
        Airwave360AutomationLWC.loadFieldOptions('Lead');
        Airwave360AutomationLWC.loadFieldOptions('Opportunity');
        Airwave360AutomationLWC.loadFieldOptions('Task');
        test.stopTest();
    }
    
    @isTest
    public static void getScheduleListTest(){
        test.startTest();
        Airwave360AutomationLWC.getScheduleList();
        test.stopTest();
    }

    @isTest
    public static void getSmsTemplatesTest(){
        
        test.startTest();
        Airwave360AutomationLWC.getSmsTemplates('Contact');
        Airwave360AutomationLWC.getSmsTemplates('Lead');
        test.stopTest();
    }
    
    @isTest
    public static void getPicklistOptionsTest(){
        
        test.startTest();
        Airwave360AutomationLWC.getPicklistOptions('Contact', 'LeadSource');
        Airwave360AutomationLWC.getPicklistOptions('Lead', 'Industry');
        test.stopTest();
    }

    @isTest
    public static void getAlllookupfieldsAndSMSTemplatesTest(){
        
        test.startTest();
        Airwave360AutomationLWC.getAlllookupfieldsAndSMSTemplates('CampaignMember','Contact')  ;
        test.stopTest();
    }
    
    @isTest
    public static void getFieldTypeTest(){
        Set<String> fieldValue=new Set<String>{'Name', 'IsDeleted', 'Salutation', 'Birthdate', 'MailingLongitude'};
        test.startTest();
        Airwave360AutomationLWC.getFieldType('Contact', fieldValue);
        test.stopTest();
    }
    
    @isTest
    public static void getRecordingNumberTest(){
        
        test.startTest();
        Airwave360AutomationLWC.getRecordingNumber();
        test.stopTest();
    }
    
    @isTest
    public static void saveAllDataTest(){     
        S2V__SMS_Template__c template=[Select Id from S2V__SMS_Template__c limit 1];
        Map<String, String> comboboxValuesForVoicemail= new Map<String, String>{'method' => 'Voice Mail',
                    'objectName'=> 'Opportunity',
                    'toContactObjectName'=> 'Contact',
                    'toWhomField'=> 'S2V__Primary_Contact__c',
                    'userReference'=> 'OwnerId',
                    'recordingNumber'=> '1 - Description -',
                    'selectedSchedule'=> 'Now',
                    'scheduleFrequencyValue'=> '',
                    'scheduleFrequencyDateTimeValue'=> ''};
                        
		Map<String, String> comboboxValuesForSMSTemplate= new Map<String, String>{'method' => 'SMS',
                    'objectName'=> 'Opportunity',
                    'toContactObjectName'=> 'Contact',
                    'toWhomField'=> 'S2V__Primary_Contact__c',
                    'userReference'=> 'OwnerId',
                    'smsTemplateId'=> template.Id,
                    'selectedSchedule'=> 'Future Call',
                    'scheduleFrequencyValue'=> 'Minutes',
                    'scheduleFrequencyDateTimeValue'=> '60'};

        List<Map<String, String>> rowValues=new List<Map<String, String>>();
        rowValues.add(new Map<String, String>{'selectField' => 'StageName',
                    'selectedOperator'=> 'Equals',
                    'inputValue'=> 'Qualification',
                    'fieldType'=> 'picklist'});
        rowValues.add(new Map<String, String>{'selectField' => 'Amount',
                    'selectedOperator'=> 'Equals',
                    'inputValue'=> '20000',
                    'fieldType'=> 'number'});
        rowValues.add(new Map<String, String>{'selectField' => 'CloseDate',
                    'selectedOperator'=> 'Equals',
                    'inputValue'=> '2025-07-15',
                    'fieldType'=> 'date'});
        rowValues.add(new Map<String, String>{'selectField' => 'IsWon',
                    'selectedOperator'=> 'Equals',
                    'inputValue'=> 'true',
                    'fieldType'=> 'checkbox'});
        rowValues.add(new Map<String, String>{'selectField' => 'Name',
                    'selectedOperator'=> 'Equals',
                    'inputValue'=> 'Testing',
                    'fieldType'=> 'text'});
        
        Map<String, String> comboboxValuesWithContactObject= new Map<String, String>{'method' => 'SMS',
                    'objectName'=> 'Contact',
                    'toContactObjectName'=> '',
                    'toWhomField'=> '',
                    'userReference'=> 'OwnerId',
                    'smsTemplateId'=> template.Id,
                    'selectedSchedule'=> 'Future Call',
                    'scheduleFrequencyValue'=> 'Minutes',
                    'scheduleFrequencyDateTimeValue'=> '60'};
        
        test.startTest();
        Airwave360AutomationLWC.saveAllData(rowValues,comboboxValuesForVoicemail);
        Airwave360AutomationLWC.saveAllData(rowValues,comboboxValuesForSMSTemplate);
        Airwave360AutomationLWC.saveAllData(rowValues,comboboxValuesWithContactObject);
        test.stopTest();
    }
    
    @isTest
    public static void getFieldAPINameTest(){
        test.startTest();
        Airwave360AutomationLWC.getFieldAPIName('Contact', 'Pronouns');
        test.stopTest();
    }
    
    @isTest
    public static void AllSmsTemplateTest(){
        S2V__SMS_Template__c template=[Select Id from S2V__SMS_Template__c limit 1];
        test.startTest();
        Airwave360AutomationLWC.AllSmsTemplate(template.Id);
        test.stopTest();
    }
    
        @isTest
    public static void QueryBuildingTest(){
        S2V__SMS_Template__c template=[Select Id from S2V__SMS_Template__c limit 1];
        Map<String, String> comboboxValuesForVoicemail= new Map<String, String>{'method' => 'Voice Mail',
                    'objectName'=> 'Opportunity',
                    'toContactObjectName'=> 'Contact',
                    'toWhomField'=> 'S2V__Primary_Contact__c',
                    'userReference'=> 'OwnerId',
                    'recordingNumber'=> '1 - Description -',
                    'selectedSchedule'=> 'Now',
                    'scheduleFrequencyValue'=> 'Hours',
                    'scheduleFrequencyDateTimeValue'=> '1'};
                        
		Map<String, String> comboboxValuesForSMSTemplate= new Map<String, String>{'method' => 'SMS',
                    'objectName'=> 'Opportunity',
                    'toContactObjectName'=> 'Contact',
                    'toWhomField'=> 'S2V__Primary_Contact__c',
                    'userReference'=> 'OwnerId',
                    'smsTemplateId'=> template.Id,
                    'selectedSchedule'=> 'Now',
                    'scheduleFrequencyValue'=> 'Minutes',
                    'scheduleFrequencyDateTimeValue'=> '60'};

        List<Map<String, String>> rowValues=new List<Map<String, String>>();
        rowValues.add(new Map<String, String>{'selectField' => 'StageName',
                    'selectedOperator'=> 'Equals',
                    'inputValue'=> 'Qualification',
                    'fieldType'=> 'picklist'});
        rowValues.add(new Map<String, String>{'selectField' => 'Amount',
                    'selectedOperator'=> 'Equals',
                    'inputValue'=> '20000',
                    'fieldType'=> 'number'});
        rowValues.add(new Map<String, String>{'selectField' => 'CloseDate',
                    'selectedOperator'=> 'Equals',
                    'inputValue'=> '2025-07-15',
                    'fieldType'=> 'date'});
        rowValues.add(new Map<String, String>{'selectField' => 'IsWon',
                    'selectedOperator'=> 'Equals',
                    'inputValue'=> 'true',
                    'fieldType'=> 'checkbox'});
        rowValues.add(new Map<String, String>{'selectField' => 'Name',
                    'selectedOperator'=> 'Equals',
                    'inputValue'=> 'Testing',
                    'fieldType'=> 'text'});
        test.startTest();
        Airwave360AutomationLWC.QueryBuilding(comboboxValuesForSMSTemplate, rowValues);
        Airwave360AutomationLWC.QueryBuilding(comboboxValuesForVoicemail, rowValues);
        test.stopTest();
    }
    
    
    
}