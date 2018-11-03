<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../incs/HTMLEntities.dtd">
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>

<xsl:template match="/">
	<style>
		body { font-family: Tahoma, Verdana, Arial; font-size: 9pt; color: #000000; background-color: #FFFFFF }
		td { font-family: Tahoma, Verdana, Arial; font-size: 9pt; color: #000000; background-color: #FFFFFF }
		table { border: 0px none #FFFFFF }
		a { color: #660066; text-decoration: none }
		a:vlink { color: #660066 } }
		a:hover { text-decoration: underline }
		.propertyname { color: #006600 }
		.methodname { color: #000066 }
		.parametername { color: #660000 }
		.title { font-weight: bold; font-size: 10pt }
		.sourcecode { fonr-family: Courier New, Tahoma, Verdana; font-size: 9pt; color: #000033; background-color: #EEEEEE }
	</style>
	
	<xsl:apply-templates select="files" />
	<xsl:apply-templates select="component" />

	<p>
	<hr width="400" align="left"/>
	Windows Script Components (WSC) Reflection 1.0
	<br/><a href="mailto:akita@psntv.com">Support</a>
	</p>

</xsl:template>

<xsl:template match="files">
	<p><b>Choose a component to Reflect</b></p>
	<xsl:apply-templates select="filename" />
</xsl:template>

<xsl:template match="filename">
	<li><a href="reflection.asp?xml={.}"><xsl:value-of select="."/></a></li>
</xsl:template>

<xsl:template match="component">
	<xsl:apply-templates select="registration" />
	<xsl:apply-templates select="public" />
	<xsl:apply-templates select="script" />
	<br/>
	<a href="reflection.asp" style="color: #000000">&lt;&lt; back</a>
</xsl:template>

<xsl:template match="registration">
	<p class="title"><xsl:value-of select="@progid" />&nbsp;<xsl:value-of select="@version" /></p>
	<xsl:value-of select="@description" /><br />
	<br />
</xsl:template>

<xsl:template match="public">
	<table>
	<tr><td colspan="2"><b>properties</b></td></tr>
		<xsl:apply-templates select="property">
			<xsl:sort select="@name" />
		</xsl:apply-templates>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2"><b>methods</b></td></tr>
		<xsl:apply-templates select="method">
			<xsl:sort select="@name" />
		</xsl:apply-templates>
	</table>
</xsl:template>

<xsl:template match="property">
	<tr><td width="10">&nbsp;</td><td class="propertyname">
	<xsl:value-of select="@name" />
	(
	<xsl:for-each select="get | put">
		<xsl:if test="name() = 'get'">
			<span class="parametername">Get</span>
		</xsl:if>
		<xsl:if test="name() = 'put'">
			<span class="parametername">Set</span>
		</xsl:if>
		<xsl:if test="position() != last()">
			,
		</xsl:if>
	</xsl:for-each>
	)
	</td></tr>
</xsl:template>

<xsl:template match="method">
	<tr><td width="10">&nbsp;</td><td class="methodname">
		<xsl:value-of select="@name" />
		(
		<xsl:for-each select="parameter">
			<span class="parametername"><xsl:value-of select="@name" /></span>
			<xsl:if test="position() != last()">
				,
			</xsl:if>
		</xsl:for-each>
		)
	</td></tr>
</xsl:template>

<xsl:template match="script">
	<script language="Jscript">
		function showSource() {
			divSource.style.display = divSource.style.display == 'none' ? '' : 'none';
		}
	</script>
	<p><a href="javascript:showSource()" style="color: #000000"><b>view script source</b></a></p>
	<div id="divSource" style="position: relative; display: none">
	<textarea wrap="OFF" cols="70" rows="25" class="sourcecode"><xsl:value-of select="." /></textarea>
	</div>
</xsl:template>

</xsl:stylesheet>