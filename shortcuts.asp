<!-- #include file="incs/txmlfront.asp" -->
<style>
td { font-family: Tahoma, Verdana, Arial, Helvetica; font-size: 9pt }
</style>
<table>
<tr><td><b>shortcut</b></td><td><b>language</b></td><td><b>xml</b></td><td><b>style</b></td></tr>
<tr><td colspan="4"></td></tr>
<%
Set oConn = Server.CreateObject( "ADODB.Connection" )
oConn.Open "DSN=PMIDB;UID=pmiuser;PWD=pmiuser"

sSQL = "select shortcut, language_id, " & _
" folder1.path || file1.filename || '.' || file1.type xml, " & _
" folder2.path || file2.filename || '.' || file2.type xsl " & _
" from tbXML_Front, tbXML_folders folder1, tbXML_folders folder2, tbXML_base file1, tbXML_base file2 " & _
" where file1.id = tbXML_front.xml_id " & _
" and file2.id = tbXML_front.style_id " & _
" and file1.folder_id = folder1.folder_id " & _
" and file2.folder_id = folder2.folder_id " & _
" order by shortcut "

Set oRS = oConn.Execute ( sSQL )

While Not oRS.EOF
	Response.Write "<tr><td>" & oRS( "shortcut" ) & "</td><td align=""right"">" & oRS( "language_id" ) & "</td><td>" & oRS( "xml" ) & "</td><td>" & oRS( "xsl" ) & "</td></tr>" & vbCRLF
	oRS.MoveNext
Wend

Set oRS = Nothing
Set oConn = Nothing
%>
</table>