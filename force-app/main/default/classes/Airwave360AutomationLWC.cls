/**
* @File Name : Airwave360AutomationLWC.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : July 21, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | July 21, 2025 |   | Initial Version
**/

public class Airwave360AutomationLWC {
	
		@AuraEnabled 
	public static Map<String, Map<String,String>> loadFieldOptions(String objectName){
		
		Map<String, Map<String,String>> objectAndReferenceOptions=new Map<String, Map<String,String>>();

		//Creating Map for Object Fields
		Map<String, String> fieldOptions=new Map<String,String>();
		Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
		for(Schema.SObjectField sobjectFields : fieldMap.Values()) {
			if(sobjectFields.getDescribe().getName() == 'CampaignId') {                
                    fieldOptions.put(sobjectFields.getDescribe().getName(), sobjectFields.getDescribe().getLabel());
                }
			if(sobjectFields.getDescribe().getType() != Schema.DisplayType.REFERENCE && sobjectFields.getDescribe().getType() != Schema.DisplayType.TEXTAREA 
                   && sobjectFields.getDescribe().getType() != Schema.DisplayType.DATETIME) {
                       
                       if(sobjectFields.getDescribe().getName() != 'OtherGeocodeAccuracy' &&
                          sobjectFields.getDescribe().getName() != 'MailingGeocodeAccuracy' ){
                              fieldOptions.put(sobjectFields.getDescribe().getName(), sobjectFields.getDescribe().getLabel());
                          }
                   }    
		}

		//Creating map for user reference fields
		Map<String, String> userReferenceOptions=new Map<String, String>();
		Map<String, Schema.SObjectField> fieldMapForReference = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        Map<String, String> mapFieldAPINameToLable= new Map<String, String>();
            for(Schema.SObjectField sobjectFields : fieldMapForReference.Values()) {
                mapFieldAPINameToLable.put(sobjectFields.getDescribe().getName(), sobjectFields.getDescribe().getLabel());
                
                if(sobjectFields.getDescribe().getType() == Schema.DisplayType.REFERENCE) {
                    List<Schema.sObjectType> referencedObjectTypes = sobjectFields.getDescribe().getReferenceTo();
                    
                    if(referencedObjectTypes != null && referencedObjectTypes.size() > 0) {
                        
                        for(Schema.sObjectType ObjType : referencedObjectTypes) {
                            
                            if(String.valueOf(ObjType) == 'User' || String.valueOf(ObjType) == 'Group, User') {
                                userReferenceOptions.put(sobjectFields.getDescribe().getName(), sobjectFields.getDescribe().getLabel());
                            }
                        }
                    }
                }
            }

		
		System.debug(fieldOptions);
		System.debug(userReferenceOptions);
		objectAndReferenceOptions.put('ObjectFields',fieldOptions);
		objectAndReferenceOptions.put('UserReferenceFields',userReferenceOptions);
		Map<String, String> smsTemplateOptions=new Map<String,String>();
		if(objectName=='Contact' || objectName=='Lead'){
			smsTemplateOptions=getSmsTemplates(objectName);
			objectAndReferenceOptions.put('SMSTemplate',smsTemplateOptions);
		}
        /*Map<String, String> fixedUser=new Map<String, String>();
        fixedUser=getFixedUsers();
		if(fixedUser!=null && (!fixedUser.isEmpty())){
        objectAndReferenceOptions.put('FixedUsers',fixedUser);
		}*/

        Map<String, String> optionSchedule=getScheduleList();
        if(optionSchedule!=null && (!optionSchedule.isEmpty())){
            objectAndReferenceOptions.put('optionSchedule',optionSchedule);
        }

		Map<String, String> fieldTypeMap=new Map<String, String>();
		System.debug(fieldOptions.keySet());
        fieldTypeMap=getFieldType(objectName, fieldOptions.keySet());
		if(fieldTypeMap!=null && (!fieldTypeMap.isEmpty())){
			objectAndReferenceOptions.put('fieldTypeMap',fieldTypeMap);
		}

		return objectAndReferenceOptions;
	}

