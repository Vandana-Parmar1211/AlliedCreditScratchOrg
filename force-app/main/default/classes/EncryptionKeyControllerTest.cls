@isTest
public class EncryptionKeyControllerTest {
    
    @testSetup
    static void setup() {
        // Create a test Encrypted Key record if necessary
        S2V__Encrypted_Key__c testKey = new S2V__Encrypted_Key__c(S2V__Key_Details__c = 'TestKey123');
        insert testKey;
    }
    
    @isTest
    static void testConstructorWithExistingRecord() {
        // Test constructor when an Encrypted Key record already exists
        Test.startTest();
        EncryptionKeyController controller = new EncryptionKeyController();
        Test.stopTest();
        
        // Verify that the error message is added and the flag is set
        System.assertEquals('Record already exist please delete to create new.', ApexPages.getMessages()[0].getSummary());
        System.assert(controller.falg);
        System.assertEquals('TestKey123', controller.encryptionKey);
    }
    
    @isTest
    static void testConstructorWithoutExistingRecord() {
        // Delete existing records
        delete [SELECT Id FROM S2V__Encrypted_Key__c];
        boolean falg = true;
        // Test constructor when no Encrypted Key record exists
        Test.startTest();
        EncryptionKeyController controller = new EncryptionKeyController();
        Test.stopTest();
        
        // Verify that no error message is added and the encryption key is blank
        System.assertEquals(0, ApexPages.getMessages().size());
        //System.assert(!controller.falg);
        System.assertEquals('', controller.encryptionKey);
    }
    
    @isTest
    static void testProcessInputWithBlankKey() {
        // Test processInput method with blank encryptionKey
        EncryptionKeyController controller = new EncryptionKeyController();
        controller.encryptionKey = '';
        
        Test.startTest();
        controller.processInput();
        Test.stopTest();
        
        // Verify that the error message is added
        System.assertEquals('Record already exist please delete to create new.', ApexPages.getMessages()[0].getSummary());
    }
    
    @isTest
    static void testProcessInputWithValidKey() {
        // Delete existing records to ensure the test runs correctly
        delete [SELECT Id FROM S2V__Encrypted_Key__c];
        
        // Test processInput method with a valid encryptionKey
        EncryptionKeyController controller = new EncryptionKeyController();
        controller.encryptionKey = 'NewKey123';
        
        Test.startTest();
        controller.processInput();
        Test.stopTest();
        
        // Verify that the new record is created
        S2V__Encrypted_Key__c insertedKey = [SELECT S2V__Key_Details__c FROM S2V__Encrypted_Key__c LIMIT 1];
        System.assertEquals('NewKey123', insertedKey.S2V__Key_Details__c);
    }
    
    @isTest
    static void testClearInput() {
        // Test clearInput method when an Encrypted Key record exists
        EncryptionKeyController controller = new EncryptionKeyController();
        
        Test.startTest();
        controller.clearInput();
        Test.stopTest();
        
        // Verify that the existing record is deleted and encryptionKey is cleared
        Integer keyCount = [SELECT COUNT() FROM S2V__Encrypted_Key__c];
        System.assertEquals(0, keyCount);
        System.assertEquals('', controller.encryptionKey);
    }
}