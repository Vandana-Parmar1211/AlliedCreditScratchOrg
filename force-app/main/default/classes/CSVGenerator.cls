public with sharing class CSVGenerator {
    
    //METHOD THAT CREATES CSV FORMAT FOR SMS
    public static String generateCSVFORSMS(List<string> phoneListFinalSMS) {
        
        List<String> headers = new List<String>{'Phone','Message'};
            List<List<String>> data = new List<List<String>>();
        List<String> phoneEntries = new List<String>();
        //system.debug('@@phoneListFinalSMS-->'+phoneListFinalSMS.length());
        if(phoneListFinalSMS != null){
            for(string conDetails : phoneListFinalSMS){
                    List<String> parts = new List<String>();
                    if(conDetails != null){
                        parts = conDetails.trim().split('xz5qabc926'); 
                        List<String> rowData = new List<String>();
                        
                        if (parts.size() >= 2) {
                            rowData.add(parts[0]); 
                            rowData.add(parts[1]); 
                        }
                        data.add(rowData);
                    }
        
            }
        }
        // USE CSVWriter1 TO CONSTRUCT THE CSV CONTENT
        String csvContent = CSVWriter1.writeForVoicemail(headers, data);
        return EncodingUtil.base64Encode(Blob.valueOf(csvContent));
    }
    
    //METHOD THAT CREATES CSV FORMAT FOR VOICEMAIL
    public static String generateCSVForVoicemail(List<string> phoneListFinal) {
        
        List<String> headers = new List<String>{'FirstName','LastName','Phone'};
            List<List<String>> data = new List<List<String>>();
        List<String> phoneEntries = new List<String>();
        if(phoneListFinal != null){
            
                for (String entry : phoneListFinal) {
                    List<String> parts = new List<String>();
                    if(entry != null){
                        parts = entry.trim().split('xz5qabc926'); 
                        List<String> rowData = new List<String>();
                        
                        if (parts.size() >= 3) {
                            rowData.add(parts[0]); 
                            rowData.add(parts[1]); 
                            rowData.add(parts[2]); 
                        }
                        data.add(rowData);
                    }
                } 
        }
        // USE CSVWriter1 TO CONSTRUCT THE CSV CONTENT
        String csvContent = CSVWriter1.writeForVoicemail(headers, data);
        return EncodingUtil.base64Encode(Blob.valueOf(csvContent));
    }
    
    //METHOD TO WRITE CSV CONTENT TO A FILE FOR SMS
    public static String writeCSVToFileSMS(List<string> phoneListFinalSMS,String XAPIkey,String OrgId) {
        string Fileid;
        string Returnval = '';
        
        // Generate CSV content
		String csvContent = generateCSVFORSMS(new List<String>(phoneListFinalSMS));
        if(csvContent != null){
            Returnval = uploadCSVFileonYabbrFirstCall('BulkSMS.csv', csvContent,XAPIkey,OrgId);
        }
        return Returnval;
    }
    
    //METHOD TO WRITE CSV CONTENT TO A FILE FOR VOICEMAIL
    public static String writeCSVToFileForVoiceMail(List<string> phoneListFinal,String XAPIkey,String OrgId) {
        string Fileid;
        string Returnval = '';
        
        // Generate CSV content
        String csvContent = generateCSVForVoicemail(phoneListFinal);
        if(csvContent != null){
            Returnval = uploadCSVFileonYabbrFirstCall('BulkSMS.csv', csvContent,XAPIkey,OrgId);
        }
        return Returnval;
    }
    
    //METHOD THAT POSTS NAME OF CSV
    
    public static string uploadCSVFileonYabbrFirstCall(string fileName,string base64String,String XAPIkey,String OrgId){
        
        string returnval = '';
        string CommonURL = System.Label.CommonURL;
        String endpoint = CommonURL+OrgId+'/files/tgts';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('x-api-key', XAPIkey);
        req.setHeader('Content-Type', 'application/json');
        
        // Define the payload
        String payload = '{'+
            '"name": "'+fileName+'",'+
            '"uploadMethod": "PUT",'+
            '"contentType": "text/csv"'+
            '}';
        req.setBody(payload);
        Http http = new Http();
        
        try {
            //SEND THE REQUEST TO GET THE RESPONSE 
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                // EXTRACT URL FROM RESPONSE 
                String url = (String) responseMap.get('url');
                String fileId = (String) responseMap.get('id');
                boolean Issucces;
                Issucces  = uploadCSVFileonYabbrSecondCall(url,base64String,fileId,XAPIkey);
                if(Issucces == true){
                    returnval = fileId;
                }
            } 
        } catch (Exception e) {
            system.debug('Exception: ' + e.getMessage());
        }
        return returnval;
    }
    
    //METHOD THAT POSTS CSV IN BLOB FORMAT
    public static Boolean uploadCSVFileonYabbrSecondCall(string url,string base64String,string fileId,String XAPIkey){
        
        String endpoint =url;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('PUT');
        req.setHeader('Content-Type', 'text/csv');
        Blob requestBodyBlob = EncodingUtil.base64Decode(base64String);
        req.setBodyAsBlob(requestBodyBlob);
        Http http = new Http();
        Boolean Succcess;
        try {
            // Send the request and get the response
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                Succcess = true;
            } else {
                Succcess = false;
            }
        } catch (Exception e) {
            system.debug('Exception: ' + e.getMessage());
            Succcess = false;
        }
        return Succcess;
    }
        
}