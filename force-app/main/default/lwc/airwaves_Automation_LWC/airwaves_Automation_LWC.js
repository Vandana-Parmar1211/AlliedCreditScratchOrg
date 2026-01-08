import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import loadFields from '@salesforce/apex/Airwave360AutomationLWC.loadFieldOptions'
import getToWhomObject from '@salesforce/apex/Airwave360AutomationLWC.getAlllookupfieldsAndSMSTemplates'
import getRecordings from '@salesforce/apex/Airwave360AutomationLWC.getRecordingNumber'
import getPicklistData from '@salesforce/apex/Airwave360AutomationLWC.getPicklistOptions'
import saveData from '@salesforce/apex/Airwave360AutomationLWC.saveAllData'

export default class Airwaves_Automation_LWC extends LightningElement {

    // isVoicemail=false;
    isObjectsDisabled = true;
    isTocontactDisabled = false;
    isScheduledDisabled = true;
    isReferencefieldDisabled = true;
    isFixeduserDisabled = true;
    iswhomIdDisabled = true;
    isSMSTemplateHidden = true;
    isRecordingNumberHidden = false;
    isRecordingNumberDisabled = true;
    isSelectRecordingHidden = true;
    voiceorsmstext = 'SMS/Voice Mail';
    isSelectRecordingDisabled = true;
    // isFixedUserHidden=false;
    isLoading = false;
    isUserReferenceHidden = false;
    objectName = '';
    toContactObjectName = '';
    toWhomFieldName = '';
    smsTemplateValue = '';
    smsTemplateLabel = '';
    referenceFieldValue = '';
    recordingNumber = '';
    fixedUserValue = '';
    recordingValue = '';
    scheduleValue = '';
    fieldTypeObj = [];
    radioValue = '';
    finalData = [];
    changeStepNumber = '6';
    scheduleValueIsFutureCall = true;
    scheduleFrequencyValue = '';
    scheduleFrequencyDateTimeValue = '';
    scheduleFrequencyDateTime = [];
    scheduleFrequency = [];


    @track objectFields = [];
    @track referencefieldOptions = [];
    @track smsTemplateOptions = [];
    @track fixedUserOptions = [];
    @track whomIdOptions = [];
    @track operatorOptions = [];

    @track rows = [
        { id: 0, disabled: true, fieldValue: '', operatorValue: '', operatorOptions: [], inputValue: '', type: 'text', inputPicklist: [], isPicklist: false, checked: false },
        { id: 1, disabled: true, fieldValue: '', operatorValue: '', operatorOptions: [], inputValue: '', type: 'text', inputPicklist: [], isPicklist: false, checked: false },
        { id: 2, disabled: true, fieldValue: '', operatorValue: '', operatorOptions: [], inputValue: '', type: 'text', inputPicklist: [], isPicklist: false, checked: false },
        { id: 3, disabled: true, fieldValue: '', operatorValue: '', operatorOptions: [], inputValue: '', type: 'text', inputPicklist: [], isPicklist: false, checked: false },
        { id: 4, disabled: true, fieldValue: '', operatorValue: '', operatorOptions: [], inputValue: '', type: 'text', inputPicklist: [], isPicklist: false, checked: false },
        { id: 5, disabled: true, fieldValue: '', operatorValue: '', operatorOptions: [], inputValue: '', type: 'text', inputPicklist: [], isPicklist: false, checked: false }
    ];

    @track radioOptions = [{ label: 'Voicemail', value: 'Voicemail' }, { label: 'SMS', value: 'SMS' }];
    @track objectOptions = [
        { label: 'CampaignMember', value: 'CampaignMember' },
        { label: 'Contact', value: 'Contact' },
        { label: 'Lead', value: 'Lead' },
        { label: 'Opportunity', value: 'Opportunity' },
        { label: 'Task', value: 'Task' }];
    @track scheduleOptions = [];
    @track toContactOptions = [{ label: 'Contact', value: 'Contact' }, { label: 'Lead', value: 'Lead' }];

