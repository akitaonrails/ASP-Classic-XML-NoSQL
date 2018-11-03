<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../incs/HTMLEntities.dtd">
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="/collection">
<select name="comboReset">
	<option value="xml">- Default XML</option>
	<option value="template">- Template Descriptor</option>
	<xsl:for-each select="//module/template/data">
		<option value="{../../folder}/{.}"><xsl:value-of select="@name"/></option>
	</xsl:for-each>
	<option value="ignore"></option>
	<option value="xsl">- Default Style</option>
	<xsl:for-each select="//module/template/style">
		<option value="{../../folder}/{.}"><xsl:value-of select="@name"/></option>
	</xsl:for-each>
</select>
</xsl:template>

</xsl:stylesheet>