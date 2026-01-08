//***********THIS CLASS IS NOT IN USED*****************************//
global class IOVDCallerID {
    global class RObject
    {
        global String callerid{get;set;}
        global String id {get;set;}
        global Boolean verified {get;set;}
        global String resource_uri {get;set;}
        
    }
    global List<RObject> objects{get;set;}
    global boolean isSuccess{get;set;}
    global String error {get;set;}
    global String id{get;set;}
    global Boolean callerBoolean {get;set;}
    

}