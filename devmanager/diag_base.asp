<div id="divBase" style="position:absolute; visibility: hidden; width:380px; height:60px; z-index:1; left: 429px; top: 338px" class="floatingbox"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="1">
  <form name="formBase">
    <tr> 
      <td colspan="2" class="dragtitle"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="boxtitle">-- Make Base Links</td>
            <td align="right"><button name="btSave" onclick="BaseClickSave( this.form )">Save</button> <button name="btCancel" onclick="oControl.Get('divBase').Hide()"> X </button> 
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td onclick="InvertXML()">XML file:</td>
      <td>
		<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td><div id="divBaseXML"></div></td>
			<td align="right"><button name="btErase" onclick="BaseClickErase( 1 )"> x </button></td>
		</tr>
		</table>
	  </td>
    </tr>
    <tr> 
      <td onclick="InvertXML()">Schema file:</td>
      <td>
		<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td><div id="divBaseSchema"></div></td>
			<td align="right"><button name="btErase" onclick="BaseClickErase( 2 )"> x </button></td>
		</tr>
		</table>
	  </td>
    </tr>
    <tr> 
      <td>XSL file:</td>
      <td>
		<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td><div id="divBaseXSL"></div></td>
			<td align="right"><button name="btErase" onclick="BaseClickErase( 3 )"> x </button></td>
		</tr>
		</table>
	  </td>
    </tr>
  </form>
  </table>
</div>
<script language="JScript">
// add this dialog to the controller
oControl.AddQueue( 'divBase' );

// handles association save
function BaseClickSave( oForm ) {
	var oFormFinal = document.formExplorer;
	if ( !oFormFinal || !oForm ) { return false }
	
	if ( oFormFinal.association_xml.value != '' ) {
		if ( ( oFormFinal.association_xsl.value == '' ) 
			&& ( oFormFinal.association_schema.value == '' ) ) {
			alert( 'Associate files first.' );
			return false;
		}
		oFormFinal.operation.value = 'baselink';
		oFormFinal.submit();
		return true;
	}
}

// erase the content
function BaseClickErase( intField ) {
	var oFormFinal = document.formExplorer;
	if ( !oFormFinal ) { return false }

	if ( intField == 1 ) {
		oFormFinal.root_xml.value = '';
		oFormFinal.association_xml.value = '';
		document.all( 'divBaseXML' ).innerText = '';
	} else if ( intField == 2 ) {
		oFormFinal.root_schema.value = '';
		oFormFinal.association_schema.value = '';
		document.all( 'divBaseSchema' ).innerText = '';
	} else {
		oFormFinal.root_xsl.value = '';
		oFormFinal.association_xsl.value = '';
		document.all( 'divBaseXSL' ).innerText = '';
	}
}

// refreshes the association box
function RefreshBase() {
	var oForm = document.formExplorer;
	if ( !oForm ) {
		return false;
	}
	
	var maxLength = 40
	
	var sTmp = oForm.association_xml.value.replace( globalRoot, '' );
	if ( sTmp.length > maxLength ) {
		sTmp = '...' + sTmp.substring( sTmp.length - 50, sTmp.length );
	}
	document.all( 'divBaseXML' ).innerText = sTmp;
	
	sTmp = oForm.association_xsl.value.replace( globalRoot, '' );
	if ( sTmp.length > maxLength ) {
		sTmp = '...' + sTmp.substring( sTmp.length - 50, sTmp.length );
	}
	document.all( 'divBaseXSL' ).innerText = sTmp;
	
	sTmp = oForm.association_schema.value.replace( globalRoot, '' );
	if ( sTmp.length > maxLength ) {
		sTmp = '...' + sTmp.substring( sTmp.length - 50, sTmp.length );
	}
	document.all( 'divBaseSchema' ).innerText = sTmp;
}

// switch XML and Schema places
function InvertXML() {
	var oForm = document.formExplorer;
	if ( !oForm ) {
		return false;
	}

	var sTmp = document.all( 'divBaseXML' ).innerText;
	document.all( 'divBaseXML' ).innerText = document.all( 'divBaseSchema' ).innerText;
	document.all( 'divBaseSchema' ).innerText = sTmp;
	
	sTmp = oForm.association_xml.value;
	oForm.association_xml.value = oForm.association_schema.value;
	oForm.association_schema.value = sTmp;

	sTmp = oForm.root_xml.value;
	oForm.root_xml.value = oForm.root_schema.value;
	oForm.root_schema.value = sTmp;
}

// handles operation dialog event 
function BaseClickOperation() {
	var oFormFinal = document.formExplorer;
	if ( !oFormFinal ) { return false }
	
	if ( globalRoot == '' ) {
		alert( 'Can\'t do nothing yet.' );
		return false;
	}
	
	if ( eventFolder ) {
		alert( 'Can\'t do base links with folders.' );
		return false;
	}
	
	if ( eventPath.indexOf( '.xml' ) > -1 ) {
		var sXML = oFormFinal.association_xml.value;
		var sSchema = oFormFinal.association_schema.value;
		// try to figure out if it´s a hidden file and if so try to fill the schema field first
		var sTmp = eventPath.replace( globalRoot, '' );
		sTmp = sTmp.replace( '.xml', '' );
		if ( sTmp.indexOf( '.' ) > -1 ) {
			oFormFinal.root_schema.value = globalRoot
			oFormFinal.association_schema.value = eventPath;
		} else {
			oFormFinal.root_xml.value = globalRoot
			oFormFinal.association_xml.value = eventPath;
		}
	} else {
		oFormFinal.root_xsl.value = globalRoot;
		oFormFinal.association_xsl.value = eventPath;
	}
	
	// if there´s the base association dialog, then call it´s refresh procedure
	RefreshBase();
	oControl.Get( 'divBase' ).Show();
}
</script>
