/* 
	This is the base class which the custom components extend.
	If you add a new custom component and controller the controller will have to extend this class.

	Each variable is called when the component's <apex:attribute> 
	gets assigned to the pageController variable.
	
	It will call one of the methods in this class depending 
	on which component it is.  This will allow the 
	main VF page's controller (leadConvertController) to access the 
	component's controller which it needs to do for the converting process.
	
	Note that if you add new components to this application, a new variable 
	will have to be added to this class following the same structure.
	
*/
	
public with sharing virtual class ComponentControllerBase {

	// This gets set in the leadConvertCoreComponent's attribute
	public PageControllerBase pageController { get;

	    set {
	
	      if (value != null) {
	
	        pageController = value;
	    
	        pageController.setComponentController(this);
	      
	
	      }
	
	    }
	    
	}
  	
  	// This gets set in the leadConvertTaskInfoComponent's attribute
  	public PageControllerBase pageControllerTask { get;

	    set {
	
	      if (value != null) {
	
	        pageControllerTask = value;
	    
	        pageControllerTask.setTaskComponentController(this);
	      
	
	      }
	
	    }

  	}

	// This gets set in the leadConvertTaskDescComponent's attribute
	public PageControllerBase pageControllerDescription{ get;

	    set {
	
	      if (value != null) {
	
	        pageControllerDescription = value;
	    
	        pageControllerDescription.setDescriptionComponentController(this);
	      
	
	      }

	    }	
    }

	// This gets set in the leadConvertTaskRemindComponent's attribute    
    public PageControllerBase pageControllerReminder{ get;

	    set {

			if (value != null) {

	        pageControllerReminder = value;
	    
	        pageControllerReminder.setReminderComponentController(this);
	      
	
	      }
	
		}

	}
 
}