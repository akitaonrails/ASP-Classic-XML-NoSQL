<div id="divNewFile" style="position:absolute; visibility: hidden; width:380px; height:100px; z-index:1; left: 30px; top: 580px" class="floatingbox"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="1">
  <form name="formNewFile">
    <tr> 
      <td colspan="2" class="dragtitle"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="boxtitle">-- New File</td>
            <td align="right"><button name="btSave" onclick="NewFileClickSave( this.form )">Save</button> <button name="btCancel" onclick="oControl.Get('divNewFile').Hide()"> X </button> 
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>Description:</td>
      <td> 
        <textarea name="description" cols="34"></textarea>
      </td>
    </tr>
    <tr> 
      <td>Filename:</td>
      <td> 
        <input type="text" name="filename" size="25" maxlength="255">
        <select name="filetype">
        <option value="xml" selected>XML</option>
        <option value="xsl">XSL</option>
        <option value="xml">Schema</option>
        </select>
      </td>
    </tr>
    <tr> 
      <td>Author:</td>
      <td> 
        <input type="text" name="author" size="40" maxlength="200">
      </td>
    </tr>
    <tr> 
      <td>Responsible:</td>
      <td> 
        <input type="text" name="responsible" size="40" maxlength="255">
      </td>
    </tr>
  </form>
  </table>
</div>
<script language="JScript">
// add this dialog to the controller
oControl.AddQueue( 'divNewFile' );

// handler
function NewFileClickSave( oForm ) {
	var oFormFinal = document.formExplorer;
	if ( !oForm || !oFormFinal ) { return false }
	
	// check description
	if ( oForm.description.value.length < 4 ) {
		alert( 'Fill in the description' );
		oForm.description.focus();
		return false;
	}
	
	// check author
	if ( oForm.author.value.length < 4 ) {
		alert( 'Fill in your complete name' );
		oForm.author.focus();
		return false;
	}
	
	// check filename
	if ( oForm.filename.value.length < 2 ) {
		alert( 'Fill in the correct filename, without extensions' );
		oForm.filename.focus();
		return false;
	}

	oFormFinal.author.value = oForm.author.value;
	oFormFinal.responsible.value = oForm.responsible.value;
	oFormFinal.param.value = oForm.filename.value + '.' + oForm.filetype.value;
	oFormFinal.operation.value = 'newfile';
	oFormFinal.submit();
}
</script>
