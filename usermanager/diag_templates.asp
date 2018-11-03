<div id="divTemplates" style="position:absolute; visibility: hidden; width:280px; height:50px; z-index:1; left: 34px; top: 373px" class="floatingbox"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="1">
  <form name="formTemplates">
    <tr> 
      <td class="dragtitle" colspan="2"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="boxtitle">-- Clone Template</td>
            <td align="right">
            <button name="btCreate" onclick="TemplateClickCreate( this.form )"> Execute </button>
            <button name="btCancel" onclick="oControl.Get('divTemplates').Hide()"> X </button>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
		<td>&nbsp;New Event Name: </td>
		<td><input type="text" name="label" size="20" maxlength="50"></td>
	</tr>
    <tr>
		<td>&nbsp;Location: </td>
		<td>
		<select name="root">
			<option value="">All</option>
			<%
			Call oSynchro.GetRoots( sList )
			Call RenderXML( sList, Server.MapPath( "diag_templates.xsl" ) )
			%>
		</select>
		</td>
	</tr>
    <tr>
		<td colspan="2">&nbsp;<input type="checkbox" value="1" name="overwrite" onfocus="ExplainOverwrite()"> Overwrite existing front-end? </td>
	</tr>
  </form>
  </table>

</div>
<script language="JScript">
// add this dialog to the controller
oControl.AddQueue( 'divTemplates' );

// handles the window show event
function TemplateClickOpen() {
	oControl.Get( 'divTemplates' ).Show();
}

// send the clone template command
function TemplateClickCreate( oForm ) {
	var oPath = oForm.root.options[ oForm.root.selectedIndex ];
	
	if ( !window.confirm( 'Are you sure you make this event in the ' + oPath.text.toUpperCase() + ' folder?' ) )
		return;
		
	var oFormFinal = document.all( "formExplorer" );
	if ( !oForm || !oFormFinal ) { return }
	
	if ( oForm.label.value == '' ) {
		alert( 'Fill in the name of the new Event' );
		return;
	}

	oFormFinal.operation.value = 'clonetemplate';
	oFormFinal.param.value = oForm.label.value + '||' + oPath.text + '||' + oPath.value;
	oFormFinal.submit();
}

function ExplainOverwrite() {
	alert( 'Understand that checking this box on will \noverwrite the styles (interface, front-end) \nof this event if it already exists' );
}
</script>
