<%
' load the pre-declared modules list
oXML.load( Server.MapPath( "../usermodules/modules.xml" ) )
oXSL.load( Server.MapPath( "modules_list.xsl" ) )
%>
<div id="divOperations" style="position:absolute; visibility: hidden; width:150px; height:30px; z-index:1; left: 34px; top: 373px" class="floatingbox"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="1">
  <form name="formOperations">
    <tr> 
      <td class="dragtitle" colspan="3"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="boxtitle">-- Modules</td>
            <td align="right">
            <button name="btCancel" onclick="oControl.Get('divOperations').Hide()"> X </button>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td> 
      <select name="listModules">
      <option selected>Select a module</option>
      <% oXML.transformNodeToObject oXSL, Response %>
      </select>
      </td>
      <td><button name="btOpen" onclick="OpClickOpen( this.form )">Open</button></td>
      <td><button name="btInfo" onclick="OpClickInfo( this.form )">Info</button></td>
    </tr>
  </form>
  </table>

</div>
<script language="JScript">
// add this dialog to the controller
oControl.AddQueue( 'divOperations' );

// global
var sModulesFolder = '../usermodules/';
var sModulesDescriptor = '/mod_description.xml';
var oFormModule = null;		// expecs that the diag_container iframe gives it´s form handler

// handles opening a new module
function OpClickOpen( oForm ) {
	if ( (!oForm) || (oForm.listModules.selectedIndex <= 0) || (!oFormModule) ) { return false }

	sURL = sModulesFolder + oForm.listModules.value + sModulesDescriptor;
	var oXML = new ActiveXObject( "MSXML.DOMDocument" );
	oXML.async = false;
	oXML.validateOnParse = false;

	try {
		oXML.load( sURL );
		var oXMLRoot = oXML.documentElement;
		var oList = oXMLRoot.getElementsByTagName( 'startFile' );
		sStartFile = oList( 0 ).text;
	} catch( e ) {
		alert( 'There\'s some problem loading the modules description file' +
		'\n' + e.description );
	}

	// module loader -- will fetch the schema and style files
	try {
		with ( oFormModule ) {
			modulefolder.value = oForm.listModules.value;
			modulestarter.value = sStartFile;
			xmlfile.value = globalURL + eventPath.replace( globalRoot, '' );
			synchroRoot.value = globalRoot;
			synchroPath.value = eventPath;
			
			oList = oXMLRoot.getElementsByTagName( 'system' );
			if ( oList.length > 0 ) {
				action = sModulesFolder + modulefolder.value + '/' + sStartFile;
			}
			submit();
		}
	} catch( e ) {
		alert( 'Something wrong with the module loader configuration\n' + e.description );
	}		
	
	// open the module box
	if ( CtOpenModule ) {
		CtOpenModule();
	}
	var oXML = null;
}

// handles fetching the modules info
function OpClickInfo( oForm ) {
	if ( (!oForm) || 
	(oForm.listModules.selectedIndex <= 0) ) { return false }

	sURL = sModulesFolder + oForm.listModules.value + sModulesDescriptor;
	var oXML = new ActiveXObject( "MSXML.DOMDocument" );
	oXML.async = false;
	oXML.validateOnParse = false;
	try {
		oXML.load( sURL );
		var oXMLRoot = oXML.documentElement;
		var oList = oXMLRoot.getElementsByTagName( 'name' );
		sInfo = 'Module Name: ' + oList( 0 ).text;

		var oList = oXMLRoot.getElementsByTagName( 'version' );
		sInfo += '\nVersion: ' + oList( 0 ).text;

		var oList = oXMLRoot.getElementsByTagName( 'revision' );
		sInfo += '.' + oList( 0 ).text;

		var oList = oXMLRoot.getElementsByTagName( 'author' );
		sInfo += '\nAuthor: ' + oList( 0 ).text;
		
		var oList = oXMLRoot.getElementsByTagName( 'shortDescription' );
		sInfo += '\n\n' + oList( 0 ).text;

		alert( sInfo );
	} catch( e ) {
		alert( 'There\'s some problem loading the modules description file' +
		'\n' + e.description );
	}
	var oXML = null;
}
</script>
