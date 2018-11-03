<!-- Container frame -->
<div id="divContainer" style="position:absolute; visibility: hidden; width:450px; height:150px; z-index:2; left: 10px; top: 10px" class="floatingbox"> 
  <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="1">
    <tr> 
      <td class="dragtitle" height="25"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td id="containerTitle" class="boxtitle">-- Properties</td>
            <td align="right">
            <button name="btContainerCancel" onclick="CtCloseDialog()"> X </button>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td> 
      <iframe id="rootProperty" src="setup_property.asp" width="100%" height="100%"></iframe>
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
	var oContainer = oControl.Get( 'divContainer' );
	oContainer.Show();
	oContainer.layer.document.all( 'rootProperty' ).src = 'setup_property.asp?path=' + sURL
}

function CtCloseDialog() {
	oControl.Get('divContainer').Hide();
}
</script>

<!-- Operations frame -->
<div id="divOperations" style="position:absolute; visibility: hidden; width:80px; height:30px; z-index:1; left: 22px; top: 239px" class="floatingbox"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="1">
  <form name="formList" action="setup.asp" method="post">
	<input type="hidden" name="operation" value="delete">
	<input type="hidden" name="path" value="">
    <tr> 
      <td class="boxtitle"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="boxtitle">-- Operations</td>
            <td align="right">
            <button name="btCancel" onclick="oControl.Get('divOperations').Hide()"> X </button>
            </td>
		  </tr>
		  <tr>
		    <td colspan="2">
			<table border="0" cellpadding="0" cellspacing="0">
				<td align="right">
				<button name="btInfo" onclick="GetInfo( this.form )"> Get Properties </button>
				<button name="btDelete" onclick="SendDelete( this.form )"> Delete </button> 
				</td>
			</table>
			</td>
          </tr>
        </table>
      </td>
    </tr>
  </form>
  </table>
</div>
<script language="JScript">
oControl.AddQueue( 'divOperations' );

// users confirms to delete
function SendDelete( oForm ) {
	if ( !oForm ) { 
		alert( 'Form doesn\'t exist. Try to reload this page and try again.' );
		return false;
	}

	if ( (sDelPath.length < 4) || (sDelPath.indexOf( ':' ) == -1) || (sDelPath.indexOf( '\\' ) == -1) ) {
		alert( 'This is not a valid form. Try to reload this page and try again.' );
		return false;
	}

	if ( window.confirm( 'Do you REALLY confirm this Delete operation?' ) ) {
		oForm.path.value = sDelPath;
		oForm.submit();
		return true;
	} else {
		return false;
	}
}

// get info handler
function GetInfo( oForm ) {
	CtOpenModule( sDelPath );
}
</script>
