/*
CreatedBY VANDANA PARMAR
Date 10TH JUNE 2024
class for decryption the key and OrgId in Airwaves360 Credential Information VF page  
*/
public with sharing class KeyDecryptionClass {
    
    //METHOD THAT DECRYPTS THE GIVEN VALUE 
    public static String decryptValue(String strForDecrypt) {
        String ENCRYPTION_KEY;
        List<S2V__Encrypted_Key__c>  ExistingKeySetting = new List<S2V__Encrypted_Key__c>();
        
        if (Schema.SObjectType.S2V__Encrypted_Key__c.isAccessible()
            && Schema.sObjectType.S2V__Encrypted_Key__c.fields.Id.isAccessible()
            && Schema.sObjectType.S2V__Encrypted_Key__c.fields.S2V__Key_Details__c.isAccessible()) {
                
                ExistingKeySetting = [Select Id, S2V__Key_Details__c from S2V__Encrypted_Key__c limit 1];
            }
        
        if(ExistingKeySetting.size() > 0){
            ENCRYPTION_KEY = ExistingKeySetting[0].S2V__Key_Details__c;
        }
        
        if (String.isBlank(strForDecrypt)) return null;
        Blob data = EncodingUtil.base64Decode(strForDecrypt);
        Blob decryptedData = Crypto.decryptWithManagedIV('AES128', Blob.valueOf(ENCRYPTION_KEY), data);
        
        return decryptedData.toString();
    }
}