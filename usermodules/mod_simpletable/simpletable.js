// instantiates the global controller
var oControl  = new TDialogControl();

var sClearXML = '<?xml version="1.0" encoding="iso-8859-1"?><root><module>mod_simpletable</module></root>';

// initialize the client XML objects
var oTemplate = new ActiveXObject( "MSXML2.DOMDocument.3.0" );
var oXML = new ActiveXObject( "MSXML2.DOMDocument.3.0" );
var oXSL = new ActiveXObject( "MSXML2.DOMDocument.3.0" );
oTemplate.async = false;
oXML.async = false;
oXSL.validateOnParse = false;
oXSL.async = false;

try {
	// load the XML files from the server
	oTemplate.load( sSchemaPath );
	oXML.load( sXMLPath );
	oXSL.load( 'interface.xsl' );
	if ( oXML.documentElement.firstChild.nodeName == 'module' ) {
		if ( oXML.documentElement.firstChild.text != 'mod_simpletable' ) {
			oXML.loadXML( sClearXML );
		}
	} else if ( oXML.documentElement.firstChild.nodeName != 'table' ) {
		oXML.loadXML( sClearXML );
	}

	// get the template table
	var oTemplateRoot = oTemplate.documentElement.childNodes( 0 );
} catch( e ) {
	// some error happened, can´t go on
	self.location = '../module_error.asp?message=' + encode( 'Simple Table Module: ' + e.description );
}

// configure the globals for this form
var cfg_combo_tables = "tableID";
var cfg_combo_rows = "rowID";

// configure the globals for the fixed template
var cfg_fixed_table = 'table';
var cfg_fixed_header = 'header';
var cfg_fixed_footer = 'footer';
var cfg_fixed_item = 'item';

// current coordinates
var intTableID = 0;
var intRowID = -1;

// clipboard storage
var oClipboard;

// allows refreshing for methods;
var allowRefresh = true;

// check which table is currently selected
function getCurrentTable() {
	return intTableID;
}

// refresh the current user form state
function refreshXML() {
	// updates the raw content of the preview and source elements
	XMLFinal.innerHTML = oXML.transformNode( oXSL );
	XMLSource.innerText = oXML.xml;

	// fetch the selected values
	sLocal = cfg_fixed_item;
	if ( intRowID == -1 ) {
		sLocal = cfg_fixed_header;
	} else if ( intRowID == -2 ) {
		sLocal = cfg_fixed_footer;
	}

	var oList = oXML.documentElement.childNodes( intTableID ).getElementsByTagName( sLocal );
	var oElement = oList( 0 );
	if ( intRowID > 0 ) {
		oElement = oList( intRowID );
	}
	if ( oElement ) {
		for ( var i = 0; i < oElement.childNodes.length; i ++ ) {
			document.all( 'txt' + oElement.childNodes( i ).tagName ).value = oElement.childNodes( i ).text;
		}
	}
}

function resetXML() {
	if ( confirm( 'Are you sure you want to clean up this document?' ) ) {
		oXML.loadXML( oXML.xml.substring( 0, oXML.xml.indexOf( '<root>' ) ) + '<root>\n</root>' );
		if ( allowRefresh )
			refreshXML();
	}
}

// create a simple node
function createElement( sName, sValue ) {
	var elementItem = oXML.createElement( sName );
	var elementValue = oXML.createTextNode( sValue );
	elementItem.appendChild( elementValue );
	return elementItem;
}

// create fixed element from template
function createTopElement( sName ) {
	// always check with the main template
	var oList = oTemplateRoot.getElementsByTagName( sName );
	if ( oList.length <= 0 ) {
		return false;
	}

	// create the new element and it´s children based on the template
	var oElement = oXML.createElement( sName );
	var oChildList = oList( 0 ).childNodes;
	for( intCount = 0; intCount < oChildList.length; intCount ++ ) {
		// try to get a form element value
		// standard: the form elements will begin with a 'txt'
		sInputName = oChildList( intCount ).text;
		oValue = document.all( 'txt' + sInputName );
		try {
			oElement.appendChild( createElement( sInputName, oValue.value ) );
		} catch ( e ) {
			alert( 'createTopElement: ' + e.description );
		}
	}
	return oElement;
}

// updates the fixed elements HEADER and FOOTER
function updateFixed( sElementName )
{
	// for now, only allow header and footer fixed elements
	if ( sElementName != cfg_fixed_header && sElementName != cfg_fixed_footer ) {
		return false;
	}

	// check what´s defined inside the same element from the template 
	// and create a new element accordingly
	var oElement = createTopElement( sElementName );

	// work on the currently selected table
	var i = getCurrentTable();
	var oNode = oXML.documentElement.childNodes( i );
	try {
		if ( sElementName == cfg_fixed_header ) {
			if ( oNode.hasChildNodes() && oNode.firstChild.tagName == sElementName ) {
				// if there´s already a header node then replace it
				oNode.replaceChild( oElement, oNode.firstChild );
			} else if ( !oNode.hasChildNodes() ) {
				// it the tree is empty then this is the first node
				oNode.appendChild( oElement );
			} else {
				// otherwise insert this node before the tree´s first node
				oNode.insertBefore( oElement, oNode.childNodes( 0 ) );
			}
		} else {
			if ( oNode.hasChildNodes() && oNode.lastChild.tagName == sElementName ) {
				// if this element already then replace it
				oNode.replaceChild( oElement, oNode.lastChild );
			} else {
				// it the tree is empty then this is the first node
				oNode.appendChild( oElement );
			}
		}	       
	} catch ( e ) {
		alert( 'updateFixed: ' + e.description );
	}
	
	// force a refresh
	if ( allowRefresh ) 
		refreshXML();

	// check for errors	
	if ( e ) {
		return false;
	}
	return true;
}

