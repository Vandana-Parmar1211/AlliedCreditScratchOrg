Global with sharing class Airwaves360VoiceMailSendPageController{    
    Global String firstfilterval = null;
    Global String secondfilterval = null;
    Global String thirdfilterval = null;
    Global String forthfilterval  = null;
    Global String fifthfilterval = null;
    Global String sixthfilterval  = null;
    
    public List<TableRow> tableRows { get; set; }
    public Integer rowIndex { get; set; } 
    public List<SelectOption> fieldOptions { get; set; }
    public Integer enabledRows { get; set; } 
    public String rowselectedvalue {get;set;}
    public Integer selectedRowIndex { get; set; }
    
    public List<SelectOption> lstPickValues1 {get;set;}
    public List<SelectOption> lstPickValues2 {get;set;}
    public List<SelectOption> lstPickValues3 {get;set;}
    public List<SelectOption> lstPickValues4 {get;set;}
    public List<SelectOption> lstPickValues5 {get;set;}
    public List<SelectOption> lstPickValues6 {get;set;}
    
    public List<SelectOption> lstOperatorValues {get;set;}
    public String selectedPicVal {get;set;} //SELECTED FIELD FROM Field'S DROPDOWN
    public String selectedObject {get;set;} //SELECTED OBJECT FROM OBJECT'S DROPDOWN
    public String selectedField {get;set;} //SELECTED FIELD FROM OBJECT'S DROPDOWN
    public String selectedRecordingName {get;set;} // SELECTED RECORDING NUMBER 4A
    public Date selectedDate {get;set;} // SELECTED DATE FOR FUTURE CALL
    public Integer selectedDate1 {get;set;}
    public String selectedOptionschedule{get;set;} //SCHEDULING TYPE NOW OR FUTURE CALL
    public String selectedFreq {get;set;} // FREQUENCY OF FUTURE CALL
    public String selectedFreqValue {get;set;}
    public boolean enabletime {get;set;} // BOOLEAN TO SHOW FREQUENCY, TIME AND TIME FOR FUTURE CALL
    List<SelectOption> options {get;set;}
    List<SelectOption> optionSchedule{get;set;}
    public List<SelectOption> lstObjNames {get;set;} // LIST OF OBJECTS
    public List<SelectOption> lstObjFields {get;set;} // LIST OF FIELD RELATED TO SELECTED OBJECT
    private map<String,String> mapFieldAPINameToLable;
    private String tempS2VId; 
    public Boolean isEditMode {get;set;}
    public String fieldsneed{get;set;} 
    public String userfields{get;set;}
    
    //FILTER VALUES FOR FIELD NAMES
    public String filterValue1{get;set;}
    public String filterValue2{get;set;}
    public String filterValue3{get;set;}
    public String filterValue4{get;set;}
    public String filterValue5{get;set;}
    public String filterValue6{get;set;}
    
    //FILTER VALUES FOR OPERATORS
    public String filterop1{get;set;}
    public String filterop2{get;set;}
    public String filterop3{get;set;}
    public String filterop4{get;set;}
    public String filterop5{get;set;}
    public String filterop6{get;set;}
    
    //FILTER VALUES FOR TEXT FIELD
    public String filtertext1{get;set;}
    public String filtertext2{get;set;}
    public String filtertext3{get;set;}
    public String filtertext4{get;set;}
    public String filtertext5{get;set;}
    public String filtertext6{get;set;}
    
    //FILTER VALUES FOR Date FIELD
    public String filterdate1{get;set;}
    public String filterdate2{get;set;}
    public String filterdate3{get;set;}
    public String filterdate4{get;set;}
    public String filterdate5{get;set;}
    public String filterdate6{get;set;}
    
    //QUERY PART
    public String querycreating {get;set;}
    public String queryFinal{get;set;}
    public String selectedUser{get;set;} //SELECTED USER FROM DROP DOWN TO FILTER RECORDINGS
    public List<SelectOption> lstAllusr {get;set;} //LIST OF ALL USER
    public List<SelectOption> lstAlllookuprelated {get;set;} // LOOKUP FIELDS FOR SELECTED OBJECT IN 3RD OPTION
    public String selectedTime {get;set;} // SELECTED TIME FOR FUTURE CALL
    public String selectedLookup {get;set;}  //SELECTED LOOKUP TO SEND EMAIL 
    public String Recordingnumbers{get;set;} //SELECTED RECORDING NUMBER TO SEND TO THE CONTACT OR LEAD
    
    //SMS TEMPLATE
    public String smstemplateID {get;set;}
    public String smstemplateName {get;set;}
    public String smstemplateBody {get;set;}
    public String radioValues;
    public boolean voicemailvalue {get;set;}
    public boolean sms {get;set;}
    
    List<SelectOption> Selectedoptions {get;set;}
    public List<SelectOption> ScheduleFreqValueListVoiceMail { get; set; }
    public List<SelectOption> ScheduleFreqValueListSMS { get; set; }
    
    //CONSTRUCTOR STARTS
    public Airwaves360VoiceMailSendPageController(){
        
        selectedPicVal = '';
        options = new List<SelectOption>();
        optionSchedule = new List<SelectOption>();
        
        lstPickValues1 = new List<SelectOption>();
        lstPickValues2 = new List<SelectOption>();
        lstPickValues3 = new List<SelectOption>();
        lstPickValues4 = new List<SelectOption>();
        lstPickValues5 = new List<SelectOption>();
        lstPickValues6 = new List<SelectOption>();
        
        lstOperatorValues =  new List<SelectOption>();
        lstOperatorValues.add(new selectoption('Equals', 'Equals'));
        lstOperatorValues.add(new selectoption('Not equals to', 'Not equals to'));
        
        lstAlllookuprelated = new List<SelectOption>();
        lstAllusr = new List<SelectOption>();
        lstAllusr.add(new SelectOption('0','-- None --'));
        enabletime = false;
        querycreating='';  
        
        mapFieldAPINameToLable = new map<String,String>();
        List<String> lstobjName = new List<String>();
        lstObjNames = new List<SelectOption>();
        lstObjNames.add(new SelectOption('0','-- None --'));
        lstObjFields = new List<SelectOption>();
        lstObjFields.add(new SelectOption('0','-- None --'));
        
        ScheduleFreqValueListVoiceMail = new List<SelectOption>();
        ScheduleFreqValueListVoiceMail.add(new SelectOption('Hours', 'Hours'));
        ScheduleFreqValueListVoiceMail.add(new SelectOption('Minutes', 'Minutes'));
        ScheduleFreqValueListVoiceMail.add(new SelectOption('Days', 'Days'));
        
        ScheduleFreqValueListSMS = new List<SelectOption>();
        ScheduleFreqValueListSMS.add(new SelectOption('Hours', 'Hours'));
        ScheduleFreqValueListSMS.add(new SelectOption('Minutes', 'Minutes'));
        
        //TO FILL THE LIST OF OBJECT FROM WHICH VOICE MAIL WILL SEND
        List<String> lstobjnamenotused = new List<String>();
        lstObjNames.add(new selectoption('Contact','Contact'));
        lstObjNames.add(new selectoption('Lead','Lead'));
        lstObjNames.add(new selectoption('Opportunity','Opportunity'));
        lstObjNames.add(new selectoption('CampaignMember','CampaignMember'));
        lstObjNames.add(new selectoption('Task','Task'));
        
        Set<SelectOption> setObjNames = new set<SelectOption>();
        setObjNames.addAll(lstObjNames);
        lstObjNames.clear();
        lstObjNames.addAll(setObjNames);
        lstObjNames.sort();
        
        enabledRows = -1; // Disable all rows initially
        tableRows = new List<TableRow>();
        fieldOptions = new List<SelectOption>(); // Empty initially
        selectedObject = ''; // No object selected at the start
        initializeRows();
    }
    //CONSTRUCTOR ENDS
    // ✅ Load fields dynamically from the selected object
    private void loadFieldOptions(String objectName) {
        fieldOptions.clear();
        fieldOptions.add(new SelectOption('', 'Select an Option'));
        
        if (!String.isEmpty(objectName)) {
            Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            for(Schema.SObjectField sobjectFields : fieldMap.Values()) {
                if(sobjectFields.getDescribe().getName() == 'CampaignId') {                
                    fieldOptions.add(new selectoption(sobjectFields.getDescribe().getName(), sobjectFields.getDescribe().getLabel()));
                }
                if(sobjectFields.getDescribe().getType() != Schema.DisplayType.REFERENCE && sobjectFields.getDescribe().getType() != Schema.DisplayType.TEXTAREA 
                   && sobjectFields.getDescribe().getType() != Schema.DisplayType.DATETIME) {
                       
                       if(sobjectFields.getDescribe().getName() != 'OtherGeocodeAccuracy' &&
                          sobjectFields.getDescribe().getName() != 'MailingGeocodeAccuracy' ){
                              fieldOptions.add(new selectoption(sobjectFields.getDescribe().getName(), sobjectFields.getDescribe().getLabel()));
                          }
                   }    
            }
        }
    }
    
    // ✅ Initialize rows (disabled by default)
    private void initializeRows() {
        for (Integer i = 0; i < 6; i++) {
            tableRows.add(new TableRow(i, '', '', false));
        }
    }
    
    // ✅ Called when the object is selected
    public void onObjectChange() {
        if (!String.isEmpty(selectedObject)) {
            enabledRows = 0; // Enable the first row
            loadFieldOptions(selectedObject);
        } else {
            enabledRows = -1; // Keep all rows disabled if no object is selected
        }
    }
    
    // ✅ Called when field selection changes
    public void updateRow() {
        if (rowIndex != null && rowIndex < tableRows.size()) {
            TableRow row = tableRows[rowIndex];
            
            if (String.isEmpty(row.fieldName)) {
                row.fieldType = '';
                row.operators.clear();
                row.picklistOptions.clear();
                row.selectedValue = '';  
                return;
            }
            String newFieldType = getFieldType(selectedObject, row.fieldName);
            
            if (row.fieldType != newFieldType) {
                row.selectedValue = '';  
            }
            row.fieldType = newFieldType;
            row.operators = getOperators(row.fieldType);
            if (row.fieldType == 'picklist') {
                row.picklistOptions = getPicklistOptions(selectedObject, row.fieldName);
            } else {
                row.picklistOptions.clear();
            }
            enableNextRow();
        }
    }
    public static String formatDateToYYYYMMDD(String inputDate) {
        if (String.isEmpty(inputDate)) {
            return ''; // ✅ Return empty if input is empty
        }
        String formattedDate = '';
        try {
            // ✅ Convert DD/MM/YYYY or YYYY/MM/DD to YYYY-MM-DD
            if (inputDate.contains('/')) {  
                List<String> dateParts = inputDate.split('/');
                if (dateParts.size() == 3) {
                    // ✅ Check if format is DD/MM/YYYY
                    String day = dateParts[0].length() == 1 ? '0' + dateParts[0] : dateParts[0];  // Ensure two-digit day
                    String month = dateParts[1].length() == 1 ? '0' + dateParts[1] : dateParts[1]; // Ensure two-digit month
                    formattedDate = dateParts[2] + '-' + month + '-' + day; // Rearrange to YYYY-MM-DD
                }
            }
            return formattedDate; // ✅ Returns YYYY-MM-DD format
            
        } catch (Exception e) {
            System.debug('Error formatting date: ' + e.getMessage());
            return ''; // ✅ Return empty if invalid format
        }
    }
    
    public void setFilterDateByIndex() {
        try {
            
            filterDate1 = formatDateToYYYYMMDD(filterDate1);
            filterDate2 = formatDateToYYYYMMDD(filterDate2);
            filterDate3 = formatDateToYYYYMMDD(filterDate3);
            filterDate4 = formatDateToYYYYMMDD(filterDate4);
            filterDate5 = formatDateToYYYYMMDD(filterDate5);
            filterDate6 = formatDateToYYYYMMDD(filterDate6);
            
        } catch (Exception e) {
            System.debug('Error parsing date: ' + e.getMessage());
        }
    }
    
    // ✅ Enable the next row when a value is entered
    public void enableNextRow() {
        
        if (rowIndex != null && rowIndex == enabledRows && rowIndex < tableRows.size() - 1 ) {
            enabledRows++;
        }
        setFilterDateByIndex();
        rowselectedvalue = '';
    }
    
    // ✅ Get the field type dynamically
    @testvisible
    private String getFieldType(String objectName, String fieldName) {
        if (String.isEmpty(fieldName)) return '';
        
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        if (objectName == 'Task' && fieldName == 'Subject') {
            return 'text';
        }else if (fieldResult.getType() == Schema.DisplayType.Picklist || fieldResult.getType() == Schema.DisplayType.COMBOBOX) {
            return 'picklist';
        } else if (fieldResult.getType() == Schema.DisplayType.Integer || fieldResult.getType() == Schema.DisplayType.Double || 
                   fieldResult.getType() == Schema.DisplayType.Currency || fieldResult.getType() == Schema.DisplayType.Percent) {
                       return 'number';
                   } else if (fieldResult.getType() == Schema.DisplayType.Date || fieldResult.getType() == Schema.DisplayType.DateTime) {
                       return 'date';
                   } else if (fieldResult.getType() == Schema.DisplayType.Boolean) {
                       return 'checkbox';
                   } else {
                       return 'text';
                   }
    }
    
    // ✅ Get operators based on field type
    public static List<SelectOption> getOperators(String fieldType) {
        List<SelectOption> options = new List<SelectOption>();
        if (fieldType == 'number' || fieldType == 'date') {
            options.add(new SelectOption('Equals', 'Equals'));
            options.add(new SelectOption('Not equals to', 'Not equals to'));
            options.add(new SelectOption('Less than', 'Less than'));
            options.add(new SelectOption('Greater than', 'Greater than'));
            options.add(new SelectOption('Less or equal', 'Less or equal')); 
            options.add(new SelectOption('Greater or equal', 'Greater or equal'));
        } else {
            options.add(new SelectOption('Equals', 'Equals'));
            options.add(new SelectOption('Not equals to', 'Not equals to'));
        }
        return options;
    }
    
    // ✅ Get picklist options dynamically
    @testvisible
    private List<SelectOption> getPicklistOptions(String objectName, String fieldName) {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '-- None --'));
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            options.add(new SelectOption(entry.getLabel(), entry.getLabel()));
        }
        return options;
    }
    
    // ✅ Table Row Class
    public class TableRow {
        public Integer index { get; set; }
        public String fieldName { get; set; }
        public String fieldType { get; set; }
        public String selectedOperator { get; set; }
        public String selectedValue { get; set; }
        public List<SelectOption> operators { get; set; }
        public List<SelectOption> picklistOptions { get; set; }
        public Boolean isEnabled { get; set; }  // ✅ Added to track if the row is enabled
        public String getIndexAsString() {
            return String.valueOf(index);
        }
        public TableRow(Integer i, String name, String type, Boolean enabled) {
            this.index = i;
            this.fieldName = name;
            this.fieldType = type;
            this.selectedOperator = '';
            this.selectedValue = '';
            this.operators = new List<SelectOption>();
            this.picklistOptions = new List<SelectOption>();
            this.isEnabled = enabled;
        }
    }
    
    public void clearFilter() {
        if (selectedRowIndex != null && selectedRowIndex < tableRows.size()) {
            TableRow row = tableRows[selectedRowIndex];
            row.fieldName = '';
            row.selectedOperator = null;
            row.selectedValue = '';
            row.fieldType = '';
            row.picklistOptions = new List<SelectOption>();
            if (selectedRowIndex == 0) {
                filterDate1 = '';
            } else if (selectedRowIndex == 1) {
                filterDate2 = '';
            } else if (selectedRowIndex == 2) {
                filterDate3 = '';
            } else if (selectedRowIndex == 3) {
                filterDate4 = '';
            } else if (selectedRowIndex == 4) {
                filterDate5 = '';
            } else if (selectedRowIndex == 5) {
                filterDate6 = '';
            }
            setFilterDateByIndex();
        }
    }
    
    // ✅ Updated method to accept `selectedValue`
    public void setRowFilterValues(TableRow row, String selectedValue) {
        String formattedValue = '';
        
        try {
            if (row.fieldType == 'date') {
                // ✅ Convert date to yyyy-MM-dd format
                Date selectedDate = Date.valueOf(selectedValue);
                DateTime dateTimeValue = DateTime.newInstance(selectedDate.year(), selectedDate.month(), selectedDate.day());
                formattedValue = dateTimeValue.format('yyyy-MM-dd');
            } else {
                // ✅ Handle boolean & text values
                if (selectedValue == 'true' || selectedValue == 'false') {
                    formattedValue = selectedValue;
                } else {
                    formattedValue = '\'' + selectedValue + '\'';
                }
            }
        } catch (Exception e) {
            system.debug('Error processing row ' + row.index + ': ' + e.getMessage());
        }
        
        // ✅ Assign values based on zero-based index
        if (row.index == 0) {
            filterValue1 = row.fieldName;
            filterop1 = row.selectedOperator;
            firstfilterval = formattedValue;
        } else if (row.index == 1) {
            filterValue2 = row.fieldName;
            filterop2 = row.selectedOperator;
            secondfilterval = formattedValue;
        } else if (row.index == 2) {
            filterValue3 = row.fieldName;
            filterop3 = row.selectedOperator;
            thirdfilterval = formattedValue;
        } else if (row.index == 3) {
            filterValue4 = row.fieldName;
            filterop4 = row.selectedOperator;
            forthfilterval = formattedValue;
        } else if (row.index == 4) {
            filterValue5 = row.fieldName;
            filterop5 = row.selectedOperator;
            fifthfilterval = formattedValue;
        } else if (row.index == 5) {
            filterValue6 = row.fieldName;
            filterop6 = row.selectedOperator;
            sixthfilterval = formattedValue;
        }
    }
    
    @testvisible
    private String getFilterDateByIndex(Integer rowIndex) {
        
        if (rowIndex == 0) return formatDateToYYYYMMDD(filterDate1);
        if (rowIndex == 1) return formatDateToYYYYMMDD(filterDate2);
        if (rowIndex == 2) return formatDateToYYYYMMDD(filterDate3);
        if (rowIndex == 3) return formatDateToYYYYMMDD(filterDate4);
        if (rowIndex == 4) return formatDateToYYYYMMDD(filterDate5);
        if (rowIndex == 5) return formatDateToYYYYMMDD(filterDate6);
        return null;
    }
    
    
    //GETTING FIELDS OF SELECTED OBJECT INTO FILTER CRITERIA'S DROP DOWN
    public List<SelectOption> getAllFieldNames()
    {
        lstAlllookuprelated.clear();
        lstAlllookuprelated.add(new SelectOption('','Select an Option'));
        if(selectedObject != Null && selectedObject != '0') {
            Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
            for(Schema.SObjectField sobjectFields : fieldMap.Values()) {
                if(sobjectFields.getDescribe().getName() == 'CampaignId') {                
                    lstAlllookuprelated.add(new selectoption(sobjectFields.getDescribe().getName(), sobjectFields.getDescribe().getLabel()));
                }
                if(sobjectFields.getDescribe().getType() != Schema.DisplayType.REFERENCE && sobjectFields.getDescribe().getType() != Schema.DisplayType.TEXTAREA 
                   && sobjectFields.getDescribe().getType() != Schema.DisplayType.DATETIME) {
                       
                       if(sobjectFields.getDescribe().getName() != 'OtherGeocodeAccuracy' &&
                          sobjectFields.getDescribe().getName() != 'MailingGeocodeAccuracy' ){
                              lstAlllookuprelated.add(new selectoption(sobjectFields.getDescribe().getName(), sobjectFields.getDescribe().getLabel()));
                          }
                   }    
            }
            return lstAlllookuprelated;
        }
        return null;
    }
    
    //GETTING FIELDS Value OF Field DROP DOWN
    public List<SelectOption> getAllPicFieldValues(String selectedfield, String Listnum) {
        
        if(Test.isRunningTest()) {
            selectedObject = 'Account';
        }
        if(selectedObject != null && selectedfield != null) {
            List<Schema.PicklistEntry> LstOfPLEntryVal = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap().get(selectedfield).getDescribe().getPicklistValues();
            
            for(Schema.PicklistEntry pickListVal : LstOfPLEntryVal) {
                if(Listnum == '1') {
                    lstPickValues1.add(new selectoption(pickListVal.getLabel(), pickListVal.getLabel()));
                }
                else if(Listnum == '2') {
                    lstPickValues2.add(new selectoption(pickListVal.getLabel(), pickListVal.getLabel()));
                    
                }else if(Listnum == '3') {
                    lstPickValues3.add(new selectoption(pickListVal.getLabel(), pickListVal.getLabel()));
                    
                }else if(Listnum == '4') {
                    lstPickValues4.add(new selectoption(pickListVal.getLabel(), pickListVal.getLabel()));
                    
                }else if(Listnum == '5') {
                    lstPickValues5.add(new selectoption(pickListVal.getLabel(), pickListVal.getLabel()));
                    
                }else if(Listnum == '6') {
                    lstPickValues6.add(new selectoption(pickListVal.getLabel(), pickListVal.getLabel()));
                }
            }
        }
        return lstPickValues1;
    }
    
    //GETTING REFERENCE FIELD LIKE OWNER,MODIFY BY FIELDS WHICH ARE RELATED TO USER
    public List<SelectOption> getSobjectFieldNames()
    {
        //IF SELECTED OBJECT IS NOT LEAD.
        if( selectedObject != null && selectedObject.trim() != '' && selectedObject != '0') {
            mapFieldAPINameToLable.clear();
            lstObjFields.clear();
            lstObjFields.add(new SelectOption('0','-- None --'));
            Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
            
            for(Schema.SObjectField sobjectFields : fieldMap.Values()) {
                mapFieldAPINameToLable.put(sobjectFields.getDescribe().getName(), sobjectFields.getDescribe().getLabel());
                
                if(sobjectFields.getDescribe().getType() == Schema.DisplayType.REFERENCE) {
                    List<Schema.sObjectType> referencedObjectTypes = sobjectFields.getDescribe().getReferenceTo();
                    
                    if(referencedObjectTypes != null && referencedObjectTypes.size() > 0) {
                        
                        for(Schema.sObjectType ObjType : referencedObjectTypes) {
                            
                            if(String.valueOf(ObjType) == 'User' || String.valueOf(ObjType) == 'Group, User') {
                                lstObjFields.add(new selectoption(sobjectFields.getDescribe().getName(), sobjectFields.getDescribe().getLabel()));
                            }
                        }
                    }
                }
            }
        }
        return lstObjFields;
    }
    
    //FETCH ALL USERS OF CURRENT ORG AND ADD IT IN TO DROP DOWN
    public List<SelectOption> SobjectUserNames1{
        get{
            lstAllusr.clear();
            if (Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.fields.Id.isAccessible() && Schema.sObjectType.User.fields.ProfileId.isAccessible() && 
                Schema.sObjectType.Profile.isAccessible() && Schema.sObjectType.Profile.fields.Id.isAccessible() && Schema.sObjectType.Profile.fields.Name.isAccessible() &&
                Schema.sObjectType.User.fields.Name.isAccessible() && Schema.sObjectType.User.fields.isActive.isAccessible()) {
                    String profileName = System.Label.Profile_Name;
                    List<User> LstOfUesr = [select Id,Name ,ProfileId from User where isActive = true limit 500];
                    Profile SysAdminprofile = [select Id,Name from Profile where Name =:profileName limit 1];
                    lstAllusr.add(new SelectOption('0','-- None --'));  
                    for(User usrs : LstOfUesr){
                        lstAllusr.add(new SelectOption(usrs.Id ,usrs.Name));
                    }
                }
            return lstAllusr;
        }
        set;
    }
    
    //FETCHES THE OPTION SCHEDULES AND ADD IT IN TO DROP DOWN
    public List<SelectOption> getScheduleList(){
        optionSchedule.clear();
        Schema.DescribeFieldResult fieldResult = S2V__Airwaves360_Active_Schedule__c.S2V__Option_Schedule__c.getDescribe();
        List<Schema.PicklistEntry> pickList = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry sp : pickList) {
            optionSchedule.add(new SelectOption(sp.getLabel(), sp.getValue()));
        }
        return optionSchedule;
    }
    
    // commented by vandana 13-12-24
    //FREQUENCIES FOR FUTURE CALL TO IDENTIFY WHEN USER WANT TO SCHEDULE AND SEND VOICE MAIL
    public List<SelectOption> getScheduleFreqList()
    {
        Schema.DescribeFieldResult fieldResult = S2V__Airwaves360_Active_Schedule__c.S2V__Schedule_Frequency__c.getDescribe();
        List<Schema.PicklistEntry> pickList = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry sp : pickList) {
            options.add(new SelectOption(sp.getLabel(), sp.getValue()));
        }
        return options;
    }
    
    //ENABLING DATE FREQUENCY AND TIME FIELD TO SCHEDULE IN FURURE
    public void enableFutureCallFields()
    {
        if(selectedOptionschedule != null && selectedOptionschedule != '0' && selectedOptionschedule == 'Future Call') {
            enabletime = True;
        }else{
            enabletime = False;
        }
    }
    
    //SAVE ALL SELECTED DATA IN TO S2V__S2V_SEND_VOICEMAIL__C OBJECT AS A RECORD
    public PageReference saveData() {
        for (TableRow row : tableRows) {
            String selectedValue = row.selectedValue;
            
            // ✅ Check if the field type is "DATE"
            if (row.fieldType == 'date') {
                String dateValue = getFilterDateByIndex(row.index);
                if (dateValue != null && dateValue.trim() != '') {
                    selectedValue = dateValue; // ✅ Use filterDateX instead of selectedValue
                }
            }
            setRowFilterValues(row, selectedValue);
        }
        
        Airwaves360_Active_Schedule__c ActiveScheduleObj = new Airwaves360_Active_Schedule__c();
        //OBJECT SELECTED
        if(selectedObject != null && selectedObject.trim() != '' && selectedObject.trim() != '0' 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Name.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Object_Name__c.isCreateable()
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Name.isUpdateable()
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Object_Name__c.isUpdateable()) {
               
               ActiveScheduleObj.Name = selectedObject;
               ActiveScheduleObj.Object_Name__c = selectedObject;
           }
        
        //FIELD SELECTED
        if(selectedField != null && selectedField.trim() != '' && selectedField.trim() != '0' 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Reference_Field__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Reference_Field_Lable__c.isCreateable()
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Reference_Field__c.isUpdateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Reference_Field_Lable__c.isUpdateable()) {
               
               ActiveScheduleObj.Reference_Field__c = selectedField;
               ActiveScheduleObj.Reference_Field_Lable__c = mapFieldAPINameToLable.get(selectedField);
           }
        
        //RECORDING SELECTED
        if(selectedRecordingName != null && selectedRecordingName.trim() != '' && selectedRecordingName.trim() != '0' 
           && (Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Recording_Name__c.isCreateable() || Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Recording_Name__c.isUpdateable())
           && (Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Recording_Number__c.isCreateable() || Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Recording_Number__c.isUpdateable())) {
               
               List<String> lststr = selectedRecordingName.split(' - ');
               ActiveScheduleObj.S2V__Recording_Number__c = Integer.valueOf(lststr[0]);
               ActiveScheduleObj.Recording_Name__c = lststr[1];
           }
        
        //SCHEDULING SELECTING
        if(selectedOptionschedule != null && selectedOptionschedule.trim() != '' && selectedOptionschedule.trim()!= '0'
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Option_Schedule__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Option_Schedule__c.isUpdateable()) {
               
               ActiveScheduleObj.Option_Schedule__c = selectedOptionschedule;            
           }
        
        //USER SELECTED
        if(selectedUser != '0' && selectedUser != Null && selectedUser != '' 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Voice_mail_1_User__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Voice_mail_1_User__c.isUpdateable()) {
               
               ActiveScheduleObj.Voice_mail_1_User__c = selectedUser;
           } 
        
        //RECORDING USER
        if(selectedRecordingName != '0' && selectedRecordingName != Null && selectedRecordingName != '' 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Recording_By_1_User__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Recording_By_1_User__c.isUpdateable()) {
               
               ActiveScheduleObj.Recording_By_1_User__c = selectedRecordingName;
           }
        
        //RECORDING NAME
        if(Recordingnumbers != Null && Recordingnumbers != '0' && Recordingnumbers != ''
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Recording_Name__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Recording_Name__c.isUpdateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Recording_Number__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Recording_Number__c.isUpdateable()) {
               
               List<String> lststr = Recordingnumbers.split(' - ');
               ActiveScheduleObj.S2V__Recording_Number__c = Integer.valueOf(lststr[0]);
               ActiveScheduleObj.Recording_Name__c = lststr[1];
           }
        
        //LOOKUP FIELDS
        if(selectedLookup != Null && selectedLookup != '' && selectedLookup != '0'
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Selected_Lookup__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Selected_Lookup__c.isUpdateable()) {
               
               ActiveScheduleObj.Selected_Lookup__c = selectedLookup;
           }
        
        //SENDING METHOD VM TRUE
        if(voicemailvalue ==  true && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Sending_Method__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Sending_Method__c.isUpdateable()) {
               
               ActiveScheduleObj.S2V__Sending_Method__c = 'Voicemail';
           }
        
        //SMS TRUE
        if(sms == true && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Sending_Method__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Sending_Method__c.isUpdateable()) {
               
               ActiveScheduleObj.S2V__Sending_Method__c = 'SMS';
               
               //TEMPLATE BODY
               if(smstemplateBody!=null && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__SMS_Template_Body_New__c.isCreateable() 
                  && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__SMS_Template_Body_New__c.isUpdateable()) {
                      
                      ActiveScheduleObj.S2V__SMS_Template_Body_New__c = smstemplateBody;
                  }
               
               //TEMPLATE NAME
               if(smstemplateName!=null && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__SMS_Template_Name__c.isCreateable() 
                  && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__SMS_Template_Name__c.isUpdateable()) {
                      
                      ActiveScheduleObj.S2V__SMS_Template_Name__c = smstemplateName;
                  }
           }
        
        //OBJECT NAME:
        if(fieldsneed!=null && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__SMS_Object__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__SMS_Object__c.isUpdateable()) {
               
               ActiveScheduleObj.S2V__SMS_Object__c =  fieldsneed;
           }
        
        //ACTIVE
        IF(Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Is_Active__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Is_Active__c.isUpdateable()) {
               
               ActiveScheduleObj.Is_Active__c = True;
           }
        
        //ACTIVITY HISTORY
        IF(Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Activity_History__c.isCreateable() 
           && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Activity_History__c.isUpdateable()) {
               
               ActiveScheduleObj.Activity_History__c= True;
           }
        
        //::::: FOR OPTION SCHEDULE FUTURE STARTS HERE (VOICEMAIL && SMS) ::::: 
        if(selectedOptionschedule!=null && selectedOptionschedule.trim()!='' && selectedOptionschedule.trim()!='Now')
        {   
            if(Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Option_Schedule__c.isCreateable() 
               && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.Option_Schedule__c.isUpdateable()){
                   
                   ActiveScheduleObj.Option_Schedule__c = selectedOptionschedule;
               }
            
            if(selectedFreqValue!=null && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Schedule_Time__c.isCreateable() && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Schedule_Time__c.isUpdateable())
            {
                ActiveScheduleObj.S2V__Schedule_Time__c = selectedFreqValue;
            }
            
            if(selectedDate1!=null && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Schedule_TIme_textBox__c.isCreateable() && Schema.sObjectType.Airwaves360_Active_Schedule__c.fields.S2V__Schedule_TIme_textBox__c.isUpdateable())
            {
                ActiveScheduleObj.S2V__Schedule_TIme_textBox__c = String.valueOf(selectedDate1);
            }
        }
        
        // QUERY CREATING PART 
        String querycommanpart;
        if(filterText1 != '' || filterText2 != '' || filterText3 != '' || filterText4 != '' || filterText5 != '' || filterText6 != '' ) {
            
            if(selectedField != '0' && selectedField != Null && selectedField != ''&& selectedLookup != '0' && selectedLookup != Null && selectedLookup != '') {
                
                querycommanpart = '['+'SELECT'+' Id,'+selectedField+','+selectedLookup+' '+'FROM'+' '+selectedObject+' '+'WHERE'+' ';
            }
            else if(selectedField != '0' && selectedField != Null && selectedField != '') {
                
                querycommanpart = '['+'SELECT'+' Id,'+selectedField+' '+'FROM'+' '+selectedObject+' '+'WHERE'+' ';
            }
            else if(selectedLookup != '0' && selectedLookup != Null && selectedLookup != '') {
                
                querycommanpart = '['+'SELECT'+' Id,'+selectedLookup+' '+'FROM'+' '+selectedObject+' '+'WHERE'+' ';
                
            } else {
                
                querycommanpart = '['+'SELECT'+' '+'Id'+' '+'FROM'+' '+selectedObject+' '+'WHERE'+' ';
            } 
        } 
        else {
            
            if(selectedField != '0' && selectedField != Null && selectedField != '' 
               && selectedLookup != '0' && selectedLookup != Null && selectedLookup != '') {
                   
                   querycreating = '['+'SELECT'+' Id,'+selectedField+','+selectedLookup+' '+'FROM'+' '+selectedObject+'];';
                   
               } else if(selectedField != '0' && selectedField != Null && selectedField != '') {
                   
                   querycreating = '['+'SELECT'+' Id,'+selectedField+' '+'FROM'+' '+selectedObject+'];';
                   
               } else if(selectedLookup != '0' && selectedLookup != Null && selectedLookup != '') {
                   
                   querycreating = '['+'SELECT'+' Id,'+selectedLookup+' '+'FROM'+' '+selectedObject+'];';
                   
               } else {
                   
                   querycreating = '['+'SELECT'+' '+'Id'+' '+'FROM'+' '+selectedObject+'];';
               } 
        }
        
        String operator1 = '';
        String operator2 = '';
        String operator3 = '';
        String operator4 = '';
        String operator5 = '';
        String operator6 = '';
        
        Map<String, String> operatorMapping = new Map<String, String>{
            'Equals' => '=',
                'Not equals to' => '!=',
                'Less than' => '<',
                'Greater than' => '>',
                'Less or equal' => '<=',
                'Greater or equal' => '>='
                };
                    
                    if (filterop1 != null) {
                        operator1 = operatorMapping.containsKey(filterop1) ? operatorMapping.get(filterop1) : '';
                        
                    }
        if (filterop2 != null) {
            operator2 = operatorMapping.containsKey(filterop2) ? operatorMapping.get(filterop2) : '';
        }
        if (filterop3 != null) {
            operator3 = operatorMapping.containsKey(filterop3) ? operatorMapping.get(filterop3) : '';
            
        }
        if (filterop4 != null) {
            operator4 = operatorMapping.containsKey(filterop4) ? operatorMapping.get(filterop4) : '';
        }
        if (filterop5 != null) {
            operator5 = operatorMapping.containsKey(filterop5) ? operatorMapping.get(filterop5) : '';
        }
        if (filterop6 != null) {
            operator6 = operatorMapping.containsKey(filterop6) ? operatorMapping.get(filterop6) : '';
        }
        
        sObjectType sObjType = ((SObject)(Type.forName('Schema.'+selectedObject).newInstance())).getSObjectType();
        DescribeSObjectResult sObjectDescription = sObjType.getDescribe();
        
        if(filterValue1 != null && filterValue1 != '' && filterValue1 != '0'){
            Schema.DisplayType FldType1val = sObjectDescription.fields.getMap().get(filterValue1).getDescribe().getType();
            if(firstfilterval == null && FldType1val != Schema.DisplayType.BOOLEAN ){
                system.debug('inside if');
                firstfilterval = null;
            }else if(firstfilterval == null && FldType1val == Schema.DisplayType.BOOLEAN){
                firstfilterval = 'false';
            }
        }
        
        if(filterValue2 != null && filterValue2 != '' && filterValue2 != '0'){
            Schema.DisplayType FldType2val = sObjectDescription.fields.getMap().get(filterValue2).getDescribe().getType();
            if(secondfilterval == null && FldType2val != Schema.DisplayType.BOOLEAN){
                secondfilterval = null;
            }else if(secondfilterval == null && FldType2val == Schema.DisplayType.BOOLEAN){
                secondfilterval = 'false';
            }
        }
        
        if(filterValue3 != null && filterValue3 != '' && filterValue3 != '0'){
            Schema.DisplayType FldType3val = sObjectDescription.fields.getMap().get(filterValue3).getDescribe().getType();
            if(thirdfilterval == null && FldType3val != Schema.DisplayType.BOOLEAN){
                thirdfilterval = null;
            }else if(thirdfilterval == null && FldType3val == Schema.DisplayType.BOOLEAN){
                thirdfilterval = 'false';
            }
        }
        
        if(filterValue4 != null && filterValue4 != '' && filterValue4 != '0'){
            Schema.DisplayType FldType4val = sObjectDescription.fields.getMap().get(filterValue4).getDescribe().getType();
            if(forthfilterval == null && FldType4val != Schema.DisplayType.BOOLEAN){
                forthfilterval = null;
            }else if(forthfilterval == null && FldType4val == Schema.DisplayType.BOOLEAN){
                forthfilterval = 'false';
            }
        }
        
        if(filterValue5 != null && filterValue5 != '' && filterValue5 != '0'){
            Schema.DisplayType FldType5val = sObjectDescription.fields.getMap().get(filterValue5).getDescribe().getType();
            if(fifthfilterval == null && FldType5val != Schema.DisplayType.BOOLEAN){
                fifthfilterval = null;
            }else if(fifthfilterval == null && FldType5val == Schema.DisplayType.BOOLEAN){
                fifthfilterval = 'false';
            }
        }
        
        if(filterValue6 != null && filterValue6 != '' && filterValue6 != '0'){
            Schema.DisplayType FldType6val = sObjectDescription.fields.getMap().get(filterValue6).getDescribe().getType();
            if(sixthfilterval == null && FldType6val != Schema.DisplayType.BOOLEAN){
                sixthfilterval = null;
            }else if(sixthfilterval == null && FldType6val == Schema.DisplayType.BOOLEAN){
                sixthfilterval = 'false';
            }
        }
        List<String> filterValues = new List<String>{filterValue1, filterValue2, filterValue3, filterValue4, filterValue5, filterValue6};
            List<String> filterVals = new List<String>{firstfilterval, secondfilterval, thirdfilterval, forthfilterval, fifthfilterval, sixthfilterval};
                List<String> operators = new List<String>{operator1, operator2, operator3, operator4, operator5, operator6};
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
                
                if (filterVals[i] == '\'\'' || filterVals[i].trim() == '\'\'' || filterVals[i] == '\'null\'' || filterVals[i].trim() == '' ) {
                    filterVals[i] = null;
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
              queryFinal = selectedObject +' '+'obj'+selectedObject +'='+querycreating;
              if(queryFinal.contains('AND Id = null')) {
                  queryFinal = queryFinal.remove('AND Id = null');
              }
              
              ActiveScheduleObj.S2V__S2vQuery__c = queryFinal;    
              //system.debug('ActiveScheduleObj.Queryc>>>'+ActiveScheduleObj.Queryc);
          }
        
        String queryFinalwhereClause = S2V.QueryParserClass.getWhereClause(queryFinal);
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
               
               if(whareClauseList.contains(queryFinalwhereClause)) {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Condtition is already Active'));
                   return null;
               }
               //CREATING NEW ACTIVE SCHEDULE RECORD
               insert ActiveScheduleObj;
           }
        
        PageReference pgReference = new PageReference('/apex/S2VActiveSchedulePage');
        pgReference.setRedirect(true);
        return pgReference;
    }
    
    
    //FETCHING LOOKUP FIELD OF CONTACT OR LEAD FOR OBJECT LIKE OPPORTUNITY AND TASK
    public List<SelectOption> getAlllookupfields() {
        List<SelectOption> result = new List<SelectOption>();
        result.clear();
        result.add(new selectoption('0','--None--'));
        if(selectedObject != Null && selectedObject != '0' && fieldsneed != NUll && fieldsneed != '0' && selectedObject != 'Contact' && selectedObject != 'Lead') {
            
            map<string, Map<String, Schema.SObjectField>> objectFieldsMap = new map<string, Map<String, Schema.SObjectField>>(); //Object field schema map
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
            
            for(Schema.SObjectField fld :objectFields.values()){
                schema.describeFieldResult dfield = fld.getDescribe();
                string fldType = string.valueOf(dfield.getType()); 
                if (fldType == 'REFERENCE') { 
                    List<Schema.sObjectType> temp = fld.getDescribe().getReferenceTo();
                    
                    for(Schema.sObjectType s : temp) {
                        if(String.valueOf(s) == fieldsneed) {
                            result.add(new selectoption(fld.getDescribe().getName(),fld.getDescribe().getLabel())); 
                        }
                    }
                }
            }
        }
        return result;      
    }
    
    //GET 1 SMS TEMPLATES FROM THE SMS_Template__c OBJECT
    public PageReference AllSmsTemplate()
    {
        try
        {
            if(Schema.sObjectType.SMS_Template__c.isAccessible() && Schema.sObjectType.SMS_Template__c.fields.Template_Name__c.isAccessible()
               && Schema.sObjectType.SMS_Template__c.fields.Template_Body__c.isAccessible() && Schema.sObjectType.SMS_Template__c.fields.id.isAccessible())
            {
                SMS_Template__c objSMSTemplate = [SELECT id,Template_Name__c,Template_Body__c FROM SMS_Template__c WHERE id=:smstemplateID LIMIT 1];
                
                if(objSMSTemplate != null){
                    smstemplateName = objSMSTemplate.Template_Name__c;
                    smstemplateBody = objSMSTemplate.Template_Body__c;
                }
                return null;    
            }
        }
        catch(QueryException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,'Error');
            ApexPages.addMessage(myMsg); 
            return null;
        }
        return null;
    }
    
    //GET SMS TEMPLATES
    public List<SelectOption> getSmsTemplates()
    {
        try
        { 
            string ObjSelected;
            Selectedoptions = new List<SelectOption>();
            if(fieldsneed != null && fieldsneed != '0'){
                ObjSelected = fieldsneed;  
            }
            
            if(fieldsneed == '0' && selectedObject == 'Contact'){
                ObjSelected = 'Contact'; 
            }else if(fieldsneed == '0' && selectedObject == 'Lead'){
                ObjSelected = 'Lead';
            }
                  
            List<SMS_Template__c> objListSMStemplates = [SELECT id,Template_Name__c,Template_Body__c FROM SMS_Template__c WHERE 
                                                        Template_Name__c != null AND S2V__Object_Name__c = :ObjSelected WITH SECURITY_ENFORCED];
            
            Selectedoptions.add(new SelectOption('none','------Select the SMS Template----------'));
            
            if((objListSMStemplates != null) && (!objListSMStemplates.isEmpty())){
                
                for(SMS_Template__c objEmailTemp : objListSMStemplates) {
                    
                    Selectedoptions.add(new SelectOption(objEmailTemp.id,objEmailTemp.Template_Name__c));
                }
            }
            return Selectedoptions;
        }
        catch(QueryException e)
        {
            ApexPages.addMessages(e);
            return null;  
        }
    }
    
    public List<SelectOption> getRadios() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Voicemail','Voicemail'));
        options.add(new SelectOption('SMS','SMS'));
        return options;
    }
    
    public String getRadioValues()
    {
        return radioValues;
    }
    
    public void setRadioValues (String radioValues)
    {
        this.radioValues =  radioValues;
    } 
    
    public PageReference actionSave()
    {
        if (radioValues == 'Voicemail') {
            voicemailvalue = true;
            sms = false;
        }
        
        if(radioValues == 'SMS') {
            voicemailvalue = False;
            sms = true;
        }
        return null;
    }
    
    //GETTING 1 TO 10 RECORDING NUMBER TO IDENTIFY RECORDING NAME AND SEND THAT RECORDING AS A VOICE MAIL
    public List<SelectOption> getAllrecornumber()
    {
        if(Schema.sObjectType.Airwaves360_Drip_Recording_Description__c.isAccessible() 
           && Schema.sObjectType.Airwaves360_Drip_Recording_Description__c.fields.Id.isAccessible() 
           && Schema.sObjectType.Airwaves360_Drip_Recording_Description__c.fields.Recording_Number__c.isAccessible() 
           && Schema.sObjectType.Airwaves360_Drip_Recording_Description__c.fields.OwnerId.isAccessible() 
           && Schema.sObjectType.Airwaves360_Drip_Recording_Description__c.fields.Description__c.isAccessible() 
           && Schema.sObjectType.Airwaves360_Drip_Recording_Description__c.fields.S2V__yabbrFileID__c.isAccessible()) { 
               
               Id currentUserId = UserInfo.getUserId();
               
               List<Airwaves360_Drip_Recording_Description__c> rec = [SELECT Id,S2V__yabbrFileID__c,Recording_Number__c,Description__c
                                                                      FROM Airwaves360_Drip_Recording_Description__c where OwnerId = :currentUserId 
                                                                      ORDER BY Recording_Number__c ASC LIMIT 10];
               List<SelectOption> result = new List<SelectOption>();
               result.clear();
               result.add(new selectoption('0','--None--'));
               
               for(Airwaves360_Drip_Recording_Description__c rec1 : rec) {
                   if(rec1.Description__c != Null && rec1.Description__c != '') {
                       result.add(new selectoption(String.valueOf(rec1.Recording_Number__c)+' - '+rec1.Description__c, String.valueOf(rec1.Recording_Number__c)+' - '+rec1.Description__c));
                   }
               }
               
               if(result!=null) {
                   return result;          
               }
           }
        
        return null;
    }
    
    
    //METHOD THAT FETCHES VALUES FROM ACTIVE SCHEDULE AND CALLS ANOTHER METHOD FOR SMS SENDING 
    //THIS METHOD IS NOT IN USED
    Global static Boolean CallFutureMethodBatchFinalMethodNew2(List<id> lstSobjRcrds, String ObjectName,string XAPIkey, string OrgId,Integer NumberOfFutureVoicemails,
                                                               List<Id> ActiveScheduleRecordId ,Map<Id,id> mapofContact, Map<Id,string> mapofContactmobile) {
                                                                   Boolean retVal = false;
                                                                   return retVal;
                                                               }
    
    //METHOD THAT CREATES SMS IN AIRWAVES TRANSCRIPT
    //THIS METHOD IS NOT IN USED
    Global static Boolean sendSingleSMSMethod (String objectName, String fromNumber, String toNumber, String message,String XAPIkey)
    {
        Boolean isSusccess;
        return isSusccess;
    }
    
    //THIS METHOD IS NOT IN USED
    Global static Boolean CallFutureMethodBatch(List<id> lstSobjRcrds, String ObjectName, string timeZone) {
        Boolean retVal = false;
        return retVal;
    }
    
    //THIS METHOD IS NOT IN USED
    Global static Boolean CallFutureMethodBatchNew(List<id> lstSobjRcrds, String ObjectName) {
        Boolean retVal = false;
        return retVal;
    }
    
    //THIS METHOD IS NOT IN USED
    Global static Boolean CallFutureMethodBatchFinal(List<id> lstSobjRcrds, String ObjectName,string XAPIkey, string OrgId) {
        Boolean retVal = false;
        return retVal;
    }
    
    //THIS METHOD IS NOT IN USED
    Global static Boolean CallFutureMethodBatchFinal2(List<id> lstSobjRcrds, String ObjectName,string XAPIkey, string OrgId,Integer NumberOfFutureVoicemails) {
        Boolean retVal = false;
        return retVal;
    }
    
    //THIS METHOD IS NOT IN USED
    Global static Boolean CallFutureMethodBatchFinalMethod(List<id> lstSobjRcrds, String ObjectName,string XAPIkey, string OrgId,Integer NumberOfFutureVoicemails,String ActiveScheduleRecordId) {
        Boolean retVal = false;
        return retVal;
    }
    
    //THIS METHOD IS NOT IN USED
    Global static Boolean CallFutureMethodBatchFinalMethodNew(List<id> lstSobjRcrds, String ObjectName,string XAPIkey, string OrgId,Integer NumberOfFutureVoicemails,List<Id> ActiveScheduleRecordId ,Map<Id,Contact> mapofContact, Map<Id,string> mapofContactmobile) {
        Boolean retVal = false;
        return retVal;
    }
    
    //METHOD NOT IN USED
    Global static String Phonelist(List<Id> lstCntIds,String ObjectName)
    {
        String phoneListFinal;
        return phoneListFinal;
    }
    
    //METHOD NOT IN USED
    Global static String PhonelistSMS(List<Id> lstCntIds,String ObjectName )
    {
        String phoneListFinalSMS;
        return phoneListFinalSMS;
    }
    
    //METHOD NOT IN USED
    Global static String CountryCodeList(List<Id> lstCntIds,String ObjectName)
    {
        String CountryCode = '';
        return CountryCode;
    }
    
    //METHOD THAT RETURNS STRING OF MOBILE AND CONTACT NAME
    Global static String PhonelistSMSNewForBulk(List<Id> lstCntIds,String ObjectName,Map<Id,String> MapOfTemplate )
    {
        String phoneListFinalSMS ;
        return phoneListFinalSMS;
    }
}