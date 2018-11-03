<div id="divCheckXML" style="position:absolute; visibility: hidden; width:400px; height:60px; z-index:1; left: 429px; top: 338px" class="floatingbox"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="1">
  <form name="formCheck">
    <tr> 
      <td class="dragtitle"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="boxtitle">-- Check XML Compliance</td>
            <td align="right"><button name="btCancel" onclick="oControl.Get('divCheckXML').Hide()"> X </button>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
	  <td>
	  <div id="checkInnerBox" style="position: relative; display: none">
	    <table width="90%" border="0" cellpadding="1" cellspacing="1">
	    <tr>
	      <td><div id="checkURL"></div></td>
	    </tr>
	    <tr>
	      <td><b><div id="checkReason"></div></b></td>
	    </tr>
	    <tr>
	      <td>
	      <table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td nowrap>File Position: <div id="checkFilePos"></div></td>
				<td nowrap>Line: <div id="checkLine"></div></td>
				<td nowrap>Line Position: <div id="checkLinePos"></div></td>
			</tr>
	      </table>
	      </td>
	    </tr>
	    <tr>
	      <td>Source: <div id="checkSrcText"></div></td>
	    </tr>
		<tr>
		  <td colspan="2">&nbsp;</td>
		</tr>
		</table>
	  </div>
	  <div id="checkInnerSuccess" style="position: relative; display: none">
	  <p align="center"><b>No Errors were detected</b></p>
	  </div>
	  </td>
	</tr>
  </form>
  </table>
</div>
<script language="JScript">
// add this dialog to the controller
oControl.AddQueue( 'divCheckXML' );

// do the checking in the choosed XML file
function CheckXML() {
	var oXML = new ActiveXObject( "MSXML2.DomDocument.3.0" );

	try {
		// clear old values
		document.all( 'checkReason' ).innerText = '';
		document.all( 'checkFilePos' ).innerText = '';
		document.all( 'checkLine' ).innerText = '';
		document.all( 'checkLinePos' ).innerText = '';
		document.all( 'checkSrcText' ).innerText = '';
		document.all( 'checkURL' ).innerText = '';

		oXML.async = false;
		oXML.validateOnParse = false;
		oXML.load( globalURL + eventPath.replace( globalRoot, '' ) );

		if ( oXML.parseError.errorCode != 0 ) {
			document.all( 'checkReason' ).innerText = oXML.parseError.reason;
			document.all( 'checkFilePos' ).innerText = oXML.parseError.filepos;
			document.all( 'checkLine' ).innerText = oXML.parseError.line;
			document.all( 'checkLinePos' ).innerText = oXML.parseError.linePos;
			document.all( 'checkSrcText' ).innerText = oXML.parseError.srcText;
			document.all( 'checkURL' ).innerText = oXML.parseError.url;
			
			document.all( 'checkInnerBox' ).style.display = '';
			document.all( 'checkInnerSuccess' ).style.display = 'none';
		} else {
			document.all( 'checkInnerBox' ).style.display = 'none';
			document.all( 'checkInnerSuccess' ).style.display = '';
		}
	} catch( e ) {
	}
}

// used by diag_operations to call the box
function CheckXMLOperation() {
	var oFormFinal = document.formExplorer;
	if ( !oFormFinal ) { return false }
	
	if ( ( globalURL == '' ) || ( eventPath == '' ) ) {
		alert( 'Can\'t do nothing in this point' );
		return false;
	}
	
	// if there´s the association dialog, then call it´s refresh procedure
	CheckXML();
	oControl.Get( 'divCheckXML' ).Show();
}
</script>
