/* 
This is a base class which can be extended by any page controller that will communicate 
with the controllers for compnents. 

If you add a new Visual Force page and controller for this Lead Convert app and want it 
to communicate with the components you can extend this class.
*/
  
public with sharing virtual class PageControllerBase {

	/*
	 these variables will hold references to the 4 component 
	 controllers involved with the Lead Convert application
	 
	 If you add new components and controllers they will 
	 need to be added here in order for the Visual Force 
	 page to communicate with them.
	*/
	//this is the controller for leadConvertCoreComponentController
	private ComponentControllerBase myComponentController;
	
	//this is the controller for leadConvertTaskInfoComponentController
	private ComponentControllerBase myTaskComponentController;
	
	//this is the controller for leadConvertRemindComponentController
	private ComponentControllerBase myReminderComponentController;
	
	//this is the controller for leadConvertTaskDescComponentController
	private ComponentControllerBase myDescriptionComponentController;

	// this method will return the leadConvertCoreComponentController. It is overridden in the LeadConverController class
	public virtual ComponentControllerBase getMyComponentController() {

    	return myComponentController;
 
	}

	// this method will return the leadConvertTaskInfoComponentController. It is overridden in the LeadConverController class
	public virtual ComponentControllerBase getmyTaskComponentController() {

    	return myTaskComponentController;
 
	}
  
	// this method will return the leadConvertRemindComponentController. It is overridden in the LeadConverController class
	public virtual ComponentControllerBase getmyReminderComponentController() {

    	return myReminderComponentController;
 
	}
	
	// this method will return the leadConvertTaskDescComponentController. It is overridden in the LeadConverController class
	public virtual ComponentControllerBase getmyDescriptionComponentController() {

    	return myDescriptionComponentController;
 
	}

    // this method will return the leadConvertTaskInfoComponentController. It is overridden in the LeadConverController class
	public virtual void setTaskComponentController(ComponentControllerBase compController) {

    	myTaskComponentController = compController;

	}

	// this method will set the leadConvertCoreComponentController. It is overridden in the LeadConverController class
	public virtual void setComponentController(ComponentControllerBase compController) {

    	myComponentController = compController;

	}
	
	// this method will set the leadConvertRemindComponentController. It is overridden in the LeadConverController class
	public virtual void setReminderComponentController(ComponentControllerBase compController) {

    	myReminderComponentController = compController;

	}
	
	// this method will set the leadConvertTaskDescComponentController. It is overridden in the LeadConverController class
	public virtual void setDescriptionComponentController(ComponentControllerBase compController) {

    	myDescriptionComponentController = compController;

	}

	// return the instance of this class
	public PageControllerBase getThis() {

    	return this;

	}
}