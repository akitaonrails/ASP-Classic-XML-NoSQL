<%
' define the sql templates
Dim qSearch, qUpdate, qDelete, qUndelete, qRename

Sub DefineQueries
	If oSynchro.Oracle Then
		qDelete = "update tbXML_Front set deleted = 1, shortcut = '.' || shortcut where deleted = 0 and front_id in ( %ids% )"

		qUndelete = "update tbXML_Front set deleted = 0, shortcut = SUBSTR( shortcut, 2, LENGTH( shortcut ) - 1 ) where deleted = 1 and front_id in ( %ids% )"

		qSearch = "select front_id, shortcut, language_id, " & _
		" folder1.path || file1.filename || '.' || file1.type xml, " & _
		" folder2.path || file2.filename || '.' || file2.type xsl, " & _
		" root1.path root_xml, " & _
		" root2.path root_xsl, " & _
		" tbXML_Front.deleted" & _
		" from tbXML_Front, tbXML_folders folder1, tbXML_folders folder2, " & _
		" tbXML_folders root1, tbXML_folders root2, tbXML_base file1, tbXML_base file2 " & _
		" where file1.id = tbXML_front.xml_id " & _
		" and file2.id = tbXML_front.style_id " & _
		" and file1.folder_id = folder1.folder_id " & _
		" and file2.folder_id = folder2.folder_id " & _
		" and folder1.root_id = root1.folder_id " & _
		" and folder2.root_id = root2.folder_id " & _
		" and tbXML_Front.language_id %language_id% " & _
		" %deleted% " & _
		" %parameters% " & _
		" order by shortcut "
	Else
		qDelete = "update tbXML_Front set deleted = 1, shortcut = '.' + shortcut where deleted = 0 and front_id in ( %ids% )"

		qUndelete = "update tbXML_Front set deleted = 0, shortcut = right( shortcut, len( shortcut ) - 1 ) where deleted = 1 and front_id in ( %ids% )"

		qSearch = "select front_id, shortcut, language_id, " & _
		" folder1.path + file1.filename + '.' + file1.type xml, " & _
		" folder2.path + file2.filename + '.' + file2.type xsl, " & _
		" root1.path root_xml, " & _
		" root2.path root_xsl, " & _
		" tbXML_Front.deleted" & _
		" from tbXML_Front, tbXML_folders folder1, tbXML_folders folder2, " & _
		" tbXML_folders root1, tbXML_folders root2, tbXML_base file1, tbXML_base file2 " & _
		" where file1.id = tbXML_front.xml_id " & _
		" and file2.id = tbXML_front.style_id " & _
		" and file1.folder_id = folder1.folder_id " & _
		" and file2.folder_id = folder2.folder_id " & _
		" and folder1.root_id = root1.folder_id " & _
		" and folder2.root_id = root2.folder_id " & _
		" and tbXML_Front.language_id %language_id% " & _
		" %deleted% " & _
		" %parameters% " & _
		" order by shortcut "
	End If
End Sub

' execute the search
Function Search
	Dim sTmp, aTmp
	
	' define the language
	sTmp = qSearch
	If Not IsEmpty( Request( "languageCombo" ) ) and Request( "languageCombo" ) <> "" Then
		sTmp = Replace( sTmp, "%language_id%", " = " & Request( "languageCombo" ) )
	Else
		sTmp = Replace( sTmp, "%language_id%", " in ( -1, 2, 3 ) " )
	End If
	
	' check if search for deleteds or not
	If Request( "deleted" ) = "1" Then
		sTmp = Replace( sTmp, "%deleted%", " and deleted is not null " )
	Else
		sTmp = Replace( sTmp, "%deleted%", " and deleted = 0 " )
	End If
	
	' define the search for descriptions
	If Not IsEmpty( Request( "keywords" ) ) and Request( "keywords" ) <> "" Then
		If Request( "files" ) = 1 Then
			sTmp = Replace( sTmp, "%parameters%", " and ( " & _
			ParseSearchString( "shortcut", Request( "keywords" ) ) & " or " & _
			ParseSearchString( "file1.filename", Request( "keywords" ) ) & " or " & _
			ParseSearchString( "file2.filename", Request( "keywords" ) ) & " or " & _
			ParseSearchString( "file1.description", Request( "keywords" ) ) & " or " & _
			ParseSearchString( "file2.description", Request( "keywords" ) ) & " ) " )
		Else
			sTmp = Replace( sTmp, "%parameters%", " and " & ParseSearchString( "shortcut", Request( "keywords" ) ) )
		End If
	Else
		sTmp = Replace( sTmp, "%parameters%", "" )
	End If
	
	Response.Write vbCRLF & "<!-- debug search: " & sTmp & " -->" & vbCRLF
	Search = sTmp
