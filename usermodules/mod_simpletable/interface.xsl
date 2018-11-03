<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="/root">
	<xsl:apply-templates select="table"/>
</xsl:template>

<xsl:template match="table">
	<xsl:choose>
	<xsl:when test="count(header) != 0">
		<xsl:apply-templates select="header">
			<xsl:with-param name="currentTable" select="position() - 1"/>
		</xsl:apply-templates>
	</xsl:when>
	<xsl:otherwise>
		<xsl:call-template name="newheader">
			<xsl:with-param name="currentTable" select="position() - 1"/>
		</xsl:call-template>
	</xsl:otherwise>
	</xsl:choose>

	<table width="100%" border="0" cellspacing="1" cellpadding="1">
		<xsl:choose>
		<xsl:when test="count(item) != 0">
			<xsl:apply-templates select="item">
				<xsl:with-param name="currentTable" select="position() - 1"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="newitem">
				<xsl:with-param name="currentTable" select="position() - 1"/>
			</xsl:call-template>
		</xsl:otherwise>
		</xsl:choose>
	</table>
			
	<xsl:choose>
	<xsl:when test="count(footer) != 0">
		<xsl:apply-templates select="footer">
			<xsl:with-param name="currentTable" select="position() - 1"/>
		</xsl:apply-templates>
	</xsl:when>
	<xsl:otherwise>
		<xsl:call-template name="newfooter">
			<xsl:with-param name="currentTable" select="position() - 1"/>
		</xsl:call-template>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="header">
	<xsl:param name="currentTable"/>
	<div tableID="{$currentTable}" rowID="-1" onclick="setCoordinates(this)" onmouseover="turnHover( this, true )" onmouseout="turnHover( this, false )">
		<xsl:for-each select="*">
			<xsl:value-of select="."/><br/>
		</xsl:for-each>
	</div>
</xsl:template>

<xsl:template name="newheader">
	<xsl:param name="currentTable"/>
	<div tableID="{$currentTable}" rowID="-1" onclick="setCoordinates(this)" onmouseover="turnHover( this, true )" onmouseout="turnHover( this, false )">
	-- click here to insert new header
	</div>
</xsl:template>

<xsl:template match="footer">
	<xsl:param name="currentTable"/>
	<div tableID="{$currentTable}" rowID="-2" onclick="setCoordinates(this)" onmouseover="turnHover( this, true )" onmouseout="turnHover( this, false )">
		<xsl:for-each select="*">
			<xsl:value-of select="."/>
			<xsl:if test="position() != last()">
			<br/>
			</xsl:if>
		</xsl:for-each>
	</div>
	<br/>
</xsl:template>

<xsl:template name="newfooter">
	<xsl:param name="currentTable"/>
	<div tableID="{$currentTable}" rowID="-2" onclick="setCoordinates(this)" onmouseover="turnHover( this, true )" onmouseout="turnHover( this, false )">
	-- click here to insert new footer
	</div>
	<br/>
</xsl:template>

<xsl:template match="item">
	<xsl:param name="currentTable"/>
	<xsl:if test="position()=1">
    	<tr>
		<td> </td>
    	<xsl:for-each select="*">
			<td><b><xsl:value-of select="name()"/></b></td>
		</xsl:for-each>
		</tr>
	</xsl:if>

	<tr tableID="{$currentTable}" rowID="{position() - 1}" onclick="setCoordinates(this)" onmouseover="turnHover( this, true )" onmouseout="turnHover( this, false )"> 
	<td><b><xsl:value-of select="position()"/></b></td>
	<xsl:for-each select="*">
		<td><xsl:value-of select="."/></td>
	</xsl:for-each>
	</tr>
</xsl:template>

<xsl:template name="newitem">
	<xsl:param name="currentTable"/>
	<tr tableID="{$currentTable}" rowID="0" onclick="setCoordinates(this)" onmouseover="turnHover( this, true )" onmouseout="turnHover( this, false )"> 
	<td>-- click here to insert a new item</td>
	</tr>
</xsl:template>
</xsl:stylesheet>