//***********THIS CLASS IS NOT IN USED*****************************//
@isTest
global class S2VSendSMSLeadQueueableHttpMock implements HttpCalloutMock {
 
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        return res;
    }
}