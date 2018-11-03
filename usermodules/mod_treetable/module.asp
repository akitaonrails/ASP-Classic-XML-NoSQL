<!--
	Tree Edition Applet
	akita@psntv.com
	04/04/2001
	alpha candidate release .4
-->
<%
' try to get a path from the user explorer (expects a well formed URL)
' URL usually built using module_loader.asp + frame_loader.asp
Dim sXMLPath, sSchemaPath, sXSLPath
sXMLPath = Request( "xmlfile" )
If IsEmpty( sXMLPath ) Then
	sXMLPath = "chave.xml"
End If
%>
<html>
<head>
<title>Simple Tree Editor</title>
<link rel="stylesheet" href="../../styles.css">
<script language="JScript">
var sXMLPath = '<%=sXMLPath%>';
var sXSLPath = 'http://<%=Request.ServerVariables( "HTTP_HOST" ) & Replace( Request.ServerVariables( "URL" ), "module.asp", "template.xsl" )%>';

<!-- #include file="../../incs/TDialogs.js"-->
<!-- #include file="treetable.js"-->
</script>

<body onload = "oControl.RunQueue();refreshXML();">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td class="boxtitle">:: Simple Tree Editor</td>
	<td class="boxtitle" align="right">
	<select id="totalNodes">
	<%
	Dim i, j, k
	For i = 2 to 10
		j = 1
		for k = 1 to i
			j = j * 2
		Next
		Response.Write "<option value=""" & i & """>" & j & "</option>" & vbCRLF
	Next
	%>
	</select>
	<button onclick="createTree()" id="btCreate">New Tree</button>&nbsp;
	</td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>

<tr>
	<td colspan="2"><div id="XMLFinal" style="background-color: #FFFFFF">Wait a minute while the file is loading ...</div></td>
</tr>

</table>

<hr>
<button onclick="controlSourceBox()" id="btControlSource">Source (for developers)</button>
<div id="sourcecontrol"  style="position:relative; visibility: hidden">
	<pre>
	<div id="XMLSource"></div>
	</pre>
</div>

<!-- #include file="diag_editnode.asp" -->
</body>
</html>