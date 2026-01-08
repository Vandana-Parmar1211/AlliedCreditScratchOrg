@isTest
public class Airwaves360FutureVoicemailBatch_test {

    
       static testMethod void TestMethod1() {
           S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();
       
                
        //CUSTOM SETTING
        List<CountryCode__c> listCS = new List<CountryCode__c>();
        CountryCode__c objCS = new CountryCode__c();
        objCS.Name = 'AU';
        objCS.Country__c = 'AU';
        objCS.Active__c = TRUE;
        listCS.add(objCS);
        insert listCS;
        
        //TIMEZONE
        S2V_Time_Zones__c objTMZ = new S2V_Time_Zones__c();
        objTMZ.Name = 'Australia/NSW';
        objTMZ.Start_Time__c = Time.newInstance(01, 00, 2, 20);
        objTMZ.Stop_Time__c  = Time.newInstance(23, 59, 2, 20);
        insert objTMZ;
  
        //CONTACT INSERTION
        List<Contact> listCon = new List<Contact>();
        Contact objCon = new Contact();
        objCon.FirstName = 'Dhairya';
        objCon.LastName = 'Shah';
        objCOn.MobilePhone = '121211';
        objCon.MailingCountry = 'AU';
        listCon.add(objCon);
        insert listCon;
        
        //FUTURE VMS
        Future_Voicemails__c objFM = new Future_Voicemails__c();
        objFM.ContactId__c = objCon.id;
        objFM.Sobject_Name__c = 'Contact';
        objFM.Status__c = 'Queue';
        objFM.Timezone__c = objTMZ.Name;
        objFM.Record_Id__c = objCon.id;
        objFM.S2V__Sobject_Name__c = 'Opportunity';
         objFM.Sending_Method__c = 'Voicemail';  
        insert objFM;
        
        String soql = 'SELECT Id, Record_Id__c, Sobject_Name__c,Status__c,Timezone__c ';
        soql += 'FROM Future_Voicemails__c ';
        soql += 'WHERE (Status__c = '+ '\''+ CommonConstant.status + '\' AND Record_Id__c != NULL) ';
       
        Test.StartTest();
        Airwaves360FutureVoicemailBatch uca = new Airwaves360FutureVoicemailBatch(soql);
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        
       
        system.assertEquals(1, listCS.size());
        
    }
    
     static testMethod void TestMethod2() {
        
           S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();
                
        //CUSTOM SETTING
        List<CountryCode__c> listCS = new List<CountryCode__c>();
        CountryCode__c objCS = new CountryCode__c();
        objCS.Name = 'AU';
        objCS.Country__c = 'AU';
        objCS.Active__c = TRUE;
        listCS.add(objCS);
        insert listCS;
        
        //TIMEZONE
        S2V_Time_Zones__c objTMZ = new S2V_Time_Zones__c();
        objTMZ.Name = 'Australia/NSW';
        objTMZ.Start_Time__c = Time.newInstance(01, 00, 2, 20);
        objTMZ.Stop_Time__c  = Time.newInstance(23, 59, 2, 20);
        insert objTMZ;
  
        //CONTACT INSERTION
        List<Contact> listCon = new List<Contact>();
        Contact objCon = new Contact();
        objCon.FirstName = 'Dhairya';
        objCon.LastName = 'Shah';
        objCOn.MobilePhone = '121211';
        objCon.MailingCountry = 'AU';
        listCon.add(objCon);
        insert listCon;
        
        //FUTURE VMS
        Future_Voicemails__c objFM = new Future_Voicemails__c();
        objFM.ContactId__c = objCon.id;
        objFM.Sobject_Name__c = 'Contact';
        objFM.Status__c = 'Queue';
        objFM.Timezone__c = objTMZ.Name;
        objFM.Record_Id__c = objCon.id;
        objFM.S2V__Sobject_Name__c = 'Opportunity';
         objFM.Sending_Method__c = 'SMS';  
        insert objFM;
        
        String soql = 'SELECT Id, Record_Id__c, Sobject_Name__c,Status__c,Timezone__c ';
        soql += 'FROM Future_Voicemails__c ';
        soql += 'WHERE (Status__c = '+ '\''+ CommonConstant.status + '\' AND Record_Id__c != NULL) ';
       
        Test.StartTest();
        Airwaves360FutureVoicemailBatch uca = new Airwaves360FutureVoicemailBatch(soql);
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        
       
        system.assertEquals(1, listCS.size());
        
    }
    
