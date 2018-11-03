<!-- #include file="../incs/inc_constructor.asp" -->
<%
' handles the form operations
Function ExecuteForm()
	Dim sErrors
	sErrors = ""

	' delete operation of a root folder
	If Request( "operation" ) = "delete" Then
		oSynchro.Root = Request( "path" )
		If Not oSynchro.DeleteRoot() Then
			sErrors = sErrors & "<item>The deletion of the root has failed. Check if it doesn´t have elements inside it and if it indeed exists.</item>"
		Else
			Response.Redirect "setup_root.asp"
		End If
	End If

	' creation operation of a root folder
	If Request( "operation" ) = "create" Then
		If Not oSynchro.CreateRoot( Request( "path" ), Request( "url" ), Request( "description" ) ) Then
			sErrors = sErrors & "<item>The creation of the root has failed</item>" & vbCRLF
		Else
			Response.Redirect "setup_root.asp"
		End If
	End If

	' formats the xml root element
	ExecuteForm = ""
	If sErrors <> "" Then
		ExecuteForm = "<errors>" & vbCRLF & sErrors & "</errors>"
	End If
End Function

%>
<html>
<script language="JScript"><!--
// handles the formNew submit
function SendNew( oForm ) {
	// check object consistency
	if ( !oForm ) { 
		alert( 'Form doesn\'t exist. Try to reload this page and try again.' );
		return false;
	}
	
	// check description of the root folder
	if ( oForm.description.value.length < 3 ) {
		alert( 'Please, insert a short description' );
		return false;
	}
	
	// pseudo-check the path of the root folder
	var sPath = oForm.path.value;
	if ( (sPath.length < 4) || (sPath.indexOf( ':' ) == -1) || (sPath.indexOf( '\\' ) == -1) ) {
		alert( 'Please, insert a valid complete path' );
		return false;
	}
	
	// no errors until here: submit the form
	oForm.submit();
	return true;
}


var sDelPath = '';	// the path that the user will confirm to delete

// path clicked: set the global above and ask confirmation
function OpenOperation( sPath ) {
	sDelPath = sPath.replace( /\//gi, '\\' );
	oControl.Get('divOperations').Show();
}

// instantiates the global controller
var oControl  = new TDialogControl();
//--></script>
<link rel="stylesheet" href="../styles.css">
<body onload = "oControl.RunQueue()">
<%
' Execute Form operations and print errors
Call RenderXML( ExecuteForm(), Server.MapPath( "setup_errors.xsl" ) )

' print current registered root folders
Dim sRoots
Call oSynchro.GetRoots( sRoots )
Call RenderXML( sRoots, Server.MapPath( "setup_list.xsl" ) )
%>
<table width="600" border="0" cellspacing="0" cellpadding="1">
<form name="formNew" action="setup_root.asp" method="post">
<input type="hidden" name="operation" value="create">
    <tr> 
      <td colspan="2" class="boxtitle">Creation of a Root Folder</td>
    </tr>
    <tr> 
      <td>Complete Physical Path:</td>
      <td> 
        <input type="text" name="path" size="60" maxlength="255">
      </td>
    </tr>
    <tr> 
      <td>URL Translation (*):</td>
      <td> 
        <input type="text" name="url" size="60" maxlength="255">
      </td>
    </tr>
    <tr> 
      <td>Short Description:</td>
      <td> 
        <input type="text" name="description" size="60" maxlength="1000">
      </td>
    </tr>
    <tr> 
      <td height="14">&nbsp;</td>
      <td height="14"> 
        <button name="btAdd" onclick="SendNew( this.form )">Add New</button>
        <button name="btHelp" onclick="OpenHelp( 'divRoot' )">? HELP</button>
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2"><i>(*) the root folder must be visible from a URL. 
      <br>Don´t use "http://". For example, instead of writing "http://yourserver/folder1/folder2", 
      simply write "/folder1/folder2" down.</i></td>
    </tr>
    <tr> 
      <td colspan="2"><i>(**)In order to use the templates system you must define at least 2 system
      level folders: one named "common" and another named "templates"</i></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
</form>
</table>

<form name="formExplorer" method="POST" action="explorer.asp" target="_top"></form>

</body>
</html>

<!-- #include file="diag_setup.asp" -->
<!-- #include file="../incs/inc_destructor.asp" -->