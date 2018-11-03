<div id="divEditBox" style="position:absolute; visibility: hidden; width:100px; height:50px; z-index:1; left: 10px; top: 10px" class="floatingbox"> 
	<table width="200" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td class="dragtitle"> :: node: </td>
		<td class="dragtitle"><div id="txtCoordinates">(-1,-1)</div></td>
		<td class="boxtitle" align="right">
		<button onclick="changeNode()" id="btReplace" disabled>Replace</button>
		<button onclick="oControl.Get('divEditBox').Hide()" id="btCloseEdit"> X </button></td>
	</tr>
	<tr>
		<td colspan="2"><input id="txtNode"></td>
	</tr>
	</table>
</div>
<script language="JScript">
// add this dialog to the controller
oControl.AddQueue( 'divEditBox' );
</script>
