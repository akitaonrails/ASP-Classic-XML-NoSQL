<!-- #include file="../incs/inc_constructor.asp" -->
<!-- #include file="inc_shortcuts.asp" -->
<%
Call DefineQueries

Dim sSQL, sSQLDelete, sSQLUndelete, strResult, iPage
sSQL = ""		' global sql command storage
strResult = ""	' global error message storage

' current page from the recordset
iPage = Request( "page" )	
If Not IsNull( iPage ) and Not IsEmpty( iPage ) Then
	iPage = CInt( Request( "page" ) )
Else
	iPage = 1
End If

Select Case Request( "command" )
Case "search"
	' fetch the recordset from the query
	sSQL = Search()
	Response.Write "<!-- debug: " & sSQL & " -->"
Case "operation"
	' make undelete and delete operations in a batch
	sSQLUndelete = Replace( qUndelete, "%ids%", Request( "ids" ) )
	sSQLDelete = Replace( qDelete, "%ids%", Request( "deletelist" ) )
	
	Response.Write "<!-- debug: " & sSQLUndelete & " -->" & vbCRLF
	Response.Write "<!-- debug: " & sSQLDelete & " -->" & vbCRLF
	
	on error resume next
	oConn.BeginTrans
	oConn.Execute sSQLUndelete
	If ( Trim( Request( "deletelist" ) ) <> "" ) Then
		oConn.Execute sSQLDelete
	End If
	If oConn.Errors.Count <> 0 Then
		oConn.RollbackTrans
		strResult = "Erase/Unerase operation failed. Try again"
	Else
		oConn.CommitTrans
		strResult = "Successful Erase/Unerase operation"
	End If
	on error goto 0
Case "rename"
	Dim sNewLabel
	sNewLabel = LCase( Replace( Request( "renamelabel" ), "'", "" ) )
	sSQL = Replace( qRename, "%shortcut%", sNewLabel )
	sSQL = Replace( sSQL, "%id%", Request( "front_id" ) )
	Response.Write "<!-- debug: " & sSQL & " -->" & vbCRLF

	on error resume next
	oConn.BeginTrans
	oConn.Execute sSQL
	If oConn.Errors.Count <> 0 Then
		oConn.RollbackTrans
		strResult = "Rename operation failed. Try again"
	Else
		oConn.CommitTrans
		strResult = "Successful rename operation"
	End If
	on error goto 0
	
End Select
%>
<html>
<script language="JScript">
// perform erase/unerase operation
function SubmitErase( oForm ) {
	if ( oForm ) {
		if ( window.confirm( 'Are you sure about this set of operations?' ) ) {
			oForm.command.value = 'operation';
			oForm.submit();
		}
	}
}

// navigate from the pages in the current recordset
function SubmitPage( oForm, iPage ) {
	if ( oForm ) {
		oForm.command.value = 'search';
		oForm.page.value = iPage;
		oForm.submit();
	}
}

// mini-help for the search
function HelpSearch() {
	alert( 'You can use "+" and "-" commands to do better searches.\n' +
	' "+a +b" means "a AND b" \n' +
	' "+a -b" means "a AND NOT b" \n' +
	' "a b" means "a OR b" \n' +
	' "+a +\'b c\'" means "a AND \'b c\'" \n' +
	' "+a +b c" means "( a AND b ) OR c" \n' +
	' and so on.' );
}

// redirects to the explorer module
function ClickFolder( sRoot, sPath ) {
	if ( formExplorer ) {
		with( formExplorer ) {
			root.value = sRoot;
			param.value = sPath;
			operation.value = 'openfolder';
			submit();
		}
	}
}

// instantiates the global controller
var oControl  = new TDialogControl();
</script>
<link rel="stylesheet" href="../styles.css">
<body onload = "oControl.RunQueue()">
<p class="maintitle">XML Tools - Shortcut Manager</p>

 <table width="600" border="0" cellspacing="0" cellpadding="1">
 <form name="formSearch" method="POST" action="setup_shortcuts.asp">
 <input type="hidden" name="command" value="search">
 <input type="hidden" name="page" value="<%=iPage%>">
    <tr> 
      <td colspan="3" class="boxtitle">Search Box</td>
    </tr>
    <tr>
      <td>
      Language:
      <%
      Call RenderXML( sList, Server.MapPath( "setup_shortcuts.xsl" ) )
      %>
      </td>
      <td>Keywords: <input type="text" name="keywords" size="50" maxlength="200" value="<%=Request( "keywords" )%>">
      <button onclick="HelpSearch()"> &nbsp;?&nbsp; </button>
      </td>
      <td align="right">
		<button onclick="this.form.submit()">Submit</button>
	  </td>
	</tr>
	<tr>
	  <td colspan="3">
	  <table border="0" width="100%">
		<tr>
			<td>
			Search deleted files?
			<input type="radio" name="deleted" value="1"<%if ( Request( "deleted" ) = "1" ) Then Response.Write " checked" end If%>>Yes
			<input type="radio" name="deleted" value="0"<%if ( Request( "deleted" ) <> "1" ) Then Response.Write " checked" end If%>>No
			</td>
			<td align="right">
			Search descriptions of the files?
			<input type="radio" name="files" value="1"<%if ( Request( "files" ) = "1" ) Then Response.Write " checked" end If%>>Yes
			<input type="radio" name="files" value="0"<%if ( Request( "files" ) <> "1" ) Then Response.Write " checked" end If%>>No
			</td>
		</tr>
	  </table>
	  </td>
	</tr>
 </form>
 </table>
 
