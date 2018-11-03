<div id="divEditor" style="position:absolute; visibility: hidden; width:380px; height:60px; z-index:1; left: 429px; top: 444px" class="floatingbox"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="1">
  <form name="formEditor">
    <tr> 
      <td class="dragtitle"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="boxtitle" id="EditorTitle">-- Raw File Edition</td>
            <td align="right"><button name="btSave" onclick="EdClickSave( this.form )">Save</button> <button name="btCancel" onclick="oControl.Get('divEditor').Hide()"> X </button> 
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td> 
        <textarea name="editor" cols="80" rows="20" wrap="OFF"></textarea>
      </td>
    </tr>
    <tr>
      <td>
		<%
		' load the module´s template list
		Call oXML.load( Server.MapPath( "../usermodules/modules.xml" ) )
		Call oXSL.load( Server.MapPath( "diag_editor.xsl" ) )
		oXML.transformNodeToObject oXSL, Response
		%>
        <button name="btResetXML" onclick="if( confirm( 'Are you sure to replace current content\nfor the selected Template on the left?' ) ) EditorReset( comboReset.value );">Use Template</button>
        <button name="btClearAll" onclick="if( confirm( 'Are you sure to erase all the content?' ) ) { EditorReset( '' ) }">Clear All</button>
      </td>
    </tr>
  </form>
  </table>
</div>

<msie:download id="oEditorXML" style="behavior:url(#default#download)" />

<script language="JScript">
// <html xmlns:msie> is necessary in the beggining of the document

// add this dialog to the controller
oControl.AddQueue( 'divEditor' );

// handler
function EdClickSave( oForm ) {
	var oFormFinal = document.formExplorer;
	if ( !oForm || !oFormFinal ) { return false }
	
	if ( eventPath == '' ) {
		alert( 'There\'s no file selected. Try again, please.' );
		return false;
	}
	
	with( oFormFinal ) {
		param.value = eventPath;
		editor.value = oForm.editor.value;
		operation.value = 'savefile';
		submit();
	}
	return true;
}
     
// load XML files
function EditorLoad( sPath ) {
	if ( sPath != '' ) {
		try {
			oEditorXML.startDownload( sPath, PrivateEditorRefresh );
		} catch( e ) {
			alert( 'EditorLoad: ' + e.description + '\n' + sPath );
		}
	}
}

// handler for EditorLoad
function PrivateEditorRefresh( sText ) {
	try {
		document.formEditor.editor.value = sText;
	} catch( e ) {
		alert( 'download callback: ' + e.description );
	}
}

// reset the state of the current document with templates
function EditorReset( sOption ) {
	if ( sOption == 'xml' ) {
		EditorLoad( 'explorer_reset.xml' );
	} else if ( sOption == 'xsl' ) {
		EditorLoad( 'explorer_reset.xsl' );
	} else if ( sOption == 'template' ) {
		EditorLoad( 'template_reset.xml' );
	} else if ( sOption != 'ignore' && sOption != '' ) {
		EditorLoad( '../usermodules/' + sOption );
	} else {
		PrivateEditorRefresh( '' )
	}
}

// open the file editor
function OpenEditor() {	
	oControl.Get( 'divEditor' ).Show();
	var sURL =  globalURL + '/' + eventPath.replace( globalRoot, '' );
	EditorLoad( sURL );
}
</script>
