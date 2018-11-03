<!-- #include file="../incs/inc_constructor.asp" -->
<%
Dim sListClip, sListUnclip, sClipList, sRootPath
sRootPath = Request( "root_path" )
sListClip = ""
sListUnclip = ""
sClipList = ""
If Request( "seed_event" ) = Session( "seed_event" ) and Not IsEmpty( sRootPath ) Then
	' handles possible inserts
	Dim sErrors
	sErrors = ""

	Dim oEvents
	Set oEvents = Server.CreateObject( "PSNXML.TXMLEvents" )
	oEvents.ActiveConnection = oConn
	oEvents.ActiveSynchro = oSynchro
	oEvents.ActiveXML = oXML
	oEvents.Oracle = oSynchro.Oracle

	oSynchro.Root = sRootPath

	If Request( "command" ) = "manage" and Not IsNull( oSynchro.RootID ) Then
		' manage clip and unclip events
		If Not IsEmpty( Request( "unclip" ) ) Then
			If Not oEvents.ClipEvents( Request( "label" ), oSynchro.RootID, Request( "unclip" ) ) Then
				sErrors = sErrors & "[ Failed clipping events ]" & vbCRLF
			End IF
		End If
		If Not IsEmpty( Request( "clip" ) ) Then
			If Not oEvents.UnclipEvents( Request( "label" ), oSynchro.RootID, Request( "clip" ) ) Then
				sErrors = sErrors & "[ Failed unclipping events ]" & vbCRLF
			End IF
		End If
	End If

	' list current clipped and unclipped events	
	If Not IsNull( oSynchro.RootID ) Then
		If Trim( Request( "label" ) ) = "" Then
			sClipList = oEvents.ClipList( oSynchro.RootID )
		Else
			sListClip = oEvents.ListClipped( Request( "label" ), oSynchro.RootID )
			sListUnclip = oEvents.ListUnclipped( Request( "label" ), oSynchro.RootID )
		End If
	End If
	sErrors = sErrors & vbCRLF & oEvents.Log
	
	Set oEvents = Nothing
End If

' form seed
Randomize
Session( "seed_event" ) = CStr( Round( Rnd * 20000 ) )
%>
<html>
<title>XML Tools - Events Manager</title>
<script language="Jscript">
var sSelectedRoot = '<%=Replace( sRootPath, "\", "\\", 1, -1 )%>';
function SetRootCombo() {
	var oCombo = document.all( 'rootpath' );
	if ( oCombo ) {
		for ( var i = 0; i < oCombo.length; i++ )
			if ( oCombo[ i ].value = sSelectedRoot )
				oCombo[ i ].selected = true;
	}
}
function SelectAll( sCheck ) {
	for ( var i = 0; i < document.all( 'formEventsClip' ).elements.length; i++ ) {
		var oElement = document.all( 'formEventsClip' ).elements[ i ];
		if ( oElement.type == 'checkbox' && oElement.name == sCheck ) {
			oElement.checked = oElement.checked ? false : true;
		}
	}
}
</script>
<link rel="stylesheet" href="../styles.css">
<body onload="SetRootCombo()">

<table width="400" border="0" cellspacing="0">
<form name="formEventsSearch" method="POST" action="eventslist.asp">
<input type="hidden" name="seed_event" value="<%=Session( "seed_event" )%>">
<input type="hidden" name="command" value="search">
	<tr class="boxtitle">
		<td class="boxtitle">XML Tools - Events Manager</td>
		<td align="right">
		<%
		If sClipList <> "" Then
		%>
		<button onclick="self.location='eventslist.asp'"> Try Again </button>
		<%
		End If
		%>
		<button onclick="formEventsSearch.submit()"> Search </button>
		</td>
	</tr>
	<tr>
		<td colspan="2">
		<table border="0" width="100%">
			<tr valign="absmiddle">
				<td>Label: 
				<%
				If sClipList <> "" Then
					Call RenderXML( sClipList, Server.MapPath( "eventslist_labels.xsl" ) )
				Else
				%>
				<input type="text" name="label" value="<%=Request("label")%>">
				<%
				End If
				%>
				</td>
				<td align="right">Root: 
				<%
				Dim sListRoot
				Call oSynchro.GetRoots( sListRoot )
				Call RenderXML( sListRoot, Server.MapPath( "eventslist_roots.xsl" ) )
				%>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</form>
</table>

<br>

<% 
If sListClip <> "" or sListUnclip <> "" Then
%>
<table width="400" border="0" cellspacing="0">
<form name="formEventsClip" method="POST" action="eventslist.asp">
<input type="hidden" name="seed_event" value="<%=Session( "seed_event" )%>">
<input type="hidden" name="label" value="<%=Request( "label" )%>">
<input type="hidden" name="root_path" value="<%=sRootPath%>">
<input type="hidden" name="command" value="manage">
	<tr class="boxtitle">
		<td class="boxtitle">List of Events</td>
		<td align="right"><button onclick="formEventsClip.submit()"> Execute </button>
	</tr>
	<tr>
		<td colspan="2">
		<table width="100%" border="0">
			<tr valign="top">
				<td><b>Selected</b></td>
				<td><b>Available</b></td>
			</tr>
			<tr valign="top">
				<td width="50%">
				<%
				Call RenderXML( sListClip, Server.MapPath( "eventslist_clip.xsl" ) )
				%>
				</td>
				<td width="50%">
				<%
				Call RenderXML( sListUnclip, Server.MapPath( "eventslist_unclip.xsl" ) )
				%>
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td><button name="btClip" onclick="SelectAll( 'clip' )"> Inverse </button></td>
				<td><button name="btUnclip" onclick="SelectAll( 'unclip' )"> Inverse </button></td>
			</tr>
			<tr valign="top">
				<td>(choose above the events you want to deselect)</td>
				<td>(choose above the events you want to select)</td>
			</tr>
		</table>
		</td>
	</tr>
</form>
</table>
<br>
<%
End If
%>

<!-- #include file="../incs/inc_logs.asp" -->
</body>
</html>
<!-- #include file="../incs/inc_destructor.asp" -->