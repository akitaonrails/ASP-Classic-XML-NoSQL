<br>
<script language="JScript">
function GoMain() {
	var oForm = document.formExplorer;
	if ( oForm ) {
		with( oForm ) {
			try {
				root.value = '';
				path.value = '';
				param.value = '';
				operation.value = '';
			} catch( e ) {
				alert( 'menu bug: ' + e.description );
			}
			submit();
		}
	} else {
		self.location = 'explorer.asp';
	}
}
</script>
<table border="0" width="600">
	<tr>
		<td colspan="2"><hr></td>
	</tr>
	<tr>
		<td>
		Development Staff: &nbsp;
		</td>
		<td>
		[ <a href="javascript:GoMain()">Content Explorer</a> ]
		[ <a href="setup.asp">Control Panel</a> ]
		</td>
	</tr>
	<tr>
		<td>
		Content Staff: &nbsp;
		</td>
		<td>
		[ <a href="../usermanager/explorer.asp">Content Manager</a> ]
		[ <a href="javascript:OpenCompatibility()">Check Compatibility</a> ]
		</td>
	</tr>
</table>
<br>