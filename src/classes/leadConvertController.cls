/*
	This is the controller for the Visual Force page leadConvertPage.
*/

public with sharing class leadConvertController extends PageControllerBase {
    
    // This is the lead that is to be converted
    public  Lead leadToConvert {get; set;}
    
    // Constructor for this controller
    public leadConvertController(ApexPages.StandardController stdController) {
        
        //get the ID to query for the Lead fields
        Id leadId = stdController.getId();
        
        leadToConvert = [SELECT Id, Status, OwnerId, Name, Company FROM Lead WHERE Id = :leadId];
    }

	/*
	These are instances of the components' controllers which this class will access.
	
	If you add new custom components, add an instance of the class here
	*/
    public leadConvertCoreComponentController myComponentController { get; set; }
    public leadConvertTaskInfoComponentController myTaskComponentController { get; set; }
    public leadConvertTaskDescComponentController myDescriptionComponentController { get; set; }
  	
  	/*
  		These are the set methods which override the methods in PageControllerBase. 
  		These methods will be called by the ComponentControllerBase class.
  		
  		If you add new custom components, a new overridden set method must be added here.
  	*/
    public override void setComponentController(ComponentControllerBase compController) {
        
        myComponentController = (leadConvertCoreComponentController)compController;
    
    }
   
    public override void setTaskComponentController(ComponentControllerBase compController) {
    
        myTaskComponentController = (leadConvertTaskInfoComponentController)compController;
    
    }
  
    public override void setDescriptionComponentController(ComponentControllerBase compController) {
    
        myDescriptionComponentController = (leadConvertTaskDescComponentController)compController;
    
    } 

	/*
  		These are the get methods which override the methods in PageControllerBase.
  		
  		If you add new custom components, a new overridden get method must be added here.
  	*/
    public override ComponentControllerBase getMyComponentController() {

        return myComponentController;

    }

    public override ComponentControllerBase getmyTaskComponentController() {

        return myTaskComponentController;

    }   
  
    public override ComponentControllerBase getmyDescriptionComponentController() {

        return myDescriptionComponentController;

    }
    
    
    // This method is called when the user clicks the Convert button on the VF Page
    public PageReference convertLead() {
		
		// This is the lead convert object that will convert the lead 
        Database.LeadConvert leadConvert = new database.LeadConvert();
        
        // if a due date is set but the subject is not, then show an error 
        if (myTaskComponentController != null && myTaskComponentController.taskID.ActivityDate != null && string.isBlank(myTaskComponentController.taskID.Subject)){
            
            PrintError('You must enter a Subject if a Due Date is set..');
            return null;
            
        } 
        
        // if Lead Status is not entered show an error  
        if (myComponentController != null && myComponentController.leadConvert.Status == 'NONE'){
            
            PrintError('Please select a Lead Status.');
            return null;
            
        } 
        
        //set lead ID
        leadConvert.setLeadId(leadToConvert.Id);    
        
        //if the main lead convert component is not set then return
        if (myComponentController == NULL) return null;
        
        //if the Account is not set, then show an error
        if (myComponentController.selectedAccount == 'NONE')
        {
            PrintError('Please select an Account.');
            return null;
            
        }
        
        // otherwise set the account id
        else if (myComponentController != NULL && myComponentController.selectedAccount != 'NEW') {
            leadConvert.setAccountId(myComponentController.selectedAccount);
        }
        
        //set the lead convert status
        leadConvert.setConvertedStatus(myComponentController.leadConvert.Status);
        
        //set the variable to create or not create an opportunity
        leadConvert.setDoNotCreateOpportunity(myComponentController.doNotCreateOppty);
        
        //set the Opportunity name
        leadConvert.setOpportunityName(((myComponentController.doNotCreateOppty) 
            ? null : myComponentController.opportunityID.Name));
        
        //set the owner id
        leadConvert.setOwnerId(myComponentController.contactId.ownerID);
        
        //set whether to have a notification email
        leadConvert.setSendNotificationEmail(myComponentController.sendOwnerEmail);
        
        system.debug('leadConvert --> ' + leadConvert);
        
        //convert the lead
        Database.LeadConvertResult leadConvertResult = Database.convertLead(leadConvert);
        
        // if the lead converting was a success then create a task
        if (leadConvertResult.success)
        {
        	// make sure that the task information component is being used and check to see if the user has filled out the Subject field 
            if(myTaskComponentController != NULL 
                && myDescriptionComponentController != NULL 
                && myTaskComponentController.taskID.subject != null)
            {
            	//create a new task
                Task taskToCreate = new Task();
                
                //set whether there is a reminder
                taskToCreate.IsReminderSet = myTaskComponentController.remCon.taskID.IsReminderSet;
                
                //if the reminder is set, and the reminder's date is set
                if (taskToCreate.IsReminderSet 
                    && myTaskComponentController.remCon.taskID.ActivityDate != null) {
					
					//set the reminder time based on the reminder class's ActivityDate
					//The date and time in the reminder class is converted into a datetime by the convertToDatetime() method
                    taskToCreate.ReminderDateTime = 
                        convertToDatetime(
                            myTaskComponentController.remCon.taskID.ActivityDate,
                            myTaskComponentController.remCon.reminderTime
                        );
                    system.debug('taskToCreate.ReminderDateTime --> ' + taskToCreate.ReminderDateTime);
                    
                }   
				
				//set the whatId to the Opportunity Id            
                taskToCreate.WhatId = leadConvertResult.getOpportunityId();
                
                //set the whoId to the contact Id
                taskToCreate.WhoId = leadConvertResult.getContactId();
                
                //set the subject
                taskToCreate.Subject = myTaskComponentController.taskID.Subject;
                
                //set the status
                taskToCreate.Status = myTaskComponentController.taskID.Status;
                
                //set the activity date 
                taskToCreate.ActivityDate = myTaskComponentController.taskID.ActivityDate;
                
                //set the Priority 
                taskToCreate.Priority = myTaskComponentController.taskID.Priority;
                
                //set the custom field Primary Resource (this is a custom field on the Task showing an example of adding custom fields to the page)
                taskToCreate.Primary_Resource__c = myTaskComponentController.taskID.Primary_Resource__c;
                
                //set the Description field which comes from the leadConvertTaskDescComponent
                taskToCreate.Description =  myDescriptionComponentController.taskID.Description;

				//if the sendNotificationEmail variable in the leadConvertTaskDescComponent class is set then send an email
                if (myDescriptionComponentController.sendNotificationEmail)
                {
                	//create a new DMLOptions class instance
                    Database.DMLOptions dmlo = new Database.DMLOptions();
                    
                    //set the trigger user email flag to true
                    dmlo.EmailHeader.triggerUserEmail = true;
                    
                    //insert the task
                    database.insert(taskToCreate, dmlo);
                }
                else
                {
                	//if the sendNotificationEmail field was not checked by the user then simply insert the task
                    insert taskToCreate;
                }
            }
            
            // redirect the user to the newly created Account
            PageReference pageRef = new PageReference('/' + leadConvertResult.getAccountId());
            
            pageRef.setRedirect(true);
            
            return pageRef; 
        }
        else
        {

            //if converting was unsucessful, print the errors to the pageMessages and return null
            System.Debug(leadConvertResult.errors);

            PrintErrors(leadConvertResult.errors);
            
            return null;
        }
        
        return null;

    }
  	
  	//this method will take database errors and print them to teh PageMessages 
    public void PrintErrors(Database.Error[] errors)
    {
        for(Database.Error error : errors)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error.message);
            ApexPages.addMessage(msg);
        }
    }
    
    //This method will put an error into the PageMessages on the page
    public void PrintError(string error) {
        ApexPages.Message msg = new 
            ApexPages.Message(ApexPages.Severity.ERROR, error);
        ApexPages.addMessage(msg);
    } 
    
    // given a date and time, where time is a string this method will return a DateTime
    private DateTime convertToDatetime(Date d, string t) {
        String timeFormat = DateTimeUtility.LocaleToTimeFormatMap().get(UserInfo.getLocale());
        
        //if the local of the user uses AM/PM 
        if (timeFormat != null && timeFormat.endsWith('a')) {
        	
        	//split the time into 2 strings 1 time and 1 am r pm
            string [] reminderTime = t.split(' ');
            
            //split the time into hour and minute
            string hour = reminderTime[0].split(':')[0];
            string min = reminderTime[0].split(':')[1];
            
            //get the am or pm
            string AM_PM = reminderTime[1];
            
            //turn the hour into an integer
            integer hr = Integer.valueOf(hour);
            
            //if the am/pm part of the string is PM then add 12 hours
            if (AM_PM.equalsIgnoreCase('PM')) hr += 12;
            
            //return a new DateTime based on the above information
            return (
                DateTime.newInstance(
                    d, 
                    Time.newInstance(
                        hr, 
                        Integer.valueOf(min), 
                        0,
                        0
                    )
                )
            ); 
        }
        //If the user's local does not use AM/PM and uses 24 hour time
        else {
            
            //split the time by a : to get hour and minute
            string hour = t.split(':')[0];
            string min = t.split(':')[1];
            
            //turn the hour into an integer
            integer hr = Integer.valueOf(hour);
            
            //return a new DateTime based on the above information
            return (
                DateTime.newInstance(
                    d, 
                    Time.newInstance(
                        hr, 
                        Integer.valueOf(min), 
                        0,
                        0
                    )
                )
            ); 
        }
    }
}