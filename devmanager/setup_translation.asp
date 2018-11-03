<!-- #include file="../incs/inc_constructor.asp" -->
<%
Dim sCategories, sTokens, sErrors
If Not IsEmpty( Request( "command" ) ) Then
	Dim oTranslation
	Set oTranslation = Server.CreateObject( "PSNXML.TXMLTranslation" )
	oTranslation.ActiveConnection = oConn
	oTranslation.Oracle = oSynchro.Oracle

	Select Case Request( "command" ) 
	Case "add"
		If Not oTranslation.AddToken( Request( "source" ), Request( "dest" ), Request( "original" ), Request( "translation" ), Request( "category" ) ) Then
			sErrors = "[ failed to add new translation ]"
		End If
	Case "update"
		If Not oTranslation.UpdateToken( Request( "token_id" ), Request( "update_original" ), Request( "update_translation" ) ) Then
			sErrors = "[ failed to update translation ]"
		End If
	Case "delete"
		If Not oTranslation.DeleteAll( Request( "token_id" ) ) Then
			sErrors = "[ failed to hide all ]"
		End If
	End Select

	If Request( "command" ) <> "category" Then
		sTokens = oTranslation.ListTokens( Request( "source" ), Request( "dest" ), Request( "category" ) )
	End If

	sCategories = oTranslation.ListCategories( Request( "source" ), Request( "dest" ) )
	Set oTranslation = Nothing
End If
%>
<html>
<title>XML Tools - Translation Control</title>
<link rel="stylesheet" href="../styles.css">
<script language="JScript">
var sCategory = '<%=Request( "category" )%>';

function window.onload() {
	if ( sCategory != '' ) {
		if ( formSearch.category.type != 'text' ) {
			for ( var i = 0; i < formSearch.category.length; i ++ ) {
				if ( formSearch.category.options[ i ].value == sCategory ) {
					formSearch.category.options[ i ].checked = true;
				}
			}
		}
	}
}

function DoSearch( oForm ) {
	if ( !oForm ) { return }
	if ( oForm.category.value == '' ) {
		oForm.command.value = 'category'
		formSearch.btCategories.disabled = true;
	} else {
		oForm.command.value = 'search'
		formSearch.btSearch.disabled = true;
	}
	oForm.submit();
}

function DisplayToken() {
	if ( divUpdate ) 
		divUpdate.style.display = 'none';

	if ( divToken ) {
		divToken.style.display = divToken.style.display == 'none' ? '' : 'none';
	}
	ResetLast( null );
}

var iLastID;
function ResetLast( iID ) {
	if ( iLastID ) {
		var oStyle = document.all( 'row_' + iLastID ).style;
		oStyle.backgroundColor = oStyle.backgroundColor == '' ? '#888888' : '';
	}
	iLastID = iID;
}

function DisplayUpdate( iID ) {
	if ( divToken ) 
		divToken.style.display = 'none';

	if ( divUpdate ) {
		if ( iLastID == iID )
			divUpdate.style.display = divUpdate.style.display == 'none' ? '' : 'none'
		else
			divUpdate.style.display = '';
		with( formSearch ) {
			update_original.value = document.all( 'col_original_' + iID ).innerText;
			update_translation.value = document.all( 'col_translation_' + iID ).innerText;;
			token_id.value = iID;
		}
		oStyle = document.all( 'row_' + iID ).style;
		oStyle.backgroundColor = oStyle.backgroundColor == '' ? '#888888' : '';
		ResetLast( iID );
	}
}

function DoAdd( oForm ) {
	if ( oForm ) {
		if ( oForm.category.value == '' ) {
			alert( 'Input a category and check the source and destination languages' );
			return;
		}
		oForm.btAdd.disabled = true;
		oForm.command.value = 'add';
		oForm.submit();
	}
}

function DoUpdate( oForm ) {
	if ( oForm ) {
		if ( oForm.category.value == '' || oForm.update_original.value == '' || oForm.token_id.value == '' ) {
			alert( 'Input a category and check the source, destination languages and translation' );
			return;
		}
		oForm.btUpdate.disabled = true;
		oForm.command.value = 'update';
		oForm.submit();
	}
}

function DoDelete( oForm ) {
	if ( oForm ) {
		if ( window.confirm( 'Are you sure of this operation?' ) ) {
			oForm.btDelete.disabled = true;
			formSearch.token_id.value = oForm.token_id.value;
			formSearch.command.value = 'delete';
			alert( formSearch.token_id.value );
			//formSearch.submit();
		}
	}
}

