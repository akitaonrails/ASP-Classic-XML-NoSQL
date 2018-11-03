<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../../HTMLEntities.dtd">
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="table">
            <table width="450" border="0" cellspacing="1" cellpadding="2" bgcolor="#FFFFFF">
              <tr bgcolor="#000000" align="center" valign="middle"> 
                <td width="60" class="texto_resultados2"><xsl:value-of select="header/groupTitle" /></td>
                <td width="160" class="texto_resultados2" align="left">TIMES</td>
                <td width="26" class="texto_resultados2" align="center">PG</td>
                <td width="26" class="texto_resultados2" align="center">J</td>
                <td width="26" class="texto_resultados2" align="center">V</td>
                <td width="26" class="texto_resultados2" align="center">E</td>
                <td width="26" class="texto_resultados2" align="center">D</td>
                <td width="26" class="texto_resultados2" align="center">GP</td>
                <td width="26" class="texto_resultados2" align="center">GC</td>
                <td width="26" class="texto_resultados2" align="center">SG</td>
              </tr>

              <xsl:apply-templates select="item" />

            </table>
            <br/>
</xsl:template>

<xsl:template match="item">
              <tr bgcolor="#333333" align="center" valign="middle"> 
                <td width="60" class="texto_resultados" bgcolor="#FF6500"><xsl:value-of select="position()" />&ordm;</td>
                <td width="160" class="texto_resultados" align="left"><xsl:value-of select="teamName" /></td>
                <td width="26" bgcolor="#FF6500" class="texto_resultados2" align="center"><xsl:value-of select="PG" /></td>
                <td width="26" class="texto_resultados2" align="center"><xsl:value-of select="J" /></td>
                <td width="26" bgcolor="#FF6500" class="texto_resultados2" align="center"><xsl:value-of select="V" /></td>
                <td width="26" class="texto_resultados2" align="center"><xsl:value-of select="E" /></td>
                <td width="26" bgcolor="#FF6500" class="texto_resultados2" align="center"><xsl:value-of select="D" /></td>
                <td width="26" class="texto_resultados2" align="center"><xsl:value-of select="GP" /></td>
                <td width="26" bgcolor="#FF6500" class="texto_resultados2" align="center"><xsl:value-of select="GC" /></td>
                <td width="26" class="texto_resultados2" align="center"><xsl:value-of select="GP - GC" /></td>
              </tr>
</xsl:template>

</xsl:stylesheet>