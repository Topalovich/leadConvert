/*
	This class is used in the leadConvertTaskInfoComponentController
*/

public with sharing class leadConvertTaskRemindComponentController extends ComponentControllerBase {
    
    // the Task object used to hold the reminder information
    public Task taskID {
        get ;
        set;
    }
    
    // the selected reminder time
    public String reminderTime {get; set;}
    
    //This will populate the Reminder Times in increments of 30 minutes 
    //Based on the user's locale it will use AM/PM or 24 hour time
    public List<SelectOption> ReminderTimeOption {
        get {
            if(ReminderTimeOption == null) {
            	
                ReminderTimeOption = new List<SelectOption>();
                
                //get the time format based on the user's locale
                String timeFormat = DateTimeUtility.LocaleToTimeFormatMap().get(UserInfo.getLocale());
                
                String timeValue;
                
                //if the user uses AM/PM 
                if (timeFormat != null && timeFormat.endsWith('a')) {
                    ReminderAddMeridiem(ReminderTimeOption, 'AM');
                    ReminderAddMeridiem(ReminderTimeOption, 'PM');
                    reminderTime = '8:00 AM';
                } 
                //if the user uses 24 hour time
                else {
                    ReminderAddHour(ReminderTimeOption, '00', '');
                    for (Integer i = 1; i <= 23; i++)
                    {
                        ReminderAddHour(ReminderTimeOption, i.format(), '');
                    }
                    reminderTime = '8:00';
                }
            }
            return ReminderTimeOption;
        }
        set;
    }
    
    // Add AM/PMs to the times
    private void ReminderAddMeridiem(List<SelectOption> reminderTimeOption, String meridiem)
    {
        ReminderAddHour(reminderTimeOption, '12', ' ' + meridiem);
        for (Integer i = 1; i <= 11; i++)
        {
            ReminderAddHour(reminderTimeOption, i.format(), ' ' + meridiem);
        }
    }
	
	//add the hours to the list
    private void ReminderAddHour(List<SelectOption> reminderTimeOption, String hour, String meridiem)
    {
        reminderTimeOption.add(ReminderOption(hour + ':00' + meridiem));
        reminderTimeOption.add(ReminderOption(hour + ':30' + meridiem));
    }
	
	//create the select options
    private SelectOption ReminderOption(String value)
    {
        return new SelectOption(value, value);
    }
    
    //Constructor
    public leadConvertTaskRemindComponentController() {
        
        // create the task
        taskId = new Task();
        
        //se the reminder to true by default
        taskId.IsReminderSet = true;
        
        //set the reminder date to today
        taskId.ActivityDate = system.today();
    }
    
    //this will return the reminder date as a string in the desired format of 'M/d/yyyy'
    public string disabledActivityDate {
        get {
            return (taskId.ActivityDate != null) ? 
                (DateTime.newInstance(taskId.ActivityDate, Time.newInstance(0,0,0,0)).format('M/d/yyyy')).trim()
                : '';
        }
        set;
    }
}