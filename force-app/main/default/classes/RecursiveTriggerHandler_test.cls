//updated on 6th aug 2019
@IsTest
private class RecursiveTriggerHandler_test
{
    @IsTest
    private static void testTrigger()
    {
        test.starttest();
        RecursiveTriggerHandler.isFirstTime  = true;
        RecursiveTriggerHandler.stopTrigger();
        RecursiveTriggerHandler.canIRun();
        test.stoptest();
        system.assertEquals(false, RecursiveTriggerHandler.isFirstTime);
    }
}