    handleRadioChange(event) {
        this.isLoading = true;
        console.log(event.target.value);
        this.radioValue = event.target;
        if (event.target.value == 'Voicemail') {
            // this.isVoicemail=true;  
            this.isObjectsDisabled = false;
            this.isSMSTemplateHidden = true;
            this.voiceorsmstext = 'Voice Mail';
            this.isRecordingNumberHidden = false;
            this.isTocontactDisabled = true;
            this.iswhomIdDisabled = false;
            this.isSelectRecordingHidden = false;
            this.isSelectRecordingDisabled = true;

            this.objectName = '';
            this.toContactObjectName = '';
            this.toWhomFieldName = '';
            this.smsTemplateValue = '';
            this.referenceFieldValue = '';
            this.recordingNumber = '';
            this.fixedUserValue = '';
            this.recordingValue = '';
            this.scheduleValue = '';
            this.changeStepNumber = 6;

            this.objectFields = [];
            this.referencefieldOptions = [];
            this.smsTemplateOptions = [];
            this.fixedUserOptions = [];
            this.whomIdOptions = [];

            // document.getElementById('Objects').disabled=true;
        }
        else {
            //  this.isVoicemail=false;
            this.voiceorsmstext = 'SMS';
            this.isObjectsDisabled = false;
            this.isSMSTemplateHidden = false;
            this.isTocontactDisabled = true;
            this.iswhomIdDisabled = false;
            this.isRecordingNumberHidden = true;
            this.isSelectRecordingHidden = true;

            this.objectName = '';
            this.toContactObjectName = '';
            this.toWhomFieldName = '';
            this.smsTemplateValue = '';
            this.referenceFieldValue = '';
            this.recordingNumber = '';
            this.fixedUserValue = '';
            this.recordingValue = '';
            this.scheduleValue = '';
            this.changeStepNumber = 5;

            this.objectFields = [];
            this.referencefieldOptions = [];
            this.smsTemplateOptions = [];
            this.fixedUserOptions = [];
            this.whomIdOptions = [];
        }
        setTimeout(() => {
            this.isLoading = false;
        }, 500);
        // console.log(this.isVoicemail);  
    }

    enableDisableWhileSMS() {
        this.isTocontactDisabled = false;
        this.iswhomIdDisabled = false;
        this.isSMSTemplateDisabled = false;
        this.isReferencefieldDisabled = false;
        this.isFixeduserDisabled = false;
        this.isScheduledDisabled = false;
        this.isSelectRecordingDisabled = false;
    }

    blankAllComboboxes() {
        this.toContactObjectName = '';
        this.toWhomFieldName = '';
        this.smsTemplateValue = '';
        this.referenceFieldValue = '';
        this.recordingNumber = '';
        this.fixedUserValue = '';
        this.smsTemplateOptions = [];
        this.whomIdOptions = [];
        this.scheduleOptions = [];
        this.scheduleValue = '';
        this.scheduleValueIsFutureCall = true;
        this.scheduleFrequency = [];
        this.scheduleFrequencyValue = '';
        this.scheduleFrequencyDateTimeValue = '';
        this.disableRowIndexes();
    }

