<%
' ---
' Package TXML
'
' TXMLFront Class
' shortcur loader for TXMLSynchro created XML/XSL files
'
'	- internally creates MSXML.DomDocument instances
'	- this class doesn´t throw up nor raise any exception, all errors are returned
'	as boolean of function results
'
' akita@psntv.com
' 04/23/2001
' ---
Class TXMLFront
'
' --- interface
'
	Private sRoot
	Private oXML
	Private oXSL
	Private oConn
	Private iLanguageID
	
	Private aReplaceIni()
	Private aReplaceEnd()
	Private intReplace
	
	Private sXMLFile
	Private sXSLFile
	
	' sql settings
	Private isOracle
	Private sql_QueryShortcutXML
	Private sql_QueryShortcutXSL

	' --- properties
	' void Set XMLSource( *String )
	' void Set XSLSource( *String )
	' void Set LanguageID( int )
	' void Set Oracle( bool )
	' void Set ActiveConnection( *ADODB.Connection )
	' String Get XMLFile
	' String Get XSLFile
	' --- private methods
	' private void Constructor = Class_Initialize
	' private void Destructor = Class_Terminate
	' private void DefineQueries
	' --- public methods
	' bool Load( String )
	' void Render
	' void AddReplacer( String, String )
	
'
' --- implementation
'

	' set the root folder
	Public Property Let Root( sTmp )
		sRoot = sTmp
		If Right( sRoot, 1 ) <> "\" Then
			sRoot = sRoot & "\"
		End If
	End Property
	
	Public Property Get Root
		Root = sRoot
	End Property
	
	' externally fill in the XML data
	Public Property Let XMLSource( ByRef sSource )
		If Not IsNull( oXML ) Then
			oXML.loadXML( sSource )
		End If
	End Property
	
	' externally fill in the XSL data
	Public Property Let XSLSource( ByRef sSource )
		If Not IsNull( oXSL ) Then
			oXSL.loadXML( sSource )
		End If
	End Property

	' set the current language ID
	Public Property Let LanguageID( ByVal iLanguage )
		If IsNumeric( iLanguage ) Then
			iLanguageID = iLanguage
		End If
	End Property
	
	Public Property Get LanguageID
		LanguageID = iLanguage
	End Property
	
	Public Property Get XMLFile
		XMLFile = sXMLFile
	End Property
	
	Public Property Get XSLFile
		XSLFile = sXSLFile
	End Property

	' set the current sql queries
	Public Property Let Oracle( ByVal bOracle )
		If bOracle Then
			isOracle = True
		Else
			isOracle = False
		End If
		Call DefineQueries()
	End Property

	' connect to externally created filesystem and database objects
	Public Property Let ActiveConnection( ByRef oDB )
		Set oConn = oDB
	End Property

	' load the files thru a previously created shortcut association
	Public Function Load( sLabel )
		Dim sSQL, sTmp
		Dim oRS
		Load = True
		
		' -- get the XML
		sTmp = ""
		sSQL = Replace( sql_QueryShortcutXML, "%language_id%", iLanguageID )
		sSQL = Replace( sSQL, "%label%", sLabel )

		Set oRS = oConn.Execute( sSQL )
		If Not oRS.EOF Then
			sTmp = sRoot & oRS( "path" ) & oRS( "filename" )
			If Len( oRS( "type" ) ) > 0 Then
				 sTmp = sTmp & "." & oRS( "type" )
			End If
			on error resume next
			' try {
				oXML.load( sTmp )
				sXMLFile = sTmp
			on error goto 0
			' } catch( Err ) {
				Load = ( Load and ( Err.number = 0 ) )
			' }
			oRS.Close
		End If

		' -- get the XSL
		sTmp = ""
		sSQL = Replace( sql_QueryShortcutXSL, "%language_id%", iLanguageID )
		sSQL = Replace( sSQL, "%label%", sLabel )
		
		Set oRS = oConn.Execute( sSQL )
		If Not oRS.EOF Then
			sTmp = sRoot & oRS( "path" ) & oRS( "filename" )
			If Len( oRS( "type" ) ) > 0 Then
				 sTmp = sTmp & "." & oRS( "type" )
			End If
			on error resume next
			' try {
				oXSL.load( sTmp )
				sXSLFile = sTmp
			on error goto 0
			' } catch( Err ) {
				Load = ( Load and ( Err.number = 0 ) )
			' }
			oRS.Close
		End If		
		
		' clean up
		Set oRS = Nothing
	End Function
	
	' add replacers to change manually the results HTML (this is dangerous and must be used carefully)
	Public Sub AddReplacer( sIni, sEnd )
		intReplace = intReplace + 1
		If intReplace < UBound( aReplaceIni ) Then
			aReplaceIni( intReplace ) = sIni
			aReplaceEnd( intReplace ) = sEnd
		End If
	End Sub
	
	' render the XML and XSL files
	Public Sub Render( ByRef Response )
		Dim sFinal
		If intReplace > 0 Then
			sFinal = oXML.transformNode( oXSL )
			For intCount = 0 To intReplace
				sFinal = Replace( sFinal, aReplaceIni( intCount ), aReplaceEnd( intCount ), 1, -1 )
			Next
			Response.Write sFinal
		Else
			oXML.transformNodeToObject oXSL, Response
		End If
	End Sub
	
	' set the sql queries
	Private Sub DefineQueries
		If IsOracle Then
			sql_QueryShortcutXML = "select b.filename, b.type, r.path || fo.path path " & _
				"from tbXML_front f, tbXML_base b, tbXML_folders fo, tbXML_folders r " & _
				"where f.xml_id = b.id " & _
				"and b.folder_id = fo.folder_id " & _
				"and b.is_active = '1' " & _
				"and fo.root_id = r.folder_id " & _
				"and fo.is_active = '1' " & _
				"and f.language_id = '%language_id%' " & _
				"and f.shortcut = '%label%' " & _
				"and f.deleted = 0 "
			sql_QueryShortcutXSL = "select b.filename, b.type, r.path || fo.path path " & _
				"from tbXML_front f, tbXML_base b, tbXML_folders fo, tbXML_folders r " & _
				"where f.style_id = b.id " & _
				"and b.folder_id = fo.folder_id " & _
				"and b.is_active = '1' " & _
				"and fo.root_id = r.folder_id " & _
				"and fo.is_active = '1' " & _
				"and f.language_id = '%language_id%' " & _
				"and f.shortcut = '%label%' " & _
				"and f.deleted = 0 "
		Else
			sql_QueryShortcutXML = "select b.filename, b.type, r.path + fo.path as path " & _
				"from tbXML_front f, tbXML_base b, tbXML_folders fo, tbXML_folders r " & _
				"where f.xml_id = b.id " & _
				"and b.folder_id = fo.folder_id " & _
				"and b.is_active = '1' " & _
				"and fo.root_id = r.folder_id " & _
				"and fo.is_active = '1' " & _
				"and f.language_id = '%language_id%' " & _
				"and f.shortcut = '%label%' " & _
				"and f.deleted = 0 "
			sql_QueryShortcutXSL = "select b.filename, b.type, r.path + fo.path as path " & _
				"from tbXML_front f, tbXML_base b, tbXML_folders fo, tbXML_folders r " & _
				"where f.style_id = b.id " & _
				"and b.folder_id = fo.folder_id " & _
				"and b.is_active = '1' " & _
				"and fo.root_id = r.folder_id " & _
				"and fo.is_active = '1' " & _
				"and f.language_id = '%language_id%' " & _
				"and f.shortcut = '%label%' " & _
				"and f.deleted = 0 "
		End If
	End Sub
	
	' Constructor
	Private Sub Class_Initialize
		' instantiates the several needed objects
		Set oXML = Server.CreateObject( "MSXML.DomDocument" )
		oXML.async = False
		oXML.validateOnParse = False
		Set oXSL = Server.CreateObject( "MSXML.DomDocument" )
		oXSL.async = False
		oXSL.validateOnParse = False

		' defaults
		sRoot = ""
		iLanguageID = -1		
		isOracle = True
		intReplace = 0
		Call DefineQueries()
		
		ReDim aReplaceIni( 30 )
		ReDim aReplaceEnd( 30 )
	End Sub
	
	' Destructor
	Private Sub Class_Terminate
		' clean up
		Set oXML = Nothing
		Set oXSL = Nothing
	End Sub
End Class
%>