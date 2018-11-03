<%
' generate random form seed
Randomize
Session( "seedmodule" ) = cStr( Round( Rnd * 20000 ) )
%>
<html>
<head>
<title>Loader configurator</title>
<script language="JScript">
function SetParent() {
	// gives this document´s form handler to the parent controller
	if ( parent ) {
		parent.oFormModule = document.formModule;
	} else {
		alert( 'Loader: Looks like the controller is not correctly set.\nTry reloading this document.' );
	}
}
</script>
</head>
<body onload="SetParent()">
  <form name="formModule" method="POST" action="../usermodules/module_loader.asp">
  <input type="hidden" name="modulefolder" value="">
  <input type="hidden" name="modulestarter" value="">
  <input type="hidden" name="xmlfile" value="">
  <input type="hidden" name="synchroRoot" value="">
  <input type="hidden" name="synchroPath" value="">
  <input type="hidden" name="seedmodule" value="<%=Session("seedmodule")%>">
  </form>
</body>
</html>