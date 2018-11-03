<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
exclude-result-prefixes="msxsl #default user #default"
 xmlns:msxsl="urn:schemas-microsoft-com:xslt"
 xmlns:user="http://www.psn.com">

<xsl:output method="html" encoding="iso-8859-1"/>

<msxsl:script language="JScript" implements-prefix="user">
<![CDATA[
// get the correct rowspan for the table
var iLast = 1;
function GetPow( i ) {
	iLast = Math.pow( 2, i );
	return iLast;
}
// tries to reduce cpu by using a cache instead of calling pow() again
function GetLast() {
	return iLast;
}
]]>
</msxsl:script>	

<xsl:template match="/root">
    <html>
    <table width="500" height="400" border="0" cellspacing="0" cellpadding="0">
	<xsl:apply-templates select="node"/>
    </table>
    </html>
</xsl:template>

<xsl:template match="node">
	<tr> 
    <td valign="middle">
      <table width="100" border="1" cellspacing="0" cellpadding="0">
        <tr align="center" nodeID="{position() - 1}" subID="" onclick="getCoordinates( this )" onmouseover="turnHover( this, true )" onmouseout="turnHover( this, false )"> 
          <td height="15"><xsl:value-of select="name"/></td>
        </tr>
      </table>
    </td>
	<xsl:apply-templates select="subnode">
		<xsl:with-param name="currentPos" select="position() - 1"/>
	</xsl:apply-templates>
	</tr> 
</xsl:template>

<xsl:template match="subnode">
	<xsl:param name="currentPos"/>
    <td rowspan="{user:GetPow( position() )}" valign="middle">
      <table border="0" cellspacing="0" cellpadding="0" height="100%" background="imgs/back.gif">
        <tr> 
          <td bgcolor="#FFFFFF" height="25%"><img src="imgs/blank.gif" width="4" height="2"/></td>
        </tr>
        <tr valign="top"> 
          <td height="10%"><img src="imgs/up.gif" height="8" width="16"/></td>
        </tr>
        <tr> 
          <td height="30%"><img src="imgs/middle.gif" width="16" height="19"/></td>
        </tr>
        <tr valign="bottom"> 
          <td height="10%"><img src="imgs/bottom.gif" height="8" width="16"/></td>
        </tr>
        <tr> 
          <td bgcolor="#FFFFFF" height="25%"><img src="imgs/blank.gif" width="4" height="2"/></td>
        </tr>
      </table>
    </td>
    <td rowspan="{user:GetLast()}" valign="middle">
      <table width="50" border="1" cellspacing="0" cellpadding="0">
        <tr align="center" nodeID="{$currentPos}" subID="{position() - 1}" onclick="getCoordinates( this )" onmouseover="turnHover( this, true )" onmouseout="turnHover( this, false )"> 
          <td height="15"><xsl:value-of select="."/></td>
        </tr>
      </table>
    </td>
</xsl:template>

</xsl:stylesheet>