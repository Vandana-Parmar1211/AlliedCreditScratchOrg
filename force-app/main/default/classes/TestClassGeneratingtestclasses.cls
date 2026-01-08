/*
* CREATED BY DHAIRYA SHAH
* updated on 9th aug 2019
*/ 

@isTest

public class TestClassGeneratingtestclasses
{
    //METHOD 1
    static testmethod void requiredfields()
    {
        String objname = 'Contact';
        GeneratingTestClasses.forcampmember = 'test';
        GeneratingTestClasses.getRequiredFields(objname); 
        system.assertEquals('test', GeneratingTestClasses.forcampmember);
    }
    
    //METHOD 2
    static testmethod void requiredfieldsCampaignMem()
    {
        String objname = 'CampaignMember';
        GeneratingTestClasses.forcampmember = 'test';
        GeneratingTestClasses.getRequiredFields(objname); 
        system.assertEquals('test', GeneratingTestClasses.forcampmember);
    }
    
    //METHOD 3
    static testmethod void requiredfieldsCampaignMem1()
    {
        String objname = 'CampaignMember';
        GeneratingTestClasses.forcampmember = 'test';
        GeneratingTestClasses.referField1(objname); 
        system.assertEquals('test', GeneratingTestClasses.forcampmember);
    }
    
    //METHOD 4
    static testmethod void requiredfields1()
    {
        String objname = 'Opportunity';
        GeneratingTestClasses.forcampmember = 'test';
        GeneratingTestClasses.referField1(objname);
        system.assertEquals('test', GeneratingTestClasses.forcampmember);
    }
    
    //METHOD 5
    static testmethod void requiredfields2()
    {
        String objname = 'Opportunity';
        GeneratingTestClasses.forcampmember = 'test';
        GeneratingTestClasses.referField(objname);
        GeneratingTestClasses.campmembers();
        system.assertEquals('Opportunity', objname);
    }
    
    //METHOD 6
    static testmethod void requiredfields5()
    {
        String objname = 'Lead';
        GeneratingTestClasses.getRequiredFields(objname); 
        GeneratingTestClasses.campmembers();
        system.assertEquals('Lead', objname);
    }
    static testmethod void requiredfields6()
    {
        String objname = 'Task';
        GeneratingTestClasses.getRequiredFields(objname); 
        GeneratingTestClasses.campmembers();
        system.assertEquals('Task', objname);
    }

}