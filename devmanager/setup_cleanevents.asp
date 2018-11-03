<!-- #include file="../incs/inc_constructor.asp" -->
<%
Dim oEvents
Set oEvents = Server.CreateObject( "PSNXML.TXMLEvents" )
oEvents.ActiveConnection = oConn
oEvents.ActiveSynchro = oSynchro
oEvents.ActiveXML = oXML

If Request.ServerVariables( "HTTP_HOST" ) = "akita2" Then
	oEvents.Oracle = False
End If

' handles possible inserts
If Request( "seed" ) = Session( "seed" ) Then
	Dim sError
	sError = ""
	Select Case Request( "command" )
	Case "delete" :
		If Not oEvents.DeleteEvent( Request( "delete" ) ) Then
			sError = "[ error while deleting ]<br>" & oEvents.Log
		End If	
	End Select
	If sError <> "" Then
		Response.Write sError & vbCRLF
	End If
End If

' form seed
Randomize
Session( "seed" ) = CStr( Round( Rnd * 20000 ) )
%>
<html>
<title>XML Tools - Clean up Events</title>
<link rel="stylesheet" href="../styles.css">
<script language="JScript">
function ConfirmDelete() {
	if ( window.confirm( 'Confirm to delete the selected Event?' ) ) {
		formUpdate.command.value='delete'; 
		formUpdate.submit();
	}
}
</script>
<body>

<%
' shows a list of available languages
Dim sList
sList = oEvents.ListEvents
If sList <> "" Then
%>
<table width="600" border="0" cellspacing="0">
	<form name="formUpdate" method="POST" action="setup_cleanevents.asp">
	<input type="hidden" name="seed" value="<%=Session( "seed" )%>">
	<input type="hidden" name="command" value="update">

		<tr class="boxtitle">
			<td colspan="2" class="boxtitle">XML Tools - Clean Up Events</td>
		</tr>
		
		<tr><td colspan="2">&nbsp;</td></tr>
		
		<tr class="boxtitle">
			<td class="boxtitle">Label</td>
			<td align="center"><button onclick="ConfirmDelete()">Delete</button></td>
		</tr>
	<%
	Call RenderXML( sList, Server.MapPath( "setup_cleanevents.xsl" ) )
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
		Warning: This operation will erase all logical pointers for events.
		The folders and data will remain intact but all links through all the
		sites using this particular event will simply vanish away. You can
		recreate the event again the same way it was created in the first
		place, with the exact same event name. But it you simply want to clean
		up it, you still have to manually delete each event folder.
		</td>
	</tr>
</table>
</body>
</html>
<!-- #include file="../incs/inc_destructor.asp" -->