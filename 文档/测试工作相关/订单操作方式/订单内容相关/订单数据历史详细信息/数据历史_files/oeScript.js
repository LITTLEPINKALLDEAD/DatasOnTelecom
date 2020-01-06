var MSG_FIELD_LENGTH = "Length: ";
var MSG_MAX_FIELD_LENGTH = "Maximum length is ";

// set onload event handler 
//
this.onload = setFocusedElement;

// get the list of order editor buttons so that they can be dynamically enabled/disabled as appropriate
//
var oeButtons;
try {
$(function() {
    oeButtons =  $("#completeTaskButton").add("#completionStatusList").add(":button[id^='wsStatus']").add("#printPreviewButton").add("#fullPreviewButton").add("#orderHistoryButton").add("#changeStateAndStatusButton").add("#saveDataButton").add("#addRemarkButton").add("#viewRemarksButton").add("#exceptionButton"); 
  });
} catch(e) {
}

// disable all order editor buttons
//
function disableOEButtons() {
    oeButtons.attr("disabled", "disabled");
}

// enable all order editor buttons
//
function enableOEButtons() {
    oeButtons.removeAttr("disabled");
}

// Enforce save to override order values

function autoCompleteSave() {
   try {
        if(window.external && "AutoCompleteSaveForm" in window.external) {        
            window.external.AutoCompleteSaveForm(oeForm);
        }
    } catch (err) {
        // we must not be running on IE. Ignore error
    }
}

function save(contextRoot) {
    document.updateOrderError.NodeAction.value= "";
    document.updateOrderError.action = contextRoot + "/control/saveOrder.do";
    document.updateOrderError.submit();    
}

// Reload order values
function reload(contextRoot) {
    document.updateOrderError.NodeAction.value= "";
    document.updateOrderError.action = contextRoot + "/control/orderEditor.do";
    document.updateOrderError.submit();
  }

function performDataHistory(nodeid, nodetype, nodeindex, parentNodeIndex) {
     document.oeForm.Ref.value= document.oeForm.newRefNb.value;
     if (document.oeForm.newPriority) //if there is priority control
       document.oeForm.Priority.value= document.oeForm.newPriority.value;
     document.oeForm.NodeID.value= nodeid;
     document.oeForm.NodeType.value= nodetype;
     document.oeForm.NodeIndex.value= nodeindex;
     document.oeForm.ParentNodeIndex.value = parentNodeIndex;
     document.oeForm.action = CONTEXT_ROOT + "/control/dataHistory";
     document.oeForm.submit();
  }

function checkForAddition(controlName, nodeid, nodetype, parentWebID, currentCount, maxAllowedCount, isFormSubmit, isComplexType) {
	var countToBeAdded = document.getElementById(controlName).value;

    if (countToBeAdded == '') {
        countToBeAdded = 1;
    }
	var isValid = /^\s*\d+\s*$/.test(countToBeAdded);
	if (isValid && parseInt(countToBeAdded,10) > 0) {
		if((parseInt(countToBeAdded,10) + parseInt(currentCount,10)) <= parseInt(maxAllowedCount,10)) {
			   addMultipleNodes(controlName, nodeid, nodetype, parentWebID, isFormSubmit, isComplexType);
		}
		else {
		    var canAllow = parseInt(maxAllowedCount,10) - parseInt(currentCount,10);
			var response = window.confirm(MSG_CAN_ADD.replace("#",canAllow));
			if(response) {
			    document.getElementById(controlName).value = canAllow;
				addMultipleNodes(controlName, nodeid, nodetype, parentWebID, isFormSubmit, isComplexType);
			}
			else {
				return;
			}
		 }
    }
	else {
	    alert (MSG_GREATER_THAN_ZERO);
	}
}

