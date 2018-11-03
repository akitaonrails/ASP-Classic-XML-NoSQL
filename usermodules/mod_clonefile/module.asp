<%
Randomize
Session( "seedmodule" ) = CStr( Rnd * 20000 )
%>
<html>
<head>
<title>Simple Table Editor</title>
<link rel="stylesheet" href="../../styles.css">
<script language="JScript"><!--
// turn off the container default save button
try {
	parent.document.all('btContainerSave').disabled = true;
} catch( e ) {
}

function ChangeOverwrite( oCheck ) {
	if ( oCheck ) {
		oCheck.value = ( oCheck.value == 1 ) ? 0 : 1;
	}
}

function SendClone( oForm ) {
	if ( oForm ) {
		var sName = oForm.clonefilename.value;
		hasName = ( sName.length > 1 );
		hasSlashes = ( (sName.indexOf( '/' ) > -1) || (sName.indexOf( '\\' ) > -1) );
		hasPoints = ( sName.indexOf( '.' ) > -1 );
		
		if ( !hasName || hasSlashes || hasPoints ) {
			alert( 'Fill in the correct filename, without slashes or points' );
		} else {
			oForm.submit();
		}
	}
}
//--></script>
</head>
<body>

<table width="100%" border="0" cellpadding="0" cellspacing="0" style="floatingbox">
<form name="formCloner" action="module_submit.asp" method="POST">
<input type="hidden" name="seedmodule" value="<%=Session( "seedmodule" )%>">
<input type="hidden" name="synchroRoot" value="<%=Request("synchroRoot")%>">
<input type="hidden" name="synchroPath" value="<%=Request("synchroPath")%>">
<input type="hidden" name="xmlfile" value="<%=Request("xmlfile")%>">
<input type="hidden" name="modulefolder" value="<%=Request("modulefolder")%>">
<input type="hidden" name="modulestarter" value="<%=Request("modulestarter")%>">
<tr>
	<td class="boxtitle" colspan="2"> :: File Cloner</td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td>Origin File: </td>
	<td><%=Request( "xmlfile" )%></td>
	</td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td>Clone File: </td>
	<td><input type="text" size="30" name="clonefilename"> (*)</td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td><button onclick="SendClone(this.form)" id="btSubmit">Make clone</button></td>
	<td><input type="checkbox" name="overwrite" value="1" onchange="ChangeOverwrite(this)"> Overwrite existing files? (**)</td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
</form>
</table>
<i>
<p>(*) There´s no need to put the filetype along with the filename nor the complete.
<br>For example, if you want the clone to be named "teste.xml" only name it "teste" and the system will put the correct filetype. 
<br>Also don´t use folder names nor delimiters as slashes or backslashes ("/" or "\")</p>
<p>(**) Be careful with the "overwrite" option. It will erase the content of the old file and replace it´s content for the one selected here.
<br>If you have doubts, DO NOT check this checkbox.
</i>

</body>
</html>