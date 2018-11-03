<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../../incs/HTMLEntities.dtd">
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="//header|//item|//footer">
<div id="div{name()}" class="floatingbox" style="position:absolute; visibility: hidden; top: 10px; left:10px">
<table cellpadding="0" cellspacing="0">
<tr><td>
	<table cellpadding="0" cellspacing="0" width="100%">
	  <tr> 
	    <td class="dragtitle"> :: edit <xsl:value-of select="name()"/> </td>
	    <td class="boxtitle" align="right"> 
		<button onclick="oControl.Get('div{name()}').Hide()" id="closeDialog"> X </button> 
	    </td>
	  </tr>
	</table>

	<table cellpadding="0" cellspacing="0" border="0">
	<tr valign="top">
		<td>
			<table cellpadding="0" cellspacing="2" border="0">
		    <xsl:choose>
			<xsl:when test="name()='item'">
				<tr><td><button style="width:55px" onclick="appendItem()" id="btAppend">Append</button></td></tr>
				<tr><td><button style="width:55px" onclick="addItem( intRowID )" id="btAdd">Add</button></td></tr>
				<tr><td><button style="width:55px" onclick="replaceItem( intRowID )" id="btReplace">Replace</button></td></tr>
				<tr><td><button style="width:55px" onclick="removeItem( intRowID )" id="btRemove">Remove</button></td></tr>
				<tr><td></td></tr>
				<tr><td><button style="width:55px" onclick="cutItem( intRowID )" id="btCut"><img src="button_cut.gif" align="absmiddle"/>Cut</button></td></tr>
				<tr><td><button style="width:55px" onclick="copyItem( intRowID )" id="btCopy"><img src="button_copy.gif" align="absmiddle"/>Copy</button></td></tr>
				<tr><td><button style="width:55px" onclick="pasteItem( intRowID )" id="btPaste"><img src="button_paste.gif" align="absmiddle"/>Paste</button></td></tr>
				<tr><td><button style="width:55px" onclick="moveUpItem( intRowID )" id="btMoveUp">Up</button></td></tr>
				<tr><td><button style="width:55px" onclick="moveDownItem( intRowID )" id="btMoveDown">Down</button></td></tr>
			</xsl:when>
			<xsl:otherwise>
				<tr><td><button onclick="update{name()}()" id="update{name()}">update</button></td></tr>
			</xsl:otherwise>
			</xsl:choose>
			</table>
		</td>
		<td>
			<table cellpadding="0" cellspacing="2" border="0">
			<xsl:for-each select="col">
				<tr><td><xsl:value-of select="."/></td><td><input id="txt{.}" style="width:160px"/></td></tr>
			</xsl:for-each>
			</table>
		</td>
	</tr>
	</table>

</td></tr>
</table>
</div>
</xsl:template>

</xsl:stylesheet>