function addMultipleNodes(controlName, nodeid, nodetype, parentWebID, isFormSubmit, isComplexType) {
    if (isComplexType == 'true') {
      var id = nodeid + parentWebID;
      var lookup = document.getElementById(id);
      var mnemonicPath = lookup.options[lookup.selectedIndex].value;
      if (mnemonicPath == '') {
        alert (MSG_SELECT_COMPLEX_TYPE);
        return;
      }
      document.oeForm.MnemonicPath.value = mnemonicPath;
    } else {
        document.oeForm.MnemonicPath.value = "";
    }
    document.oeForm.isCDTNode.value = isComplexType;
    saveIntermediateValues();
    document.oeForm.NodeID.value= nodeid;
    document.oeForm.NodeType.value= nodetype;
    document.oeForm.ParentWebID.value= parentWebID;
    document.oeForm.NodeAction.value= "ADD";
	document.oeForm.countControl.value=controlName;
    document.oeForm.action = CONTEXT_ROOT + "/control/orderEditor.do";
	document.oeForm.formSubmitOrNot.value=isFormSubmit;
    if(isFormSubmit == 'true') {
    	document.body.style.cursor = "wait";
    	//Need to disable the buttons to prevent user from clicking anything else
    	disableOEButtons();
       	document.oeForm.submit();
    }else {
    	ajaxAnywhere.submitAJAX();
    }
    // reset to defaults as HTTP reload would
    document.oeForm.NodeID.value = "";
    document.oeForm.NodeType.value = "";
    document.oeForm.ParentWebID.value = "";
    document.oeForm.NodeAction.value = ""; 
}
function addNode(nodeid, nodetype, parentWebID, isFormSubmit) {
    saveIntermediateValues();
    document.oeForm.NodeID.value= nodeid;
    document.oeForm.NodeType.value= nodetype;
    document.oeForm.ParentWebID.value= parentWebID;
    document.oeForm.NodeAction.value= "ADD";
    document.oeForm.action = CONTEXT_ROOT + "/control/orderEditor.do";
	document.oeForm.formSubmitOrNot.value=isFormSubmit;
    if(isFormSubmit == 'true') {
    	document.body.style.cursor = "wait";
    	//Need to disable the buttons to prevent user from clicking anything else
    	disableOEButtons();
    	document.oeForm.submit();
    }else {
    	ajaxAnywhere.submitAJAX();
    } 
    // reset to defaults as HTTP reload would
    document.oeForm.NodeID.value = "";
    document.oeForm.NodeType.value = "";
    document.oeForm.ParentWebID.value = "";
    document.oeForm.NodeAction.value = ""; 
}

function deleteNode(webid, isFormSubmit) {
    if (confirm(MSG) == true) {
        saveIntermediateValues();
        var oldWebID = document.oeForm.WebID.value;
        document.oeForm.WebID.value= webid;
        document.oeForm.NodeAction.value= "DELETE";
        document.oeForm.action = CONTEXT_ROOT + "/control/orderEditor.do";
		document.oeForm.formSubmitOrNot.value=isFormSubmit;
        if(isFormSubmit == 'true') {
	    	document.body.style.cursor = "wait";
	    	//Need to disable the buttons to prevent user from clicking anything else
	    	disableOEButtons();
	    	document.oeForm.submit();
	    }else {
	    	ajaxAnywhere.submitAJAX();
	    }        
        // reset to default as HTTP reload would
        document.oeForm.WebID.value = oldWebID;
        document.oeForm.NodeAction.value= "";
    }
}

/*To allow for deletion when a number is entered in the count control and/or 
when the checkboxes are checked to select instances for deletion. The deleteWebId
field is the webId of the parent node whose children are to be deleted by
bulk deletion.*/
function deleteNodes(countControlName, selectControlName, nodeId, parentNodeIndex, isFormSubmit, deleteWebId) {
	try {
		// check if this is a CDT node
		var id = deleteWebId + 'ComplexTypesList';
	    var lookup = document.getElementById(id);
	    var mnemonicPath = lookup.options[lookup.selectedIndex].value;
	    if (mnemonicPath != '') {
	    	document.oeForm.MnemonicPath.value = mnemonicPath;
	    }
	} catch (e) {
		//ignore. this means the deleted node is not a CDT
	}
    saveIntermediateValues();
    document.oeForm.NodeAction.value= "DELETEMULTIPLE";
    document.oeForm.ParentNodeIndex.value = parentNodeIndex;
    document.oeForm.DeleteWebId.value= deleteWebId;
	document.oeForm.countControl.value=countControlName;
	document.oeForm.selectControl.value=selectControlName;
	document.oeForm.NodeID.value= nodeId;
    document.oeForm.action = CONTEXT_ROOT + "/control/orderEditor.do";
	document.oeForm.formSubmitOrNot.value=isFormSubmit;
    if(isFormSubmit == 'true') {
    	document.body.style.cursor = "wait";
    	//Need to disable the buttons to prevent user from clicking anything else
    	disableOEButtons();
       	document.oeForm.submit();
    }else {
    	ajaxAnywhere.submitAJAX();
    }    
    // reset to default as HTTP reload would
    document.oeForm.NodeAction.value= "";
}

