var sXMLTemplate = 'template.xml';
var oXML = new ActiveXObject( "MSXML2.DOMDocument.3.0" );
oXML.async = false;
oXML.validateOnParse = false;

// open the calendar picker dialog
function OpenCalendar( oText ) {
	try {
		var arr = window.showModalDialog( 'diag_calendar.htm', null, 'dialogWidth: 310px; dialogHeight: 320px' );
		if ( arr ) {
			oText.value = arr[ 'date' ];
		}
	} catch( e ) {
		window.status = e.description;
	}
}

// Executes commands depending on which button has been pushed
function Toggle( sCommand )
{
	if ( sCommand.toLowerCase() == 'source' ) {
		refreshXML();
		divSource.style.display = divSource.style.display == 'none' ? '' : 'none';
		divSource.innerText = oXML.xml;
		return;
	}
	try {
		divEdit.focus();
		document.execCommand( sCommand, true );
	} catch( e ) {
		window.status = 'error: ' + e.description;
	}
}

// change the visual of the button per event
function HandleEvent( oButton, sEvent ) {
	if ( sEvent == 'over' ) 
		oButton.className = 'tbButtonMouseOverUp'
	else if ( sEvent == 'out' ) 
		oButton.className = 'tbButton'
	else if ( sEvent == 'down' ) 
		oButton.className = 'tbButtonDown'
	else if ( sEvent == 'up' ) 
		oButton.className = 'tbButtonMouseOverUp'
}

// handler for external container for this module
function getSource() {
	refreshXML();
	return oXML.xml;
}

// updates the xml object
function refreshXML() {
	try {
		oDoc.childNodes( 0 ).text = formEditor.title.value;
		oDoc.childNodes( 1 ).text = formEditor.subtitle.value;
		oDoc.childNodes( 2 ).text = formEditor.author.value;
		oDoc.childNodes( 3 ).text = formEditor.date.value;
		var oCDATA = oXML.createCDATASection( divEdit.innerHTML );
		if ( oDoc.childNodes( 4 ).hasChildNodes() )
			oDoc.childNodes( 4 ).replaceChild( oCDATA, oDoc.childNodes( 4 ).firstChild )
		else
			oDoc.childNodes( 4 ).appendChild( oCDATA );
	} catch( e ) {
		alert( 'refreshXML: ' + e.description );
	}
}

// updates the rich-text editor 
function refreshEditor() {
	try {
		formEditor.title.value = oDoc.childNodes( 0 ).text;
		formEditor.subtitle.value = oDoc.childNodes( 1 ).text;
		formEditor.author.value = oDoc.childNodes( 2 ).text;
		formEditor.date.value = oDoc.childNodes( 3 ).text;
		divEdit.innerHTML = oDoc.childNodes( 4 ).nodeTypedValue;
	} catch( e ) {
		alert( 'refreshEditor: ' + e.description );
	}
}

// loads the necessary xml files
var oDoc = null;
try {
	if ( !oXML.load( sXMLPath ) ) {
		oXML.load( sXMLTemplate );
	} else {
		var oList = oXML.documentElement.getElementsByTagName( 'document' );
		if( oList.length == 0 ) {
			oXML.load( sXMLTemplate );
		}
	}
} catch( e ) {
	alert( 'onload: ' + e.description );
}

var oDoc = oXML.documentElement.firstChild;
if ( oDoc.nodeName != 'document' ) {
	var oDoc = oDoc.nextSibling;
}
