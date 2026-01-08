//***********THIS CLASS IS NOT IN USED*****************************//
global class IORecording {
    global class RObject
    {
        global String audio_file {get;set;}
        global String id {get;set;}
        global String name {get;set;}
        global String resource_uri {get;set;}
        global String saleslforce_user_id {get;set;}
        global String recording_number{get;set;}
        global String description{get;set;}
    }
    global List<RObject> objects{get;set;}
    global boolean isSuccess{get;set;}
    global Meta meta{get;set;}
    global class Meta
    {
        global String next{get;set;}
        global String previous{get;set;}
        global String total_count{get;set;}
    }
    
}