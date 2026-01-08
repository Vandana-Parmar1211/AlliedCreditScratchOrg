/*
 *UPDATED ON 6TH AUG 2019 dhairya shah
 */  
@isTest
global class IOCallHistoryResponceTest implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        return res; 
    }
}