<%
sPath = "����� ���� ���� ����� ���� ��o"
sTmp = ""
For intCount = 1 To Len( sPath )
	sChar = Mid( sPath, intCount, 1 )
	If InStr( "�����", sChar ) Then
		sChar = "a"
	ElseIf InStr( "����", sChar ) Then
		sChar = "e"
	ElseIf InStr( "����", sChar ) Then
		sChar = "i"
	ElseIf InStr( "�����", sChar ) Then
		sChar = "o"
	ElseIf InStr( "����", sChar ) Then
		sChar = "u"
	ElseIf InStr( "�", sChar ) Then
		sChar = "c"
	End If	
	sTmp = sTmp & sChar
Next
Response.Write sPath & "<BR>"
Response.Write sTmp
%>