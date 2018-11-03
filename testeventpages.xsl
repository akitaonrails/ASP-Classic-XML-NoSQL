<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="/list">
	<p><b>List of Pages of the Event</b></p>
	<xsl:apply-templates select="item"/>
</xsl:template>

<xsl:template match="item">
<p>
ID : <xsl:value-of select="id" />
<br/>Label : <xsl:value-of select="label" />
<br/>EventID : <xsl:value-of select="event_id" />
</p>
</xsl:template>

</xsl:stylesheet>