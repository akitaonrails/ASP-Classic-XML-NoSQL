// instantiates the global controller
var oControl  = new TDialogControl();

// set the globals of the tree
var cfg_fixed_node = 'node';
var cfg_fixed_name = 'name';
var cfg_fixed_subnode = 'subnode';

// set the XML objects
var oXML = new ActiveXObject( "MSXML2.DOMDocument.3.0" );
var oXSL = new ActiveXObject( "MSXML2.DOMDocument.3.0" );
oXML.async = false;
oXSL.async = false;
oXML.validateOnParse = false;

try {
	oXML.load( sXMLPath );
	oXSL.load( sXSLPath );
	
	if ( oXML.documentElement.firstChild.nodeName == 'module' ) {
		if ( oXML.documentElement.firstChild.text != 'mod_treetable' ) {
			oXML.load( 'chave.xml' );
		}
	} else if ( oXML.documentElement.firstChild.nodeName != 'node' ) {
		oXML.load( 'chave.xml' );
	}
} catch( e ) {
	// error happened, so get out
	self.location = '../module_error.asp?message=' + encode( 'Tree Table Module: ' + e.description );
}

// set the current selected node
var currentNode = -1;
var currentSubNode = -1;

// refreshes the preview boxes
function refreshXML() {
	btReplace.disabled = true;
	try {
		if ( oXML.xml != '' ) {
			XMLFinal.innerHTML = oXML.transformNode( oXSL );
			XMLSource.innerText = oXML.xml;
		}
	} catch( e ) {
		alert( 'refreshXML: ' + e.description );
	}
	if ( currentNode < 0 && currentSubNode < 0 ) {
		txtCoordinates.innerText = ' :: select a node ';
	}
	btReplace.disabled = false;
}

// replace the selected node for the new one
function changeNode() {
	if ( currentNode < 0 ) {
		alert( 'click on a node of the tree first' );
		return false;
	}

	var bReturn = false;
	try {
		// get the selected node tree
		var oNode = oXML.documentElement.childNodes( currentNode );
		if ( currentSubNode > -1 ) {
			// seek in the subnodes of this node
			var oList = oNode.getElementsByTagName( cfg_fixed_subnode );
			var oSubNode = oList( currentSubNode );
			oSubNode.text = txtNode.value;
		} else {
			// change this root node name property
			oNode.firstChild.text = txtNode.value;
		}
		refreshXML();
		bReturn = true;
	} catch( e ) {
		alert( 'changeNode: ' + e.description );
		bReturn = false;
	}
	
	try {
		oControl.Get( 'divEditBox' ).Hide();
	} catch( e ) {
	}
	return bReturn;
}

// creates a brand new tree
function createTree() {
	intTotal = totalNodes.value;
	intNodes = Math.pow( 2, intTotal );

	try {
		oXML.loadXML( '<?xml version="1.0" encoding="iso-8859-1"?><root><module>mod_treetable</module></root>' );
		for ( var i = 0; i < intNodes; i ++ ) {
			elementItem = oXML.createElement( cfg_fixed_node );
			elementName = oXML.createElement( cfg_fixed_name );
			elementItem.appendChild( elementName );
			oXML.documentElement.appendChild( elementItem );
		}
	
		for ( intLevel = 2; intLevel <= intNodes; intLevel *= 2 ) {
			var iIni = oXML.documentElement.firstChild.tagName == 'module' ? 1 : 0;
			var iEnd = oXML.documentElement.firstChild.tagName == 'module' ? intNodes + 1 : intNodes;
			for ( j = iIni; j < iEnd; j += intLevel ) {
				elementSubNode = oXML.createElement( cfg_fixed_subnode );
				oXML.documentElement.childNodes( j ).appendChild( elementSubNode );
			}
		}
		refreshXML();
	} catch( e ) {
		alert( 'createTree: ' + e.description );
	}
}

// controls the view source box
function controlSourceBox() {
	if ( sourcecontrol.style.visibility == 'visible' ) {
		sourcecontrol.style.visibility = 'hidden';
	} else {
		sourcecontrol.style.visibility = 'visible';
	}
}

// gives each node the power of self-selection
function getCoordinates( oObj ) {
	try {
		currentNode = parseInt( oObj.nodeID );
		currentSubNode = parseInt( oObj.subID );
		if ( oXML.documentElement.childNodes( 0 ).tagName == 'module' ) {
			currentNode ++;
		}
		if ( isNaN( currentSubNode ) ) {
			currentSubNode = -1;
		}
		document.all( 'txtCoordinates' ).innerText = '(' + currentNode + ', ' + currentSubNode + ')';
		document.all( 'txtNode' ).value = oObj.innerText;
		oControl.Get( 'divEditBox' ).Show();
	} catch( e ) {
		alert( 'getCoordinates: ' + e.description );
	}
}

// highlight table elements
function turnHover( oObj, isOn ) {
	if ( oObj ) {
		if ( isOn ) {
			oObj.style.backgroundColor = '#CCCCCC';
		} else {
			oObj.style.backgroundColor = '#FFFFFF';
		}
	}
}

// handler for external container for this module
function getSource() {
	return oXML.xml;
}