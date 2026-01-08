@isTest
public class S2VActiveSchedules_Test
{ 

    static testmethod void S2VActiveSchedules()
    {  
        
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc; 
        
        S2V__Airwaves360_Active_Schedule__c sendvoicemail=new S2V__Airwaves360_Active_Schedule__c();
        sendvoicemail.S2V__Object_Name__c='Contact';
        sendvoicemail.S2V__Reference_Field_Lable__c='abc';
        sendvoicemail.S2V__Recording_Name__c='aakriti';
        sendvoicemail.S2V__Option_Schedule__c='Now';
        sendvoicemail.S2V__Schedule_Frequency__c='Daily';
        sendvoicemail.S2V__Reference_Field__c='kjj';
        sendvoicemail.S2V__Start_Date__c=system.today();
        insert sendvoicemail;
        
        list<id> lstid=new list<id>();
        lstid.add(acc.Id);
        
        date startdate=system.today();
        string selectedvoice='abc';
        string phoneListFinal='xyz';
        String callerId='pqr';
        Integer optionSchedule=1;
        String ScheduleFreq='daily';
        String selectedTime1='abc';
        String useridreference='abcdg';
        Boolean isRecordingname=true;
         Test.startTest();
        
         System.assertEquals(sendvoicemail.S2V__Object_Name__c,'Contact');
         System.assertEquals(lstid.size(),1);
         
         Test.setMock(HttpCalloutMock.class, new IORecordingResponceTest()); 
         
         S2VActiveSchedules s2act = new S2VActiveSchedules();
         s2act.recId = sendvoicemail.Id;
         s2act.deleteRecord();
         
         Test.stopTest();
    }
    
     @isTest
    static void testDeleteRecordWithoutId() {
           
        S2V__Airwaves360_Active_Schedule__c sendvoicemail=new S2V__Airwaves360_Active_Schedule__c();
        sendvoicemail.S2V__Object_Name__c='Contact';
        sendvoicemail.S2V__Reference_Field_Lable__c='abc';
        sendvoicemail.S2V__Recording_Name__c='aakriti';
        sendvoicemail.S2V__Option_Schedule__c='Now';
        sendvoicemail.S2V__Schedule_Frequency__c='Daily';
        sendvoicemail.S2V__Reference_Field__c='kjj';
        sendvoicemail.S2V__Start_Date__c=system.today();
        insert sendvoicemail;
       
        Test.startTest();
        
        // Instantiate the S2VActiveSchedules class
        S2VActiveSchedules activeSchedules = new S2VActiveSchedules();
         activeSchedules.recId = sendvoicemail.Id;
        // Call the deleteRecord method without setting recId
        PageReference pr = activeSchedules.deleteRecord();
        
        // Verify the page redirection
        System.assertEquals('/apex/S2V__Airwaves360_Automation', pr.getUrl());
        
        Test.stopTest();
    }
    
}