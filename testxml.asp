<%
Set oConn = Server.CreateObject( "ADODB.Connection" )
oConn.Open "DSN=PMIDB;UID=pmiuser;PWD=pmiuser"

	Set oFront = Server.CreateObject( "PSNXML.TXMLFront" )
	oFront.ActiveConnection = oConn
	oFront.Oracle = False

Response.Write "Test 1: Call oFront.ListEvents( ""br"", ""Portal Soccer"" )"
Response.Write "<blockquote>"
	sXSL = Server.MapPath( "testeventlist.xsl" )
	Call oFront.ListEvents( "br", "Portal Soccer" )
	oFront.XSLSource = sXSL
	Call oFront.Render( Response )
Response.Write "</blockquote>"

Response.Write "Test2: Call oFront.ListEventPages( ""br"", ""Soccer Event"" )"
Response.Write "<blockquote>"
	sXSL = Server.MapPath( "testeventpages.xsl" )
	Call oFront.ListEventPages( "br", "Soccer Event" )
	oFront.XSLSource = sXSL
	Call oFront.Render( Response )
Response.Write "</blockquote>"

Response.Write "Test3: Call oFront.LoadEventPage( ""br"", ""Soccer Event"", ""results"")"
Response.Write "<blockquote>"
Response.Write "<p><b>Rendering the XML+XSL page</b></p>"

	Call oFront.LoadEventPage( "br", "Soccer Event", "results")
	Call oFront.Translate( "br", "sp", "country" )
	Call oFront.Render( Response )

Response.Write "</blockquote>"





'oFront.Load( "results_masc_class_a" )
'oFront.Render Response





Set oFront = Nothing
Set oConn = Nothing
%>