/*
	This is the controller for the leadConvertTaskInfoComponent
*/

public with sharing class leadConvertTaskInfoComponentController extends ComponentControllerBase {
	
	// The Task object the component will interact with
    public Task taskID {get; set;}
    
    // 
    public String reminderTime {get; set;}
    
    
    public Boolean reminder {get; set;}
    
    // this is an instance of the reminder controller which hold information about the reminder
    public leadConvertTaskRemindComponentController remCon {get; set;}

	// task priorities and statuses 
    private transient List<Schema.PicklistEntry> taskStatuses = Task.Status.getDescribe().getPicklistValues();
    private transient List<Schema.PicklistEntry> taskPriorities = Task.Priority.getDescribe().getPicklistValues();
    
    // Constructor
    public leadConvertTaskInfoComponentController() {
    	
    	//create the Task that will hold information gathered on the component 
        taskId = new Task();
        
        //the reminder is set to true
        taskId.IsReminderSet = true;
        reminder = true;
        
        // set the default values for the status and priority fields
        taskId.Status = TaskDefaulValue(taskStatuses);
        taskId.Priority = TaskDefaulValue(taskPriorities);
        
        //the reminder date will be set to now by default
        taskId.ReminderDateTime = datetime.now();
        
        // create an instance of the reminder component's controller
        remCon = new leadConvertTaskRemindComponentController();
    }
    
    //set the default value based on the picklist sent to the method
    private String TaskDefaulValue(List<Schema.PicklistEntry> pickList)
    {
        String defaultValue = '';
        for(Schema.PicklistEntry entry : pickList)
        {
        	//if this is the default value then set it
            if(entry.isDefaultValue())
            {
                defaultValue = entry.getLabel();
                break;
            }
        }
        return defaultValue;
    }
    
    //this method will get the Task's Statuses
    public List<SelectOption> TaskStatusOption {
        get {
            if(TaskStatusOption == null) {
                TaskStatusOption = new List<SelectOption>();
                
                for (Schema.PicklistEntry status : taskStatuses)
                {
                    TaskStatusOption.add(new SelectOption(status.getLabel(), status.getLabel()));
                } 
            }
            return TaskStatusOption;
        }
        set;
    }
    
    //this method will get the Task's Priorities
    public List<SelectOption> TaskPriorityOption {
        get {
            if(TaskPriorityOption == null) {
                TaskPriorityOption = new List<SelectOption>();
                
                for (Schema.PicklistEntry priority : taskPriorities)
                {
                    TaskPriorityOption.add(new SelectOption(priority.getLabel(), priority.getLabel()));
                } 
            }
            return TaskPriorityOption;
        }
        set;
    }
    
    //This will get called when the due date is changed.
    //This will update the reminder date to that date that was changed
    public PageReference DueDateChanged() {
        remCon.taskId.ActivityDate = taskId.ActivityDate;
        return null;
    }
}