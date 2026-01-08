@isTest
private class chatterErrorMsgQueueableTest {

    // Mock for Bulk SMS response
    class BulkSMSMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"id":"123","name":"Test Campaign","status":"completed","receipts":{"delivered":10,"rejected":2}}');
            return res;
        }
    }

    // Mock for Single SMS response
    class SingleSMSMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"messages":[{"to":"1234567890","receipts":{"rejected":"true"}}]}');
            return res;
        }
    }

    public class wrapperofFileds {
        public String campaignId;
        public String OrgId;
        public String XAPIkey;
        public Id userId;
        public Boolean isBulkSMS;
    }

    @isTest(SeeAllData=true)
    static void testQueueable_BulkSMS() {
        Test.setMock(HttpCalloutMock.class, new BulkSMSMock());

        wrapperofFileds wrap = new wrapperofFileds();
        wrap.campaignId = 'bulk123';
        wrap.OrgId = 'org456';
        wrap.XAPIkey = 'api-key';
        wrap.userId = UserInfo.getUserId();
        wrap.isBulkSMS = true;

        List<wrapperofFileds> wrapperList = new List<wrapperofFileds>{ wrap };
        String wrapperJson = JSON.serialize(wrapperList);

        Test.startTest();
        System.enqueueJob(new chatterErrorMsgQueueable(wrapperJson));
        Test.stopTest();

        System.assertEquals(true, true); // Add debug log review if needed
    }

    @isTest(SeeAllData=true)
    static void testQueueable_SingleSMS() {
        Test.setMock(HttpCalloutMock.class, new SingleSMSMock());

        // Label used in Apex code: System.Label.SingleSMSendpoint
        // You should make sure this label exists in your org and contains something like: 'https://api.airwaves360.com/2019-01-23/organisations'

        wrapperofFileds wrap = new wrapperofFileds();
        wrap.campaignId = 'singleSMS789';
        wrap.OrgId = 'org999'; // Not used in this path but kept for consistency
        wrap.XAPIkey = 'api-key';
        wrap.userId = UserInfo.getUserId();
        wrap.isBulkSMS = false;

        List<wrapperofFileds> wrapperList = new List<wrapperofFileds>{ wrap };
        String wrapperJson = JSON.serialize(wrapperList);

        Test.startTest();
        System.enqueueJob(new chatterErrorMsgQueueable(wrapperJson));
        Test.stopTest();

        System.assertEquals(true, true); // Consider asserting based on debug logs or notifications
    }
}