<div id="divContainer" style="position:absolute; visibility: hidden; width:700px; height:500px; z-index:1; left: 10px; top: 10px" class="floatingbox"> 
  <table width="100%" height="500" border="0" cellspacing="0" cellpadding="1">
    <tr> 
      <td class="dragtitle" height="25"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td id="containerTitle" class="boxtitle">-- Container</td>
            <td align="right">
            <button name="btContainerSave" onclick="CtSave()">Save</button>
            <button name="btContainerCancel" onclick="CtCloseDialog()"> X </button>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td> 
      <iframe id="frameEditor" src="frame_loader.asp" width="100%" height="100%"></iframe>
      </td>
    </tr>
  </form>
  </table>
</div>
<script language="JScript">
// add this dialog to the controller
oControl.AddQueue( 'divContainer' );

// handle the container window
function CtOpenModule( sURL ) {
	with ( oControl.Get( 'divContainer' ) ) {
		Show();
		Move( 15, 15 );
	}
}

// handle the save operation: expects a getSource() method in the external module
function CtSave() {
	var oForm = document.formExplorer;
	if ( !oForm ) { return false }
	
	with ( oForm ) {
		try {
			editor.value = frameEditor.getSource();
			if ( editor.value != '' ) {
				operation.value = 'save';
				param.value = eventPath;
				submit();
			}
		} catch( e ) {
			alert( 'CtSave: ' + e.description );
		}
	}
	return true;
}

function CtCloseDialog() {
	document.all( 'frameEditor' ).src = 'frame_loader.asp';
	oControl.Get('divContainer').Hide();
}
</script>