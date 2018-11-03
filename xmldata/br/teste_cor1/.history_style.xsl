<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../../HTMLEntities.dtd">
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="/root">
   <xsl:apply-templates select="document" />
</xsl:template>

<xsl:template match="document">
<div align="left" class="texto_regulamento">
   <p align="center"><b><xsl:value-of select="title" /></b></p>
   <br/>
   <blockquote>
   <xsl:value-of select="text" disable-output-escaping="yes"/>
   </blockquote>
</div>
</xsl:template>

</xsl:stylesheet>