function checkForDeletion(countControlName, selectControlName, nodeId, parentNodeIndex, currentCount, minInstances, isFormSubmit, deleteWebId) {
    var countToBeDeleted = document.getElementById(countControlName).value;
    var selectToBeDeleted = document.getElementById(selectControlName).value;
	var isValid;
	
	if (countToBeDeleted != '' && selectToBeDeleted != '') {
		//Show error message that both modes cannot be used
		alert(MSG_DELETE_EITHER_OR);
		return;
	}

	if (countToBeDeleted == '' && selectToBeDeleted == '') {
		alert(MSG_ENTER_EITHER_OR);
		return;
	}
    
    //If user entered some count for deletion
    if (countToBeDeleted != '') {
		isValid = /^\s*\d+\s*$/.test(countToBeDeleted); //Checks for positive including 0.
		
		if (isValid && parseInt(countToBeDeleted, 10) > 0) {
			//Perform deletion by using count.
			if ((parseInt(currentCount,10) - parseInt(countToBeDeleted, 10)) >= parseInt(minInstances,10)) {
				//Perform deletion
				if(confirm(MSG_BULK_DELETE.replace("#",parseInt(countToBeDeleted, 10))) == true) {
					deleteNodes(countControlName, selectControlName, nodeId, parentNodeIndex, isFormSubmit, deleteWebId);
					return;
				}
				else {
					return;
				}
		   }
		   else {
				//Show error prompt that the number entered will bring the total instance count below the minimum value
				alert(MSG_DELETE_BY_SPECIFIED_NUMBER);
				return;
					}
				}
				else {
					//Show error message that enter a numeric value greater than 0
					alert(MSG_GREATER_THAN_ZERO);
					return;
				}
		   }

	//User selected some checkboxes for deletion
	if (selectToBeDeleted != '') {
		if ((parseInt(currentCount,10) - selectToBeDeleted.split(",").length) >= parseInt(minInstances,10)) {
			//Perform deletion by using count.
			if(confirm(MSG) == true) {
					deleteNodes(countControlName, selectControlName, nodeId, parentNodeIndex, isFormSubmit, deleteWebId);
		}
		else {
			return;
		}
	 }
	 else {
		//Show error prompt that the number entered will bring the total instance count below the minimum value
			alert(MSG_DELETE_BY_SELECTED_INSTANCES);
		}
	 }  
}

//when the checkbox is clicked, this method will be fired
function selectForDeletion(controlName, webID) {
	var checkBoxName = 'chk' + webID;
	var deletionString = document.oeForm.elements[controlName].value;
	var webIDIndex;

	//If the checkbox is checked, add it to the hidden control name passed in
	if (document.oeForm.elements[checkBoxName].checked) {
		if (deletionString != "") {
			deletionString = deletionString + "," + webID;
		}
		else {
			deletionString = webID;
		}
		document.oeForm.elements[controlName].value = deletionString;
	}
	else {
		//Loop through the string to remove the webID from the hidden control
		//This may return nulls in the form of ,, strings to the server
		webIDIndex = deletionString.indexOf (webID);
		var newDeletionString;
		
		if (webIDIndex > 0) {
			newDeletionString = deletionString.replace ("," + webID, "");
		}
		else if (webIDIndex == 0) {
			if (deletionString.indexOf (",") != -1) {
				newDeletionString = deletionString.replace (webID + ",", "");
			}
			else {
				newDeletionString = deletionString.replace (webID, "")
			}
		}
	document.oeForm.elements[controlName].value = newDeletionString;
	}
}

var refreshAndSaveTimerId;
function checkRefreshAndSaveAction(webid, isFormSubmit,nodeID){
	var oldWebID = document.oeForm.WebID.value;
    document.oeForm.WebID.value= webid;
    document.oeForm.NodeAction.value= "CHECK";
    document.oeForm.EventNodeID.value=nodeID;
    saveIntermediateValues();
    document.oeForm.action = CONTEXT_ROOT + "/control/orderEditor.do";
	document.oeForm.formSubmitOrNot.value=isFormSubmit;
    if(isFormSubmit == 'true') {
    	document.body.style.cursor = "wait";
    	//Need to disable the buttons to prevent user from clicking anything else
    	disableOEButtons();
    	document.oeForm.submit();
    } else {
    	ajaxAnywhere.submitAJAX();
    } 
    // reset to default as HTTP reload would
    document.oeForm.WebID.value = oldWebID;
    document.oeForm.NodeAction.value= "";
    // Added the below lines to get focus of the cursor on the element which fired event rule.
    document.body.style.cursor = "auto";
    document.getElementById(webid).focus();
}

