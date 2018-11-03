<!-- #include file="../../incs/inc_constructor.asp" -->
<%
Dim isOK
Dim sErrors

isOK = False
sErrors = ""
If Request( "seedmodule" ) = Session( "seedmodule" ) Then
	' gets the user configurations
	Dim oClone
	Dim sRoot, sPath, sXML, sModuleFolder, sModuleStarter, sCloneFile, sNewPath
	Dim iStyleID, iSchemaID
	
	' get the form values
	sRoot = Request( "synchroRoot" )
	sPath = Request( "synchroPath" )
	sXML = Request( "xmlfile" )
	sModuleFolder = Request( "modulefolder" )
	sModuleStarter = Request( "modulestarter" )
	sCloneFile = Request( "clonefilename" )
	sOverwrite = Request( "overwrite" )
	
	' set path
	sNewPath =  Left( sPath, InStrRev( sPath, "/" ) ) & _
		sCloneFile & _
		Mid( sPath, InStrRev( sPath, "." ), Len( sPath ) )
		
	If sPath <> sNewPath Then
		' set the synchro object
		oSynchro.Root = sRoot
		oSynchro.Path = sPath

		' check if overwrite or not
		If oFS.FileExists( oSynchro.Path ) and sOverwrite = "0" Then
			sErrors = "File already Exists. Cloning operation failed." 
		End If

		If sErrors = "" Then
			' set the copy object
			Set oClone = Server.CreateObject( "PSNXML.TXMLSynchro" )
	
			oClone.Connect oFS, oConn
			oClone.Oracle = oSynchro.Oracle
			oClone.Root = sRoot
			oClone.Path = sNewPath 
		
			iStyleID = oSynchro.StyleID
			iSchemaID = oSynchro.SchemaiD

			' make the copy		
			If Not oClone.CreateFile( oSynchro.FileInfo( "description" ), oSynchro.FileInfo( "author" ), oSynchro.FileInfo( "responsible" ), iStyleID, iSchemaID ) Then
				sErrors = "Error in the creation process. Please Try Again."
			Else
				Dim sSource
				Call oSynchro.ReadFile( sSource )
				If oClone.WriteFile( sSource ) Then
					isOK = True
				End If
			End If
	
			Set oClone = Nothing
		End If
	End If
End If

%>

<html>
<head>
<title>Simple Table Editor</title>
<link rel="stylesheet" href="../../styles.css">
<script language="JScript">
function OnUnLoad() {
	if ( parent ) {
		with( parent.formExplorer ) {
			operation.value = 'openfolder';
			submit();
		}
	}
}
</script>
</head>
<body onunload="OnUnLoad()">

<table width="100%" border="0" cellpadding="0" cellspacing="0" style="floatingbox">
<tr>
	<td class="boxtitle"> :: File Cloner</td>
</tr>
<tr>
	<td align="center">
	<% If isOK Then %>
		Operation successful -- close this box.
	<% Else %>
		Operation Failed -- <%=sErrors%> <br><a href="javascript:history.go(-1)">Click here to go Back</a>.
	<% End If %>
	</td>
</tr>
</table>

</body>
</html>
<!-- #include file="../../incs/inc_destructor.asp" -->