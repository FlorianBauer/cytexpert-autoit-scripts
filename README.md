# AutoIt CytExpert Scripts

Scripts to control the CytExpert software for the CytoFLEX FACS via Windows GUI automation.


## Installation

1. Download and install the latest AutoIt Version from the [Download Page](https://www.autoitscript.com/site/autoit/downloads/).
2. Download and unpack the following UDF package [UIA_V0_70.zip](https://www.autoitscript.com/forum/applications/core/interface/file/attachment.php?id=61194).
Additional information therefore can be found in the corresponding [IUIAutomation MS Framework Thread](https://www.autoitscript.com/forum/topic/153520-iuiautomation-ms-framework-automate-chrome-ff-ie/)
3. Place the files `CUIAutomation2.au3` and `UIAWrappers.au3` from the package in the same directory as the CytExpert-Script files.
4. Ensure that the paths in `CytExpertDefs.au3` match the installation directory of CytExpert installed on the system.
5. If the `CytExpertStartUp.au3` script should be able to start up the CytExpert Software by itself, log-in credentials must be
also provided in the head section of the `CytExpertDefs.au3`. 


## File Overview

* `CytExpertDefs.au3` - Include file containing function definitions, installation paths and log-in credentials.
* `CytExpertStartUp.au3` - Script for starting and initializing the CytoFLEX Software "CytExpert".
* `CytExpertLoad.au3` - Script for loading an experiment file and open the device hatch.
* `CytExpertRun.au3` - Script for closing the device hatch and running the actual experiment.
* `CytExpertOpenHatch.au3` - Script for opening the device hatch.
* `CytExpertCloseHatch.au3` - Script for closing the device hatch.


## Usage

Run the scripts.

**`CytExpertStartUp.au3`:**  
Starts the CytExpert program and does a back-flush.
Returns: 0 on success, otherwise an error value.

**`CytExpertLoad.au3`:**  
Loads the given template file and opens the device hatch.
Parameter1: Path of the template file (`*.xitm`) (File has to exist).
Parameter2: (Optional) Path and name of the output file of the experiment (`*.xit`) (File shall not yet exist).
Returns: 0 on success, otherwise an error value.

**`CytExpertRun.au3`:**  
Closes the device hatch and tuns the loaded experiment. Ensure that `CytExpertStartUp.au3` and `CytExpertLoad.au3` 
was successfully executed before executing this script.
Returns: 0 on success, otherwise an error value.

**`CytExpertOpenHatch.au3`:**  
Opens the device hatch.
Returns: 0 on success, otherwise an error value.

**`CytExpertCloseHatch.au3`:**  
Closes the device hatch.
Returns: 0 on success, otherwise an error value.

