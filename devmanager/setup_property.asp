<!-- #include file="../incs/inc_constructor.asp" -->
<%
Dim sRoot, sRootURL
sRoot = ""
sRootURL = ""
If Not IsEmpty( Request( "path" ) ) Then
	oSynchro.Root = Request( "path" )
	sRoot = oSynchro.Root
	sRootURL = oSynchro.RootURL
End If
%>
<html>
<head>
<title>Root Property Box</title>
<link rel="stylesheet" href="../styles.css">
</head>
<body>
<b>Path:</b> <%=sRoot%>
<br>
<b>URL:</b> <%=sRootURL%>
</body>
</html>
<!-- #include file="../incs/inc_destructor.asp" -->