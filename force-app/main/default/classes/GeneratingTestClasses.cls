/*Created By: Dhairya Shah
*Dated: 6TH AUG 2019
*Desc: This class is used to create all the test classes for the trigger dynamically and returns into S2VTriggerDeploymentClass
*/

Global class GeneratingTestClasses{
    
    public Static String crntobj{get;set;}
    public Static String crntobj1{get;set;}
    public Static String crntobj2 {get;set;}
    public Static String crntObjCampMem {get;set;}
    public Static String forcampmember {get;set;}
    
    // CONSTRUCTOR
    public GeneratingTestClasses()
    {
        
    }
    
    // THIS METHOD CHECKS THE REQUIRED FIELD OF SELECTED OBJECT
    public Static String getRequiredFields(String selectedObject)
    {
        Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
        List<String> s = new List<String>();
        List<String> fldnum = new List<String>();
        List<String> dt = new List<String>();
        String referName = '';
        
      
        
        
        if(selectedObject == 'CampaignMember')
        {
            crntobj ='List<CampaignMember> listObjCampMem = new List<CampaignMember>();\n'+'S2V.RecursiveTriggerHandler.isFirstTime  =true; \n '+selectedObject+' '+selectedObject+'obj = new '+selectedObject+'();\n' + selectedObject+' '+selectedObject+'obj1 = new '+selectedObject+'();\n';
        }
        else
        {
            crntobj = 'S2V.RecursiveTriggerHandler.isFirstTime  =true; \n '+selectedObject+' '+selectedObject+'obj = new '+selectedObject+'();\n';
        }
        
        for(Schema.SObjectField sobjectFields : fieldMap.Values())
        {         
            Schema.DescribeFieldResult F = sobjectFields.getDescribe();
            
            Schema.DisplayType fielddataType = sobjectFields.getDescribe().getType();
            String ldidname  = String.valueof(sobjectFields);
            if(!f.isNillable() && f.isCreateable() && !f.isDefaultedOnCreate()) 
            {
                if(fielddataType == Schema.DisplayType.String || fielddataType == Schema.DisplayType.TextArea || fielddataType == Schema.DisplayType.TextArea)
                {
                    crntobj +='         '+selectedObject+'obj.'+sobjectFields+' = \'test\';\n';                 
                } 
                
                else if(fielddataType == Schema.DisplayType.Integer || fielddataType == Schema.DisplayType.Percent || fielddataType == Schema.DisplayType.Double)
                {
                    crntobj +='         '+selectedObject+'obj.'+sobjectFields +' = 5;\n';
                } 
                
                else if(fielddataType == Schema.DisplayType.Date || fielddataType == Schema.DisplayType.DateTime)
                {
                    crntobj +='         '+selectedObject+'obj.'+sobjectFields +' = System.Today();\n'; 
                } 
                
                else if(fielddataType == Schema.DisplayType.Email)
                {
                    crntobj +='         '+selectedObject+'obj.'+sobjectFields +' = \'test@test.com\';\n';
                } 
                
                else if(fielddataType == Schema.DisplayType.Picklist || fielddataType == Schema.DisplayType.MultiPicklist)
                {
                    List<Schema.PicklistEntry> ple = F.getPicklistValues();
                    crntobj +='         '+selectedObject+'obj.'+sobjectFields +' = \''+ple[0].getLabel()+'\';\n';
                } 
                
                else if(fielddataType == Schema.DisplayType.Phone)
                {
                    crntobj +='         '+selectedObject+'obj.'+sobjectFields +' = 1234567890;\n';
                } 
                
                else if(fielddataType == Schema.DisplayType.Boolean)
                {
                    crntobj +='         '+selectedObject+'obj.'+sobjectFields+' = True;\n';
                }
                
                else if(fielddataType == Schema.DisplayType.Reference)
                {
                    List<Schema.SObjectType> referobj = sobjectFields.getDescribe().getReferenceTo();
                    //CHECKS THE SELECTED OBJECT REQUIRED LOOKUP FIELDS
                    crntobj +='         '+selectedObject+'obj.'+sobjectFields +' = '+GeneratingTestClasses.referField(String.valueof(referobj[0]))+';\n';
                }
            }
        }
        
        
        
        if(selectedObject == 'CampaignMember')
        {
            
            crntobj +='         '+selectedObject+'obj.ContactId = objCon.Id;\n'+ selectedObject+'obj1.ContactId = objCon1.Id;\n';
            
            crntobj +='         '+selectedObject+'obj1.S2V__S2V_Stop_Notifications_SMS__c = false;\n';
             crntobj +='         '+selectedObject+'obj1.Status = \'Sent\';\n';
            crntobj +='         '+selectedObject+'obj1.CampaignID = Campaignobj2.Id;\n';
            crntobj +='listObjCampMem.add'+'('+selectedObject+'obj)'+';\n';
            crntobj +='listObjCampMem.add'+'('+selectedObject+'obj1)'+';\n';
            crntobj +='         insert listObjCampMem;\n';
            crntobj +='S2V.RecursiveTriggerHandler.isFirstTime  =true; \n ';
            crntobj+='List<CampaignMember> listObjCampMem2 = new List<CampaignMember>();\n'+selectedObject+' '+selectedObject+'obj3 = new '+selectedObject+'();\n';
            
            crntobj +='         '+selectedObject+'obj3.Id = '+selectedObject+'obj1.Id;\n';
            crntobj +='         '+selectedObject+'obj3.S2V__S2V_Stop_Notifications_SMS__c = true;\n';
              crntobj +='         '+selectedObject+'obj1.Status = \'Sent\';\n';
            crntobj +='listObjCampMem2.add'+'('+selectedObject+'obj3)'+';\n';
            crntobj +='         update listObjCampMem2;';
            
            
            
        }
        
        
        
        
        
        if(selectedObject == 'Task')
        {
           crntobj +='          '+selectedObject+'obj.Status = \'Open\';\n';
            crntobj +='         '+selectedObject+'obj.Subject = \'Send Voicemail Test\';\n';
             crntobj +='         '+selectedObject+'obj.S2V__S2V_Stop_Notifications__c = false;\n';
             crntobj +='         '+selectedObject+'obj.S2V__Sending_Method__c = \'Voicemail\';\n';
        }
        
        if(selectedObject != 'CampaignMember')
        {
            crntobj +='         insert '+selectedObject+'obj;\n';
        }
        
        if(selectedObject == 'Task')
        {  
            crntobj +='S2V.RecursiveTriggerHandler.isFirstTime  =true; \n ';
            crntobj +='    '+selectedObject+' '+selectedObject+'obj1 = new '+selectedObject+'();\n'; 
            crntobj +='         '+selectedObject+'obj1.Id =  '+selectedObject+'obj.Id;\n';
             crntobj +='          '+selectedObject+'obj1.Status = \'Completed\';\n';
            crntobj +='         '+selectedObject+'obj1.Subject = \'SubjectTest\';\n';
            crntobj +='         '+selectedObject+'obj1.S2V__S2V_Stop_Notifications__c = true;\n';
             crntobj +='         '+selectedObject+'obj1.S2V__Sending_Method__c = \'Voicemail\';\n';
            crntobj +='update '+selectedObject+'obj1;';
        }
        
        
        if(selectedObject == 'Contact')
        {
             crntobj +='S2V.RecursiveTriggerHandler.isFirstTime  =true; \n ';
            crntobj +='    '+selectedObject+' '+selectedObject+'obj1 = new '+selectedObject+'();\n'; 
            crntobj +='         '+selectedObject+'obj1.Id =  '+selectedObject+'obj.Id;\n';
            crntobj +='         '+selectedObject+'obj1.LastName =\'Test_V\';\n';
            crntobj +='         '+selectedObject+'obj1.S2V__S2V_Stop_Notifications_SMS__c = true;\n';
            crntobj +='         '+selectedObject+'obj1.FirstName = \'checking\';\n';
            
            crntobj +='update '+selectedObject+'obj1;';
        }
        
        if(selectedObject == 'Lead')
        {
            crntobj +='S2V.RecursiveTriggerHandler.isFirstTime  =true; \n ';
            crntobj +='    '+selectedObject+' '+selectedObject+'obj1 = new '+selectedObject+'();\n'; 
            crntobj +='         '+selectedObject+'obj1.Id =  '+selectedObject+'obj.Id;\n';
            crntobj +='         '+selectedObject+'obj1.LastName =\'Test_V\';\n';
            crntobj +='         '+selectedObject+'obj1.S2V__S2V_Stop_Notifications_SMS__c = true;\n';
            crntobj +='         '+selectedObject+'obj1.FirstName = \'checking\';\n';
            crntobj +='         '+selectedObject+'obj1.Company = \'checking\';\n';
            crntobj +='update '+selectedObject+'obj1;';
        }
        
        if(selectedObject == 'Opportunity'){
             crntobj +='S2V.RecursiveTriggerHandler.isFirstTime  =true; \n ';
            crntobj +='    '+selectedObject+' '+selectedObject+'obj1 = new '+selectedObject+'();\n'; 
            crntobj +='         '+selectedObject+'obj1.Id =  '+selectedObject+'obj.Id;\n';
            crntobj +='          '+selectedObject+'obj1.Name = \'test\';\n';
            crntobj +='          '+selectedObject+'obj1.StageName = \'Closed Won\';\n';
            crntobj +='update '+selectedObject+'obj1;';

            
        }
        
        
        String tstdata;
        if(selectedObject == 'CampaignMember')
        {
            //String sforcamp = GeneratingTestClasses.campmembers();
            if(crntobj2 != Null && crntobj2 != '')
            {
                tstdata = crntobj2+'\n\n'+crntobj1+'\n\n' + crntobj;
            }
            
            else if(crntobj1 != Null && crntobj1 != '')
            {
                tstdata = crntobj1+'\n\n' + crntobj;
            } 
            else 
            {
                tstdata = '\n\n'+crntobj;
            }
        }
        else 
        {
            if(crntobj2 != Null && crntobj2 != '')
            {
                tstdata = crntobj2+'\n\n'+crntobj1+'\n\n' + crntobj;
            }
            else if(crntobj1 != Null && crntobj1 != '')
            {
                tstdata = crntobj1+'\n\n' + crntobj;
            } 
            else 
            {
                tstdata = crntobj;
            }
        }
        return tstdata;
    }
    
    //CHECKS THE REQUIRED FIELD OF SELECTED OBJECT LOOKUP FIELDS (BECAUSE WE HAVE TO CHECK TILL 3 PARENT OBJECT)
    public Static String referField(String selectedObject)
    {
        Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
        List<String> s = new List<String>();
        List<String> fldnum = new List<String>();
        List<String> dt = new List<String>();
        String referName = '';
        if(crntobj1 != Null)
        {
            crntobj1 +='\n\n         '+selectedObject+' '+selectedObject+'obj2 = new '+selectedObject+'();\n';
        } 
        else 
        {
            crntobj1 ='\n\n         '+selectedObject+' '+selectedObject+'obj2 = new '+selectedObject+'();\n';
        }
        for(Schema.SObjectField sobjectFields : fieldMap.Values())
        {
            Schema.DescribeFieldResult F = sobjectFields.getDescribe();
            Schema.DisplayType fielddataType = sobjectFields.getDescribe().getType();
            String ldidname  = String.valueof(sobjectFields);
            
            if(!f.isNillable() && f.isCreateable() && !f.isDefaultedOnCreate()) 
            {
                List<Schema.SObjectType> referobj = sobjectFields.getDescribe().getReferenceTo();
                
                if(fielddataType == Schema.DisplayType.String || fielddataType == Schema.DisplayType.TextArea || fielddataType == Schema.DisplayType.TextArea)
                {
                    crntobj1 +='         '+selectedObject+'obj2.'+sobjectFields+' = \'test\';\n';
                } 
                else if(fielddataType == Schema.DisplayType.Integer || fielddataType == Schema.DisplayType.Percent || fielddataType == Schema.DisplayType.Double)
                {
                    crntobj1 +='         '+selectedObject+'obj2.'+sobjectFields +' = 5;\n';
                } 
                else if(fielddataType == Schema.DisplayType.Date || fielddataType == Schema.DisplayType.DateTime)
                {
                    crntobj1 +='         '+selectedObject+'obj2.'+sobjectFields +' = System.Today();\n'; 
                } 
                else if(fielddataType == Schema.DisplayType.Email)
                {
                    crntobj1 +='         '+selectedObject+'obj2.'+sobjectFields +' = \'test@test.com\';\n';
                } 
                else if(fielddataType == Schema.DisplayType.Picklist || fielddataType == Schema.DisplayType.MultiPicklist)
                {
                    List<Schema.PicklistEntry> ple = F.getPicklistValues();
                    crntobj1 +='         '+selectedObject+'obj2.'+sobjectFields +' = \''+ple[0].getLabel()+'\';\n';
                } 
                else if(fielddataType == Schema.DisplayType.Phone)
                {
                    crntobj1 +='         '+selectedObject+'obj2.'+sobjectFields +' = 1234567890;\n';
                } 
                else if(fielddataType == Schema.DisplayType.Boolean)
                {
                    crntobj1 +='         '+selectedObject+'obj2.'+sobjectFields+' = True;\n';
                } 
                else if(fielddataType == Schema.DisplayType.Reference)
                {
                    crntobj1 +='         '+selectedObject+'obj2.'+sobjectFields +' = '+GeneratingTestClasses.referField1(String.valueof(referobj[0]))+';\n';
                }
            }
        }
        
        crntobj1 +='         insert '+selectedObject+'obj2;';
        String idrefer = selectedObject+'obj2.Id';
        String appendedData = crntobj1+'\n' + crntobj;
        return idrefer;
    }
    
    //GET THE DATA OF 3RD LOOKUP FIELD 
    public Static String referField1(String selectedObject)
    {
        Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
        List<String> s = new List<String>();
        List<String> fldnum = new List<String>();
        List<String> dt = new List<String>();
        String referName = '';
        
        if(crntobj2 != Null)
        {
            crntobj2 +='\n\n         '+selectedObject+' '+selectedObject+'obj1 = new '+selectedObject+'();\n';
        } 
        else 
        {
            crntobj2 ='\n\n         '+selectedObject+' '+selectedObject+'obj1 = new '+selectedObject+'();\n';
        }
        for(Schema.SObjectField sobjectFields : fieldMap.Values())
        {
            Schema.DescribeFieldResult F = sobjectFields.getDescribe();
            Schema.DisplayType fielddataType = sobjectFields.getDescribe().getType();
            
            String ldidname  = String.valueof(sobjectFields);
            if(!f.isNillable() && f.isCreateable() && !f.isDefaultedOnCreate()) 
            {
                List<Schema.SObjectType> referobj = sobjectFields.getDescribe().getReferenceTo();
                
                if(fielddataType == Schema.DisplayType.String || fielddataType == Schema.DisplayType.TextArea || fielddataType == Schema.DisplayType.TextArea )
                {
                    crntobj2 +='         '+selectedObject+'obj1.'+sobjectFields+' = \'test\';\n';
                } 
                else if(fielddataType == Schema.DisplayType.Integer || fielddataType == Schema.DisplayType.Percent || fielddataType == Schema.DisplayType.Double)
                {
                    crntobj2 +='         '+selectedObject+'obj1.'+sobjectFields +' = 5;\n';
                } 
                else if(fielddataType == Schema.DisplayType.Date || fielddataType == Schema.DisplayType.DateTime)
                {
                    crntobj2 +='         '+selectedObject+'obj1.'+sobjectFields +' = System.Today();\n'; 
                    
                } 
                else if(fielddataType == Schema.DisplayType.Email)
                {
                    crntobj2 +='         '+selectedObject+'obj1.'+sobjectFields +' = \'test@test.com\';\n';
                } 
                else if(fielddataType == Schema.DisplayType.Picklist || fielddataType == Schema.DisplayType.MultiPicklist)
                {
                    List<Schema.PicklistEntry> ple = F.getPicklistValues();
                    crntobj2 +='         '+selectedObject+'obj1.'+sobjectFields +' = \''+ple[0].getLabel()+'\';\n';
                } 
                else if(fielddataType == Schema.DisplayType.Phone)
                {
                    crntobj2 +='         '+selectedObject+'obj1.'+sobjectFields +' = 1234567890;\n';
                } 
                else if(fielddataType == Schema.DisplayType.Boolean)
                {
                    crntobj2 +='         '+selectedObject+'obj1.'+sobjectFields+' = True;\n';
                }
            }
        }
        crntobj2 +='         insert '+selectedObject+'obj1;';
        String idrefer = selectedObject+'obj1.Id';
        String appendedData = crntobj2+'\n'+crntobj1+'\n' + crntobj;
        return idrefer;
    }
    
    // USED IN TEST CLASS FOR CAMPAIGN MEMBERS TO CREATE LEAD
    public Static String campmembers()
    {
        String selectedObject = 'Lead';
        Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap();
        List<String> s = new List<String>();
        List<String> fldnum = new List<String>();
        List<String> dt = new List<String>();
        String referName = '';
        
        if(forcampmember != Null)
        {
            forcampmember +='\n\n         '+selectedObject+' '+selectedObject+'obj = new '+selectedObject+'();\n';
        } 
        else 
        {
            forcampmember ='\n\n         '+selectedObject+' '+selectedObject+'obj = new '+selectedObject+'();\n';
        }
        
        for(Schema.SObjectField sobjectFields : fieldMap.Values())
        {
            Schema.DescribeFieldResult F = sobjectFields.getDescribe();
            Schema.DisplayType fielddataType = sobjectFields.getDescribe().getType();
            String ldidname  = String.valueof(sobjectFields);
            if(!f.isNillable() && f.isCreateable() && !f.isDefaultedOnCreate()) 
            {
                List<Schema.SObjectType> referobj = sobjectFields.getDescribe().getReferenceTo();
                if(fielddataType == Schema.DisplayType.String || fielddataType == Schema.DisplayType.TextArea)
                {
                    forcampmember +='         '+selectedObject+'obj.'+sobjectFields+' = \'test\';\n';
                } 
                else if(fielddataType == Schema.DisplayType.Integer || fielddataType == Schema.DisplayType.Percent || fielddataType == Schema.DisplayType.Double)
                {
                    forcampmember +='         '+selectedObject+'obj.'+sobjectFields +' = 5;\n';
                } 
                else if(fielddataType == Schema.DisplayType.Date || fielddataType == Schema.DisplayType.DateTime)
                {
                    forcampmember +='         '+selectedObject+'obj.'+sobjectFields +' = System.Today();\n'; 
                } 
                else if(fielddataType == Schema.DisplayType.Email)
                {
                    forcampmember +='         '+selectedObject+'obj.'+sobjectFields +' = \'test@test.com\';\n';
                } 
                else if(fielddataType == Schema.DisplayType.Picklist || fielddataType == Schema.DisplayType.MultiPicklist)
                {
                    List<Schema.PicklistEntry> ple = F.getPicklistValues();
                    forcampmember +='         '+selectedObject+'obj.'+sobjectFields +' = \''+ple[0].getLabel()+'\';\n';
                }
                else if(fielddataType == Schema.DisplayType.Phone)
                {
                    forcampmember +='         '+selectedObject+'obj.'+sobjectFields +' = 1234567890;\n';
                } 
                else if(fielddataType == Schema.DisplayType.Boolean)
                {
                    forcampmember +='         '+selectedObject+'obj.'+sobjectFields+' = True;\n';
                }
            }
        }
        forcampmember +='         insert '+selectedObject+'obj;';
        String idrefer = selectedObject+'obj.Id';
        String appendedData = crntobj2+'\n'+crntobj1+'\n' + crntobj;
        return forcampmember;
    }    
}