function checkAction(webid, isFormSubmit,nodeID) {
	refreshAndSaveTimerId=setTimeout(function(){checkRefreshAndSaveAction(webid, isFormSubmit,nodeID)},1000);
}


function saveData() {
    document.oeForm.NodeAction.value= "";
    saveIntermediateValues();
    document.oeForm.action = CONTEXT_ROOT + "/control/saveOrder.do";
	isFormSubmit=document.oeForm.formSubmitOrNot.value;
	if(isFormSubmit == 'true') {
    	document.body.style.cursor = "wait";
    	//Need to disable the buttons to prevent user from clicking anything else
    	disableOEButtons();
    	document.oeForm.submit();
    }else {
        autoCompleteSave() ;
        ajaxAnywhere.submitAJAX();
    }  
}

function showOrderHistory() {
    disableOEButtons();
    document.oeForm.action = CONTEXT_ROOT + "/control/orderProcessHistorySummary";
    document.oeForm.submit();
}

function showEditorPrintVersion() {
    disableOEButtons();
    document.oeForm.NodeAction.value= "PrintPreview";
    document.oeForm.action = CONTEXT_ROOT + "/control/orderPreview";
    document.oeForm.submit();
}

function showEditorNoTabPrintVersion() {
    disableOEButtons();
    document.oeForm.NodeAction.value= "NoTabPreview";
    document.oeForm.action = CONTEXT_ROOT + "/control/orderPreview";
    document.oeForm.submit();
}


function saveAndChangeStatus() {
    disableOEButtons();
    document.oeForm.NodeAction.value= "";
    saveIntermediateValues();
    document.oeForm.action = CONTEXT_ROOT + "/control/changeStateNStatus";
    autoCompleteSave();
    document.oeForm.submit();
}


function addRemark() {
    disableOEButtons();
    saveIntermediateValues();
    document.oeForm.action = CONTEXT_ROOT + "/control/addRemarkOE";
    document.oeForm.submit();
}

function viewRemarks() {
    disableOEButtons();
    saveIntermediateValues();
    document.oeForm.action = CONTEXT_ROOT + "/control/viewRemarksOE";
    document.oeForm.submit();
}

function viewReasons() {
    disableOEButtons();
    saveIntermediateValues();
    document.oeForm.action = CONTEXT_ROOT + "/control/viewReasons";
    document.oeForm.submit();
}

function exception() {
    disableOEButtons();
    document.oeForm.NodeAction.value= "";
    document.oeForm.action = CONTEXT_ROOT + "/control/exceptionProcessing";
    document.oeForm.submit();
}

// this is called from the window onload event to set the focus
// of the "current" field
function setFocusedElement() {
	if (document.oeForm != null) {
		if ((document.oeForm.oeScrollPosition != null)
		&&(document.oeForm.oeScrollPosition.value != null)
		&&(document.oeForm.oeScrollPosition.value != "")) {
			document.body.scrollTop = document.oeForm.oeScrollPosition.value;
		}
		if ((document.oeForm.WebID != null)
		&&(document.oeForm.WebID.value != null)
		&&(document.oeForm.WebID.value != "")) {
			var currentElement = document.getElementById(document.oeForm.WebID.value);	
			if (currentElement != null) {
				currentElement.focus();
			}
		}
	}
}


function saveIntermediateValues() {
    if (document.oeForm.newRefNb) //if there is ref control
        document.oeForm.Ref.value= document.oeForm.newRefNb.value;
    if (document.oeForm.newPriority) //if there is priority control
        document.oeForm.Priority.value= document.oeForm.newPriority.value;

	/* Not required, hence commenting it out.	
    var elms = document.oeForm.elements;
    var i;
    for (i = 0; i < elms.length ; i++) {
        var e = elms[i];
        if (e.type != "text")
           continue;
        if (e.name.indexOf("masked") < 0)
           continue;
        var field = document.oeForm.elements[e.name.substr(6)];
        field.value = e.value;
    }
    	*/
	
	document.oeForm.oeScrollPosition.value = document.body.scrollTop;
}

