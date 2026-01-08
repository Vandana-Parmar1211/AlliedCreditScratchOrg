public With Sharing class chatterErrorMsgQueueable implements Queueable, Database.AllowsCallouts{
    
    public string campaignId;
    public string OrgId;
    public string XAPIkey;
    public Id userId;
    public Boolean isBulkSMS;
    public string WrapperJson;
    public static List<ConnectApi.BatchInput> batchInputListForUser = new List<ConnectApi.BatchInput>();
    
    public class Receipts {
        public Integer delivered;
        public Integer rejected;
    }
    
    public class SMSResponse {
        public String id;
        public String name;
        public String status;
        public Receipts receipts;
    }
    
    public chatterErrorMsgQueueable(string WrapperJson){
        this.WrapperJson = WrapperJson;
    }
    
    public void execute(QueueableContext context){
        
        Id currentUserId = UserInfo.getUserId();
        string customMsg;
        
        // Deserialize the JSON back to a list of wrapper objects
        List<wrapperofFileds> retrievedParams = 
            (List<wrapperofFileds>) JSON.deserialize(WrapperJson, List<wrapperofFileds>.class);
        
        // Process the retrieved data
        for (wrapperofFileds param : retrievedParams) {
            Integer deliveredCount = 0;
            Integer rejectedCount = 0;
            
            
            campaignId = param.campaignId;//res.getbody()
            OrgId = param.OrgId;
            XAPIkey = param.XAPIkey;
            userId =  param.userId;
            isBulkSMS = param.isBulkSMS; 
            
            if(isBulkSMS == true){
                // Create a new HTTP instance
                Http h = new Http(); 
                // Define the endpoint URL
                String endpoint ='https://api.airwaves360.com/2019-01-23/organisations/'+OrgId+'/campaigns/'+campaignId;
                // Create a new HTTP request
                HttpRequest req = new HttpRequest(); 
                req.setEndpoint(endpoint);
                req.setMethod('GET'); 
                req.setHeader('x-api-key', XAPIkey);
                req.setHeader('Content-Type', 'application/json');
                
                HttpResponse res = h.send(req);
                Boolean isSusccess;
                if(res.getStatusCode() == 200 || res.getStatusCode() == 201) {
                    isSusccess = True;
                    
                    // Deserialize JSON
                    SMSResponse response = (SMSResponse) JSON.deserialize(res.getBody(), SMSResponse.class);
                    
                    // Extract delivered and rejected counts
                    deliveredCount = response.receipts != null ? response.receipts.delivered : 0;
                    rejectedCount = response.receipts != null ? response.receipts.rejected : 0;
                    
                    // Log values in debug
                    
                } else {
                    isSusccess = False;
                }
                if(rejectedCount > 0 && rejectedCount != null){
                    customMsg = 'Error from Airwaves portal: '+rejectedCount+' Contact(s) Rejected\n\nPlease check the portal for details '; 
                    postChatterForUser(customMsg,currentUserId,userId,isBulkSMS,campaignId);
                } 
            }
            else if(isBulkSMS == false){// for single sms 
                
                
                // Create a new HTTP instance
                Http h = new Http(); 
                // Define the endpoint URL
                String endpoint =System.Label.SingleSMSendpoint+'/'+campaignId;
                // Create a new HTTP request
                HttpRequest req = new HttpRequest(); 
                req.setEndpoint(endpoint);
                req.setMethod('GET'); 
                req.setHeader('x-api-key', XAPIkey);
                req.setHeader('Content-Type', 'application/json');
                
                HttpResponse res = h.send(req);
                Boolean isSusccess;
                if(res.getStatusCode() == 200 || res.getStatusCode() == 201) {
                    isSusccess = True;
                    
                    // Parse JSON into a Map
                    Map<String, Object> parsedJson = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    
                    if (parsedJson.containsKey('messages')) {
                        List<Object> messages = (List<Object>) parsedJson.get('messages');
                        
                        for (Object msg : messages) {
                            Map<String, Object> messageData = (Map<String, Object>) msg;
                            String recipient = (String) messageData.get('to');
                            
                            Map<String, Object> receipts = (Map<String, Object>) messageData.get('receipts');
                            
                            if (receipts != null) {
                                if (receipts.containsKey('rejected')) {
                                    customMsg = 'Error from Airwaves portal: Contact Rejected\n\nPlease check the Transcripts section in the portal for details '; 
                                    //postChatterForUser(customMsg,currentUserId,userId,isBulkSMS,campaignId);
                                }
                            }
                        }
                        
                    } else {
                        isSusccess = False;
                    }
                }       
            }
        }
    }
    
    public static void postChatterForUser(string customMsg,Id currentUserId,Id userId,Boolean isBulkSMS,string CampaignId){
        
        
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.subjectId = userId;
        
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        
        // Add header message
        ConnectApi.TextSegmentInput introSegment = new ConnectApi.TextSegmentInput();
        
        introSegment.text = customMsg;
        
        messageBodyInput.messageSegments.add(introSegment);
        
        ConnectApi.MentionSegmentInput mentionSegmentInput1 = new ConnectApi.MentionSegmentInput();
        mentionSegmentInput1.id = userId;
        messageBodyInput.messageSegments.add(mentionSegmentInput1);
        
        if(userId != currentUserId){
            ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
            textSegmentInput1.text = ' FYI ';
            
            messageBodyInput.messageSegments.add(textSegmentInput1);
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            mentionSegmentInput.id = currentUserId;
            messageBodyInput.messageSegments.add(mentionSegmentInput);
        }
        
        ConnectApi.TextSegmentInput breakSegment1 = new ConnectApi.TextSegmentInput();
        breakSegment1.text = '\n';
        messageBodyInput.messageSegments.add(breakSegment1);
        
        if(isBulkSMS == true){
            ConnectApi.LinkSegmentInput linkSegment = new ConnectApi.LinkSegmentInput();
            linkSegment.url = 'https://my.airwaves360.com/?#/campaigns/sms/' + campaignId + '/chat';
            //linkSegment.text = 'Click here to open the campaign At Airwaves'; // Display text
            
            messageBodyInput.messageSegments.add(linkSegment);
            
        }
        
        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        batchInputListForUser.add(new ConnectApi.BatchInput(feedItemInput));
    }
}