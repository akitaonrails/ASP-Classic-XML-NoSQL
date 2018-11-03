<!-- #include file="../incs/inc_constructor.asp" -->
<%
' get form parameters
Dim sRoot, sPath, sEditor, sDescription, sAuthor, sResponsible, sOperation
Dim sAssociationXML, sAssociationXSL, sAssociationSchema
Dim sRootXML, sRootXSL, sRootSchema
Dim sParam, hasForm
Dim sSource, sXSLFile, sDescriptionFile
Dim intCount
Dim sErrors
Dim hasImport

hasImport = False

sErrors = ""
sSource = ""
sXSLFile = Server.MapPath( "explorer_list.xsl" )
sDescriptionFile = Server.MapPath( "description.xsl" )

hasForm = False
sRoot = ""
sPath = ""
sDescription = ""
sAuthor = ""
sResponsible = ""
sOperation = ""
sParam = ""

'If Request( "seed" ) = Session( "seed" ) Then
If Not IsNull( Request( "seed" ) ) and Not IsNull( Session( "seed" ) ) Then
	hasForm = True
	sRoot			= Request( "root" )
	sPath			= Request( "path" )
	sDescription	= Request( "description" )
	sAuthor			= Request( "author" )
	sResponsible	= Request( "responsible" )
	sOperation		= Request( "operation" )
	sParam			= Request( "param" )
	sEditor			= Request( "editor" )
	sAssociationXML	= Request( "association_xml" )
	sAssociationXSL	= Request( "association_xsl" )
	sAssociationSchema = Request( "association_schema" )
	sRootXML	= Request( "root_xml" )
	sRootXSL	= Request( "root_xsl" )
	sRootSchema = Request( "root_schema" )
	sLanguageID = Request( "languageID" )
	
	Select Case sOperation
	Case ""
		hasForm = False
	Case "setroot"
		' set the root folder
		' -- sParam is the root path
		oSynchro.Root = sParam
	Case "openfolder" 
		' dive into the folder
		' -- sParam is the new folder (complete path)
		oSynchro.Root = sRoot
		oSynchro.Path = sParam
	Case "goparent"
		oSynchro.Root = sRoot
		oSynchro.Path = sPath
		oSynchro.GoParent
	Case "newfolder"
		' create a new folder
		' -- sParam is the new folder (relative path)
		sParam = Trim( sParam )
		sParam = Replace( sParam, "/", "", 1, -1 )
		sParam = Replace( sParam, "\", "", 1, -1 )
		
		oSynchro.Root = sRoot
		oSynchro.Path = sPath & "\" & sParam
		If Not oSynchro.CreateFolder( sDescription ) Then
			sErrors = sErrors & "<error>Failed to create a new folder</error>"
		End If
		oSynchro.GoParent
	Case "newfile"
		' create a new file
		' -- sParam is the new filename (relative path)
		sParam = Trim( sParam )
		sParam = Replace( sParam, "/", "", 1, -1 )
		sParam = Replace( sParam, "\", "", 1, -1 )
		
		oSynchro.Root = sRoot
		oSynchro.Path = sPath & "\" & sParam
		If Not oSynchro.CreateFile( sAuthor, sDescription, sResponsible, null, null ) Then
			sErrors = sErrors & "<error>Failed to create a new file</error>"
		End IF
	Case "deletefolder"
		' -- sParam is the folder to delete (complete path)
		oSynchro.Root = sRoot
		oSynchro.Path = sParam
		If Not oSynchro.DeleteFolder() Then
			sErrors = sErrors & "<error>Failed to delete the folder</error>"
		End If
	Case "deletefile"
		' -- sParam is the file to delete (complete path)
		oSynchro.Root = sRoot
		oSynchro.Path = sParam

		If Not oSynchro.DeleteFile() Then
			sErrors = sErrors & "<error>Failed to delete the file</error>"
		End If
	Case "associate"
		Dim oAssociation
		Set oAssociation = Server.CreateObject( "PSNXML.TXMLSynchro" )
		oAssociation.Oracle = oSynchro.Oracle
		oAssociation.Connect oFS, oConn
		
		oSynchro.Root = sRootXML
		oAssociation.Root = sRootXSL
		
		oSynchro.Path = sAssociationXML
		oAssociation.Path = sAssociationXSL

		oSynchro.LanguageID = sLanguageID

		If Not oSynchro.CreateShortcut( sParam, oAssociation ) Then
			sErrors = sErrors & "<error>Failed to create the shortcut!</error>"
		End If
		
		oSynchro.Path = sPath
		Set oAssociation = Nothing
	Case "savefile"
		oSynchro.Root = sRoot
		oSynchro.Path = sParam
		If Not oSynchro.WriteFile( sEditor ) Then
			sErrors = sErrors & "<error>Failed to write down the file!</error>"
		End If
	Case "baselink"
		' create new synchro objects to get style and schema IDs
		Dim oStyle, oSchema
		oStyle = null
		oSchema = null
		
		oSynchro.Root = sRootXML
		oSynchro.Path = sAssociationXML
		
		If sAssociationXSL <> "" Then
			Set oStyle = Server.CreateObject( "PSNXML.TXMLSynchro" )
			oStyle.Oracle = oSynchro.Oracle
			oStyle.Connect oFS, oConn
			oStyle.Root = sRootXSL
			oStyle.Path = sAssociationXSL
		End If
		
		If sAssociationSchema <> "" Then
			Set oSchema = Server.CreateObject( "PSNXML.TXMLSynchro" )
			oSchema.Oracle = oSynchro.Oracle
			oSchema.Connect oFS, oConn
			oSchema.Root = sRootSchema
			oSchema.Path = sAssociationSchema
		End If

		' make the association
		If Not oSynchro.CreateBaseLink( oStyle, oSchema ) Then
			sErrors = sErrors & "<error>Failed to associate the Schema File and XSL to the base XML file</error>"
		End If

		' clean up
		Set oStyle = Nothing
		Set oSchema = Nothing
	Case "export"
		oSynchro.Root = sRoot
		oSynchro.Path = sPath

		Dim sExport
		If sParam = "1" Then
			sParam = True
		Else
			sParam = False
		End If

		If Not oSynchro.ExportFiles( sExport, sParam ) Then
			sErrors = sErrors & "<error>Failed to export the files from this folder</error>"
		Else
			oSynchro.Path = ".export_script.xml"
			If oSynchro.CreateFile( "export generator", "export script", "export generator", null, null ) Then
				If Not oSynchro.WriteFile( sExport ) Then
					sErrors = sErrors & "<error>Error writing export script " & oSynchro.Path & "</error>"
				End If
			End If
		End If
	Case "import"
		oSynchro.Root = sRoot
		oSynchro.Path = sPath

		Dim sImport
		If sParam = "1" Then
			sParam = True
		Else
			sParam = False
		End If
		
		oSynchro.Path = ".export_script.xml"
		If oSynchro.ReadFile( sImport ) Then
			If Not oSynchro.ImportFiles( sImport, sParam ) Then
				sErrors = sErrors & "Error creating files imported from export file. Aborted at: " & oSynchro.Path 
			End If
		Else
			sErrors = sErrors & "<error>File .export_script.xml not found</error>"
		End If
	End Select
	
	' update the current valid client side root and local path	
	sRoot = oSynchro.Root
	sPath = Replace( oSynchro.Path, sRoot, "" )
	sPath = Replace( sPath, oSynchro.File, "" )
End IF

' generate random form seed
Randomize
Session( "seed" ) = cStr( Round( Rnd * 20000 ) )
%>
<html xmlns:msie>
<script language="JScript">

// configuration
var globalRoot = '<%=Replace( sRoot, "\", "/", 1, -1 )%>';
var globalPath = '<%=Replace( sPath, "\", "/", 1, -1 )%>';
var globalURL = '<%=oSynchro.RootURL%>';

// event state
var eventClicked = false;
var eventFolder = false;
var eventPath = '';

// generic folder/file click event
function GenericClick( sPath, isFolder ) {
	eventFolder = isFolder;
	eventClicked = true;
	eventPath = sPath;
	if ( eventPath != '..' ) {
		oControl.Get( 'divOperations' ).Show();
	} else {
		OpClickOpen();
	}
}

// event handler for folders
function ClickFolder( sPath ) {
	GenericClick( sPath, true );
}

// event handler for files
function ClickFile( sPath ) {
	GenericClick( sPath, false );
}

// export files
function Export() {
	if ( window.confirm( "Do you want to copy\nthe content of each file also?" ) ) {
		formExplorer.param.value = 1;
	} else {
		formExplorer.param.value = 0;
	}
	formExplorer.operation.value = 'export';
	formExplorer.submit();
}

// import files
function Import() {
	if ( window.confirm( "Do you want to overwrite\nthe content of existing files?" ) ) {
		formExplorer.param.value = 1;
	} else {
		formExplorer.param.value = 0;
	}
	formExplorer.operation.value = 'import';
	formExplorer.submit();
}

// instantiates the global controller
var oControl  = new TDialogControl();
//--></script>
<link rel="stylesheet" href="../styles.css">
<body onload = "oControl.RunQueue()">
<p class="maintitle">XML Tools - Content Manager for Developers</p>

<table width="600" border="0" cellspacing="0" cellpadding="1">
  <tr> 
    <td class="boxtitle">Name</td>
    <td class="boxtitle" align="right">Size</td>
    <td class="boxtitle" align="right">Creation</td>
    <td class="boxtitle" align="right">Last Modified</td>
  </tr>
<%
If sPath <> "" Then
	' show the parent link
	sSource = "<root><parent><path>[ " & sPath & ".. ]</path></parent></root>"
	Call RenderXML( sSource, sXSLFile )
End If

If not hasForm Then
	' first time, show the root folders as default
	Call oSynchro.GetRoots( sSource )
	If Len( sSource ) > 1 Then
		Call RenderXML( sSource, sXSLFile )
	Else
		Response.Write "<tr><td colspan=""4"" align=""center"">[ if nothing showed up, hit the <b>reload</b> button of your browser or press <b>F5</b> keyboard button. ]</td></tr>"
	End If
Else
	Dim isFoldersEmpty, isFilesEmpty
	isFoldersEmpty = False
	isFilesEmpty = False
	
	' show the current subfolders
	Call oSynchro.GetFolders( sSource )
	If Len( sSource ) > 1 Then
		Call RenderXML( sSource, sXSLFile )
	Else
		isFoldersEmpty = True
	End If

	' show the current files
	Call oSynchro.GetFiles( sSource )
	If Len( sSource ) > 1 Then
		' has import file?
		If InStr( sSource, ".export_script" ) Then
			hasImport = True
		End If

		Call RenderXML( sSource, sXSLFile )
	Else
		isFilesEmpty = True
	End If
	
	' folder empty?
	If isFoldersEmpty and isFilesEmpty Then
		Response.Write "<tr><td colspan=""4"" align=""center"">[ empty ]</td></tr>"
	End If
	
	' show the description, if any
	Call oSynchro.GetDescription( sSource )
	If sSource <> "" Then
		Call RenderXML( sSource, sDescriptionFile )
	End If
End If

If sRoot <> "" Then 
%>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>

  <tr> 
    <td colspan="4"> 
		<button name="btAddFolder" onclick="oControl.Get('divNewFolder').Show()">Add Folder</button> 
		<button name="btAddFile" onclick="oControl.Get('divNewFile').Show()">Add File</button>
		<button name="btAssociation" onclick="RefreshAssociation();oControl.Get('divAssociation').Show()">Shortcut</button>
		<button name="btBaseLink" onclick="RefreshBase();oControl.Get('divBase').Show()">Association</button>
		<button name="btExport" onclick="Export()">Export</button>
		<% If hasImport Then %>
		<button name="btImport" onclick="Import()">Import</button>
		<% End If %>
		<button name="btHelp" onclick="OpenHelp( 'divTools' )"> ? HELP </button> 
	</td>
  </tr>
<% 
End If 
%>
</table>

<!-- this form concentrates all the operation parameters -->
<form name="formExplorer" method="POST" action="explorer.asp">
	<input type="hidden" name="seed" value="<%=Session("seed")%>">
	<input type="hidden" name="root" value="<%=sRoot%>">
	<input type="hidden" name="path" value="<%=sPath%>">
	<input type="hidden" name="association_xml" value="<%=sAssociationXML%>">
	<input type="hidden" name="association_xsl" value="<%=sAssociationXSL%>">
	<input type="hidden" name="association_schema" value="<%=sAssociationSchema%>">
	<input type="hidden" name="root_xml" value="<%=sRootXML%>">
	<input type="hidden" name="root_xsl" value="<%=sRootXSL%>">
	<input type="hidden" name="root_schema" value="<%=sRootSchema%>">
	<input type="hidden" name="languageID" value="<%=sLanguageID%>">

	<input type="hidden" name="operation" value="">
	<input type="hidden" name="param" value="">
	<input type="hidden" name="description" value="">
	<input type="hidden" name="author" value="">
	<input type="hidden" name="responsible" value="">
	<input type="hidden" name="editor" value="">
	
</form>

<!-- #include file="inc_menu.asp" -->
<!-- #include file="../incs/inc_logs.asp" -->
</body>
</html>

<!-- 
DIALOG BOXES 
format:
	<div id='divName'>
		<form name="formName">
		</form>
	</div>
	<script>
		// handlers
	</script>
-->

<!-- #include file="diag_operations.asp" -->
<!-- #include file="diag_newfolder.asp" -->
<!-- #include file="diag_newfile.asp" -->
<!-- #include file="diag_association.asp" -->
<!-- #include file="diag_base.asp" -->
<!-- #include file="diag_editor.asp" -->
<!-- #include file="diag_checkxml.asp" -->

<!-- #include file="../incs/inc_destructor.asp" -->