/***** interface masks *****/
	// specific mask for the updateFixed function
	function updateheader() {
		return updateFixed( cfg_fixed_header );
	}

	// specific mask for the updateFixed function
	function updatefooter() {
		return updateFixed( cfg_fixed_footer );
	}

// insert an item node somewhere in the item list
function insertItem( iPosition )
{
	// check what´s defined inside the item element from the template 
	// and create a new element accordingly
	var oElement = createTopElement( cfg_fixed_item );

	var i = getCurrentTable();
	var oNode = oXML.documentElement.childNodes( i );
	var oList = oNode.getElementsByTagName( cfg_fixed_item );
	try {
		if ( isNaN( iPosition ) || iPosition < 0 || iPosition > oList.length || oList.length <= 0 ) {
			if ( oNode.lastChild && oNode.lastChild.tagName == cfg_fixed_footer ) {
				// if the last fixed element do exists, then insert before it
				oNode.insertBefore( oElement, oNode.lastChild );
			} else {
				// in the last cast always try to insert it at the bottom
				oNode.appendChild( oElement );
			}
		} else {
			// insert before the specified row item
			oNode.insertBefore( oElement, oList( iPosition ) );
		}
	} catch ( e ) {
		alert( 'insertItem: ' + e.description );
	}
	
	// force a refresh
	if ( allowRefresh ) 
		refreshXML();

	// check for errors	
	if ( e ) {
		return false;
	}
	return true;

}

// replace an item node of a specified position
function replaceItem( iPosition )
{
	// check what´s defined inside the item element from the template 
	// and create a new element accordingly
	var oElement = createTopElement( cfg_fixed_item );

	var i = getCurrentTable();
	var oNode = oXML.documentElement.childNodes( i );
	var oList = oNode.getElementsByTagName( cfg_fixed_item );
	try {
		if ( !isNaN( iPosition ) && iPosition > -1 && iPosition < oList.length && oList.length > 0 ) {
			oNode.replaceChild( oElement, oList( iPosition ) );
		}
	} catch ( e ) {
		alert( 'replaceItem: ' + e.description );
	}
	
	// force a refresh
	if ( allowRefresh )
		refreshXML();

	// check for errors	
	if ( e ) {
		return false;
	}
	return true;

}

// remove an item node of a specified position
function removeItem( iPosition )
{
	var i = getCurrentTable();
	var oNode = oXML.documentElement.childNodes( i );
	var oList = oNode.getElementsByTagName( cfg_fixed_item );
	try {
		if ( !isNaN( iPosition ) && iPosition > -1 && iPosition < oList.length && oList.length > 0 ) {
			oNode.removeChild( oList( iPosition ) );
		}
	} catch ( e ) {
		alert( 'removeItem: ' + e.description );
	}
	
	// force a refresh
	if ( allowRefresh )
		refreshXML();

	// check for errors	
	if ( e ) {
		return false;
	}
	return true;

}

/***** interface masks *****/
	// specific mask to insert a node in a specific row
	function addItem( iPosition ) {
		return insertItem( iPosition );
	}

	// specific mask for appending an item
	function appendItem() {
		return insertItem( -1 );
	}


// insert table somewhere 
function insertTable( iPosition )
{
	// check what´s defined inside the item element from the template 
	// and create a new element accordingly
	var oElement = oXML.createElement( cfg_fixed_table );

	var oNode = oXML.documentElement;
	var oList = oNode.getElementsByTagName( cfg_fixed_table );
	try {
		if ( isNaN( iPosition ) || iPosition < 0 || iPosition > oList.length || oList.length <= 0 ) {
			// in the last cast always try to insert it at the bottom
			intTableID = oList.length;
			oNode.appendChild( oElement );
		} else {
			// insert before the specified row item
			oNode.insertBefore( oElement, oList( iPosition ) );
		}
	} catch ( e ) {
		alert( 'insertTable: ' + e.description );
	}
	
	// force a refresh
	if ( allowRefresh )
		refreshXML();

	// check for errors	
	if ( e ) {
		return false;
	}
	return true;
}

// remove a table from a position
function removeTable( iPosition )
{
	var oNode = oXML.documentElement;
	var oList = oNode.getElementsByTagName( cfg_fixed_table );
	try {
		if ( !isNaN( iPosition ) && iPosition > -1 && iPosition < oList.length && oList.length > 0 ) {
			oNode.removeChild( oList( iPosition ) );
		}
	} catch ( e ) {
		alert( 'removeTable: ' + e.description );
	}
	
	// force a refresh
	if ( allowRefresh )
		refreshXML();

	// check for errors	
	if ( e ) {
		return false;
	}
	return true;
}

