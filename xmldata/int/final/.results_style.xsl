<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../incs/HTMLEntities.dtd">
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="//item">
<p>
Nome: <xsl:value-of select="nome" />
<br/>Telefone: <xsl:value-of select="telefone" />
<br/>Email: <xsl:value-of select="email" />
</p>
</xsl:template>

</xsl:stylesheet>