<br>

 <table width="600" border="0" cellspacing="0" cellpadding="1">
 <form name="formOperation" method="POST" action="setup_shortcuts.asp">
 <input type="hidden" name="command" value="search">
 <input type="hidden" name="page" value="<%=iPage%>">
 <input type="hidden" name="languageCombo" value="<%=Request( "languageCombo" )%>">
 <input type="hidden" name="keywords" value="<%=Request( "keywords" )%>">
 <input type="hidden" name="deleted" value="<%=Request( "deleted" )%>">
 <input type="hidden" name="files" value="<%=Request( "files" )%>">
 
 <input type="hidden" name="front_id" value="">
 <input type="hidden" name="renamelabel" value="">
 
    <tr> 
      <td colspan="5" class="boxtitle">Results</td>
    </tr>
	<tr>
		<td></td>
		<td><b>Shortcut</b></td>
		<td><b>XML File</b></td>
		<td><b>Style File</b></td>
		<td><b>Deleted</b></td>
	</tr>
<%
Dim iTotalPage, intCount
iTotalPage = 0
If Request( "command" ) = "search" Then
	Set oRS = Server.CreateObject( "ADODB.Recordset" )
	oRS.ActiveConnection = oConn
	oRS.CursorLocation = 3	' adUseClient
	oRS.CursorType = 3		' static
	oRS.LockType = 3		' read-only
	oRS.Source = sSQL
	oRS.PageSize = 20
	oRS.Open

	If Not oRS.EOF Then
		oRS.AbsolutePage = iPage
		iTop = ( ( oRS.AbsolutePage - 1 ) * oRS.PageSize ) + 1

		For intCount = 1 To oRS.PageSize
			If Not oRS.EOF Then
	%>
	<tr>
		<td align="right"><%=(intCount - 1) + iTop%>.&nbsp;</td>
		<%
		If Left( oRS( "shortcut" ), 1 ) <> "." Then
		%>
		<td><a href="#" onclick="ShortClickOpen( this, <%=oRS( "front_id" )%> )"><%=oRS( "shortcut" )%></a></td>
		<% 
		Else
		%>
		<td><%=oRS( "shortcut" )%></td>
		<% 
		End If 
		sXML = oRS("xml")
		sXSL = oRS("xsl")
		
		If Len( sXML ) > 30 Then
			sXML = Left( sXML, 14 ) & "..." & Right( sXML, 14 )
		End If

		If Len( sXSL ) > 30 Then
			sXSL = Left( sXSL, 14 ) & "..." & Right( sXSL, 14 )
		End If
		%>
		<td><a href="javascript:ClickFolder('<%=Replace( oRS("root_xml"), "\", "/", 1, -1 )%>','<%=Replace( sXML, "\", "/", 1, -1 )%>')"><%=oRS( "xml" )%></a></td>
		<td><a href="javascript:ClickFolder('<%=Replace( oRS("root_xsl"), "\", "/", 1, -1 )%>','<%=Replace( sXSL, "\", "/", 1, -1 )%>')"><%=oRS( "xsl" )%></a></td>
		<td align="center"><input type="checkbox" name="deletelist" value="<%=oRS( "front_id" )%>"
		<%If ( oRS( "deleted" ) = 1 ) Then Response.Write " checked" End If%>></td>
	</tr>
	<%
				sIDs = sIDs & oRS( "front_id" ) & ", "
				oRS.MoveNext
			Else
				Exit For
			End If
		Next
		iTotalPage = oRS.PageCount
		sIDs = Left( sIDs, Len( sIDs ) - 2 )
	End If
	Set oRS = Nothing
End If
%>  
	<tr>
		<td colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="5" align="center"><%=strResult%><br></td>
	</tr>
	<tr>
		<td colspan="5">
		<%
		If iTotalPage > 0 Then
		%>
		<button onclick="SubmitErase( this.form )">Erase/Unerase marked</button>&nbsp;
		<%
		End If
		
		If iPage > 1 Then
		%>
		<button onclick="SubmitPage( this.form, <%=( iPage - 1 )%> )"> < Previous Page </button>
		<%
		End If
		
		If iPage < iTotalPage Then
		%>
		<button onclick="SubmitPage( this.form, <%=( iPage + 1 )%> )"> Next Page > </button>
		<%
		End If
		%>
		</td>
	</tr>
	
	<input type="hidden" name="ids" value="<%=sIDs%>">
 </form>
 </table>
 
<!-- interfaces the explorer modules´s 'openfolder' method -->
<form name="formExplorer" method="POST" action="explorer.asp">
	<input type="hidden" name="seed" value="<%=Session("seed")%>">
	<input type="hidden" name="operation" value="openfolder">
	<input type="hidden" name="root" value="">
	<input type="hidden" name="param" value="">
</form>

</body>
</html>

<!-- #include file="diag_shortcut.asp" -->

<!-- #include file="../incs/inc_destructor.asp" -->