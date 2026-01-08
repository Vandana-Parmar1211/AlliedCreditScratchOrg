/*
 * updated on 6th aug 2019
 */ 

global class IOMyAccountResponceTest  implements HttpCalloutMock 
{          
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();       
        return res; 
    }

}