<div id="divOperations" style="position:absolute; visibility: hidden; width:150px; height:30px; z-index:1; left: 34px; top: 373px" class="floatingbox" selectable="true">
  <table width="100%" border="0" cellspacing="0" cellpadding="1">
  <form name="formOperations">
    <tr> 
      <td class="dragtitle"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="boxtitle">-- Operations</td>
            <td align="right">
            <button name="btCancel" onclick="oControl.Get('divOperations').Hide()"> X </button>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td> 
      <select name="OpList" onchange="HandleOpList( this.form )">
      <option value="open">		Open</option>
      <option value="delete">	Delete</option>
      <option value="shortcut">	Shortcut</option>
      <option value="base">		Association</option>
      <option value="check">	Check XML</option>
      </select>
      <button onclick="HandleOpList( this.form )">Execute</button>
      </td>
    </tr>
  </form>
  </table>	
</div>

<script language="JScript"><!--
// add this dialog to the controller
oControl.AddQueue( 'divOperations' );

function HandleOpList( oForm ) {
	switch ( oForm.OpList.value ) {
	case 'open' : 
		OpClickOpen();
		break;
	case 'delete' :
		OpClickDelete();
		break;
	case 'shortcut' :
		OpClickAssociation();
		break;
	case 'base' :
		OpClickBase();
		break;
	case 'check' :
		OpClickCheck();
		break;
	}
}
// handle operation "open"
function OpClickOpen() {
	var oForm = document.formExplorer;
	if ( !oForm ) { return false }

	if ( eventFolder ) {
		// handle for folder
		oForm.param.value = eventPath;
		if ( globalRoot == '' ) {
			// define a root
			oForm.operation.value = 'setroot';
		} else {
			// dive into a folder
			oForm.operation.value = 'openfolder';
		}
		
		if ( eventPath == '..' ) {
			// go back to the parent of this folder
			oForm.operation.value = 'goparent';
			oForm.param.value = globalPath;
		}
	} else {
		// handle for file
		OpenEditor();
		return true;
	}
	oForm.submit();
	return true;	
}

// handle operation "delete"
function OpClickDelete() {
	var oForm = document.formExplorer;
	if ( !oForm ) { return false }

	if ( globalRoot == '' ) {
		alert( 'Can\'t delete nothing in this point' );
		return false;
	}
	if ( window.confirm( 'Do you REALLY confirm this Delete operation?' ) ) {
		oForm.param.value = eventPath;	
		if ( eventFolder ) {
			// handle for folder
			oForm.operation.value = 'deletefolder';
		} else {
			// handle for file
			oForm.operation.value = 'deletefile';
		}
		oForm.submit();
		return true;
	} else {
		return false;
	}
}

// handle operation "association"
function OpClickAssociation() {
	if ( AscClickOperation ) {
		AscClickOperation();
	}
}

// handle operation "association"
function OpClickBase() {
	if ( BaseClickOperation ) {
		BaseClickOperation();
	}
}

// handle operation "check URL"
function OpClickCheck() {
	if ( CheckXMLOperation ) {
		CheckXMLOperation();
	}
}
	
//--></script>