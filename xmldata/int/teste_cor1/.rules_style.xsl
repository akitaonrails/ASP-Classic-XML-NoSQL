<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../../HTMLEntities.dtd">
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="//document">
   <p><b><xsl:value-of select="title" /></b></p>
   <br/>
   <xsl:value-of select="text" />
</xsl:template>

</xsl:stylesheet>