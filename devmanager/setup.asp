<!-- #include file="../incs/inc_constructor.asp" -->
<html>
<script language="JScript">
// instantiates the global controller
var oControl  = new TDialogControl();
</script>
<link rel="stylesheet" href="../styles.css">
<title>Control Panel</title>
<body onload = "oControl.RunQueue()">
<p class="maintitle">XML Tools - Control Panel</p>
<ul>
	<li><a href="#" onclick="OpenApplet( 'setup_root.asp' )">Root Path Configuration</a></li>
	<li><a href="#" onclick="OpenApplet( 'setup_languages.asp' )">Language Manager</a></li>
	<li><a href="#" onclick="OpenApplet( 'setup_translation.asp' )">Translation Manager</a></li>
	<li><a href="#" onclick="OpenApplet( 'setup_shortcuts.asp' )">Shortcut Manager</a></li>
	<li><a href="#" onclick="OpenApplet( 'setup_cleanevents.asp' )">Clean Up Events</a></li>
	<li><a href="#" onclick="OpenApplet( '../incs/reflection.asp' )">WSC Reflection</a></li>
</ul>
<!-- #include file="inc_menu.asp" -->
</body>
</html>

<div id="divContainer" style="position:absolute; visibility: hidden; width:640px; height:480px; z-index:1; left: 0px; top: 0px" class="floatingbox"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="1">
    <tr> 
      <td class="dragtitle"> 
        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="boxtitle">-- Container</td>
            <td align="right"><button name="btCancel" onclick="oControl.Get('divContainer').Hide()"> X </button></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td><iframe id="frameContainer" src="../incs/blank.asp" width="640" height="480" marginwidth="0" marginheight="0"></iframe></td>
    </tr>
  </table>
</div>

<script language="JScript">
// add this dialog to the controller
oControl.AddQueue( 'divContainer' );

function OpenApplet( sPage ) {
	document.all( 'frameContainer' ).src = sPage;
	oControl.Get( 'divContainer' ).Show();
}
</script>

<!-- #include file="../incs/inc_destructor.asp" -->