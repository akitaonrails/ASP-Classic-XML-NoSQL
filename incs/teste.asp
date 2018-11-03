<%
sPath = "באדגה יטכך םלןמ ףעפץצ תשûü חדo"
sTmp = ""
For intCount = 1 To Len( sPath )
	sChar = Mid( sPath, intCount, 1 )
	If InStr( "באדגה", sChar ) Then
		sChar = "a"
	ElseIf InStr( "יטכך", sChar ) Then
		sChar = "e"
	ElseIf InStr( "םלןמ", sChar ) Then
		sChar = "i"
	ElseIf InStr( "ףעפץצ", sChar ) Then
		sChar = "o"
	ElseIf InStr( "תשûü", sChar ) Then
		sChar = "u"
	ElseIf InStr( "ח", sChar ) Then
		sChar = "c"
	End If	
	sTmp = sTmp & sChar
Next
Response.Write sPath & "<BR>"
Response.Write sTmp
%>