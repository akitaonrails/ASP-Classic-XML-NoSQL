<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../incs/HTMLEntities.dtd">
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="/">
	<xsl:apply-templates select="//parent"/>
	<xsl:apply-templates select="//folder"/>
	<xsl:apply-templates select="//file"/>
</xsl:template>

<xsl:template match="parent">
  <tr> 
    <td height="16" colspan="4"> 
      <img border="0" name="imgParent" src="../imgs/icon_folder.gif" width="18" height="15" align="absmiddle"/>&nbsp;
      <a href="javascript:ClickFolder( '..' )"><xsl:value-of select="path"/></a></td>
  </tr>
</xsl:template>

<xsl:template match="folder">
  <tr> 
    <td> 
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
      &nbsp;
      <a href="javascript:ClickFolder( '{ translate( path, '\', '/' ) }' )"><xsl:value-of select="name"/></a></td>
    <td align="right"><xsl:value-of select="size"/></td>
    <td align="right"><xsl:value-of select="created"/></td>
    <td align="right"><xsl:value-of select="lastmodified"/></td>
  </tr>
</xsl:template>

<xsl:template match="file">
  <tr> 
    <td> 
      <img border="0" name="imgFile" src="../imgs/icon_file.gif" width="18" height="17" align="absmiddle"/>&nbsp;
      <a href="#" onclick="ClickFile( '{ translate( path, '\', '/' ) }' )"><xsl:value-of select="name"/></a></td>
    <td align="right"><xsl:value-of select="size"/></td>
    <td align="right"><xsl:value-of select="created"/></td>
    <td align="right"><xsl:value-of select="lastmodified"/></td>
  </tr>
</xsl:template>

</xsl:stylesheet>