<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../incs/HTMLEntities.dtd">
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="/list">
	<select name="label">
		<xsl:apply-templates select="clip" />
	</select>
</xsl:template>

<xsl:template match="clip">
	<option value="{label}"><xsl:value-of select="label" /></option>
</xsl:template>

</xsl:stylesheet>