End Function

' parser to build the sql query
'	based on the 3 search cases:
'	"+" which means obligatory words (AND LIKE)
'	"-" which means not desired words (AND NOT LIKE)
'	""  which means may be there (OR LIKE)
Function ParseSearchString( sField, sParameters )
	Dim sResult, aTmp, sTmp 
	Dim aLook(), aMiss(), aOr()
	Dim iLook, iMiss, iOr
	Dim oReg

	sParameters = Replace( sParameters, """", "", 1, -1 )
	sParameters = Replace( sParameters, "  ", " ", 1, -1 )
	sParameters = Replace( sParameters, "+ ", "+", 1, -1 )
	sParameters = Replace( sParameters, "- ", "-", 1, -1 )
	If Not InStr( sParameters, " " ) Then
		sParameters = sParameters & " "
	End If
	
	' take care of phrases	
	Set oReg = new RegExp
	oReg.IgnoreCase = True
	oReg.Global = True
	oReg.Pattern = "'(.*?)'"
	
	on error resume next
	Set oMatches = oReg.Execute( sParameters )
	For Each oMatch in oMatches
		sTmp = Replace( oMatch.Value, " ", "_" )
		sParameters = Replace( sParameters, oMatch.Value, sTmp )
	Next
	Set oMatches = Nothing
	on error goto 0
	Set oReg = Nothing
	
	' simple parse thru whitespaces
	iLook = 0
	iMiss = 0
	aTmp = Split( Trim( sParameters ), " " )
	For Each sTmp in aTmp
		If Left( Trim( sTmp ), 1 ) = "+" Then
			iLook = iLook + 1
		ElseIf Left( Trim( sTmp ), 1 ) = "-" Then
			iMiss = iMiss + 1
		End If
	Next
	
	ReDim aLook( iLook )
	ReDim aMiss( iMiss )
	ReDim aOr( UBound( aTmp ) - iLook - iMiss )

	' check for the tokens
	iLook = 0
	iMiss = 0
	iOr = 0
	For Each sTmp in aTmp
		sTmp = Trim( sTmp )
		If Left( sTmp, 1 ) = "+" Then
			aLook( iLook ) = sTmp
			iLook = iLook + 1
		ElseIf Left( sTmp, 1 ) = "-" Then
			aMiss( iMiss ) = sTmp
			iMiss = iMiss + 1
		Else
			aOr( iOr ) = sTmp
			iOr = iOr + 1
		End If
	Next	
	
	' build the final sql condition for each case
	sLook  = ""
	If UBound( aLook ) >= 0 Then
		For Each sTmp in aLook
			If sTmp <> "" Then
				sTmp = Replace( sTmp, "_", " ", 1, -1 )
				sTmp = Right( Trim( sTmp ), Len( sTmp ) - 1 )
				sLook = sLook & sField & " like '%" & Replace( sTmp, "'", "", 1, -1 ) & "%' and "
			End If
		Next
		If Len( sLook ) > 1 Then
			sLook = Left( sLook, Len( sLook ) - 4 )
		End If
	End If
	
	sMiss  = ""
	If UBound( aMiss ) >= 0 Then
		For Each sTmp in aMiss
			If sTmp <> "" Then
				sTmp = Replace( sTmp, "_", " ", 1, -1 )
				sTmp = Right( Trim( sTmp ), Len( sTmp ) - 1 )
				sMiss = sMiss & sField & " not like '%" & Replace( sTmp, "'", "", 1, -1 ) & "%' and "
			End If
		Next
		If Len( sMiss ) > 1 Then
			sMiss = Left( sMiss, Len( sMiss ) - 4 )
		End If
	End If
	
	sOr  = ""
	If UBound( aOr ) >= 0 Then	
		For Each sTmp in aOr
			If sTmp <> "" Then
				sTmp = Replace( sTmp, "_", " ", 1, -1 )
				sOr = sOr & sField & " like '%" & Replace( sTmp, "'", "", 1, -1 ) & "%' or "
			End If
		Next
		If Len( sOr ) > 1 Then
			sOr = Left( sOr, Len( sOr ) - 4 )
		End If
	End If
	
	' join the 3 sub-statements
	sResult = ""
	If sLook <> "" Then 
		If sMiss <> "" Then
			sResult = "( " & sLook & " and " & sMiss & " )"
		Else
			sResult = "( " & sLook & " )"
		End If
	Else
		If sMiss <> "" Then
			sResult = "( " & sMiss & " )"
		End If
	End If
	
	If sResult <> "" and sOr <> "" Then
		sResult = sResult & " or ( " & sOr & " )"
	Else
		sResult = sResult & sOr
	End If
	
	ParseSearchString = sResult
End Function
%>
