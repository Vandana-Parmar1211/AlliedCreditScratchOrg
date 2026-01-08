global with sharing class BatchOnFutureSMSScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        // Schedule this job to run one minute from now
         S2V.BatchOnFutureSMS batchJob = new S2V.BatchOnFutureSMS();
        Database.executeBatch(batchJob); 
        //BatchRescheduler.scheduleNextRun();
        
        //System.schedule('EveryMinuteBatchJob ' , chronExp, new BatchOnFutureVoicemailsScheduler());
       
    }

}