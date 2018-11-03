<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../../HTMLEntities.dtd">
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="/root">
   <xsl:apply-templates select="table" />
</xsl:template>

<xsl:template match="table">
            <table width="450" border="0" cellspacing="0" cellpadding="3" height="30">
              <tr>
                <td colspan="2" class="texto_resultados2"><xsl:value-of select="header/groupTitle" /></td>
              </tr>
              <tr> 
                <td width="110" align="center"><img src="imgs/data.gif" width="27" height="6" /></td>
                <td width="350" align="center"><img src="imgs/resultados2.gif" width="67" height="6" /></td>
              </tr>
            </table>
            <table width="450" border="0" cellspacing="1" cellpadding="2" bgcolor="#FFFFFF">
            <xsl:apply-templates select="item" />
            </table>
</xsl:template>

<xsl:template match="item">
              <tr bgcolor="#333333" align="center" valign="middle"> 
                <td width="110" class="texto_resultados"><xsl:value-of select="date" /></td>
                <td width="150" class="texto_resultados" align="right"><xsl:value-of select="teamHome" /></td>
                <td width="25" bgcolor="#FF6500" class="texto_resultados2"><xsl:value-of select="goalsHome" /></td>
                <td width="25" bgcolor="#FF6500" class="texto_resultados2"><xsl:value-of select="goalsVisitor" /></td>
                <td width="150" class="texto_resultados" align="left"><xsl:value-of select="teamVisitor" /></td>
              </tr>
</xsl:template>

</xsl:stylesheet>