     static testMethod void TestMethod3() {
        
           S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();
                
        //CUSTOM SETTING
        List<CountryCode__c> listCS = new List<CountryCode__c>();
        CountryCode__c objCS = new CountryCode__c();
        objCS.Name = 'AU';
        objCS.Country__c = 'AU';
        objCS.Active__c = TRUE;
        listCS.add(objCS);
        insert listCS;
        
        //TIMEZONE
        S2V_Time_Zones__c objTMZ = new S2V_Time_Zones__c();
        objTMZ.Name = 'Australia/NSW';
        objTMZ.Start_Time__c = Time.newInstance(01, 00, 2, 20);
        objTMZ.Stop_Time__c  = Time.newInstance(23, 59, 2, 20);
        insert objTMZ;
  
        //CONTACT INSERTION
        List<Contact> listCon = new List<Contact>();
        Contact objCon = new Contact();
        objCon.FirstName = 'Dhairya';
        objCon.LastName = 'Shah';
        objCOn.MobilePhone = '121211';
        objCon.MailingCountry = 'AU';
        listCon.add(objCon);
        insert listCon;
        
        //FUTURE VMS
        Future_Voicemails__c objFM = new Future_Voicemails__c();
        objFM.ContactId__c = objCon.id;
        objFM.Sobject_Name__c = 'Contact';
        objFM.Status__c = 'Queue';
        objFM.Timezone__c = objTMZ.Name;
        objFM.Record_Id__c = objCon.id;
        objFM.S2V__Sobject_Name__c = 'Contact';
         objFM.Sending_Method__c = 'Voicemail';  
        insert objFM;
        
        String soql = 'SELECT Id, Record_Id__c, Sobject_Name__c,Status__c,Timezone__c ';
        soql += 'FROM Future_Voicemails__c ';
        soql += 'WHERE (Status__c = '+ '\''+ CommonConstant.status + '\' AND Record_Id__c != NULL) ';
       
        Test.StartTest();
        Airwaves360FutureVoicemailBatch uca = new Airwaves360FutureVoicemailBatch(soql);
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        
       
        system.assertEquals(1, listCS.size());
        
    }
    
     static testMethod void TestMethod4() {
         
            S2V__Airwaves360_settings__c setting = new S2V__Airwaves360_settings__c();
        setting.S2V__OrganizationId__c = 'ChMvHuiclUOgZxcCYo+HQ4zYiL8HcV+fttSNV97fXyo=';
        setting.S2V__XapiKey__c = 'YLpBi3Lesu57qC7RJ/mEq5FIXxpbcat9hesWXkYOGXE=';
        insert setting;
        
        S2V__Encrypted_Key__c encrypt = new S2V__Encrypted_Key__c();
        encrypt.S2V__Key_Details__c = 'MyS3cur3K3y12333';
        encrypt.SetupOwnerId = UserInfo.getOrganizationId();
        insert encrypt; 
        
        S2V__Encrypted_Key__c retrievedSetting = S2V__Encrypted_Key__c.getOrgDefaults();
        
       
                
        //CUSTOM SETTING
        List<CountryCode__c> listCS = new List<CountryCode__c>();
        CountryCode__c objCS = new CountryCode__c();
        objCS.Name = 'AU';
        objCS.Country__c = 'AU';
        objCS.Active__c = TRUE;
        listCS.add(objCS);
        insert listCS;
        
        //TIMEZONE
        S2V_Time_Zones__c objTMZ = new S2V_Time_Zones__c();
        objTMZ.Name = 'Australia/NSW';
        objTMZ.Start_Time__c = Time.newInstance(01, 00, 2, 20);
        objTMZ.Stop_Time__c  = Time.newInstance(23, 59, 2, 20);
        insert objTMZ;
  
        //CONTACT INSERTION
        List<Contact> listCon = new List<Contact>();
        Contact objCon = new Contact();
        objCon.FirstName = 'Dhairya';
        objCon.LastName = 'Shah';
        objCOn.MobilePhone = '121211';
        objCon.MailingCountry = 'AU';
        listCon.add(objCon);
        insert listCon;
        
        //FUTURE VMS
        Future_Voicemails__c objFM = new Future_Voicemails__c();
        objFM.ContactId__c = objCon.id;
        objFM.Sobject_Name__c = 'Contact';
        objFM.Status__c = 'Queue';
        objFM.Timezone__c = objTMZ.Name;
        objFM.Record_Id__c = objCon.id;
        objFM.S2V__Sobject_Name__c = 'Contact';
         objFM.Sending_Method__c = 'SMS';  
        insert objFM;
        
        String soql = 'SELECT Id, Record_Id__c, Sobject_Name__c,Status__c,Timezone__c ';
        soql += 'FROM Future_Voicemails__c ';
        soql += 'WHERE (Status__c = '+ '\''+ CommonConstant.status + '\' AND Record_Id__c != NULL) ';
       
        Test.StartTest();
        Airwaves360FutureVoicemailBatch uca = new Airwaves360FutureVoicemailBatch(soql);
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        
        
        system.assertEquals(1, listCS.size());
        
    }
}