    handleObjectChange(event) {
        this.isLoading = true;
        this.objectName = event.detail.value;
        console.log(this.objectName);
        this.blankAllComboboxes();
        switch (this.objectName) {

            case 'CampaignMember':
                if (this.voiceorsmstext == 'SMS') {
                    this.enableDisableWhileSMS();
                }
                if (this.voiceorsmstext == 'Voice Mail') {
                    this.isRecordingNumberDisabled = true;
                    this.enableDisableWhileSMS();
                }
                break;
            case 'Contact':
                if (this.voiceorsmstext == 'SMS') {
                    this.isTocontactDisabled = true;
                    this.iswhomIdDisabled = true;
                    this.isSMSTemplateDisabled = false;
                    this.isReferencefieldDisabled = false;
                    this.isFixeduserDisabled = false;
                    this.isScheduledDisabled = false;
                }
                if (this.voiceorsmstext == 'Voice Mail') {
                    this.isRecordingNumberDisabled = true;
                    this.isTocontactDisabled = true;
                    this.iswhomIdDisabled = true;
                    this.isSMSTemplateDisabled = false;
                    this.isReferencefieldDisabled = false;
                    this.isFixeduserDisabled = false;
                    this.isScheduledDisabled = false;
                    this.isSelectRecordingDisabled = false;
                }

                break;
            case 'Lead':
                if (this.voiceorsmstext == 'SMS') {
                    this.isTocontactDisabled = true;
                    this.iswhomIdDisabled = true;
                    this.isSMSTemplateDisabled = false;
                    this.isReferencefieldDisabled = false;
                    this.isFixeduserDisabled = false;
                    this.isScheduledDisabled = false;
                }
                if (this.voiceorsmstext == 'Voice Mail') {
                    this.isRecordingNumberDisabled = true;
                    this.isTocontactDisabled = true;
                    this.iswhomIdDisabled = true;
                    this.isSMSTemplateDisabled = false;
                    this.isReferencefieldDisabled = false;
                    this.isFixeduserDisabled = false;
                    this.isScheduledDisabled = false;
                    this.isSelectRecordingDisabled = false;
                }
                break;
            case 'Opportunity':
                if (this.voiceorsmstext == 'SMS') {
                    this.enableDisableWhileSMS();

                }
                if (this.voiceorsmstext == 'Voice Mail') {
                    this.isRecordingNumberDisabled = true;
                    this.enableDisableWhileSMS();

                }
                break;
            case 'Task':
                if (this.voiceorsmstext == 'SMS') {
                    this.enableDisableWhileSMS();
                }
                if (this.voiceorsmstext == 'Voice Mail') {
                    this.isRecordingNumberDisabled = true;
                    this.enableDisableWhileSMS();
                    this.isSelectRecordingDisabled = false;
                }
                break;
        }
        console.log('Prior Imperative method');
        this.getFieldOptions(this.objectName);
        setTimeout(() => {
            this.isLoading = false;
        }, 500);
    }



    getFieldOptions(paramObjectName) {
        console.log(paramObjectName);

        loadFields({ objectName: paramObjectName })
            .then(result => {
                console.log(result);
                for (let key in result) {
                    if (key == 'UserReferenceFields') {
                        let listOfFields = result[key];
                        this.referencefieldOptions = Object.keys(listOfFields).map(key => {
                            return {
                                label: listOfFields[key],
                                value: key
                            };
                        });
                    }

                    if (key == 'optionSchedule') {
                        let listOfFields = result[key];
                        this.scheduleOptions = Object.keys(listOfFields).map(key => {
                            return {
                                label: listOfFields[key],
                                value: key
                            };
                        });
                    }

                    if (key == 'SMSTemplate') {
                        let listOfFields = result[key];
                        this.smsTemplateOptions = Object.keys(listOfFields).map(key => {
                            return {
                                label: listOfFields[key],
                                value: key
                            };
                        });
                    }

                    if (key == 'ObjectFields') {
                        let listOfFields = result[key];
                        this.objectFields = Object.keys(listOfFields).map(key => {
                            return {
                                label: listOfFields[key],
                                value: key
                            };
                        });
                    }

                    /*if (key == 'FixedUsers') {
                        let listOfFields = result[key];
                        this.fixedUserOptions = Object.keys(listOfFields).map(key => {
                            return {
                                label: listOfFields[key],
                                value: key
                            };
                        });
                    }
                    console.log(this.fixedUserOptions);*/

                    if (key == 'fieldTypeMap') {
                        let listOfFields = result[key];
                        console.log('fieldTypeMap if key is same');
                        this.fieldTypeObj = Object.keys(listOfFields).map(key => {
                            console.log(listOfFields[key] + ' ' + key);
                            return {
                                label: listOfFields[key],
                                value: key
                            };
                        });
                    }
                    console.log(this.fieldTypeObj);

                }


            })
            .catch((error) => {
                this.showToast('Error', error.body.message, 'error');
            });

        this.rows[0].disabled = false;
    }

    handletoContactChange(event) {
        console.log('Entered into Contact Change');
        this.isLoading = true;
        this.toContactObjectName = event.detail.value;
        console.log(this.objectName);
        console.log(this.toContactObjectName);
        getToWhomObject({ selectedObject: this.objectName, fieldsneed: this.toContactObjectName })
            .then(result => {
                for (let key in result) {
                    if (key == 'Alllookupfields') {
                        let listOfFields = result[key];
                        this.whomIdOptions = Object.keys(listOfFields).map(key => {
                            return {
                                label: listOfFields[key],
                                value: key
                            };
                        });
                    }

                    if (key == 'SMSTemplate') {
                        let listOfFields = result[key];
                        this.smsTemplateOptions = [];
                        this.smsTemplateOptions = Object.keys(listOfFields).map(key => {
                            return {
                                label: listOfFields[key],
                                value: key
                            };
                        });

                        console.log(this.whomIdOptions);
                    }
                }
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            })
        setTimeout(() => {
            this.isLoading = false;
        }, 500);
    }

