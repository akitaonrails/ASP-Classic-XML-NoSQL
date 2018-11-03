<%
Response.Buffer = True
Response.Expires = 0                              ' - works with IE 4.0 browsers. 
Response.AddHeader "Pragma","no-cache"            ' - works with proxy servers. 
Response.AddHeader "cache-control", "no-store"    ' - works with IE 5.0 browsers. 

Const cntConnection = "DSN=PMIDB;UID=pmiuser;PWD=pmiuser;"

Dim oSynchro
Dim oFS
Dim oConn

' initialize globals
Set oSynchro = Server.CreateObject( "PSNXML.TXMLSynchro" )
Set oFS = Server.CreateObject( "Scripting.FileSystemObject" )
Set oConn = Server.CreateObject( "ADODB.Connection" )
oConn.Open cntConnection
oSynchro.Connect oFS, oConn
If Request.ServerVariables( "HTTP_HOST" ) = "akita2" Then
	oSynchro.Oracle = False
End If

' get languages
Dim oLanguage
Set oLanguage = Server.CreateObject( "PSNXML.TXMLLanguage" )
oLanguage.ActiveConnection = oConn
If Request.ServerVariables( "HTTP_HOST" ) = "akita2" Then
	oLanguage.Oracle = False
End If

' set XML objects
Dim oXML, oXSL
Set oXML = Server.CreateObject( "MSXML.DOMDocument" )
Set oXSL = Server.CreateObject( "MSXML.DOMDocument" )
oXML.async = False
oXSL.async = False
oXML.validateOnParse = False
oXSL.validateOnParse = False

' passivelly renders raw XML data and pre-configured XSL templates
Sub RenderXML( ByRef sSource, ByVal sStyle )
	If sSource = "" Then
		Exit Sub
	End If
	on error resume next
	' try {
		oXML.loadXML( sSource )
		oXSL.load( sStyle )
	' } catch( Err ) {
		If Err.number = 0 Then
			oXML.transformNodeToObject oXSL, Response
		End If
	' }
	on error goto 0
	
	' clear the buffer
	sSource = ""
End Sub

%>
<script language="JScript">
// open the help file (must be named as "help.asp" and must receive the parameter "item" 
function OpenHelp( sLabel ) {
	window.open( 'help.asp?item=' + sLabel, 'help', 'width=400,height=400,scrollbars=yes')
}

// open the compatibility check window
function OpenCompatibility() {
	window.open( '../compatibility/compatibility.asp', 'compatible', 'width=550,height=270,scrollbars=yes,status=yes')
}

<!-- #include file="TDialogs.js" -->
</script>