<!-- #include file="../incs/inc_constructor.asp" -->
<%
Dim oTranslation
Set oTranslation = Server.CreateObject( "PSNXML.TXMLTranslation" )
oTranslation.ActiveConnection = oConn
oTranslation.Oracle = oSynchro.Oracle
oTranslation.PersistData = True
oTranslation.ActiveXML = oXML

If Request( "command" ) = "category" Then
	Call oTranslation.ListCategories( Request( "source" ), Request( "dest" ) )
ElseIf Request( "command" ) = "tokens" Then
	Call oTranslation.ListTokens( Request( "source" ), Request( "dest" ), Request( "category" ) )
End If
Set oTranslation = Nothing

Response.ContentType = "text/xml"
Response.Write oXML.xml
%>
<!-- #include file="../incs/inc_destructor.asp" -->