<%
Dim sStyleFile
sStyleFile =  "reflection.xsl"

Dim oXML, oXSL
Set oXML = Server.CreateObject( "MSXML.DOMDocument" )
Set oXSL = Server.CreateObject( "MSXML.DOMDocument" )
oXML.async = False
oXSL.async = False
oXML.validateOnParse = False
oXSL.validateOnParse = False

Call oXSL.load( Server.MapPath( sStyleFile ) )

If Not IsEmpty( Request( "xml" ) ) Then
	Call oXML.load( Server.MapPath( Request( "xml" ) ) )
Else
	Dim oFS, oFolder, oFile, sXML
	Set oFS = Server.CreateObject( "Scripting.FileSystemObject" )
	Set oFolder = oFS.GetFolder( Replace( Server.MapPath( sStyleFile ), sStyleFile, "" ) )
	For Each oFile in oFolder.Files
		If UCase( oFile.type ) = UCase( "Windows Script Component" ) Then
			sXML = sXML & "<filename>" & oFile.Name & "</filename>"
		End If
	Next
	If sXML <> "" Then
		sXML = "<files>" & sXML & "</files>"
		oXML.loadXML( sXML )
	End If
	Set oFolder = Nothing
	Set oFS = Nothing
End If

oXML.transformNodeToObject oXSL, Response

Set oXML = Nothing
Set oXML = Nothing
%>