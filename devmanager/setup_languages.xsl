<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../incs/HTMLEntities.dtd">
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="//language">
	<tr>
		<td><xsl:value-of select="label"/></td>
		<td><xsl:value-of select="shortlabel"/></td>
		<xsl:choose>
			<xsl:when test="is_common = '1'">
				<td align="center"><input type="radio" name="common" value="{id}" checked="1" /></td>
			</xsl:when>
			<xsl:otherwise>
				<td align="center"><input type="radio" name="common" value="{id}" /></td>
			</xsl:otherwise>
		</xsl:choose>
		<td align="center"><input type="checkbox" name="delete" value="{id}" /></td>
	</tr>
</xsl:template>

</xsl:stylesheet>