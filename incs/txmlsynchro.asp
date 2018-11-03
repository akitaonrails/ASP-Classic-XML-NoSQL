<%
' ---
' Package TXML
'
' TXMLSynchro Class
' encapsulates file management thru both filesystem and RDBMS table (specific structure)
' and tries to maintain consistent synchronization between both
'
' akita@psntv.com
' 04/16/2001
'
' Last Update: 05/16/2001 by akita@psntv.com
' ---
'
' note:
'	- using the pair "on error resume next" and "on error goto 0" as 
'	exception handler boundaries, working the same as a "try { } finally { }" block
'	- using explicit ByVal and ByRef parameter declarations to avoid double meanings
'	- all variables are explicitly declared in the beginning of every method ( so
'	Option Explicit would work )
'	- this class doesn´t throw up nor raise any exception, all errors are returned
'	as boolean of function results
'	- interface to tbXMLDynamic lacks implementation
'
Class TXMLSynchro
'
' --- interface
'

	' working variables
	Private main_root_URL
	Private main_root_active
	Private main_root_id
	Private main_root
	Private local_path
	Private filename
	Private filetype
	Private description_file
	
	Private objFile
	Private objFS
	Private objConn

	Private iFileFormat	' file format
	Private sDeletedFlag
	Private iLanguageID	' for creating language-aware shortcut associations

	Private sErrors	' XML errors buffer
	
	' sql templates
	Private sql_InsertFolder
	Private sql_InsertFile
	Private sql_UndeleteFolder
	Private sql_UndeleteFile
	Private sql_DeleteFolder
	Private sql_DeleteFile
	Private sql_QueryFolder
	Private sql_QueryFile
	Private sql_QueryFileID
	Private sql_QueryRoot
	Private sql_ListRoot
	Private sql_FolderID
	Private sql_FileID
	Private sql_InsertShortcut
	Private sql_QueryShortcutXML
	Private sql_QueryShortcutXSL
	Private sql_CreateBaseLinks

	Private isOracle
	Private isUser	' if this is true then hides some details for a non-developer interface
	
	' tbXML_folders mask
	Private fld_ID
	Private fld_Path
	Private fld_Active
	Private fld_Desc
	
	' tbXML_base mask
	Private file_ID
	Private file_Name
	Private file_Active
	Private file_Style
	Private file_Schema
	Private file_StyleFile
	Private file_SchemaFile
	Private file_Folder
	Private file_Type
	Private file_Author
	Private file_Responsible
	Private file_Desc
	
	' -- properties
	' void Set Root( String )
	' String Get Root
	' String Get RootURL
	' void Set Path( String )
	' String Get Path
	' String Get File
	' int Get FileID
	' int Get FolderID
	' String Get SchemaFile
	' String Get StyleFile
	' int Get SchemaID
	' int Get StyleID
	' void Set Oracle( bool )
	' bool Get Oracle
	' void Set HideDetails( bool )
	' bool Get HideDetails
	' String Get Errors
	' int Set FileFormat
	' int Set LanguageID
	
	' -- private methods
	' private String FormatPath( String )
	' private bool IsPath( String )
	' private bool TranslateURL( String )
	' private void Constructor = Class_Initialize
	' private void Destructor = Class_Terminate
	' private String GetAssociation( String )
	' private bool FetchFolder()
	' private bool FetchFile()
	' private bool OpenFile()
	' private bool CloseFile()
	' private bool FileHandler( String, *String )
	' private String GetXMLNode( String, String )
	
	' -- public methods
	' void Connect( *Scripting.FileSystemObject, *ADODB.Connection )
	' bool ChangePath( String )
	' String FileInfo( String )
	' String FolderInfo( String )
	' void GoParent()
	' void ResetLocal()
	' bool CreateRoot( String, String, String )
	' bool CreateFolder( String )
	' bool CreateFile( String, String, String, *TXMLSynchro, *TXMLSynchro )
	' bool ReadFile( *String )
	' bool WriteFile( *String )
	' bool DeleteFolder()
	' bool DeleteFile()
	' bool DeleteRoot()
	' void GetRoots( *String )
	' void GetFolders( *String )
	' void GetFiles( *String )
	' void GetDescription( *String )
	' bool CreateShortcut( String, *TXMLSynchro )
	' bool GetShortcut( String, *TXMLSynchro )
	' bool CreateBaseLink( String, String )
	
	' -- not yet implemented
	' bool CloneFile( String )
	' bool RenameFile( String )
	' bool RenameFolder( String )
	' bool RenameRoot( String )
	' bool MoveFile( String )
	' bool MoveFolder( String ) 
	' bool DeleteShortcut( String )
	' bool RenameShortcut( String, String )
	' bool FixStructure()
	
