/*Created By: vandana parmar
*Dated: 11th march 2024
*Desc: Generating Triggers and deploying it the different orgs.

*/

Global with sharing class Airwaves360TriggerDeploymentController {
    public static String API_VERSION = System.Label.Api_Version;
    
    
    //CONSTRUCTOR
    public Airwaves360TriggerDeploymentController()
    {
             
    }
    //CREATING QUERY FROM THE CLASS CALLED S2VVOICEMAILSENDPAGECONTROLLER AND USING THE STORED QUERY IN STRING CALLED QUERYCREATNG FROM THE DECLARED CLASS
    
  
    
    //CREATING SERVICE USING METADATA API
    /*private static S2V.MetadataService.MetadataPort createService(string strsessionId)
{ 
S2V.MetadataService.MetadataPort service = new S2V.MetadataService.MetadataPort();
service.SessionHeader = new S2V.MetadataService.SessionHeader_element();
service.SessionHeader.sessionId =  strsessionId; ///UserInfo.getSessionId();
return service;     
} */
    
}