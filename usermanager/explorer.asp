<!-- #include file="../incs/inc_constructor.asp" -->
<%
' set for non-developer
oSynchro.HideDetails = True

' get form parameters
Dim sRoot, sPath, sParam, sOperation, hasForm
Dim sSource, sXSLFile
Dim intCount
Dim sDescriptionFile
Dim sOperationResult

sSource = ""
sXSLFile = Server.MapPath( "explorer_list.xsl" )
sDescriptionFile = Server.MapPath( "description.xsl" )

hasForm = False
sRoot = ""
sPath = ""

Dim hasTemplate, isTemplateFolder
hasTemplate = False
isTemplateFolder = False

If Not IsEmpty( Request( "seed" ) ) and Not IsEmpty( Session( "seed" ) ) Then
	sOperationResult = "Operation Completed Successfully"
	hasForm = True
	sRoot = Request( "root" )
	sPath = Request( "path" )
	sParam = Request( "param" )
	sEditor = Request( "editor" )
	sOperation = Request( "operation" )
	
	Select Case sOperation
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
	Case "save"
		oSynchro.Root = sRoot
		oSynchro.Path = sParam
		If Not InStr( sEditor, "encoding" ) Then
			sEditor = Replace( sEditor, """1.0""?>", """1.0"" encoding=""iso-8859-1""?>" )
		End If
		If Not oSynchro.WriteFile( sEditor ) Then
			sErrors = sErrors & "<error>Failed to write down the file!</error>"
			sOperationResult = "Operation Failed. Try to reload this page once."
		End If
	Case "clonetemplate"
		oSynchro.Root = sRoot
		oSynchro.Path = sPath & ".template.xml"

		Dim oEvents
		Set oEvents = Server.CreateObject( "PSNXML.TXMLEvents" )
		oEvents.ActiveConnection = oConn
		oEvents.ActiveSynchro = oSynchro
		oEvents.ActiveXML = oXML
		If Request.ServerVariables( "HTTP_HOST" ) = "akita2" Then
			oEvents.Oracle = False
		End If

		Dim aParam
		aParam = Split( sParam, "||" )
		
		If aParam( 2 ) <> "" Then
			Call oEvents.SetEventRoot( aParam( 1 ), aParam( 2 ) )
		End If
		If Not oEvents.CreateEvent( aParam( 0 ) ) Then
			sErrors = sErrors & "<error>Failed to create new Event from the chosen template</error>"
			sOperationResult = "Operation Failed. Try to reload this page once."
		End If
		sErrors = sErrors & vbCRLF & vbCRLF & oEvents.Log
		
		Set oEvents = Nothing

		' reset path		
		oSynchro.Root = sRoot
		oSynchro.Path = sPath & ".template.xml"
	End Select

	' update the current valid client side root and local path	
	sRoot = oSynchro.Root
	sPath = Replace( oSynchro.Path, sRoot, "" )
	sPath = Replace( sPath, oSynchro.File, "" )

	' check for templates
	hasTemplate = oFS.FileExists( oSynchro.Path & ".template.xml" ) 
	isTemplateFolder = ( InStr( oSynchro.Root, "template" ) > 0 )
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
	var oForm = document.formExplorer;
	if ( !oForm || eventClicked ) { 
		return false;
	}

	eventFolder = isFolder;
	eventClicked = true;
	eventPath = sPath;

	// handler for folder
	oForm.param.value = eventPath;
	if ( eventFolder ) {
		if ( globalRoot == '' ) {
			oForm.operation.value = 'setroot';
		} else if ( eventPath == '..' ) {
			oForm.operation.value = 'goparent';
		} else {
			oForm.operation.value = 'openfolder';
		}
		oForm.submit();
		return true;
	} else {
		oControl.Get( 'divOperations' ).Show();
	}
	eventClicked = false;
}

// event handler for folders
function ClickFolder( sPath ) {
	GenericClick( sPath, true );
}

// event handler for files
function ClickFile( sPath ) {
	GenericClick( sPath, false );
}

// instantiates the global controller
var oControl  = new TDialogControl(); 
//--></script>
<link rel="stylesheet" href="../styles.css">
<body onload = "oControl.RunQueue()">
<p class="maintitle">XML Tools - Content Manager for Content Staff</p>

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
		Response.Write "<tr><td colspan=""4"" align=""center"">[ if nothing showed up, hit the <b>reload</b> button of your browser or press <b>F5</b> ]</td></tr>"
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
%>
  <tr> 
    <td colspan="4" align="center">&nbsp;<%=sOperationResult%></td>
  </tr>
  <tr> 
    <td colspan="4"> 
		<% 
		If hasTemplate Then 
		%>
		<button name="btClone" onclick="TemplateClickOpen()"> NEW EVENT </button>
		<button name="btHelp" onclick="OpenHelp( 'divTemplate' )"> ? HELP </button>
		<% 
		ElseIf isTemplateFolder Then 
		%>
		<button name="btClone" onclick="EventsClickOpen()"> MANAGE EVENTS </button>  
		<button name="btHelp" onclick="OpenHelp( 'divEvents' )"> ? HELP </button>
		<% 
		Else 
		%>
		<button name="btHelp" onclick="OpenHelp( 'divConcepts' )"> ? HELP </button>  
		<% 
		End If 
		%>
		
	</td>
  </tr>
</table>

<!-- this form concentrates all the operation parameters -->
<form name="formExplorer" method="POST" action="explorer.asp">
	<input type="hidden" name="seed" value="<%=Session("seed")%>">
	<input type="hidden" name="root" value="<%=sRoot%>">
	<input type="hidden" name="path" value="<%=sPath%>">
	<input type="hidden" name="operation" value="">
	<input type="hidden" name="param" value="">
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
<!-- #include file="diag_container.asp" -->
<!-- #include file="diag_templates.asp" -->
<!-- #include file="diag_events.asp" -->

<!-- #include file="../incs/inc_destructor.asp" -->