'
' --- implementation
'

	' set the main root
	Public Property Let Root( ByVal sPath )
		Dim objRS 
		
		sPath = FormatPath( sPath )
		main_root = ""
		main_root_id = null
		main_root_active = False
		main_root_URL = ""
		If Not IsPath( sPath ) or InStr( sPath, "." ) <> 0 or Not objFS.FolderExists( sPath ) Then
			Exit Property
		End If

		main_root = sPath		
		If InStrRev( main_root, "\" ) <> Len( main_root ) Then
			main_root = main_root & "\"
		End If
		
		' query ID
		main_root_id = null
		Set objRS = objConn.Execute( Replace( sql_QueryRoot, "%path%", main_root ) )
		If Not objRS.EOF Then
			main_root_id		= objRS( "folder_id" )
			main_root_active	= ( objRS( "is_active" ) = "1" )
			main_root_URL		= objRS( "url" )
			objRS.Close
		End If
		Set objRS = Nothing
		
		' do not allow a root that is not registered
		If IsNull( main_root_id ) Then
			main_root		= ""
			main_active		= False
			main_root_URL	= ""
		End If
	End Property
	
	' read-only root property
	Public Property Get Root
		Root = main_root
	End Property
	
	' read-only root URL property - it must be in the description field
	Public Property Get RootURL
		RootURL = main_root_URL
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
	
	' get the current sql flag
	Public Property Get Oracle
		Oracle = isOracle
	End Property
	
	' set permission level for user and non-users
	Public Property Let HideDetails( ByVal bHide )
		If bHide Then
			isUser = True
		Else
			isUser = False
		End If
	End Property
	
	' get permission level
	Public Property Get HideDetails
		HideDetails = isUser
	End Property
	
	' direct path parser
	Public Property Let Path( ByVal sPath )
		Call ChangePath( sPath )
	End Property

	' get the current complete path
	Public Property Get Path
		Path = main_root & local_path & File
	End Property
	
	' get the current filename
	Public Property Get File
		Dim sTmp
		If filetype <> "" Then
			sTmp = filename & "." & filetype
		Else
			sTmp = filename
		End If
		File = sTmp
	End Property

	' get the current file ID
	Public Property Get FileID
		If ( IsEmpty( file_ID ) or file_ID = "" ) and filename <> "" Then
			Call FetchFile()
		End If
		FileID = file_ID
	End Property
	
	' get the current folder ID
	Public Property Get FolderID
		If ( IsEmpty( fld_ID ) or fld_ID = "" ) and local_path <> "" Then
			Call FetchFolder()
		End If
		FolderID = fld_ID
	End Property
	
	' get this file's style 
	Public Property Get StyleFile
		If file_StyleFile = "" Then
			file_StyleFile = GetAssociation( "style" )
		End If
		StyleFile = file_StyleFile
	End Property

	' get this file's schema
	Public Property Get SchemaFile
		If file_SchemaFile = "" Then
			file_SchemaFile = GetAssociation( "schema" )
		End If
		SchemaFile = file_SchemaFile
	End Property
	
	' get the style id
	Public Property Get StyleID
		If file_ID = "" Then
			Call FetchFile()
		End If
		StyleID = file_Style
	End Property
	
	' get the schema id
	Public Property Get SchemaID
		If file_ID = "" Then
			Call FetchFile()
		End If
		SchemaID = file_Schema
	End Property

	' helper method for the 2 properties above
	Private Function GetAssociation( sOperation )
		Dim sSQL, oRS, intID
		
		If file_ID = "" Then
			Call FetchFile()
		End If

		If sOperation = "style" Then
			intID = file_Style
		Else
			intID = file_Schema
		End If

		GetAssociation = ""	
		on error resume next
		' try {
			sSQL = Replace( sql_QueryFileID, "%id%", intID )
			Set oRS = objConn.Execute( sSQL )
		' } catch( Err ) {
			If Err.number = 0 Then
				If Not oRS.EOF Then
					GetAssociation = Root & oRS( "path" ) & oRS( "filename" ) & "." & oRS( "type" )
				End If
			Else
				Call PrintErr( Err )
			End If
		' }
		on error goto 0
	End Function

	' set the file format when opening
	Public Property Let FileFormat( iFormat )
		If IsNumeric( iFormat ) Then
			iFileFormat = iFormat
		End If
	End Property
	
	' set the current language ID
	Public Property Let LanguageID( iLanguage )
		If IsNumeric( iLanguage ) Then
			iLanguageID = iLanguage
		End If
	End Property
	
	' get current language
	Public Property Get LanguageID
		LanguageID = iLanguageID
	End Property
	
	' get the current errors buffer
	Public Property Get Errors
		Errors = GetXMLNode( "errors", sErrors )
	End Property

	' print all trapped exceptions when in debug mode
	Private Sub PrintErr( ByRef oErr )
		Dim sTmp
		If Not IsNull( oErr ) and oErr.number <> 0 Then
			sTmp = GetXMLNode( "number",	oErr.number ) & _
				GetXMLNode( "source",		HTMLEncode( oErr.source ) ) & _
				GetXMLNode( "description",	HTMLEncode( oErr.description ) ) & _
				GetXMLNode( "helpcontext",	oErr.helpcontext ) & _
				GetXMLNode( "helpfile",		oErr.helpfile )
			sErrors = sErrors & GetXMLNode( "item", sTmp )
		End If
	End Sub
	
	' connects to a filesystem object
	' -- user this instead of the next method
	Public Sub Connect( ByRef oFile, ByRef oDB )
		Set objFS = oFile
		Set objConn = oDB
	End Sub

	' default path formatting
	Private Function FormatPath( ByVal sPath )
		sPath = Trim( sPath )
		sPath = Replace( sPath, "/", "\", 1, -1 )
		sPath = Replace( sPath, "\\", "\", 1, -1 )
		sPath = Replace( sPath, "'", "", 1, -1 )
		sPath = Replace( sPath, "  ", " ", 1, -1 )
		sPath = Replace( sPath, " ", "_", 1, -1 )
		FormatPath = sPath
	End Function

	' check the basic syntax of a path
	Private Function IsPath( ByVal sPath ) 
		Dim intCount
		Dim sChar
		Dim sTmp
		Dim intDot
		
		If IsEmpty( sPath ) Then
			IsPath = False
			Exit Function
		End If
		
		' double dots, may indicate a drive (ignore it)
		intDot = InStr( sPath, ":" ) 
		If intDot > 0 Then
			If intDot = 2 Then
				sPath = Right( sPath, Len( sPath ) - 2 )
			Else
				IsPath = False
				Exit Function
			End If
		End If
		
		' check for invalid chars (complexity n^2 - quadratic)
		sPath = LCase( sPath )
		For intCount = 1 To Len( sPath )
			sChar = Mid( sPath, intCount, 1 )
			If ( sChar < "a" or sChar > "z" ) and ( sChar < "0" or sChar > "9" ) and InStr( " ._- \()[]{}", sChar ) <= 0 Then
				IsPath = False
				Exit Function
			End If
		Next

		IsPath = True
	End Function
	
	' parse a path by syntax only (doesn´t check physical availability)
	' if it´s a valid path then overwrites current filename and local_path properties
	Private Function TranslateURL( ByVal sPath )
		Dim aSub
		Dim intIgnore, intCount, intTmp
		Dim sTmp
		Dim lastDot
		Dim lastSlash

		' initial necessary formatting (this can alter the original string)
		sPath = FormatPath( sPath )

		' make sure that it doesn´t have the root with it
		sPath = Replace( sPath, main_root, "", 1, -1 )

		If Not IsPath( sPath ) or Not main_root_active Then
			local_path = ""
			filename = ""
			filetype = ""
			TranslateURL = False
			Exit Function
		End If

		' build the path from the main root 
		sPath = Trim( LCase( sPath ) )
		If Left( sPath, 1 ) <> "\" Then
			' relative path
			sPath = main_root & local_path & sPath
		Else
			' from the root
			sPath = main_root & Right( sPath, Len( sPath ) - 1 )
		End If

		' navigate to check relatives ".."
		aSub = Split( sPath, "\" )
		intCount = 0
		For intCount = 0 To UBound( aSub )
			If InStr( aSub( intCount ), ".." ) Then
				If intCount > 0 Then
					' backtrack to erase unneeded subfolders
					intTmp = intCount - 1
					While aSub( intTmp ) = "" and intTmp > 0
						intTmp = intTmp - 1
					Wend
					aSub( intTmp ) = ""
				End If
				aSub( intCount ) = ""
			End If
		Next
		
		' re-build the absolute folder path without the ".."
		sTmp = ""
		For intCount = 0 To UBound( aSub )
			If aSub( intCount ) <> "" Then
				sTmp = sTmp & Trim( aSub( intCount ) ) & "\"
			End If
		Next
		sTmp = Left( sTmp, Len( sTmp ) - 1 )
		
		' if the relative ".." goes below the root, it´s invalid
		If Left( sTmp, Len( main_root ) ) <> main_root Then
			TranslateURL = False
			Exit Function
		End If

		sPath = Replace( sTmp, main_root, "" )
		' see if there´s a filename in the this path (basically: there´s a dot)
		lastDot = InStrRev( sPath, "." )
		lastSlash = InStrRev( sPath, "\" )
		If lastDot > 0 Then 
			If lastDot > lastSlash and Len( sPath ) - lastDot <= 3 Then
				' the dot is after the last slash, presumably an extension separator
				' the extension can´t be larger than the standard 3
				local_path	= Left( sPath, lastSlash )
				filename	= Right( sPath, Len( sPath ) - lastSlash )
				lastDot		= InStrRev( filename, "." )
				filetype	= Right( filename, Len( filename ) - lastDot )
				filename	= Left( filename, lastDot - 1 )

				TranslateURL = True
			Else
				' a dot before the last slash means invalid name
				TranslateURL = False
			End If
		Else
			local_path = sPath
			filename = ""
			filetype = ""
			If Right( local_path, 1 ) <> "\" Then
				local_path = local_path & "\"
			End If
			TranslateURL = True
		End If

	End Function

	' get other file properties
	Public Function FileInfo( ByVal sProperty )
		sProperty = LCase( Trim( sProperty ) )

		' try to get the folder data
		If file_ID = "" Then
			Call FetchFile()
		End If

		Select Case sProperty
		Case "author"
			FileInfo = file_Author
		Case "responsible"
			FileInfo = file_Responsible
		Case "description"
			FileInfo = file_Desc
		Case "id"
			FileInfo = FileID
		Case "style"
			FileInfo = SchemaFile
		Case "schema"
			FileInfo = StyleFile
		Case "name"
			FileInfo = File
		End Select
	End Function

	' get other file properties
	Public Function FolderInfo( ByVal sProperty )
		sProperty = LCase( Trim( sProperty ) )

		' try to get the folder data
		If  fld_ID = "" Then
			Call FetchFolder()
		End If

		Select Case sProperty
		Case "description"
			FolderInfo = file_Description
		Case "id"
			FolderInfo = Fld_ID
		Case "path"
			FolderInfo = Path
		End Select
	End Function

	' goes to an existing folder
	Public Function ChangePath( ByVal sPath )
		ChangePath = False
		If TranslateURL( sPath ) Then
			ChangePath = True
		End If
	End Function

	' go back in the local folders
	Public Sub GoParent
		Dim aSub
		Dim intCount

		If local_path = "" or local_path = "\" Then
			local_path = ""
			Exit Sub
		End If

		' rip the very last slash off
		If Right( local_path, 1 ) = "\" Then
			local_path = Left( local_path, Len( local_path ) - 1 )
		End If
		
		' reconstruct the path without the last element
		If InStr( local_path, "\" ) > 0 Then
			aSub = Split( local_path, "\" )
			For intCount = 0 To UBound( aSub ) - 1
				local_path = aSub( intCount ) & "\"
			Next
		Else
			local_path = ""
		End If
	End Sub

	' retrieve the folder info
	Private Function FetchFolder()
		Dim sSQL
		Dim objRS

		FetchFolder = False
		If local_path = "" or IsNull( main_root_id ) Then
			Exit Function
		End If
		
		sSQL = Replace( sql_QueryFolder, "%path%", local_path )
		sSQL = Replace( sSQL, "%root_id%", main_root_id )
		on error resume next
		' try {
			Set objRS = objConn.Execute( sSQL )
		' } catch( Err ) {
			If Err.number = 0 Then
				If Not objRS.EOF Then
					fld_ID		 = objRS( "folder_id" )
					fld_Path	 = local_path
					fld_Active	 = cInt( objRS( "is_active" ) )
					fld_Desc	 = objRS( "description" )
					
					objRS.Close
					FetchFolder = True
				End If
			End If
		' }
		on error goto 0
		Set objRS = Nothing
	End Function
	
	' retrieve the file info
	Private Function FetchFile()
		Dim sSQL
		Dim objRS

		FetchFile = False
		If filename = "" Then
			Exit Function
		End If
		' if there´s no folder information available, then force fetch
		' if fails, then exits
		If IsEmpty( fld_ID ) or fld_ID = "" Then
			If Not FetchFolder() Then
				Exit Function
			End If
		End If
	
		' check the existence first, and close asap
		sSQL = Replace( sql_QueryFile, "%filename%", filename )
		sSQL = Replace( sSQL, "%filetype%", filetype )
		If IsEmpty( fld_ID ) or fld_ID = "" Then
			sSQL = Replace( sSQL, " = %folder_id%", " is NULL" )
		Else
			sSQL = Replace( sSQL, "%folder_id%", fld_ID )
		End IF
		
		on error resume next
		' try {
			Set objRS = objConn.Execute( sSQL )
		' } catch( e ) {
			If Err.number = 0 Then
				If Not objRS.EOF Then
					file_ID		 = objRS( "id" )
					file_Name	 = objRS( "filename" )
					file_Type	 = objRS( "type" )
					file_Active	 = cInt( objRS( "is_active" ) )
					file_Style	 = objRS( "style_id" )
					file_Schema	 = objRS( "schema_id" )
					file_Folder	 = objRS( "folder_id" )
					file_Author	 = objRS( "author" )
					file_Desc	 = objRS( "description" )
					file_Responsible = objRS( "responsible" )
					
					objRS.Close
					FetchFile = True
				End If
			Else
				Call PrintErr( Err )
			End If
		' } 
		on error goto 0
		
		Set objRS = Nothing
		
	End Function

	' reset the local file settings
	Public Sub ResetLocal
		local_path = ""
		filename = ""
		filetype = ""

		fld_ID = ""
		fld_Path = ""
		fld_Active = 0
		fld_Desc = ""
	
		file_ID = ""
		file_Name = ""
		file_Active = 0
		file_Style = ""
		file_Schema = ""
		file_StyleFile = ""
		file_SchemaFile = ""
		file_Folder = ""
		file_Type = ""
		file_Author = ""
		file_Responsible = ""
		file_Desc = ""
	End Sub
	
	' this procedure creates the root folder, it´s relativelly "dangerous" as
	' it will create a folder wherever the sPath parameter says
	' - the sDesc parameter must be the URL
	Public Function CreateRoot( ByVal sPath, sURL, sDesc )
		Dim sSQL, sTmp, intCount
		Dim aSub

		' check the syntax of the path
		sPath = FormatPath( sPath )
		If Not IsPath( sPath ) and InStr( sPath, ".." ) = 0 Then
			CreateRoot = False
			Exit Function
		End If
		
		' remove the last slash for a while
		If Right( sPath, 1 ) = "\" Then
			sPath = Left( sPath, Len( sPath ) - 1 )
		End If

		' check if the root folder exists, and if not, attempts to create it
		If Not objFS.FolderExists( sPath ) Then
			sTmp = sPath & sDeletedFlag
			If objFS.FolderExists( sTmp ) Then
				' folder is marked as deleted, restore it
				on error resume next
				' try {
					Call objFS.MoveFolder( sTmp, Replace( sTmp, sDeletedFlag, "" ) )
				' } catch( Err ) {
					If Err.number <> 0 Then
						' could not restore the folder so get off
						' -- do not attempt to create another, someone must manually verify
						' why it can´t be undeleted
						Call PrintErr( Err )
						DeleteRoot = False
						Exit Function
					End If
				' }
				on error goto 0
			Else
				' check for drive
				sTmp = sPath & "\"
				If InStr( sTmp, ":" ) > 0 Then
					sTmp = Replace( sTmp, ":\", ":/" )
				End If
				aSub = Split( sTmp, "\" )
				If InStr( aSub( 0 ), ":" ) > 0 Then
					aSub( 0 ) = Replace( aSub( 0 ), ":/", ":\" )
				End If

				on error resume next
				' try {
					' create the sub-folders recursivelly
					sTmp = ""
					For intCount = 0 To UBound( aSub )
						sTmp = sTmp & aSub( intCount ) & "\"
						If Not objFS.FolderExists( sTmp ) Then
							If IsNull( objFS.CreateFolder( sTmp ) ) Then
								Call PrintErr( Err )
								CreateRoot = False
								Exit Function
							End If
						End If
					Next
				' } catch( Err ) {
					If Err.number <> 0 Then
						Call PrintErr( Err )
						CreateRoot = False
						Exit Function
					End If
				' }
				on error goto 0
			End If
		End If

		' tries to find out if this folder already exists in the DB
		Root = sPath

		If IsNull( main_root_id ) Then
			If IsEmpty( sDesc ) Then
				sDesc = ""
			End If
			If IsEmpty( sURL ) Then
				sURL = ""
			End If
			
			sDesc = Trim( sDesc )
			sURL = Trim( sURL )
			' prepare the sql command to create a brand new folder register
			sSQL = Replace( sql_InsertFolder, "%path%", sPath & "\" )
			sSQL = Replace( sSQL, "%is_active%", 1 )
			sSQL = Replace( sSQL, "%url%", sURL )
			sSQL = Replace( sSQL, "%description%", sDesc )
			sSQL = Replace( sSQL, "%root_id%", "NULL" )	' that´s what defines a root folder
			on error resume next
			' try {
				objConn.BeginTrans
				objConn.Execute sSQL
			' } catch( objConn.Errors ) {
				If objConn.Errors.Count > 0 Then
					Call PrintErr( Err )
					objConn.RollbackTrans
					CreateRoot = False
				Else
					objConn.CommitTrans
					Root = sPath
					CreateRoot = True
				End If
			' }
			on error goto 0
		Else
			' looks like this folders already exists in the DB but is marked deactivated
			sSQL = Replace( sql_UndeleteFolder, "%id%", main_root_id )
			on error resume next
			' try {
				objConn.BeginTrans
				objConn.Execute sSQL
			' } catch( objConn.Errors ) {
				If objConn.Errors.Count > 0 Then
					Call PrintErr( Err )
					objConn.RollbackTrans
					CreateRoot = False
				Else
					objConn.CommitTrans
					main_root_active = True
					CreateRoot = True
				End If
			' }
			on error goto 0
		End If
	End Function
	
	' create folders and force creation of nesting folders
	' this procedure is basically safe as it attempts to never go below the
	' assigned root folder
	Public Function CreateFolder( ByVal sDesc )
		Dim aSub
		Dim sTmp
		Dim sSQL
		Dim canCommit
		Dim objRS
		Dim intCount
		Dim sLocal
		
		If local_path = "" or IsNull( main_root_id ) Then
			CreateFolder = False
			Exit Function
		End If

		' only create if doesn´t exist already
		If FetchFolder() Then
			CreateFolder = True
			If fld_Active = 0 Then
				' try to undelete a folder
				sSQL = Replace( sql_UndeleteFolder, "%id%", fld_ID )
				on error resume next
				' try {
					oConn.BeginTrans
					oConn.Execute sSQL
				' } catch( oConn.Errors ) {
					If oConn.Errors.Count > 0 Then
						Call PrintErr( Err )
						oConn.RollbackTrans
						CreateFolder = False
					Else
						' try to rename the deleted file
						sLocal = main_root & local_path
						If InStrRev( sLocal, "\" ) = Len( sLocal ) Then
							sLocal = Left( sLocal, Len( sLocal ) - 1 )
						End If
						Call objFS.MoveFolder( sLocal & sDeletedFlag, sLocal )

						If Err.number = 0 Then
							oConn.CommitTrans
							CreateFolder = True
						Else
							Call PrintErr( Err )
							oConn.RollbackTrans
							CreateFolder = False
						End If
					End If
				' }
				on error goto 0
			End If
		Else
			If IsEmpty( sDesc ) Then
				sDesc = ""
			End If
			
			' set the query parameters
			fld_ID = Null
			fld_Path = local_path
			fld_Active = 1
			fld_Desc = Trim( Replace( sDesc, "'", "" ) )

			sSQL = Replace( sql_InsertFolder, "%path%", fld_Path )
			sSQL = Replace( sSQL, "%is_active%", fld_Active )
			sSQL = Replace( sSQL, "%description%", fld_Desc )
			sSQL = Replace( sSQL, "%url%", "" )
			sSQL = Replace( sSQL, "%root_id%", main_root_id )

			canCommit = True
			on error resume next
			' try {
				objConn.BeginTrans
				objConn.Execute sSQL
			' } finally {
				If objConn.Errors.Count > 0 Then
					Call PrintErr( Err )
					objConn.RollbackTrans
					CreateFolder = False
				Else
				
					' only create the physical folders if the current transaction
					' is successful to be commited
					' try to force creation of nested folders

					If Not objFS.FolderExists( main_root & local_path ) Then
						aSub = Split( local_path, "\" )
						sTmp = main_root
						For intCount = 0 To UBound( aSub )
							sTmp = sTmp & aSub( intCount ) & "\"
							If Not objFS.FolderExists( sTmp ) Then
								If IsNull( objFS.CreateFolder( sTmp ) ) Then
									canCommit = False
									Exit For
								End If
							End If
						Next
					End If

					If canCommit Then
						' get the folder ID before commiting
						Set objRS = objConn.Execute( sql_FolderID )
						If Not objRS.EOF Then
							fld_ID = objRS( "folder_id" )
						End If
						Set objRS = Nothing
						objConn.CommitTrans
						CreateFolder = True
					Else
						Call PrintErr( Err )
						objConn.RollbackTrans
						CreateFolder = False
					End If

				End If
			' }
			on error goto 0
	
		End If

	End Function
	
	' create a text file and force folder creation
	Public Function CreateFile( ByVal sAuthor, ByVal sDesc, ByVal sResponsible, ByRef oXSL, ByRef oSchema )
		Dim sSQL
		Dim objRS
		Dim iTmp

		If filename = "" Then
			CreateFile = False
			Exit Function
		End If

		' check the folder
		If local_path <> "" Then
			If Not objFS.FolderExists( local_path ) Then
				If Not CreateFolder( "" ) Then
					CreateFile = False
					Exit Function
				End If
			End If	
		End If

		' try to get the folder data
		If IsEmpty( fld_ID ) or fld_ID = "" Then
			Call FetchFolder()
		End If

		' if the folder_id is still null then abort
		If IsEmpty( fld_ID ) or fld_ID = "" Then
			CreateFile = False
			Exit Function
		End If

		' only create file if it doesn´t exist already
		If FetchFile() Then
			CreateFile = True
			If file_Active = 0 Then
				' try to undelete a file
				sSQL = Replace( sql_UndeleteFile, "%id%", file_ID )
				on error resume next
				' try {
					oConn.BeginTrans
					oConn.Execute sSQL
				' } catch( oConn.Errors ) {
					If oConn.Errors.Count > 0 Then
						Call PrintErr( Err )
						oConn.RollbackTrans
						CreateFile = False
					Else
						' try to rename the deleted file
						Call objFS.MoveFile( Path & sDeletedFlag, Path )

						If Err.number = 0 Then
							oConn.CommitTrans
							CreateFile = True
						Else
							Call PrintErr( Err )
							oConn.RollbackTrans
							CreateFile = False
						End If
					End If
				' }
				on error goto 0
			End If
		Else
			file_ID = Null
			file_Name = filename
			file_Type = LCase( filetype )
			file_Active = 1
			file_Style = "NULL"
			file_Schema = "NULL"
			file_Responsible = sResponsible
			file_Author = sAuthor
			file_Desc = sDesc
			file_Folder = fld_ID

			' the only file that can have default associations is xml one
			If file_Type = "xml" Then
				' check if this is the numeric ID or the object that holds the ID
				on error resume next
				iTmp = cInt( oXSL )
				If IsNumeric( iTmp ) and Err.number = 0 Then
					file_Style = iTmp
				Else
					If Not IsNull( oXSL ) Then
						file_Style = oXSL.FileID
					End If
				End If
				on error goto 0
				
				' the same as above
				on error resume next
				iTmp = cInt( oSchema )
				If IsNumeric( iTmp ) and Err.number = 0 Then
					file_Schema = iTmp
				Else
					If Not IsNull( oSchema ) Then
						file_Schema = oSchema.FileID
					End If
				End If
				on error goto 0
			End If
					
			sSQL = Replace( sql_InsertFile, "%style_id%", file_Style )
			sSQL = Replace( sSQL, "%schema_id%", file_Schema )
			sSQL = Replace( sSQL, "%folder_id%", file_Folder )
			sSQL = Replace( sSQL, "%type%", file_Type )
			sSQL = Replace( sSQL, "%filename%", file_name )
			sSQL = Replace( sSQL, "%author%", file_Author )
			sSQL = Replace( sSQL, "%responsible%", file_Responsible )
			sSQL = Replace( sSQL, "%description%", file_Desc )

			on error resume next
			' try {
				objConn.BeginTrans
				objConn.Execute sSQL
			' } finally {
				If objConn.Errors.Count > 0 Then
					Call PrintErr( Err )
					objConn.RollbackTrans
					CreateFile = False
				Else
					' only try to create the file if the current transaction is
					' successful

					Call objFS.CreateTextFile( Path, False, False )

					If objFS.FileExists( Path ) then
						Set objRS = objConn.Execute( sql_FileID )
						If Not objRS.EOF Then
							fld_ID = objRS( "file_id" )
							objRS.Close
						End If
						Set objRS = Nothing
						objConn.CommitTrans
						CreateFile = True
					Else
						Call PrintErr( Err )
						objConn.RollbackTrans
						CreateFile = False
					End If

				End If
			' }
			on error goto 0
		End If

	End Function
	
	' open a file handler for the current file
	Private Function OpenFile( ByVal iMode )
		' check the file existance
		If filename = "" or Not objFS.FileExists( Path ) Then
			OpenFile = False
			Exit Function
		End If
		
		' check if there´s already an open document
		If Not IsNull( objFile ) Then
			on error resume next
			' try {
				objFile.Close
			' } finally {
				Set objFile = Nothing
			' }
			on error goto 0
		End If
		
		' get the file handler
		Set objFile = objFS.OpenTextFile( Path, iMode, False, iFileFormat )
		OpenFile = True
	End Function
	
	' FileHandler Wrapper: explicitly closes the current opened file
	Private Function CloseFile()
		CloseFile = FileHandler( "close", Null )
	End Function

	' FileHandler Wrapper: read the current opened file
	Public Function ReadFile( ByRef sBuffer )
		ReadFile = False
		If OpenFile( 1 ) Then
			If FileHandler( "read", sBuffer ) Then
				ReadFile = CloseFile()
			End If
		End If
	End Function
	
	' FileHandler Wrapper: write content to the current opened file
	Public Function WriteFile( ByRef sBuffer )
		WriteFile = False
		If OpenFile( 2 ) Then
			If FileHandler( "write", sBuffer ) Then
				WriteFile = CloseFile()
			End If
		End If
	End Function
	
	' internal use only
	Private Function FileHandler( ByVal sOperation, ByRef sBuffer )
		If IsNull( objFile ) Then
			FileHandler = False
			Exit Function
		End If

		on error resume next
		' try {
			Select Case sOperation
			Case "close"
				objFile.Close
				Set objFile = Nothing
			Case "read"
				sBuffer = objFile.ReadAll()
			Case "write"
				objFile.Write( sBuffer )
			End Select
		' } catch ( Err ) {	
			If Err.number <> 0 Then
				Call PrintErr( Err )
			End If
			FileHandler = ( Err.number =  0 )
		' }
		on error goto 0
	End Function

	' gives the file a "deleted" status
	Public Function DeleteFile()
		Dim sSQL

		' check if the file exists
		If Not ( filename <> "" or objFS.FileExists( Path ) ) Then
			DeleteFile = False
			Exit Function
		End If

		' fetch the file data
		If file_ID = "" Then
			If Not FetchFile() Then
				DeleteFile = False
				Exit Function
			End If
		End If

		' if object is opened, close it
		If Not IsNull( objFile ) Then
			If Not CloseFile() Then
				DeleteFile = False
			End If
		End If

		sSQL = Replace( sql_DeleteFile, "%id%", file_ID )

		on error resume next
		' try {
			objConn.BeginTrans
			objConn.Execute sSQL 
		' } catch( oConn.Errors ) {
			If objConn.Errors.Count > 0 Then
				Call PrintErr( Err )
				DeleteFile = False
				objConn.RollbackTrans
			Else

				Call objFS.MoveFile( Path, Path & sDeletedFlag )

				If Err.number <> 0 Then
					Call PrintErr( Err )
					DeleteFile = False
					objConn.RollbackTrans
				Else
					DeleteFile = True
					objConn.CommitTrans
				End If

			End If
		' }
		on error goto 0
	End Function
	
	' gives the folder a "deleted" status
	Public Function DeleteFolder()
		Dim sLocal

		' check if the folder exists
		sLocal = main_root & local_path
		If IsNull( main_root_id ) or local_path = "" or Not objFS.FolderExists( sLocal ) Then
			DeleteFolder = False
			Exit Function
		End If

		' fetch the folder data
		If IsEmpty( fld_ID ) or fld_ID = "" Then
			If Not FetchFolder() Then
				DeleteFolder = False
				Exit Function
			End If
		End If

		on error resume next
		' try {
			objConn.BeginTrans
			objConn.Execute Replace( sql_DeleteFolder, "%id%", fld_ID )
		' } catch( oConn.Errors ) {
			If objConn.Errors.Count > 0 Then
				Call PrintErr( Err )
				DeleteFolder = False
				objConn.RollbackTrans
			Else
				' try {
					If InStrRev( sLocal, "\" ) = Len( sLocal ) Then
						sLocal = Left( sLocal, Len( sLocal ) - 1 )
					End If
					Call objFS.MoveFolder( sLocal, sLocal & sDeletedFlag )
				' } catch( Err ) {
					If Err.number <> 0 Then
						Call PrintErr( Err )
						DeleteFolder = False
						objConn.RollbackTrans
					Else
						DeleteFolder = True
						objConn.CommitTrans
						
						' everything gone ok, the current local_path is invalid so try to go to the parent
						Call GoParent()
					End If
				' }
			End If
		' }
		on error goto 0
	End Function

	' deletes a root folder
	' very dangerous operation, but it will not delete folders that have content
	Public Function DeleteRoot()
		Dim oRoot, sLocal

		' check if the folder exists
		If IsNull( main_root_id ) or Not objFS.FolderExists( main_root ) Then
			DeleteRoot = False
			Exit Function
		End If

		' check if the folder is empty
		Set oRoot = objFS.GetFolder( main_root )
		If oRoot.SubFolders.Count > 0 or oRoot.Files.Count > 0 Then
			Set oRoot = Nothing
			DeleteRoot = False
			Exit Function
		End If
		Set oRoot = Nothing

		on error resume next
		' try {
			objConn.BeginTrans
			objConn.Execute Replace( sql_DeleteFolder, "%id%", main_root_id )
		' } catch( oConn.Errors ) {
			If objConn.Errors.Count > 0 Then
				Call PrintErr( Err )
				DeleteRoot = False
				objConn.RollbackTrans
			Else
				on error resume next
				' try {
					sLocal = main_root
					If InStrRev( sLocal, "\" ) = Len( sLocal ) Then
						sLocal = Left( sLocal, Len( sLocal ) - 1 )
					End If
					Call objFS.MoveFolder( sLocal, sLocal & sDeletedFlag )
				' } catch( Err ) {
					If Err.number <> 0 Then
						Call PrintErr( Err )
						DeleteRoot = False
						objConn.RollbackTrans
					Else
						DeleteRoot = True
						main_root = ""
						main_root_id = null
						objConn.CommitTrans
					End If
				' }
				on error goto 0
			End If
		' }
		on error goto 0
	End Function
	
	' formats a simple XML node 
	Private Function GetXMLNode( ByVal sLabel, ByVal sValue )	
		GetXMLNOde = "<" & sLabel & ">" & sValue & "</" & sLabel & ">" & vbCRLF
	End Function

	' return all the root folders
	' <roots>
	'	<folder>...</folder>
	' </roots>
	Public Sub GetRoots( ByRef sBuffer )
		Dim oFolder, sLocal, objRS, sPath
		sBuffer = "<roots>" & vbCRLF
		Set objRS = objConn.Execute( sql_ListRoot )
		While Not objRS.EOF 
			' return an XML formatted table
			If cInt( objRS( "is_active" ) ) = 1 Then
				on error resume next
				' try {
					sPath = Left( objRS( "path" ), Len( objRS( "path" ) ) - 1 )
					Set oFolder = objFS.GetFolder( sPath )
				' } catch( Err ) {
					If Err.number = 0 Then
						sBuffer = sBuffer & _ 
						"<folder>" & vbCRLF & _
							GetXMLNode( "name",			oFolder.name ) & vbCRLF & _
							GetXMLNode( "shortname",	oFolder.shortname ) & vbCRLF & _
							GetXMLNode( "type",			oFolder.type ) & vbCRLF & _
							GetXMLNode( "size",			oFolder.size ) & vbCRLF & _
							GetXMLNode( "path",			oFolder.path ) & vbCRLF & _
							GetXMLNode( "shortpath",	oFolder.shortpath ) & vbCRLF & _
							GetXMLNode( "created",		oFolder.DateCreated ) & vbCRLF & _
							GetXMLNode( "lastmodified",	oFolder.DateLastModified ) & vbCRLF & _
							GetXMLNode( "description",	objRS( "description" ) ) & vbCRLF & _
						"</folder>" & vbCRLF 
					Else
						Call PrintErr( Err )
					End If
				' }
				on error goto 0
				Set oFolder = Nothing
			End If
			objRS.MoveNext
		Wend
		sBuffer = sBuffer & "</roots>"
		
		If Len( sBuffer ) = Len( "<roots>" & vbCRLF & "</roots>" ) Then
			sBuffer = ""
		End If
	End Sub

	' return all the subfolder info of the current folder
	' <subfolders>
	'	<parent>...</parent>
	'	<folder>...</folder>
	'	...
	' </subfolders>
	Public Sub GetFolders( ByRef sBuffer )
		Dim oRoot, oFolder, sLocal
		
		on error resume next
		' try {
			sLocal = main_root & local_path
			Set oRoot = objFS.GetFolder( Left( sLocal, Len( sLocal ) - 1 ) )
		' } catch( Err ) {
			If Err.number = 0 Then
				' return an XML formatted table
				sBuffer = "<subfolders>" & vbCRLF
				For Each oFolder in oRoot.SubFolders
					If InStr( oFolder.name, sDeletedFlag ) = 0 Then
						If ( Not isUser ) or ( isUser and Left( oFolder.name, 1 ) <> "." ) Then
							sBuffer = sBuffer & _ 
							"<folder>" & vbCRLF & _
								GetXMLNode( "name",			oFolder.name ) & vbCRLF & _
								GetXMLNode( "shortname",	oFolder.shortname ) & vbCRLF & _
								GetXMLNode( "type",			oFolder.type ) & vbCRLF & _
								GetXMLNode( "path",			oFolder.path ) & vbCRLF & _
								GetXMLNode( "shortpath",	oFolder.shortpath ) & vbCRLF & _
								GetXMLNode( "created",		oFolder.DateCreated ) & vbCRLF & _
								GetXMLNode( "lastmodified",	oFolder.DateLastModified ) & vbCRLF & _
							"</folder>" & vbCRLF
						End If
					End If
				Next
				sBuffer = sBuffer & "</subfolders>"
			Else
				Call PrintErr( Err )
			End If
		' }
		on error goto 0
		Set oRoot = Nothing
		
		If Len( sBuffer ) = Len( "<subfolders>" & vbCRLF & "</subfolders>" ) Then
			sBuffer = ""
		End If
	End Sub

	' return all the files info of the current folder
	' <files>
	'	<parent>...</parent>
	'	<file>...</file>
	'	...
	' </files>
	Public Sub GetFiles( ByRef sBuffer )
		Dim oRoot, oFile, sLocal
		
		on error resume next
		' try {
			sLocal = main_root & local_path
			Set oRoot = objFS.GetFolder( Left( sLocal, Len( sLocal ) - 1 ) )
		' } catch( Err ) {
			If Err.number = 0 Then
				' return an XML formatted table
				sBuffer = "<files>" & vbCRLF
				For Each oFile in oRoot.Files
					If InStr( oFile.name, sDeletedFlag ) = 0 Then
						If ( Not isUser ) or ( isUser and Left( oFile.name, 1 ) <> "." ) Then
							sBuffer = sBuffer & _
							"<file>" & vbCRLF & _
								GetXMLNode( "name",			oFile.name ) & vbCRLF & _
								GetXMLNode( "shortname",	oFile.shortname ) & vbCRLF & _
								GetXMLNode( "type",			oFile.type ) & vbCRLF & _
								GetXMLNode( "size",			oFile.size ) & vbCRLF & _
								GetXMLNode( "path",			oFile.path ) & vbCRLF & _
								GetXMLNode( "shortpath",	oFile.shortpath ) & vbCRLF & _
								GetXMLNode( "created",		oFile.DateCreated ) & vbCRLF & _
								GetXMLNode( "lastmodified",	oFile.DateLastModified ) & vbCRLF & _
							"</file>" & vbCRLF
						End If
					End If
				Next
				sBuffer = sBuffer & "</files>"
			Else
				Call PrintErr( Err )
			End If
		' }
		on error goto 0
			
		Set oRoot = Nothing
		If Len( sBuffer ) = Len( "<files>" & vbCRLF & "</files>" ) Then
			sBuffer = ""
		End If
	End Sub

	' return the content of a ".description.xml" if there´s any
	Public Sub GetDescription( ByRef sBuffer )
		Dim oFile, sLocal
		
		sLocal = main_root & local_path & description_file
		on error resume next
		' try {
			If objFS.FileExists( sLocal ) Then
				Set oFile = objFS.OpenTextFile( sLocal, 1, False, iFileFormat )
				' 1 = readonly
				sBuffer = oFile.ReadAll()
			End If
		' } catch( Err ) {
			If Err.number <> 0 Then
				Call PrintErr( Err )
			End If
		' }
		on error goto 0
			
		Set oFile = Nothing
	End Sub

	' associate 2 TXMLSynchro objects
	Public Function CreateShortcut( ByVal sLabel, ByRef oXSL )
		Dim sSQL
		Dim iThisFile
		Dim iOtherFile

		CreateShortcut = False
		If IsNull( sLabel ) or IsNull( oXSL ) Then
			Exit Function
		End If
		
		on error resume next
		' try {
			iThisFile = FileID
			iOtherFile = oXSL.FileID
		' } catch( Err ) {
			If Err.number = 0 and Not IsEmpty( iThisFile ) and Not IsEmpty( iOtherFile ) Then
				sSQL = Replace( sql_InsertShortcut, "%language_id%", iLanguageID )
				sSQL = Replace( sSQL, "%xml_id%", iThisFile )
				sSQL = Replace( sSQL, "%xsl_id%", iOTherFile )
				sSQL = Replace( sSQL, "%label%", sLabel )
				on error resume next
				' try {
					objConn.BeginTrans
					oConn.Execute sSQL
				' } catch( oConn.Errors ) {
					If oConn.Errors.Count > 0 Then
						Call PrintErr( Err )
						oConn.RollbackTrans
						CreateShortcut = False
					Else
						oConn.CommitTrans
						CreateShortcut = True
					End If
				' }
				on error goto 0
			Else
				Call PrintErr( Err )
			End If
		' }
		on error goto 0
	End Function

	' fill in data into the 2 available TXMLSynchro object thru 
	' a previous shortcut association	
	Public Function GetShortcut( ByVal sLabel, ByRef oXSL )
		Dim sSQL, sTmp
		Dim oRS
	
		If IsNull( sLabel ) or IsNull( oXML ) or IsNull( oXSL ) Then
			GetShortcut = False
			Exit Function
		End If
		
		GetShortcut = True ' default until procedure fails
		
		' -- retrieve the XML data
		sTmp = ""
		sSQL = Replace( sql_QueryShortcutXML, "%language_id%", iLanguageID )
		sSQL = Replace( sSQL, "%label%", sLabel )
		on error resume next
		' try {
			Set oRS = oConn.Execute( sSQL )
		' } catch( Err ) {
			If Err.number = 0 Then
				If Not oRS.EOF Then
					sTmp = oRS( "path" ) & oRS( "filename" )
					If Len( oRS( "type" ) ) > 0 Then
						 sTmp = sTmp & "." & oRS( "type" )
					End If
					Call ChangePath( sTmp )	
					Call FetchFile()
				End If
			Else
				Call PrintErr( Err )
				GetShortcut = False
				Exit Function
			End If
		' }
		on error goto 0
		
		' -- retrieve the XSL data
		sTmp = ""
		sSQL = Replace( sql_QueryShortcutXSL, "%language_id%", iLanguageID )
		sSQL = Replace( sSQL, "%label%", sLabel )
		on error resume next
		' try {
			Set oRS = oConn.Execute( sSQL )
		' } catch( Err ) {
			If Err.number = 0 Then
				If Not oRS.EOF Then
					sTmp = oRS( "path" ) & oRS( "filename" )
					If Len( oRS( "type" ) ) > 0 Then
						 sTmp = sTmp & "." & oRS( "type" )
					End If
					Call oXSL.ChangePath( sTmp )					
					Call oXSL.FetchFile()
				End If
			Else
				Call PrintErr( Err )
				GetShortcut = False
				Exit Function
			End If
		' }
		on error goto 0
	End Function

	' make schema and style files association to the current base XML file
	Public Function CreateBaseLink( ByRef oStyle, ByRef oSchema )
		Dim sSQL
		Dim sSchema, sStyle

		If IsEmpty( file_ID ) or file_ID = "" Then
			Call FetchFile()
		End If
	
		' get the style file id
		If Not IsNull( oStyle ) Then
			file_Style = oStyle.FileID
		End If

		' get the schema file id
		If Not IsNull( oSchema ) Then
			file_Schema = oSchema.FileID
		End If
	
		' there must be the file_ID and at least one of the associations
		If ( file_Style = "" and file_Schema = "" ) or file_ID = "" Then
			CreateBaseLink = False
			Exit Function
		End If
		
		' check values
		sStyle = "NULL"
		If file_Style <> "" Then
			sStyle = file_Style
		End If
		
		sSchema = "NULL"
		If file_Schema <> "" Then
			sSchema = file_Schema
		End If
		
		' render the SQL command
		sSQL = Replace( sql_CreateBaseLinks, "%schema_id%", sSchema )
		sSQL = Replace( sSQL, "%style_id%", sStyle )
		sSQL = Replace( sSQL, "%id%", file_ID )

		on error resume next
		' try {
			objConn.Execute sSQL
		' } catch( objConn.Errors ) {
			If objConn.Errors.Count > 0 Then
				objConn.RollbackTrans
				CreateBaseLink = False
				Call PrintErr( Err )
			Else
				objConn.CommitTrans
				CreateBaseLink = True
			End If
		' }
		on error goto 0
	End Function

	' defines sql queries
	Private Sub DefineQueries
		If isOracle Then
			' queries and commands for Oracle 8i compatible

			sql_InsertFolder	= "insert into tbXML_folders ( folder_id, root_id, creation_date, is_active, path, url, description ) " & _
								" values ( seq_tbXML_folders.NextVal, %root_id%, SYSDATE, 1, '%path%', '%url%', '%description%' )"

			sql_InsertFile		= "insert into tbXML_base ( id, creation_date, is_active, style_id, schema_id, folder_id, type, filename, author, responsible, description ) " & _
								" values ( seq_tbXML_base.NextVal, SYSDATE, 1, %style_id%, %schema_id%, %folder_id%, '%type%', '%filename%', '%author%', '%responsible%', '%description%' )"

			sql_DeleteFolder	= "update tbXML_folders set is_active = '0' where folder_id = '%id%'"
			
			sql_DeleteFile		= "update tbXML_base set is_active = '0' where id = '%id%'"

			sql_UndeleteFolder	= "update tbXML_folders set is_active = '1' where folder_id = '%id%'"
			
			sql_UndeleteFile	= "update tbXML_base set is_active = '1' where id = '%id%'"
	
			sql_QueryFolder		= "select * from tbXML_folders where LOWER( path ) = LOWER( '%path%' ) and root_id = '%root_id%'"
		
			sql_QueryFile		= "select * from tbXML_base where LOWER( filename ) = LOWER( '%filename%' ) and type = '%filetype%' and folder_id = %folder_id%"
			
			sql_QueryFileID		= "select filename, type, tbXML_folders.path from tbXML_base, tbXML_folders where tbXML_folders.folder_id = tbXML_base.folder_id and id = %id%"

			sql_QueryRoot		= "select * from tbXML_folders where root_id is null and LOWER( path ) = LOWER( '%path%' )"
			
			sql_ListRoot		= "select * from tbXML_folders where root_id is null"
		
			sql_FolderID		= "select seq_tbXML_folders.CurrVal folder_id from DUAL" 
		
			sql_FileID			= "select seq_tbXML_base.CurrVal file_id from DUAL"
			
			sql_InsertShortcut	= "insert into tbXML_front ( front_id, language_id, xml_id, style_id, shortcut, creation, deleted ) values ( seq_tbXML_front.NextVal, %language_id%, %xml_id%, %xsl_id%, '%label%', SYSDATE, 0 )"

			sql_QueryShortcutXML = "select b.filename, b.type, ff.path from tbXML_front f, tbXML_base b, tbXML_folders ff where f.xml_id = b.id and b.folder_id = ff.folder_id and b.is_active = 1 and ff.is_active = '1' and f.language_id = %language_id%  and f.shortcut = '%label%'and f.deleted = 0"

			sql_QueryShortcutXSL = "select b.filename, b.type, ff.path from tbXML_front f, tbXML_base b, tbXML_folders ff where f.style_id = b.id and b.folder_id = ff.folder_id and b.is_active = 1 and ff.is_active = '1' and f.language_id = %language_id% and f.shortcut = '%label%' and f.deleted = 0"
			
			sql_CreateBaseLinks = "update tbXML_base set schema_id = %schema_id%, style_id = %style_id% where id = %id%"
		Else
			' queries and commands for MS SQL Server compatible
			
			sql_InsertFolder	= "insert into tbXML_folders ( root_id, creation_date, is_active, path, url, description ) " & _
								" values ( %root_id%, getdate(), 1, '%path%', '%url%', '%description%' )"

			sql_InsertFile		= "insert into tbXML_base ( creation_date, is_active, style_id, schema_id, folder_id, type, filename, author, responsible, description ) " & _
								" values ( getdate(), 1, %style_id%, %schema_id%, %folder_id%, '%type%', '%filename%', '%author%', '%responsible%', '%description%' )"

			sql_UndeleteFolder	= "update tbXML_folders set is_active = '1' where folder_id = '%id%'"
			
			sql_UndeleteFile	= "update tbXML_base set is_active = '1' where id = '%id%'"

			sql_DeleteFolder	= "update tbXML_folders set is_active = '0' where folder_id = '%id%'"
			
			sql_DeleteFile		= "update tbXML_base set is_active = '0' where id = '%id%'"
				
			sql_QueryFolder		= "select * from tbXML_folders where LOWER( path ) = LOWER( '%path%' ) and root_id = '%root_id%'"
		
			sql_QueryFile		= "select * from tbXML_base where LOWER( filename ) = LOWER( '%filename%' ) and type = '%filetype%' and folder_id = %folder_id%"
			
			sql_QueryFileID		= "select filename, type, tbXML_folders.path from tbXML_base, tbXML_folders where tbXML_folders.folder_id = tbXML_base.folder_id and id = %id%"
			
			sql_QueryRoot		= "select * from tbXML_folders where root_id is null and LOWER( path ) = LOWER( '%path%' )"
			
			sql_ListRoot		= "select * from tbXML_folders where root_id is null"
		
			sql_FolderID		= "select top 1 folder_id from tbXML_folders order by creation_date desc" 
		
			sql_FileID			= "select top 1 id file_id from tbXML_base order by creation_date desc"

			sql_InsertShortcut	= "insert into tbXML_front ( language_id, xml_id, style_id, shortcut, created, deleted ) values ( %language_id%, %xml_id%, %xsl_id%, '%label%', GetDate(), 0 )"

			sql_QueryShortcutXML = "select b.filename, b.type, ff.path from tbXML_front f, tbXML_base b, tbXML_folders ff where f.xml_id = b.id and b.folder_id = ff.folder_id and b.is_active = 1 and ff.is_active = '1' and f.language_id = %language_id% and f.shortcut = '%label%' and f.deleted = 0"

			sql_QueryShortcutXSL = "select b.filename, b.type, ff.path from tbXML_front f, tbXML_base b, tbXML_folders ff where f.style_id = b.id and b.folder_id = ff.folder_id and b.is_active = 1 and ff.is_active = '1' and f.language_id = %language_id% and f.shortcut = '%label%' and f.deleted = 0"

			sql_CreateBaseLinks = "update tbXML_base set schema_id = %schema_id%, style_id = %style_id% where id = %id%"
		End If
	End Sub
	
	' constructor - make initial settings
	Private Sub Class_Initialize
		isDebug = False
		main_root_active = False
		main_root_id = null		
		main_root = ""
		main_root_URL = ""
		
		iFileFormat = -2
		sDeletedFlag = "_deleted"
		iLanguageID = -1
		sErrors = ""
		description_file = ".description.xml"
		
		Set objFS = Nothing
		Set objConn = Nothing

		' defines the sql queries (defaults to Oracle)
		isOracle = True		
		
		isUser = False
		Call DefineQueries()
		
		Call ResetLocal()
	End Sub
	
	' destructor
	Private Sub Class_Terminate
		' clean up memory
		If Not IsNull( objFile ) Then
			on error resume next
			' try {
				objFile.Close
			' } finally {
			' }
			on error goto 0
		End If
		Set objFile = Nothing
	End Sub
End Class

%>