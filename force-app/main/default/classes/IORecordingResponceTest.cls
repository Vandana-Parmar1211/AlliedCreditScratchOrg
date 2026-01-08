/*
* DESC: S2V RECORDING RESPONSE TEST CLASS
* UPDATED ON 6TH AUG 2019
*/
@isTest
global class IORecordingResponceTest implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"message":"success to send request to S2V","status":"success","meta":{"limit":20,"next":null,"offset":0,"previous":null,"total_count":1},"objects":[{"audio_file":"https://login.straight2voicemail.com.au/media/audio/4RR6C8PPEN_TapBasin_01.mp3","id":987,"recording_number": "4","saleslforce_user_id": "0056F000006VAKZQA4","name":"faddee8","resource_uri":"/api/v1/recording/987/"}]}');
        System.assert(res.getStatusCode() != null);
        return res;  
    }
    
}