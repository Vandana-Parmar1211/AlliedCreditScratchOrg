/*
 * Created By: Dhairya Shah
 * Desc: Scheduleable class for scheduling future voicemails records.
 * updated on 8th aug 2019
 */

//***********THIS CLASS IS NOT IN USED*****************************//
global with sharing class S2VFutureVoicemailBase implements Schedulable{
    
    public Interface IS2VFutureVoicemailBase{
        void execute(SchedulableContext sc);
    }
    
    global void execute(SchedulableContext sc) {
        
    }
}