    retrieveValues() {
        console.log('Testing');
        const el = this.template.querySelector('[data-index="1"][name="fieldName"]');
        console.log(el.disabled);
    }

    handleFieldChange(event) {
        console.log('Entered into handleFieldChange');

        const index = parseInt(event.target.dataset.index, 10);
        this.rows[index].fieldValue = event.detail.value;
        // Enable next row if it exists
        if (index + 1 < this.rows.length) {
            this.rows[index + 1].disabled = false;
        }
        // Force reactivity
        this.rows = [...this.rows];


        //this.field1Value=event.detail.value;
        //Code start for operator combobox
        let temvar = event.detail.value;
        this.rows[index].operatorOptions = [];
        //console.log(this.fieldTypeObj[temvar].value);
        for (let key in this.fieldTypeObj) {
            console.log(this.fieldTypeObj[key].value + '  ' + this.fieldTypeObj[key].label);
            if (temvar == this.fieldTypeObj[key].value) {
                console.log('inside if condition');
                if (this.fieldTypeObj[key].label == 'number' || this.fieldTypeObj[key].label == 'date') {
                    console.log('inside if condition of fieldTypeObj');
                    this.rows[index].operatorOptions = [{ label: 'Equals', value: 'Equals' },
                    { label: 'Not equals to', value: 'Not equals to' },
                    { label: 'Less than', value: 'Less than' },
                    { label: 'Greater than', value: 'Greater than' },
                    { label: 'Less or equal', value: 'Less or equal' },
                    { label: 'Greater or equal', value: 'Greater or equal' },
                    { label: 'Equals', value: 'Equals' }];
                } else {
                    this.rows[index].operatorOptions = [{ label: 'Equals', value: 'Equals' },
                    { label: 'Not equals to', value: 'Not equals to' }];
                }

                if (this.fieldTypeObj[key].label == 'picklist') {
                    this.rows[index].isPicklist = true;
                    console.log('change in code');
                    this.inputTypeChange(this.rows[index].fieldValue, index);
                }

                if (this.fieldTypeObj[key].label == 'checkbox') {
                    this.rows[index].isPicklist = false;
                    this.rows[index].type = 'checkbox';
                    this.rows[index].inputValue = false;
                }

                if (this.fieldTypeObj[key].label == 'date') {
                    this.rows[index].isPicklist = false;
                    this.rows[index].type = 'date';
                }

                if (this.fieldTypeObj[key].label == 'text') {
                    this.rows[index].isPicklist = false;
                    this.rows[index].type = 'text';
                }
            }
        }
        //Code Ends for operator combobox
    }

