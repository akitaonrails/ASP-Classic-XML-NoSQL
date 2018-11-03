<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../incs/HTMLEntities.dtd">
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="/errors">
<table width="600" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="errorstitle">Errors and Warnings</td>
  </tr>
  <tr>
    <td><xsl:value-of select="item"/></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
</xsl:template>

</xsl:stylesheet>