<div id="divNewFolder" style="position:absolute; visibility: hidden; width:380px; height:100px; z-index:1; left: 33px; top: 430px" class="floatingbox"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="1">
  <form name="formNewFolder">
    <tr> 
        <td colspan="2" class="dragtitle"> 
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="boxtitle">-- New Folder</td>
            <td align="right"><button name="btSave" onclick="NFldClickSave( this.form )">Save</button> <button name="btCancel" onclick="oControl.Get('divNewFolder').Hide()"> X </button> 
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>Description:</td>
      <td> 
        <textarea name="description" cols="38"></textarea>
      </td>
    </tr>
    <tr> 
      <td>Path:</td>
      <td> 
        <input type="text" name="param" size="40" maxlength="255">
      </td>
    </tr>
  </form>
  </table>
</div>
<script language="JScript">
// add this dialog to the controller
oControl.AddQueue( 'divNewFolder' );

// handler
function NFldClickSave( oForm ) {
	var oFormFinal = document.formExplorer;
	if ( !oForm || !oFormFinal ) { return false }
	
	// this is the root, can´t create folders here
	if ( globalRoot == '' ) {
		alert( 'Can\'t create new folder here' );
		oControl.Get( 'divNewFolder' ).Hide();
		return false;
	}
	
	// validates description
	if ( oForm.description.value.length < 4 ) {
		alert( 'Fill in the description field' );
		oForm.description.focus();
		return false;
	}
	
	// pseudo-validates folder name
	var sFile = oForm.param.value;
	if ( ( sFile.length < 4 ) ||
		( sFile.indexOf( '/' ) > -1 ) ||
		( sFile.indexOf( '\\' ) > -1 ) ) {
		alert( 'This is a invalid folder name. Please correct it' );
		oForm.param.focus();
	}
	
	// set operation and submit
	oFormFinal.description.value = oForm.description.value;
	oFormFinal.param.value = oForm.param.value;
	oFormFinal.operation.value = 'newfolder';
	oFormFinal.submit();
}
</script>