    inputTypeChange(fieldValue, index) {
        getPicklistData({ objectName: this.objectName, fieldName: fieldValue })
            .then(result => {
                console.log(result);
                this.rows[index].inputPicklist = Object.keys(result).map(key => {
                    return {
                        label: result[key],
                        value: key
                    };
                });
                console.log(this.rows[index].inputPicklist);
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }


    handletowhomIdChange(event) {
        this.isLoading = true;
        this.toWhomFieldName = event.detail.value;
        setTimeout(() => {
            this.isLoading = false;
        }, 500);
    }

    handleSMSTemplateChange(event) {
        this.isLoading = true;
        this.smsTemplateValue = event.detail.value;

        //this.smsTemplateLabel=event.detail.label;
        setTimeout(() => {
            this.isLoading = false;
        }, 500);
    }



    handleReferencefieldChange(event) {
        this.isLoading = true;
        this.referenceFieldValue = event.detail.value;
        if (this.voiceorsmstext == 'SMS') {
            // this.isFixedUserHidden=true;

        }

        if (this.voiceorsmstext == 'Voice Mail') {
            // this.isFixedUserHidden=true;
            this.isSelectRecordingHidden = true;
            this.isRecordingNumberDisabled = false;

            getRecordings()
                .then(data => {
                    console.log(data);
                    this.recordingNumberOptions = Object.keys(data).map(key => {
                        return {
                            label: data[key],
                            value: key
                        };
                    });

                })
                .catch(error => {
                    this.showToast('Error', error.body.message, 'error');
                })
        }

        setTimeout(() => {
            this.isLoading = false;
        }, 500);
    }

    handlefixedUserChange(event) {
        this.isLoading = true;
        this.fixedUserValue = event.detail.value;
        setTimeout(() => {
            this.isLoading = false;
        }, 500);
    }

    handleFrequencyDateTimeScheduleChange(event) {
        this.scheduleFrequencyDateTimeValue = event.target.value;
    }

    handlescheduleFrequencyChange(event) {
        this.scheduleFrequencyValue = event.target.value;
    }

    handleOptionScheduleChange(event) {
        this.isLoading = true;
        if (event.detail.value == 'Future Call') {
            this.scheduleValueIsFutureCall = false;

            if (this.voiceorsmstext == 'SMS') {
                this.scheduleFrequency = [{ label: 'Hours', value: 'Hours' },
                { label: 'Minutes', value: 'Minutes' }];
            }
            if (this.voiceorsmstext == 'Voice Mail') {
                this.scheduleFrequency = [{ label: 'Hours', value: 'Hours' },
                { label: 'Minutes', value: 'Minutes' },
                { label: 'Days', value: 'Days' }];
            }
        }
        if (event.detail.value == 'Now') {
            this.scheduleValueIsFutureCall = true;
            this.scheduleFrequencyValue = '';
            this.scheduleFrequencyDateTimeValue = '';
            this.scheduleFrequency = [];
        }
        this.scheduleValue = event.detail.value;
        setTimeout(() => {
            this.isLoading = false;
        }, 500);
    }

    handleOperatorChange(event) {
        const index = parseInt(event.target.dataset.index, 10);
        this.rows[index].operatorValue = event.detail.value;
        this.rows = [...this.rows];
    }

    handleRecordingNumberChange(event) {
        this.isLoading = true;
        this.recordingNumber = event.detail.value;
        setTimeout(() => {
            this.isLoading = false;
        }, 500);
    }

    handleValueChange(event) {
        const index = parseInt(event.target.dataset.index, 10);
        if (event.target.type == 'checkbox') {
            console.log(event.target.checked);
            this.rows[index].inputValue = event.target.checked;
            console.log(this.rows[index].checked);
        }
        else {
            this.rows[index].inputValue = event.detail.value;
        }
        this.rows = [...this.rows];
    }

    handleRemoveFilter(event) {
        const index = parseInt(event.target.dataset.index, 10);
        this.rows[index].inputValue = '';
        this.rows[index].fieldValue = '';
        this.rows[index].operatorValue = '';
        this.rows[index].operatorOptions = [];
        this.rows[index].checked = false;
        this.rows[index].type = 'text';
        this.rows[index].inputPicklist = [];
        this.rows[index].isPicklist = false;
    }

    handleCancelButton() {
        this.radioValue.checked = false;
        this.isObjectsDisabled = true;
        this.isTocontactDisabled = false;
        this.isScheduledDisabled = true;
        this.isReferencefieldDisabled = true;
        this.isFixeduserDisabled = true;
        this.iswhomIdDisabled = true;
        this.isSMSTemplateHidden = true;
        this.isRecordingNumberHidden = false;
        this.isRecordingNumberDisabled = true;
        this.isSelectRecordingHidden = true;
        this.voiceorsmstext = 'SMS/Voice Mail';
        this.isSelectRecordingDisabled = true;
        this.isLoading = false;
        this.objectName = '';
        this.toContactObjectName = '';
        this.toWhomFieldName = '';
        this.smsTemplateValue = '';
        this.referenceFieldValue = '';
        this.recordingNumber = '';
        this.fixedUserValue = '';
        this.objectFields = [];
        this.referencefieldOptions = [];
        this.smsTemplateOptions = [];
        this.fixedUserOptions = [];
        this.whomIdOptions = [];
        this.scheduleValue = '';
        this.scheduleValueIsFutureCall = true;
        this.scheduleFrequency = [];
        this.scheduleFrequencyValue = '';
        this.scheduleFrequencyDateTimeValue = '';
        this.disableRowIndexes();
        this.changeStepNumber = 6;
    }

    handleSaveData() {
        this.finalData = [];
        Object.keys(this.rows).map(key => {
            if (this.rows[key].fieldValue != '' && this.rows[key].fieldValue != null) {
                this.finalData.push({
                    selectField: this.rows[key].fieldValue,
                    selectedOperator: this.rows[key].operatorValue,
                    inputValue: this.rows[key].inputValue,
                    fieldType: this.rows[key].type,
                });
            }
        });
        this.selectedComboboxesOptions = {};
        console.log(this.referenceFieldValue);
        console.log('SMS Template' + this.smsTemplateValue);
        console.log('Label' + this.smsTemplateLabel);
        console.log((this.objectName + ' ' + this.toContactObjectName + ' ' + this.toWhomFieldName + ' ' + this.referenceFieldValue + ' ' + this.scheduleValue));
        console.log((this.objectName + ' ' + this.objectName + ' ' + this.objectName + ' ' + this.referenceFieldValue + ' ' + this.scheduleValue));
        console.log('Recording number:'+this.recordingNumber+' '+ this.smsTemplateValue);
        if ((this.objectName != '' && this.toContactObjectName != '' && this.toWhomFieldName != '' && this.referenceFieldValue != '' && this.scheduleValue != '') || (this.objectName != '' && (this.objectName == 'Lead' || this.objectName == 'Contact') && this.referenceFieldValue != '' && this.scheduleValue != '')) {
            if (this.voiceorsmstext == 'Voice Mail' && (this.recordingNumber != '')) {
                console.log('Entered into conditioin');
                this.selectedComboboxesOptions = {
                    method: 'Voice Mail',
                    objectName: this.objectName,
                    toContactObjectName: this.toContactObjectName,
                    toWhomField: this.toWhomFieldName,
                    userReference: this.referenceFieldValue,
                    recordingNumber: this.recordingNumber,
                    selectedSchedule: this.scheduleValue,
                    scheduleFrequencyValue: this.scheduleFrequencyValue,
                    scheduleFrequencyDateTimeValue: this.scheduleFrequencyDateTimeValue
                };
            }
            if (this.voiceorsmstext == 'SMS' && (this.smsTemplateValue != '')) {
                this.selectedComboboxesOptions = {
                    method: 'SMS',
                    objectName: this.objectName,
                    toContactObjectName: this.toContactObjectName,
                    toWhomField: this.toWhomFieldName,
                    smsTemplateId: this.smsTemplateValue,
                    userReference: this.referenceFieldValue,
                    selectedSchedule: this.scheduleValue,
                    scheduleFrequencyValue: this.scheduleFrequencyValue,
                    scheduleFrequencyDateTimeValue: this.scheduleFrequencyDateTimeValue
                };
            }
        }
        else {
            this.showToast('Error', 'Select correct values', 'error');

        }
        console.log('Going to save data');
        if (this.selectedComboboxesOptions && Object.keys(this.selectedComboboxesOptions).length > 0) {
            saveData({ listOfObjectForQuery: this.finalData, comboboxSelectedValues: this.selectedComboboxesOptions })
                .then(result => {
                    if (result === 'Success') {
                        this.showToast('Success', 'ActiveSchedule Record Created successfully!', 'success');
                    } else {
                        this.showToast('Error', result, 'error');
                    }
                })
                .catch(error => {
                    this.showToast('Error', error.body.message, 'error');
                })
            this.handleCancelButton();
        }
        else {
            this.showToast('Error', 'Select the required values', 'error');
        }

    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    disableRowIndexes() {
        Object.keys(this.rows).map(key => {
            this.rows[key].disabled = true;
            this.rows[key].inputValue = '';
            this.rows[key].fieldValue = '';
            this.rows[key].operatorValue = '';
            this.rows[key].operatorOptions = [];
            this.rows[key].checked = false;
            this.rows[key].type = 'text';
            this.rows[key].inputPicklist = [];
            this.rows[key].isPicklist = false;
        });
    }


}