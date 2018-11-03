<!-- #include file="../incs/inc_constructor.asp" -->
<%
Dim oRS

Set oRS = Server.CreateObject( "ADODB.Recordset" )
oRS.ActiveConnection = oConn
oRS.CursorLocation = 3
oRS.LockType = 3
oRS.CursorType = 3
oRS.Open "select folder_id, path from tbXML_Folders where root_id is null"
If Not oRS.EOF Then
	aRoots = oRS.GetRows()
End If
oRS.Close
Set oRS = Nothing

If IsNull( oLanguage ) Then
	Set oLanguage = Server.CreateObject( "PSNXML.TXMLLanguage" )
	oLanguage.ActiveConnection = oConn
	If Request.ServerVariables( "HTTP_HOST" ) = "akita2" Then
		oLanguage.Oracle = False
	End If
End If

' handles possible inserts
If Request( "seed" ) = Session( "seed" ) Then
	Dim sError
	sError = ""
	Select Case Request( "command" )
	Case "add" :
		If Not oLanguage.Add( Request( "label" ), Request( "shortlabel" ) ) Then
			sError = "[ error while inserting ]"
		End If
	Case "update" :
		If Not oLanguage.SetCommon( Request( "common" ) ) Then
			sError = "[ error while setting common ]"
		End If
	Case "delete" :
		If Not oLanguage.Delete( Request( "delete" ) ) Then
			sError = "[ error while deleting ]"
		End If	
	End Select
	If sError <> "" Then
		Response.Write "<tr><td colspan=""3"">" & sError & "</td></tr>" & vbCRLF
	End If
End If

' form seed
Randomize
Session( "seed" ) = CStr( Round( Rnd * 20000 ) )
%>
<html>
<title>XML Tools - Language Configuration</title>
<link rel="stylesheet" href="../styles.css">
<body>

<table width="600" border="0" cellspacing="0">
<form name="formAdd" method="POST" action="setup_languages.asp">
<input type="hidden" name="seed" value="<%=Session( "seed" )%>">
<input type="hidden" name="command" value="add">
	<tr class="boxtitle">
		<td colspan="3" class="boxtitle">XML Tools - Language Configuration</td>
		<td align="right"><button onclick="formAdd.submit()"> Add </button>
	</tr>
	<tr>
		<td>Language Name</td>
		<td><input type="text" name="label" value="<%=Request( "label" )%>"></td>
		<td>Short Name</td>
		<td><input type="text" name="shortlabel" value="<%=Request( "shortlabel" )%>"></td>
	</tr>
</form>
</table>

<%
' shows a list of available languages
Dim sList
sList = oLanguage.XML
If sList <> "" Then
%>
	<br>
	<table width="600" border="0" cellspacing="0">
	<form name="formUpdate" method="POST" action="setup_languages.asp">
	<input type="hidden" name="seed" value="<%=Session( "seed" )%>">
	<input type="hidden" name="command" value="update">
		<tr class="boxtitle">
			<td class="boxtitle">Label</td>
			<td class="boxtitle">Short Label</td>
			<td align="center"><button onclick="formUpdate.submit()">Update</button></td>
			<td align="center"><button onclick="formUpdate.command.value='delete'; formUpdate.submit()">Delete</button></td>
		</tr>
	<%
	Call RenderXML( sList, Server.MapPath( "setup_languages.xsl" ) )
	%>
	</form>
	</table>
<%
End If
%>
<br>
<table width="600" border="0" cellspacing="0">
	<tr>
		<td>
		Warning: be very careful while managing languages as 
		all modules of this system depends on them.
		Also notice that the "common" language is the 
		language-independent modifier, which means that one folder
		can be assigned as a language-independent storage. 
		In this case, events created to be "common" will have
		the XML in the common folder and the styles in the 
		other language-dependent folders.
		</td>
	</tr>
</table>
</body>
</html>
<!-- #include file="../incs/inc_destructor.asp" -->