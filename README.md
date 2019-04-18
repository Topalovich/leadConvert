There are a number of “Black Box” processes in Salesforce that are essentially hardcoded functions that you have little or no control over. The out-of-the-box Lead Conversion process is one of these Black Box processes – when you click the standard ‘Convert’ button from a Lead record, you get redirected to a page called <em>leadconvert.jsp</em>.

While the standard page used for lead conversion is good enough most of the time for most customers, you may eventually find yourself asking, “<em>How do I customize the Convert Lead screen?</em>”

We figured the Salesforce community would get value from a customizable lead conversion page and process, so we built one by recreating the Convert Lead page using Visualforce, Javascript, and Apex.

<h3>What are the use cases for a custom Convert Lead page for converting Salesforce leads?</h3>
<ul>
 	<li>Include additional Opportunity, Account or Contact fields when converting a Lead</li>
 	<li>Hide fields on the Convert Lead page</li>
 	<li>Prevent users from creating new Opportunities when converting a Lead</li>
 	<li>Remove the Task fields from the Convert Lead page</li>
 	<li>Include additional custom buttons on the Convert Lead page</li>
 	<li>Add or remove sections and manage the style and formatting of the Convert Lead page</li>
 	<li>Implement custom or complex field mapping logic</li>
 	<li>Map Lead fields to multiple fields on the converted Opportunity, Account or Contact</li>
 	<li>Select an Account or Opportunity Record Type when converting a Lead</li>
 	<li>Redirect to a different object or screen after converting a Lead</li>
 	<li>Include a custom update on the Chatter feeds for converted records</li>
 	<li>Add Products to Opportunities at the time of lead conversion</li>
 	<li>Include logic to set default options and values when converting Leads</li>
 	<li>Copy Lead field values to custom objects upon conversion</li>
</ul>
<h3>How does the custom Convert Lead page work?</h3>
We studied how the standard Salesforce Lead conversion process worked from end-to-end, and built an exact replica of the Convert Lead page using Visualforce and Apex. The result is an unmanaged package of Apex classes, custom Visualforce components, and a Visualforce page that you can use as a starting point for customizing the lead conversion process to the exact requirements of your business users.

The Convert Lead unmanaged package contains the following components:
<h5>Visualforce Page</h5>
<ul>
 	<li><strong>leadConvertPage</strong> – The Visualforce page that replicates the standard Convert Lead page and uses the Standard Controller for the Lead sObject</li>
</ul>
<h5>Visualforce Components</h5>
<ul>
 	<li><strong>leadConvertCoreComponent</strong> – Visualforce component containing the core UI elements for the Visualforce page</li>
 	<li><strong>leadConvertTaskDescriptionComponent</strong> – Visualforce component containing UI elements related to the Task Description</li>
 	<li><strong>leadConvertTaskInfoComponent</strong> – Visualforce component containing UI elements related to the common Task fields</li>
 	<li><strong>leadConvertPageHeaderTextComponent</strong> – Visualforce component containing text that appears at the top of the Visualforce page</li>
</ul>
<h5>Apex Classes</h5>
<ul>
 	<li><strong>ComponentControllerBase</strong> – Core Visualforce component controller</li>
 	<li><strong>DateTimeUtility</strong> – Utility class containing Date / Time functions</li>
 	<li><strong>leadConvertController</strong> – Visualforce controller extension</li>
 	<li><strong>leadConvertCoreComponentController</strong> – Controller for the leadConvertCoreComponent Visualforce component</li>
 	<li><strong>leadConvertTaskDescComponentController</strong> – Controller for the leadConvertTaskDescriptionComponent Visualforce component</li>
 	<li><strong>leadConvertTaskInfoComponentController</strong> – Controller for the leadConvertTaskInfoComponent Visualforce component</li>
 	<li><strong>PageControllerBase</strong> – Helper class to manage communications between the Visualforce page and components</li>
 	<li><strong>TestLeadConvertPage</strong> – Unit tests for all Apex classes in the Convert Lead package</li>
</ul>
<h3>How do I use the custom Convert Lead page?</h3>
Implementing the custom Visualforce page is straightforward. You can choose to use either a standalone Custom Button (an example is included in the package) or overwrite the standard Convert button on the Lead object.

To use the Custom Button, simply drag it onto the desired Page Layouts from the Page Layout editor and optionally remove the standard Convert button from the page.

To override the standard Convert button, navigate to ‘Buttons, Links, and Actions’ in the Customize options for the Lead object. Click the ‘Edit’ link next to the Convert button, set the ‘Override With’ option to ‘Visualforce Page,’ and select the ‘leadConvertPage’ Visualforce page from the dropdown menu.
