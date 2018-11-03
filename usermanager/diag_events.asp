<div id="divEvents" style="position:absolute; visibility: hidden; width:450px; height:500px; z-index:1; left: 34px; top: 373px" class="floatingbox"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="1">
    <tr> 
      <td class="dragtitle"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="boxtitle">-- Manage Events</td>
            <td align="right">
            <button name="btCancel" onclick="oControl.Get('divEvents').Hide()"> X </button>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
		<td><iframe id="frameEvent" src="eventslist.asp" width="450" height="500"></iframe></td>
	</tr>
  </table>

</div>
<script language="JScript">
// add this dialog to the controller
oControl.AddQueue( 'divEvents' );

// handles the window show event
function EventsClickOpen() {
	oControl.Get( 'divEvents' ).Show();
	if ( document.all( 'frameEvent' ) )
		document.all( 'frameEvent' ).src = 'eventslist.asp';
}
</script>
