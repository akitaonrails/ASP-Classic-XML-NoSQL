<div id="divShortcut" style="position:absolute; width:300px; height:100px; left: 0px; top: 0px; visibility: hidden; z-index:1" class="floatingbox"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="1">
  <form name="formShortcut">
  <input type="hidden" name="front_id" value="">
    <tr> 
      <td colspan="2" class="dragtitle"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="boxtitle">-- Rename</td>
            <td align="right"><button name="btSave" onclick="ShortClickRename( this.form )">Save</button> <button name="btCancel" onclick="oControl.Get('divShortcut').Hide()"> X </button></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>New Label:</td>
      <td> 
        <input type="text" name="label" size="20" maxlength="100">
      </td>
    </tr>
    <tr> 
      <td colspan="2">
        Be very careful with this feature: remember that if you rename a shortcut
        that is currently in use in any website, it will instantly stop working
        correctly. So you´re at your own risk. This feature is intended for brand-new
        shortcuts created with the wrong label.
      </td>
    </tr>
  </form>
  </table>
</div>
<script language="JScript">
// add this dialog to the controller
oControl.AddQueue( 'divShortcut' );

// handler for save operation
function ShortClickRename( oForm ) {
	var oFormFinal = document.formOperation;
	if ( !oForm || !oFormFinal ) { return }
	
	oFormFinal.command.value = 'rename';
	oFormFinal.front_id.value = oForm.front_id.value;
	oFormFinal.renamelabel.value = oForm.label.value;
	oFormFinal.submit();
}

// handler for open-dialog operation
function ShortClickOpen( oObj, iID ) {
	var oForm = document.all( 'formShortcut' );
	if ( oObj && oForm ) {
		oForm.front_id.value = iID;
		oForm.label.value = oObj.innerText;
		oControl.Get( 'divShortcut' ).Show();
	}
}
</script>