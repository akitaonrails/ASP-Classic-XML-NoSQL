<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
exclude-result-prefixes="msxsl #default user #default"
 xmlns:msxsl="urn:schemas-microsoft-com:xslt"
 xmlns:user="http://www.psn.com">

<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<msxsl:script language="JScript" implements-prefix="user">
<![CDATA[
var iCache;
function GetPow( i ) {
	iCache = Math.pow( 2, i );
	return iCache;
}
function GetCache() {
	return iCache;
}
]]>
</msxsl:script>	

<xsl:template match="/root">
    <table width="500" height="500" border="0" cellspacing="0" cellpadding="0">
    	<xsl:apply-templates select="node">
			<xsl:with-param name="currentPos" select="position()"/>
		</xsl:apply-templates>
    </table>
</xsl:template>


<xsl:template match="node">
	<xsl:param name="currentPos"/>    
    <tr> 
    <td valign="middle">
      <table width="100" border="1" cellspacing="0" cellpadding="0">
        <tr align="center"> 
          <td><xsl:value-of select="name"/></td>
        </tr>
      </table>
    </td>
   	<xsl:apply-templates select="subnode">
   		<xsl:with-param name="currentPos" select="$currentPos"/>
   	</xsl:apply-templates>
    </tr> 
</xsl:template>

<xsl:template match="subnode">
	<xsl:param name="currentPos"/>
    <td rowspan="{user:GetPow( position() )}" valign="middle">
      <table border="0" cellspacing="0" cellpadding="0" height="100%" background="back.gif">
        <tr> 
          <td bgcolor="#FFFFFF" height="25%"><img src="blank.gif" width="4" height="2"/></td>
        </tr>
        <tr valign="top"> 
          <td height="10%"><img src="up.gif" height="8" width="16"/></td>
        </tr>
        <tr> 
          <td height="30%"><img src="middle.gif" width="16" height="19"/></td>
        </tr>
        <tr valign="bottom"> 
          <td height="10%"><img src="bottom.gif" height="8" width="16"/></td>
        </tr>
        <tr> 
          <td bgcolor="#FFFFFF" height="25%"><img src="blank.gif" width="4" height="2"/></td>
        </tr>
      </table>
    </td>
    <td rowspan="{user:GetCache()}" valign="middle">
      <table width="50" border="1" cellspacing="0" cellpadding="0">
        <tr align="center"> 
          <td><xsl:value-of select="."/></td>
        </tr>
      </table>
    </td>
</xsl:template>

</xsl:stylesheet>