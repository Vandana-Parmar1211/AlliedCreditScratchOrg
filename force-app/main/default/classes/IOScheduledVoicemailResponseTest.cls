//UPDATED ON 6TH AUG 2019
@isTest
global class IOScheduledVoicemailResponseTest implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"meta":{"limit":20,"next":"/api/v1/campaign/?limit=20&offset=20"}}');
        System.assert(res.getStatusCode() != null);
        return res; 
    }
}