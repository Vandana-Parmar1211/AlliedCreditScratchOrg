//***********THIS CLASS IS NOT IN USED*****************************//
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock
{ 
    global  HTTPResponse respond(HTTPRequest req)
    {

        Httpresponse response=new Httpresponse();
        return response;
    }    
}