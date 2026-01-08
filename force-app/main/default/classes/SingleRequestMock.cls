/*
* updated on 9th aug 2019
*/

//***********THIS CLASS IS NOT IN USED*****************************//
@isTest
global class SingleRequestMock implements HttpCalloutMock 
{
    global HttpResponse respond(HTTPRequest req)
    {
            HttpResponse resp = new HttpResponse();        
            return resp;
    }
    
}