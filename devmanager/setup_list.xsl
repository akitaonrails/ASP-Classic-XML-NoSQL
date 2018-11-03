<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../incs/HTMLEntities.dtd">
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="/roots">
  <table width="600" border="0" cellspacing="0" cellpadding="1">
    <tr> 
      <td class="boxtitle" colspan="4">Root Folders</td>
    </tr>
    <xsl:apply-templates select="folder"/>
    <tr> 
      <td colspan="4"> &nbsp; </td>
    </tr>
  </table>
</xsl:template>

<xsl:template match="folder">
    <tr valign="top">
      <td align="left"><a href="#" onclick="OpenOperation( '{translate(path,'\','/')}' )"> 
    <xsl:choose>
		<xsl:when test="name='common'">
			<img border="0" name="imgFolder" src="../imgs/icon_system.gif" width="18" height="18" align="absmiddle"/>
		</xsl:when>
		<xsl:when test="name='templates'">
			<img border="0" name="imgFolder" src="../imgs/icon_system.gif" width="18" height="18" align="absmiddle"/>
		</xsl:when>
		<xsl:otherwise>
			<img border="0" name="imgFolder" src="../imgs/icon_folder.gif" width="18" height="15" align="absmiddle"/>
		</xsl:otherwise>
	</xsl:choose>
      <xsl:value-of select="name"/> </a></td>
      <td align="right"><xsl:value-of select="size"/></td>
      <td align="right"><xsl:value-of select="created"/></td>
      <td align="right"><xsl:value-of select="lastmodified"/></td>
    </tr>
</xsl:template>

</xsl:stylesheet>