<div id="divAssociation" style="position:absolute; visibility: hidden; width:380px; height:60px; z-index:1; left: 429px; top: 338px" class="floatingbox"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="1">
  <form name="formAssociation">
    <tr> 
      <td colspan="2" class="dragtitle"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="boxtitle">-- Make Shortcut</td>
            <td align="right"><button name="btSave" onclick="AscClickSave( this.form )">Save</button> <button name="btCancel" onclick="oControl.Get('divAssociation').Hide()"> X </button> 
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>XML file:</td>
      <td>
		<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td><div id="divAssociationXML"></div></td>
			<td align="right"><button name="btErase" onclick="AscClickErase( 1 )"> x </button></td>
		</tr>
		</table>
	  </td>
    </tr>
    <tr> 
      <td>XSL file:</td>
      <td>
		<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td><div id="divAssociationXSL"></div></td>
			<td align="right"><button name="btErase" onclick="AscClickErase( 2 )"> x </button></td>
		</tr>
		</table>
	  </td>
    </tr>
    <tr> 
      <td>Shortcut Label:</td>
      <td> 
        <input type="text" name="shortcut" size="40" maxlength="200">
      </td>
    </tr>
    <tr> 
      <td>Language:</td>
      <td> 
		<%
		sList = oLanguage.XML
		If sList <> "" Then
			Call RenderXML( sList, Server.MapPath( "diag_association.xsl" ) )
		End If
		%>
      </td>
    </tr>
  </form>
  </table>
</div>
<script language="JScript">
// add this dialog to the controller
oControl.AddQueue( 'divAssociation' );

// handles association save
function AscClickSave( oForm ) {
	var oFormFinal = document.formExplorer;
	if ( !oFormFinal || !oForm ) { return false }
	
	if ( oForm.shortcut.value == '' ) {
		alert( 'Insert a valid shortcut.' );
		return false;
	}
	
	if ( ( oFormFinal.association_xml.value == '' ) || ( oFormFinal.association_xsl.value == '' ) ) {
		alert( 'Associate files first.' );
		return false;
	}
	
	oFormFinal.languageID.value = oForm.languageCombo.value;
	oFormFinal.param.value = oForm.shortcut.value;
	oFormFinal.operation.value = 'associate';
	oFormFinal.submit();
	return true;
}

// erase the content
function AscClickErase( intField ) {
	var oFormFinal = document.formExplorer;
	if ( !oFormFinal ) { return false }

	if ( intField == 1 ) {
		oFormFinal.root_xml.value = '';
		oFormFinal.association_xml.value = '';
		document.all( 'divAssociationXML' ).innerText = '';
	} else {
		oFormFinal.root_xsl.value = '';
		oFormFinal.association_xsl.value = '';
		document.all( 'divAssociationXSL' ).innerText = '';
	}
}

// refreshes the association box
function RefreshAssociation() {
	var oForm = document.formExplorer;
	if ( !oForm ) {
		return false;
	}
	var sTmp = oForm.association_xml.value.replace( globalRoot, '' );
	if ( sTmp.length > 45 ) {
		sTmp = '...' + sTmp.substring( sTmp.length - 50, sTmp.length );
	}
	document.all( 'divAssociationXML' ).innerText = sTmp;
	
	sTmp = oForm.association_xsl.value.replace( globalRoot, '' );
	if ( sTmp.length > 45 ) {
		sTmp = '...' + sTmp.substring( sTmp.length - 50, sTmp.length );
	}
	document.all( 'divAssociationXSL' ).innerText = sTmp;
}

// event handler for operation dialog box event
function AscClickOperation() {
	var oFormFinal = document.formExplorer;
	if ( !oFormFinal ) { return false }
	
	if ( globalRoot == '' ) {
		alert( 'Can\'t do nothing in this point' );
		return false;
	}
	
	if ( eventFolder ) {
		alert( 'Can\'t do shortcuts with folders.' );
		return false;
	}
	
	if ( eventPath.indexOf( '.xml' ) > -1 ) {
		oFormFinal.root_xml.value = globalRoot;
		oFormFinal.association_xml.value = eventPath;
	} else {
		oFormFinal.root_xsl.value = globalRoot;
		oFormFinal.association_xsl.value = eventPath;
	}
	
	// if there´s the association dialog, then call it´s refresh procedure
	RefreshAssociation();
	oControl.Get( 'divAssociation' ).Show();
}
</script>