function completeTask(fromForm) {
    disableOEButtons();
    var form = "";
	if(fromForm == 'fromOrderEditor') {
		form = document.forms['oeForm'];
	} else {
		form = document.forms['orderEditorMenu'];
	}
      var statusOptions = form.Status.options;
      for (var i = 0 ; i < statusOptions.length; i++){
    	if (statusOptions[i].selected)
    		document.oeForm.StatusID.value=statusOptions[i].value;
      }
    saveIntermediateValues();
    document.oeForm.action = CONTEXT_ROOT + "/control/completeTask";
    autoCompleteSave();
    document.oeForm.submit();
}

function wsCompleteTask(completionStatusID) {
    disableOEButtons();
    document.oeForm.StatusID.value=completionStatusID;
    saveIntermediateValues();
    document.oeForm.action = CONTEXT_ROOT + "/control/completeTask";
    autoCompleteSave();
    document.oeForm.submit();
}


function showHelp(webId) { 
	window.open(CONTEXT_ROOT+ '/control/orderEditorHelp?WebID='+webId,null,'status=no,toolbar=no,menubar=no,resizable=yes,scrollbars=no,width=600',true).focus();
}

function showPicklist(webId) {
	clearTimeout(refreshAndSaveTimerId);
	var currentElement = document.getElementById(webId);	
	var searchText = "";
	if (currentElement != null) {
		if (currentElement.childNodes != null && currentElement.childNodes.length > 0) {
			searchText = currentElement.childNodes(0).nodeValue;
		} else {
			searchText = currentElement.value;
		}
		if (searchText == "undefined" || searchText == null) {
			searchText = "";
		}
	}
	var winString = "toolbar=no,location=no,directories=no,hotkeys=no,dependent=yes,personalbar=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,height=470";
//	var urlString = CONTEXT_ROOT+ '/control/orderEditorPicklist?WebID='+webId+'&SearchText='+escape(searchText);
	var urlString = CONTEXT_ROOT+ '/control/orderEditorPicklist?WebID='+webId+'&SearchText='+encodeURI(searchText);
	var picklist = window.open(urlString,null,winString,true);
	if (picklist != null) {
		picklist.focus();
		if (!picklist.opener) {
			picklist.opener = self;
		}
		if (currentElement != null) {
			picklist.targetPicklistElement = currentElement;
		}
	}
}

function EditOrder() { 
    document.forms[0].action = CONTEXT_ROOT+"/control/orderListMenu";
    document.forms[0].submit();
}

function goToErrorMessage(errorMsgId){
    var errorMsgElement = document.getElementById(errorMsgId);
	if (errorMsgElement != null) {
		expandAllTabsTillRoot(errorMsgElement);
		var tempHREF = errorMsgElement.href; 
		var isHREFModified = false;
		
		if(tempHREF == null || tempHREF == "" || tempHREF == "undefined") {
		    /*Not sure why the link from errorzone to value node is not working with out adding a dummy href # to the anchor element of valueNode
			  Following is the same workaround */ 
			errorMsgElement.href = "#";
			isHREFModified = true;
		}
		errorMsgElement.focus();
		if(isHREFModified) {
			errorMsgElement.removeAttribute("href");
		}
	}
}

function expandAllTabsTillRoot(htmlElement) {
	if(htmlElement != null) {
		/*tabPage will have this class name, change this if the original class name of the tab page changes*/
		var cnTabPage = /tab-page/;
		//Class Name of the element that is passed 
		var cnElement = htmlElement.className;
		
		if( cnElement != null && cnElement != "" && cnTabPage.test(cnElement) ) {
			/*Invoke the select on the tabPage, this is to select the particular tab
			  We can safely assume that there will be a tabPage present if the class name of the element has tab-page, 
			  just in case, do the check also*/
			if( typeof htmlElement.tabPage != "undefined" ) {
				htmlElement.tabPage.select();
				//Now call this function again to open the parent tabs in the tab hierarchy 
				expandAllTabsTillRoot(htmlElement.parentNode);
			}
		}
		else if (htmlElement.id != null && htmlElement.id == "aazone.root") {
			//Do Nothing
			//We have reached the root node, so stop the processing 
		}
		else{
			expandAllTabsTillRoot(htmlElement.parentNode);
		}		
	}
}	
