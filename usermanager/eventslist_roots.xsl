<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../incs/HTMLEntities.dtd">
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="/">
<select name="root_path">
	<xsl:apply-templates select="//folder"/>
</select>
</xsl:template>

<xsl:template match="folder">
	<xsl:choose>
		<xsl:when test="name != 'common' and name != 'templates'">
		<option value="{translate(path,'\','/')}"><xsl:value-of select="name" /></option>
		</xsl:when>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>