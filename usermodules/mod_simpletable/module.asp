<!--
	Table Edition Applet
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
	sXMLPath = Server.MapPath( "demo.xml" )
End If

sSchemaPath = Request( "schemafile" )
If IsEmpty( sSchemaPath ) Then
	sSchemaPath = Server.MapPath( "template.xml" )
End If

sSchemaURL = Request( "schemaurl" )
If IsEmpty( sSchemaURL ) Then
	sSchemaURL = "template.xml"
End If

sXSLPath = Server.MapPath( "interface.xsl" )

' this sample requires MSXML 3
Set oTemplate = Server.CreateObject( "MSXML.DOMDocument" )
oTemplate.async = False
oTemplate.load( sSchemaPath )

Set oTemplateXSL = Server.CreateObject( "MSXML.DOMDocument" )
oTemplateXSL.async = False
oTemplateXSL.validateOnParse = False
oTemplateXSL.load( Server.MapPath( "template.xsl" ) )
%>

<html>
<head>
<title>Simple Table Editor</title>
<link rel="stylesheet" href="../../styles.css">
</head>
<script language="JScript">
var sXMLPath = '<%=sXMLPath%>';
var sSchemaPath = '<%=sSchemaURL%>';

// global module method to deliver the final XML source
function getSource() {
	return ( oXML.xml );
}

<!-- #include file="../../incs/TDialogs.js"-->
<!-- #include file="simpletable.js"-->
</script>
<body onload="oControlOnLoad();refreshXML();">
<%
' render the control dialog boxes
oTemplate.transformNodeToObject oTemplateXSL, Response

Set oTemplateXSL = Nothing
Set oTemplate = Nothing
%>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td class="boxtitle"> :: Simple Table Editor - coordinates <span id=txtTable style="font-weight:bold">(table: 1)</span></td>
	<td class="boxtitle" align="right">
		<button onclick="resetXML()" id="btResetXML">Reset</button>
		<button onclick="appendTable()" id="btAppendTable">Append</button>
		<button onclick="addTable( intTableID )" id="btAddTable">Add</button>
		<button onclick="removeTable( intTableID )" id="btRemoveTable">Remove</button>
		<button onclick="helpBox( 'main' )" id="btHelp">Help ? </button>
	</td>
</tr>
</table>
<div id="XMLFinal" style="background-color: #FFFFFF"></div>
<hr>

<button onclick="controlSourceBox()">Source (for developers)</button>
<div id="sourcecontrol"  style="position:relative; visibility: hidden">
	<pre>
	<div id="XMLSource"></div>
	</pre>
</div>

</body>
</html>