    public static Map<String, String> getScheduleList(){
        Map<String, String> optionSchedule=new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = S2V__Airwaves360_Active_Schedule__c.S2V__Option_Schedule__c.getDescribe();
        List<Schema.PicklistEntry> pickList = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry sp : pickList) {
            optionSchedule.put(sp.getLabel(), sp.getValue());
        }
        return optionSchedule;
    }


    @AuraEnabled
	public static Map<String,String> getSmsTemplates(String fieldsneed){
		try
        { 
            String ObjSelected;
			System.debug(fieldsneed);
            Map<String,String> Selectedoptions = new Map<String,String>();
            if(fieldsneed != null && fieldsneed != '0'){
                ObjSelected = fieldsneed;  
            }
            
           /* if(fieldsneed == '0' && selectedObject == 'Contact'){
                ObjSelected = 'Contact'; 
            }else if(fieldsneed == '0' && selectedObject == 'Lead'){
                ObjSelected = 'Lead';
            }*/
                  
            List<SMS_Template__c> objListSMStemplates = [SELECT id,Template_Name__c,Template_Body__c FROM SMS_Template__c WHERE 
                                                        Template_Name__c != null AND S2V__Object_Name__c = :ObjSelected WITH SECURITY_ENFORCED];
            
           // Selectedoptions.add(new SelectOption('none','------Select the SMS Template----------'));
            System.debug(objListSMStemplates);
            if((objListSMStemplates != null) && (!objListSMStemplates.isEmpty())){
                
                for(SMS_Template__c objEmailTemp : objListSMStemplates) {
                    
                    Selectedoptions.put(objEmailTemp.id,objEmailTemp.Template_Name__c);
                }
            }
			System.debug(Selectedoptions);
            return Selectedoptions;
        }
        catch(QueryException e)
        {
            throw new AuraHandledException('Custom error: ' + e.getMessage());  
        }
	}

    @AuraEnabled
    public static Map<String, String> getPicklistOptions(String objectName, String fieldName){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            options.put(entry.getLabel(), entry.getLabel());
        }
        System.debug(options);
        return options;
    }

    
  /*  public static Map<String, String> getFixedUsers(){
        Map<String, String> lstAllusr= new Map<String, String>();
        if (Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.fields.Id.isAccessible() && 
                Schema.sObjectType.Profile.isAccessible() && Schema.sObjectType.Profile.fields.Id.isAccessible() && Schema.sObjectType.Profile.fields.Name.isAccessible() &&
                Schema.sObjectType.User.fields.Name.isAccessible() && Schema.sObjectType.User.fields.isActive.isAccessible()) {
                    String profileName = System.Label.Profile_Name;
                    List<User> LstOfUesr = [select Id,Name ,ProfileId from User where isActive = true limit 500];
                    Profile SysAdminprofile = [select Id,Name from Profile where Name =:profileName limit 1];  
                    for(User usrs : LstOfUesr){
                        lstAllusr.put(usrs.Id ,usrs.Name);
                    }
                }
                System.debug(lstAllusr);
            return lstAllusr;
    }
    */

    @AuraEnabled
    public static Map<String, Map<String, String>> getAlllookupfieldsAndSMSTemplates(String selectedObject, String fieldsneed) {
        Map<String, Map<String, String>> resultSMSTemplateMap=new Map<String, Map<String, String>>();
        Map<String, String> result = new Map<String, String>();
        System.debug(selectedObject+'  '+fieldsneed);
        if(selectedObject != Null && selectedObject != '0' && fieldsneed != Null && fieldsneed != '0' && selectedObject != 'Contact' && selectedObject != 'Lead') {
            
            Map<String, Map<String, Schema.SObjectField>> objectFieldsMap = new Map<string, Map<String, Schema.SObjectField>>(); //Object field schema map
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
            System.debug('Testing in apex');
            for(Schema.SObjectField fld :objectFields.values()){
                Schema.describeFieldResult dfield = fld.getDescribe();
                String fldType = String.valueOf(dfield.getType()); 
                if (fldType == 'REFERENCE') { 
                    List<Schema.sObjectType> temp = fld.getDescribe().getReferenceTo();
                    for(Schema.sObjectType s : temp) {
                        if(String.valueOf(s) == fieldsneed) {
                            result.put(fld.getDescribe().getName(),fld.getDescribe().getLabel()); 
                            System.debug(result);
                        }
                    }
                }
            }
        }
        System.debug(result);
        if(result!=null && (!result.isEmpty())){
            resultSMSTemplateMap.put('Alllookupfields',result);
        }
        Map<String, String> smsTemplateOptions=new Map<String,String>();
		
			smsTemplateOptions=getSmsTemplates(fieldsneed);
            if(smsTemplateOptions!=null && (!smsTemplateOptions.isEmpty())){
			resultSMSTemplateMap.put('SMSTemplate',smsTemplateOptions);
            }
		

        return resultSMSTemplateMap;      
    }

	
    public static Map<String, String> getFieldType(String objectName, Set<String> fieldValue) {
		Map<String, String> fieldTypeMap=new Map<String, String>();
        if(objectName!='' && objectName!=null && (!fieldValue.isEmpty()) && fieldValue!=null){
			for(String fieldName: fieldValue){
				Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        if (objectName == 'Task' && fieldName == 'Subject') {
            fieldTypeMap.put(fieldName,'text') ;
        }else if (fieldResult.getType() == Schema.DisplayType.Picklist || fieldResult.getType() == Schema.DisplayType.COMBOBOX) {
            fieldTypeMap.put(fieldName,'picklist');
        } else if (fieldResult.getType() == Schema.DisplayType.Integer || fieldResult.getType() == Schema.DisplayType.Double || 
                   fieldResult.getType() == Schema.DisplayType.Currency || fieldResult.getType() == Schema.DisplayType.Percent) {
                       fieldTypeMap.put(fieldName, 'number');
                   } else if (fieldResult.getType() == Schema.DisplayType.Date || fieldResult.getType() == Schema.DisplayType.DateTime) {
                       fieldTypeMap.put(fieldName,'date');
                   } else if (fieldResult.getType() == Schema.DisplayType.Boolean) {
                       fieldTypeMap.put(fieldName,'checkbox');
                   } else {
                       fieldTypeMap.put(fieldName,'text');
                   }
			}
        }
		System.debug(fieldTypeMap);
		return fieldTypeMap;
        
        
    }
    @AuraEnabled
    public static Map<String, String> getRecordingNumber(){
        Map<String, String> result = new Map<String, String>();
         if(Schema.sObjectType.Airwaves360_Drip_Recording_Description__c.isAccessible() 
           && Schema.sObjectType.Airwaves360_Drip_Recording_Description__c.fields.Id.isAccessible() 
           && Schema.sObjectType.Airwaves360_Drip_Recording_Description__c.fields.Recording_Number__c.isAccessible() 
           && Schema.sObjectType.Airwaves360_Drip_Recording_Description__c.fields.OwnerId.isAccessible() 
           && Schema.sObjectType.Airwaves360_Drip_Recording_Description__c.fields.Description__c.isAccessible() 
           && Schema.sObjectType.Airwaves360_Drip_Recording_Description__c.fields.S2V__yabbrFileID__c.isAccessible()) { 
               System.debug('Inside if condition');
               Id currentUserId = UserInfo.getUserId();
               
               List<Airwaves360_Drip_Recording_Description__c> rec = [SELECT Id,S2V__yabbrFileID__c,Recording_Number__c,Description__c
                                                                      FROM Airwaves360_Drip_Recording_Description__c where OwnerId = :currentUserId 
                                                                      ORDER BY Recording_Number__c ASC LIMIT 10];
               for(Airwaves360_Drip_Recording_Description__c rec1 : rec) {
                   if(rec1.Description__c != Null && rec1.Description__c != '') {
                       result.put(String.valueOf(rec1.Recording_Number__c)+' - '+rec1.Description__c, String.valueOf(rec1.Recording_Number__c)+' - '+rec1.Description__c);
                       System.debug('inside forif');
                   }
               }
               System.debug(result);
 
           }
        
        return result;
    }



    @AuraEnabled
    public static String saveAllData(List<Map<String, String>> listOfObjectForQuery, Map<String, String> comboboxSelectedValues){
        System.debug('saveAllData');
        System.debug(listOfObjectForQuery);
		String outputOfRecordCreation='';
        if(comboboxSelectedValues !=null && (!comboboxSelectedValues.isEmpty())){
        
        Airwaves360_Active_Schedule__c ActiveScheduleObj = new Airwaves360_Active_Schedule__c();
        

        //OBJECT SELECTED
        System.debug(comboboxSelectedValues.get('objectName'));
        if(comboboxSelectedValues.get('objectName') != null && comboboxSelectedValues.get('objectName') != '' && comboboxSelectedValues.get('objectName') != '0' 
                && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Name.isCreateable() 
                && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Object_Name__c.isCreateable()
                && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Name.isUpdateable()
                && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Object_Name__c.isUpdateable()) {
               System.debug('Object name');
               ActiveScheduleObj.Name = comboboxSelectedValues.get('objectName');
               ActiveScheduleObj.Object_Name__c = comboboxSelectedValues.get('objectName');
           }
           System.debug('after Object name'+' '+comboboxSelectedValues.get('userReference'));

         //FIELD SELECTED
        if(comboboxSelectedValues.get('userReference') != null && comboboxSelectedValues.get('userReference') != '' && comboboxSelectedValues.get('userReference') != '0' 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Reference_Field__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Reference_Field_Lable__c.isCreateable()
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Reference_Field__c.isUpdateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Reference_Field_Lable__c.isUpdateable()) {
               System.debug('user Reference');
               ActiveScheduleObj.Reference_Field__c = comboboxSelectedValues.get('userReference');
               ActiveScheduleObj.Reference_Field_Lable__c =comboboxSelectedValues.get('userReference');
           }

        //RECORDING SELECTED
        System.debug('before recording number');
        if(comboboxSelectedValues.get('recordingNumber') != null && comboboxSelectedValues.get('recordingNumber').trim() != '' && comboboxSelectedValues.get('recordingNumber').trim() != '0' 
           && (Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Recording_Name__c.isCreateable() || Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Recording_Name__c.isUpdateable())
           && (Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Recording_Number__c.isCreateable() || Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Recording_Number__c.isUpdateable())) {
               System.debug(comboboxSelectedValues.get('recordingNumber'));
               List<String> lststr = comboboxSelectedValues.get('recordingNumber').split(' - ');
               ActiveScheduleObj.S2V__Recording_Number__c = Integer.valueOf(lststr[0]);
               ActiveScheduleObj.Recording_Name__c = lststr[1];
           }

        //SCHEDULING SELECTING
        System.debug('before scelected schedule');
        if(comboboxSelectedValues.get('selectedSchedule') != null && comboboxSelectedValues.get('selectedSchedule').trim() != '' && comboboxSelectedValues.get('selectedSchedule').trim()!= '0'
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Option_Schedule__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Option_Schedule__c.isUpdateable()) {
               System.debug(comboboxSelectedValues.get('selectedSchedule'));
               ActiveScheduleObj.Option_Schedule__c = comboboxSelectedValues.get('selectedSchedule');            
           }

        //RECORDING USER
        if(comboboxSelectedValues.get('recordingNumber') != '0' && comboboxSelectedValues.get('recordingNumber') != Null && comboboxSelectedValues.get('recordingNumber') != '' 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Recording_By_1_User__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Recording_By_1_User__c.isUpdateable()) {
               System.debug(comboboxSelectedValues.get('selectedSchedule'));
               ActiveScheduleObj.Recording_By_1_User__c = comboboxSelectedValues.get('recordingNumber');
           }

        //RECORDING NAME 
        if(comboboxSelectedValues.get('recordingNumber') != Null && comboboxSelectedValues.get('recordingNumber') != '0' && comboboxSelectedValues.get('recordingNumber') != ''
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Recording_Name__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Recording_Name__c.isUpdateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Recording_Number__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Recording_Number__c.isUpdateable()) {
               
               List<String> lststr = comboboxSelectedValues.get('recordingNumber').split(' - ');
               ActiveScheduleObj.S2V__Recording_Number__c = Integer.valueOf(lststr[0]);
               ActiveScheduleObj.Recording_Name__c = lststr[1];
           }
        //LOOKUP FIELDS
        if(comboboxSelectedValues.get('toWhomField') != Null && comboboxSelectedValues.get('toWhomField') != '' && comboboxSelectedValues.get('toWhomField') != '0'
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Selected_Lookup__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Selected_Lookup__c.isUpdateable()) {
               System.debug(comboboxSelectedValues.get('toWhomField'));
               ActiveScheduleObj.Selected_Lookup__c = comboboxSelectedValues.get('toWhomField');
           }
        //SENDING METHOD VM TRUE
        if(comboboxSelectedValues.get('method') ==  'Voice Mail' && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Sending_Method__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Sending_Method__c.isUpdateable()) {
               System.debug(comboboxSelectedValues.get('method'));
               ActiveScheduleObj.S2V__Sending_Method__c = 'Voicemail';
           }
        
        if(comboboxSelectedValues.get('method') ==  'SMS' && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Sending_Method__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Sending_Method__c.isUpdateable()) {
               
               ActiveScheduleObj.S2V__Sending_Method__c = 'SMS';
               System.debug(comboboxSelectedValues.get('smsTemplateId'));
               List<String> smstemplateNameAndBody=AllSmsTemplate(comboboxSelectedValues.get('smsTemplateId'));
               
               //TEMPLATE BODY
               if(smstemplateNameAndBody[1]!=null && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__SMS_Template_Body_New__c.isCreateable() 
                  && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__SMS_Template_Body_New__c.isUpdateable()) {
                      
                      ActiveScheduleObj.S2V__SMS_Template_Body_New__c = smstemplateNameAndBody[1];
                  }
               
               //TEMPLATE NAME
               if(smstemplateNameAndBody[0]!=null && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__SMS_Template_Name__c.isCreateable() 
                  && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__SMS_Template_Name__c.isUpdateable()) {
                      
                      ActiveScheduleObj.S2V__SMS_Template_Name__c = smstemplateNameAndBody[0];
                  }
           }

                if(comboboxSelectedValues.get('objectName')!=null && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__SMS_Object__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__SMS_Object__c.isUpdateable()) {
               
               ActiveScheduleObj.S2V__SMS_Object__c =  comboboxSelectedValues.get('objectName');
           }

            IF(Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Is_Active__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Is_Active__c.isUpdateable()) {
               
               ActiveScheduleObj.Is_Active__c = True;
           }

           //ACTIVITY HISTORY
        if(Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Activity_History__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Activity_History__c.isUpdateable()) {
               
               ActiveScheduleObj.Activity_History__c= True;
           }

           //::::: FOR OPTION SCHEDULE FUTURE STARTS HERE (VOICEMAIL && SMS) ::::: 
        if(comboboxSelectedValues.get('selectedSchedule')!=null && comboboxSelectedValues.get('selectedSchedule').trim()!='' && comboboxSelectedValues.get('selectedSchedule').trim()!='Now')
        {   
            if(Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Option_Schedule__c.isCreateable() 
               && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Option_Schedule__c.isUpdateable()){
                   
                   ActiveScheduleObj.Option_Schedule__c = comboboxSelectedValues.get('selectedSchedule');
               }
            
            if(comboboxSelectedValues.get('scheduleFrequencyValue')!=null && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Schedule_Time__c.isCreateable() && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Schedule_Time__c.isUpdateable())
            {
                ActiveScheduleObj.S2V__Schedule_Time__c = comboboxSelectedValues.get('scheduleFrequencyValue');
            }
            
            if(comboboxSelectedValues.get('scheduleFrequencyDateTimeValue')!=null && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Schedule_TIme_textBox__c.isCreateable() && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Schedule_TIme_textBox__c.isUpdateable())
            {
                ActiveScheduleObj.S2V__Schedule_TIme_textBox__c = String.valueOf(comboboxSelectedValues.get('scheduleFrequencyDateTimeValue'));
            }
        }

        String queryFinalwhereClause =null;

		if(listOfObjectForQuery!=null && (!listOfObjectForQuery.isEmpty())){
            for(Map<String, String> mapOfSelectedValues:listOfObjectForQuery){
            System.debug(mapOfSelectedValues.get('selectField')); 
            String selectedValue = mapOfSelectedValues.get('inputValue'); 
            if(mapOfSelectedValues.get('fieldType') != 'date' && (selectedValue != 'true' || selectedValue != 'false')){
               mapOfSelectedValues.put('inputValue','\'' + selectedValue + '\'');
            }
        }
			 String finalQuery=QueryBuilding(comboboxSelectedValues, listOfObjectForQuery);
        if(finalQuery!='' && finalQuery!=null){
            ActiveScheduleObj.S2V__S2vQuery__c = finalQuery;
            queryFinalwhereClause = S2V.QueryParserClass.getWhereClause(finalQuery);
        }
		}

        // GIVES ERROR IF ACTIVE SCHEDULE IS ALREADY EXIST WITH SAME VALUES AND QUERY
        if(Schema.sObjectType.Airwaves360_Active_Schedule__c.isUpdateable() && Schema.sObjectType.Airwaves360_Active_Schedule__c.iscreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Object_Name__c.isAccessible() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__S2vQuery__c.isAccessible() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Is_Active__c.isAccessible()) {
               List<String> whareClauseList = new List<String>();
               List<S2V__Airwaves360_Active_Schedule__c> LstOfExistingActiveSchedule = [Select id,S2V__S2vQuery__c from S2V__Airwaves360_Active_Schedule__c where S2V__Object_Name__c =: ActiveScheduleObj.S2V__Object_Name__c
                                                                                        and S2V__Is_Active__c = true WITH SECURITY_ENFORCED];
               
               if (LstOfExistingActiveSchedule != null && LstOfExistingActiveSchedule.size() > 0) {
                   for (S2V__Airwaves360_Active_Schedule__c activeschedule : LstOfExistingActiveSchedule) {
                       String whereclause = S2V.QueryParserClass.getWhereClause(activeschedule.S2V__S2vQuery__c);
                       whareClauseList.add(whereclause);
                       
                   }
               }
               System.debug('isRecordExist: '+queryFinalwhereClause+whareClauseList);
               if(whareClauseList.contains(queryFinalwhereClause)) {
                   outputOfRecordCreation='Error:  Condtition is already Active';
               }
               else{
                    //CREATING NEW ACTIVE SCHEDULE RECORD
				try{
               	    insert ActiveScheduleObj;
			    	outputOfRecordCreation='Success';
				}
				catch(Exception e){
					throw new AuraHandledException('Custom error: ' + e.getMessage());
            }
               }
		}		
        }		
			return outputOfRecordCreation;

    }


    public static String getFieldAPIName(String objectName, String fieldName){
        String fieldAPIName='';
        System.debug(objectName+' '+fieldName);
        Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        for (String apiName : fields.keySet()) {
        Schema.DescribeFieldResult describe = fields.get(apiName).getDescribe();
        System.debug(describe.getLabel());
        if (describe.getLabel() == fieldName) {
            System.debug(apiName);
            fieldAPIName=apiName;
        }
        }
        System.debug(fieldAPIName);
        return fieldAPIName;
    }


    public static List<String> AllSmsTemplate(String smstemplateID)
    {
        List<String> smstemplateNameAndBody=new List<String>();
        try
        {
            System.debug(smstemplateID);
            if(Schema.sObjectType.SMS_Template__c.isAccessible() && Schema.sObjectType.SMS_Template__c.fields.Template_Name__c.isAccessible()
               && Schema.sObjectType.SMS_Template__c.fields.Template_Body__c.isAccessible() && Schema.sObjectType.SMS_Template__c.fields.id.isAccessible())
            {
                SMS_Template__c objSMSTemplate = [SELECT id,Template_Name__c,Template_Body__c FROM SMS_Template__c WHERE id=:smstemplateID LIMIT 1];
                
                if(objSMSTemplate != null){
                    smstemplateNameAndBody.add(objSMSTemplate.Template_Name__c);
                    smsTemplateNameAndBody.add(objSMSTemplate.Template_Body__c);
                }
                return smstemplateNameAndBody;    
            }
        }
        catch(QueryException e)
        {
            throw new AuraHandledException('Custom error: ' + e.getMessage());
        }
        return null;
    }


    public static String QueryBuilding(Map<String, String> comboboxSelectedValues, List<Map<String, String>> listOfObjectForQuery){
        String querycommanpart='';
        String queryFinal='';
        if(comboboxSelectedValues.get('userReference') != '0' && comboboxSelectedValues.get('userReference') != Null && comboboxSelectedValues.get('userReference') != ''&& comboboxSelectedValues.get('toWhomField') != '0' && comboboxSelectedValues.get('toWhomField') != Null && comboboxSelectedValues.get('toWhomField') != '') {
                
                querycommanpart = '['+'SELECT'+' Id,'+comboboxSelectedValues.get('userReference')+','+comboboxSelectedValues.get('toWhomField')+' '+'FROM'+' '+comboboxSelectedValues.get('objectName')+' '+'WHERE'+' ';
            }
            else if(comboboxSelectedValues.get('userReference') != '0' && comboboxSelectedValues.get('userReference') != Null && comboboxSelectedValues.get('userReference') != '') {
                
                querycommanpart = '['+'SELECT'+' Id,'+comboboxSelectedValues.get('userReference')+' '+'FROM'+' '+comboboxSelectedValues.get('objectName')+' '+'WHERE'+' ';
            }
            else if(comboboxSelectedValues.get('toWhomField') != '0' && comboboxSelectedValues.get('toWhomField') != Null && comboboxSelectedValues.get('toWhomField') != '') {
                
                querycommanpart = '['+'SELECT'+' Id,'+comboboxSelectedValues.get('toWhomField')+' '+'FROM'+' '+comboboxSelectedValues.get('objectName')+' '+'WHERE'+' ';
                
            } else {
                
                querycommanpart = '['+'SELECT'+' '+'Id'+' '+'FROM'+' '+comboboxSelectedValues.get('objectName')+' '+'WHERE'+' ';
            } 

        String querycreating='';
        if(comboboxSelectedValues.get('userReference') != '0' && comboboxSelectedValues.get('userReference') != Null && comboboxSelectedValues.get('userReference') != '' 
               && comboboxSelectedValues.get('toWhomField') != '0' && comboboxSelectedValues.get('toWhomField') != Null && comboboxSelectedValues.get('toWhomField') != '') {
                   
                   querycreating = '['+'SELECT'+' Id,'+comboboxSelectedValues.get('userReference')+','+comboboxSelectedValues.get('toWhomField')+' '+'FROM'+' '+comboboxSelectedValues.get('objectName')+'];';
                   
               } else if(comboboxSelectedValues.get('userReference') != '0' && comboboxSelectedValues.get('userReference') != Null && comboboxSelectedValues.get('userReference') != '') {
                   
                   querycreating = '['+'SELECT'+' Id,'+comboboxSelectedValues.get('userReference')+' '+'FROM'+' '+comboboxSelectedValues.get('objectName')+'];';
                   
               } else if(comboboxSelectedValues.get('toWhomField') != '0' && comboboxSelectedValues.get('toWhomField') != Null && comboboxSelectedValues.get('toWhomField') != '') {
                   
                   querycreating = '['+'SELECT'+' Id,'+comboboxSelectedValues.get('toWhomField')+' '+'FROM'+' '+comboboxSelectedValues.get('objectName')+'];';
                   
               } else {
                   
                   querycreating = '['+'SELECT'+' '+'Id'+' '+'FROM'+' '+comboboxSelectedValues.get('objectName')+'];';
               } 

        
        Map<String, String> operatorMapping = new Map<String, String>{
            'Equals' => '=',
                'Not equals to' => '!=',
                'Less than' => '<',
                'Greater than' => '>',
                'Less or equal' => '<=',
                'Greater or equal' => '>='
                };
                Integer j=0;
                sObjectType sObjType = ((SObject)(Type.forName('Schema.'+comboboxSelectedValues.get('objectName')).newInstance())).getSObjectType();
            DescribeSObjectResult sObjectDescription = sObjType.getDescribe();
            Map<String, String> allOperator=new Map<String, String>();
            Map<String, String> allInputValue=new Map<String, String>();
            Map<String, String> allFieldValues=new Map<String, String>();
        for(Map<String, String> mapOfSelectedValues:listOfObjectForQuery){
            j=j+1;
            allFieldValues.put('FieldValue'+j, mapOfSelectedValues.get('selectField'));
            allInputValue.put('InputValue'+j, mapOfSelectedValues.get('inputValue'));
            System.debug(mapOfSelectedValues.get('selectField'));  
            if (mapOfSelectedValues.get('selectedOperator') != null) {
                        allOperator.put('operator'+j, operatorMapping.containsKey(mapOfSelectedValues.get('selectedOperator')) ? operatorMapping.get(mapOfSelectedValues.get('selectedOperator')) : '');
                       // System.debug(operator1);
            } 


            if(mapOfSelectedValues.get('selectField') != null && mapOfSelectedValues.get('selectField') != '' && mapOfSelectedValues.get('selectField') != '0'){
            Schema.DisplayType FldTypeval = sObjectDescription.fields.getMap().get(mapOfSelectedValues.get('selectField')).getDescribe().getType();
            if(mapOfSelectedValues.get('inputValue') == null && FldTypeval != Schema.DisplayType.BOOLEAN ){
                system.debug('inside if');
                allInputValue.put(j+'filterval',null);
            }else if(mapOfSelectedValues.get('inputValue') == null && FldTypeval == Schema.DisplayType.BOOLEAN){
                allInputValue.put(j+'filterval','false');
            }
        }
            
        }
            System.debug(allOperator);
            System.debug(allInputValue);


            List<String> filterValues = new List<String>(allFieldValues.values());
            List<String> filterVals = new List<String>(allInputValue.values());
                List<String> operators = new List<String>(allOperator.values());
                    List<String> queryConditions = new List<String>();

        for (Integer i = 0; i < filterValues.size(); i++) {
            if (filterValues[i] != null && filterValues[i] != '' && filterValues[i] != '0') {
                Schema.DisplayType fieldType = sObjectDescription.fields.getMap().get(filterValues[i]).getDescribe().getType();
                
                if (fieldType == Schema.DisplayType.INTEGER || fieldType == Schema.DisplayType.CURRENCY ||
                    fieldType == Schema.DisplayType.PERCENT || fieldType == Schema.DisplayType.DOUBLE) {
                        if (filterVals[i] != null && filterVals[i] != '') {
                            filterVals[i] = filterVals[i].remove('\'');
                        }
                    }
                if((!filterVals.isEmpty()) && filterVals!=null){
                if (filterVals[i] == '\'\'' || filterVals[i].trim() == '\'\'' || filterVals[i] == '\'null\'' || filterVals[i].trim() == '' ) {
                    filterVals[i] = null;
                }
                }
                
                queryConditions.add(filterValues[i] + ' ' + operators[i] + ' ' + filterVals[i]);
            }
        }

        if (!queryConditions.isEmpty()) {
            querycreating = querycommanpart + String.join(queryConditions, ' AND ') + ' ];';
        }

        //QUERY FIELD
        if(querycreating != null && querycreating != ''  
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__S2vQuery__c.isCreateable()
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__S2vQuery__c.isUpdateable()
          ) {
              queryFinal = comboboxSelectedValues.get('objectName') +' '+'obj'+comboboxSelectedValues.get('objectName') +'='+querycreating;
              if(queryFinal.contains('AND Id = null')) {
                  queryFinal = queryFinal.remove('AND Id = null');
              }
                  
              //system.debug('ActiveScheduleObj.Queryc>>>'+ActiveScheduleObj.Queryc);
          }

          return queryFinal;

    }

}