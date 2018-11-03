<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../incs/HTMLEntities.dtd">
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="//language">
	<option value="{shortlabel}"><xsl:value-of select="label"/></option>
</xsl:template>

<xsl:template match="//category">
	<option value="{.}"><xsl:value-of select="."/></option>
</xsl:template>

<xsl:template match="//token">
	<tr id="row_{id}" onclick="DisplayUpdate( {id} )">
		<td id="col_original_{id}"><xsl:value-of select="original" /></td>
		<td id="col_translation_{id}"><xsl:value-of select="translation" /></td>
		<td align="right"><input type="checkbox" name="token_id" value="{id}" /></td>
	</tr>
</xsl:template>

</xsl:stylesheet>