//updated on 6th aug 2019
@isTest
global class IOUploadRescponceTest implements HttpCalloutMock  {

    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"meta":{"limit":20,"next":null,"offset":0,"previous":null,"total_count":3},"objects":[{"audio_file":"https://login.straight2voicemail.com.au/media/audio/4RR6C8PPEN_TapBasin_01.mp3","id":987,"name":"faddee8","resource_uri":"/api/v1/recording/987/"},{"audio_file":"https://login.straight2voicemail.com.au/media/audio/UK68217N8V_TapBasin_01.wav","id":989,"name":"testing","resource_uri":"/api/v1/recording/989/"},{"audio_file":"https://login.straight2voicemail.com.au/media/audio/ASIV3EY9F1_TapBasin_01.mp3","id":986,"name":"faddee5","resource_uri":"/api/v1/recording/986/"}]}');
        System.assert(res.getStatusCode() != null);
        return res; 
    }

}