function SelectAll( oForm ) {
	for( var i = 0; i < oForm.elements.length; i ++ ) {
		if ( oForm.elements[ i ].type == 'checkbox' ) {
			oForm.elements[ i ].checked = oForm.elements[ i ].checked ? false : true;
		}
	}
}
</script>
<body>
<table width="600" border="0" cellspacing="0">
<form name="formSearch" method="POST" action="setup_translation.asp">
<input type="hidden" name="command" value="category">
<input type="hidden" name="token_id" value="">
<%
If Not IsEmpty( sCategories ) Then
%>
<input type="hidden" name="source" value="<%=Request( "source" )%>">
<input type="hidden" name="dest" value="<%=Request( "dest" )%>">
<%
End If
%>
	<tr class="boxtitle">
		<td class="boxtitle">XML Tools - Translation Control</td>
		<td align="right">
		<%
		If IsEmpty( sCategories ) Then
		%>
		<button name="btCategories" onclick="DoSearch( this.form )">Search</button>
		<%
		Else
		%>
		<button name="btAgain" onclick="self.location = 'setup_translation.asp'"> Try Again </button>
		<button name="btSearch" onclick="DoSearch( this.form )"> Search </button>
		<%
		End If
		%>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<table border="0">
			<%
			If IsEmpty( sCategories ) Then
			%>

			<tr>
				<td>Category: </td>
				<td>
					<input type="text" name="category">
				</td>
				<td>Source: </td>
				<td>
				<select name="source">
					<%
					sList = oLanguage.XML
					If sList <> "" Then
						Call RenderXML( sList, Server.MapPath( "setup_translations.xsl" ) )
					End If
					%>
				</select>
				</td>
				<td>Destination: </td>
				<td>
				<select name="dest">
					<%
					sList = oLanguage.XML
					If sList <> "" Then
						Call RenderXML( sList, Server.MapPath( "setup_translations.xsl" ) )
					End If
					%>
				</select>
				</td>
			</tr>

			<%
			Else
			%>
				
			<tr>
				<td>Translation from <%=Request( "source" )%> to <%=Request( "dest" )%> of
				category :
				</td>
				<td>
				<select name="category">
					<% Call RenderXML( sCategories, Server.MapPath( "setup_translations.xsl" ) ) %>
				</select>
				</td>
				<td align="right">
					<small>(Select a category and press "Search" again)</small>
				</td>
			</tr>
				
			<%
			End If
			%>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<table border="0">
			<tr>
			<td>[ <a href="javascript:DisplayToken()">add new translation</a> ]</td>
			</tr>
			</table>
		</tr>
	</tr>

	<tr>
		<td colspan="2">
		<div id="divToken" style="position: relative; display: none" class="floatingbox">
		<table border="0" align="center">
			<tr>
				<td>Phrase/Work:</td>
				<td><input type="text" name="original"></td>
				<td>Translation:</td>
				<td><input type="text" name="translation"></td>
				<td><button name="btAdd" onclick="DoAdd( this.form )"> Save </button></td>
			</tr>
		</table>
		</div>
		<div id="divUpdate" style="position: relative; display: none" class="floatingbox">
		<table border="0" align="center">
			<tr>
				<td>New Phrase/Work:</td>
				<td><input type="text" name="update_original"></td>
				<td>New Translation:</td>
				<td><input type="text" name="update_translation"></td>
				<td><button name="btUpdate" onclick="DoUpdate( this.form )"> Update </button></td>
			</tr>
		</table>
		</div>

		</td>
	</tr>
</form>
</table>

<br>

<%
If Not IsEmpty( sCategories ) Then
%>
<table width="600" border="0" cellspacing="0">
<form name="formList">
	<thead>
	<tr class="boxtitle">
		<td class="boxtitle" colspan="2">Translation Tokens</td>
		<td align="right">
		<button name="btDelete" onclick="DoDelete( this.form )"> Delete Marked </button>
		</td>
	</tr>
	<tr>
		<td><b>Original</b></td>
		<td><b>Translation</b></td>
		<td align="right"><b>Mark</b></td>
	</tr>
	</thead>
	<tbody>
	<%
	If Not IsEmpty( sTokens ) Then
		Call RenderXML( sTokens, Server.MapPath( "setup_translations.xsl" ) )
	End If
	%>
	<tr>
		<td colspan="2"></td>
		<td align="right"><button onclick="SelectAll( this.form )">Select All</button></td>
	</tr>
	</tbody>
</form>
</table>
<%
End If
%>
</body>
</html>
<!-- #include file="../incs/inc_destructor.asp" -->