<!-- #include file="../incs/inc_constructor.asp" -->
<%
' called by frame_loader.asp
' get´s the settings submitted from frame_loader and diag_operations
' builds a final URL that leads to the module

If Request( "seedmodule" ) = Session( "seedmodule" ) Then
	' gets the user configurations
	Dim sRoot, sPath, sXML, sModuleFolder, sModuleStarter
	sRoot = Request( "synchroRoot" )
	sPath = Request( "synchroPath" )
	sXML = Request( "xmlfile" )
	sModuleFolder = Request( "modulefolder" )
	sModuleStarter = Request( "modulestarter" )
	
	' set the synchro object
	oSynchro.Root = sRoot
	oSynchro.Path = sPath
	
	' find the schema and style files
	Dim sSchema, sStyle
	sSchema = oSynchro.SchemaFile
	sStyle = oSynchro.StyleFile
	
	' prepare as URLs
	sSchema = Replace( sSchema, oSynchro.Root, "" )
	sStyle = Replace( sStyle, oSynchro.Root, "" )
	
	sSchemaURL = oSynchro.RootURL & Replace( sSchema, "\", "/" )
	sSchema = oSynchro.Root & Replace( sSchema, "/", "\" )
	sStyle = oSynchro.RootURL & Replace( sStyle, "\", "/" )
	
	' build the URL to load the module
	Dim sURL
	sURL = sModuleFolder & "/" & sModuleStarter & _
	"?xmlfile=" & Server.URLPathEncode( sXML ) & _
	"&xslfile=" & Server.URLPathEncode( sStyle ) & _
	"&schemafile=" & Server.URLPathEncode( sSchema ) & _
	"&schemaurl=" & Server.URLPathEncode( sSchemaURL )
	
	Response.Redirect sURL
End If
%>
<!-- #include file="../incs/inc_destructor.asp" -->