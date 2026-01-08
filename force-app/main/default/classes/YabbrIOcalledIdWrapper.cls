/*
CreatedBY VANDANA PARMAR
Date 14TH FEB 2024
WRAPPER CLASS FOR 'Airwaves360IOCallerController' CLASS 
*/
 
public with sharing class YabbrIOcalledIdWrapper {
    public class Config {
        public List<String> approvedSenderIds;
        public Boolean approveSenderIds;
        public List<String> enabledDestinations;
        public List<String> selectedSenderIds;
        public Boolean selectSenderIds;
    }

    public String status;
    public Config config;
}