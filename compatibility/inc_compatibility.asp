<%
Dim sHTTP, posMSIE, isMSIE5, isPC

sHTTP = Request.ServerVariables( "HTTP_USER_AGENT" )
posMSIE = InStr( sHTTP, "MSIE" )
isMSIE5 = "NO"
If posMSIE > 0 Then
	on error resume next
	intVersion = cInt( Mid( sHTTP, posMSIE + 5, 1 ) )
	If Err.number = 0 and intVersion >= 5 Then
		isMSIE5 = "YES"
	End If
	on error goto 0
End If

isPC = "NO"
If InStr( sHTTP, "Win" ) Then
	isPC = "YES"
End If
%>

<object 
	id="MSXML3"
	classid="clsid:f5078f19-c551-11d3-89b9-0000f81fe221"
	codebase="../compatibility/msxml3.cab#version=8,00,7820,0"
	type="application/x-oleobject"
	style="display: none"></object>

<table width="500" border="0" cellspacing="0" cellpadding="1" class="floatingbox">
  <tr> 
    <td colspan="2" class="boxtitle">-- Detecting needed Components</td>
  </tr>
  <tr valign="top"> 
    <td></td>
    <td><u>Workaround (if "NO"):</u></td>
  </tr>
  <tr valign="top" nowrap> 
    <td>Internet Explorer 5.0? <b><%=isMSIE5%></b></td>
    <td>- <a href="http://www.microsoft.com/ie">get IE 5 here</a></td>
  </tr>
  <tr valign="top" nowrap> 
    <td>JScript? <b> 
    <script language="JScript">
    document.write ( "YES" );
    </script>
      <noscript>NO</noscript> </b> </td>
    <td>- activate the javascript of your browser</td>
  </tr>
  <tr valign="top" nowrap> 
    <td>Microsoft XML 3.0? <b> 
      <script language="JScript">
    try {
		var oXML = new ActiveXObject( "MSXML2.DomDocument.3.0" );
		document.write( 'YES' );
	} catch( e ) {
		document.write( 'NO' );
	}
    </script>
      </b> </td>
    <td>- <a href="msxml3.exe" onmouseover="document.all('divMSXML').style.display='block'" onmouseout="document.all('divMSXML').style.display='none'">get 
      MSXML 3 here</a> 
    </td>
  </tr>
  <tr valign="top" nowrap> 
    <td>Intel Compatible PC? <b><%=isPC%></b></td>
    <td>- switch to a PC machine</td>
  </tr>
  <tr> 
    <td></td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2">
      <div id="divMSXML" style="position: relative; display: none;"> <i>(*) this 
        page automatically tries to install the MSXML component. You can see it 
        if your browser asks you to confirm the installation of a Microsoft component 
        or if your browser suddenly starts to load something (check out the bottom 
        status bar of your browser and wait until it finishes loading).</i> </div>
	</td>
  </tr>
</table>