/***** interface masks *****/
	// specific mask to insert a table in a specific order
	function addTable( iPosition ) {
		return insertTable( iPosition );
	}

	// specific mask for append a new table
	function appendTable() {
		return insertTable( -1 );
	}

/***** clipboard functions ****/
// copy an item into the clipboard
function copyItem( iPosition )
{
	var i = getCurrentTable();
	var oNode = oXML.documentElement.childNodes( i );
	var oList = oNode.getElementsByTagName( cfg_fixed_item );
	try {
		if ( !isNaN( iPosition ) && iPosition > -1 && iPosition < oList.length && oList.length > 0 ) {
			oClipboard = oList( iPosition ).cloneNode( true );
		}
	} catch ( e ) {
		alert( 'copyItem: ' + e.description );
	}
	
	// force a refresh
	if ( allowRefresh )
		refreshXML();

	// check for errors	
	if ( e ) {
		return false;
	}
	return true;

}

// past an item node from the clipboard to the specified position
function pasteItem( iPosition )
{
	if ( oClipboard == null ) {
		alert( 'There\'s nothing in the clipboard to paste' );
		return false;
	}

	var i = getCurrentTable();
	var oNode = oXML.documentElement.childNodes( i );
	var oList = oNode.getElementsByTagName( cfg_fixed_item );
	try {
		if ( !isNaN( iPosition ) && iPosition > -1 && iPosition < oList.length && oList.length > 0 ) {
			oNode.replaceChild( oClipboard, oList( iPosition ) );
		}
	} catch ( e ) {
		alert( 'pasteItem: ' + e.description );
	}
	
	// force a refresh
	if ( allowRefresh )
		refreshXML();

	// check for errors	
	if ( e ) {
		return false;
	}
	return true;

}

// combines copy+remove to have a "cut" feature
function cutItem( iPosition ) {
	if ( copyItem( iPosition ) ) {
		return removeItem( iPosition );
	}
	return false;
}

// encapsulates the cut/paste operation in a "move up" fashion
function moveUpItem( iPosition ) {
	allowRefresh = false;
	var iResult = false;
	if ( cutItem( iPosition ) )
		if ( addItem( iPosition - 1 ) )
			if ( pasteItem( iPosition - 1 ) ) {
				intRowID --;
				iResult = true;
			}
	allowRefresh = true;
	refreshXML();
	return iResult;
}

// encapsulates the cut/paste operation in a "move down" fashion
function moveDownItem( iPosition ) {
	allowRefresh = false;
	var iResult = false;
	if ( cutItem( iPosition ) )
		if ( addItem( iPosition + 1 ) )
			if ( pasteItem( iPosition + 1 ) ) {
				intRowID ++;
				iResult = true;
			}
	allowRefresh = true;
	refreshXML();
	return iResult;
}

// controls the view source box
function controlSourceBox() {
	if ( sourcecontrol.style.visibility == 'visible' ) {
		sourcecontrol.style.visibility = 'hidden';
	} else {
		sourcecontrol.style.visibility = 'visible';
	}
}

// gives the preview table power of self-selection
function setCoordinates( oObj ) {
	try {
		// update the coordinates
		intTableID = parseInt( oObj.tableID );
		intRowID = parseInt( oObj.rowID );
		
		if ( oXML.documentElement.firstChild.tagName == 'module' )
			intTableID ++;
			
		// print the coordinates
		txtTable.innerText = '(table: ' + ( intTableID + 1 ) + ', row: ' + ( intRowID + 1 ) + ') ';

		if ( allowRefresh )
			refreshXML();

		if ( intRowID == -1 ) {
			oControl.Get( 'div' + cfg_fixed_header ).Show();
		} else if ( intRowID == -2 ) {
			oControl.Get( 'div' + cfg_fixed_footer ).Show();
		} else {
			oControl.Get( 'div' + cfg_fixed_item ).Show();
		}
	} catch( e ) {
		alert( 'setCoordinates: ' + e.description + '\n\n' +
		'Why this failed? Here are some possibilities:\n' +
		'1. Did you created the correct XML and Schema files?\n' +
		'2. Did you correctly Associated both files?\n' +
		'   (Remember that in the Association dialog box,\n' +
		'   you have the Schema field first!)\n' +
		'3. Are you really sure the files are syntatically correct?' 
		);
	}
}

// highlight table elements
function turnHover( oObj, isOn ) {
	if ( oObj ) {
		if ( isOn ) {
			oObj.style.backgroundColor = '#BBBBBB';
		} else {
			oObj.style.backgroundColor = '#FFFFFF';
		}
	}	
}

// body onload method to set the dialog controler
function oControlOnLoad() {
	oControl.AddQueue( 'div' + cfg_fixed_header );
	oControl.AddQueue( 'div' + cfg_fixed_footer );
	oControl.AddQueue( 'div' + cfg_fixed_item );
	oControl.RunQueue();
}

function helpBox( sLabel ) {
	alert( 'Option not available yet' );
}