<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ds="http://www.daksys.com" exclude-result-prefixes="xs fn ds">
<xsl:include href="anthc_dita2ePubHTML.xsl"/>
	<xsl:include href="util.xsl"/>
	<xsl:include href="param.xsl"/>
	<xsl:include href="stylesheet.xsl"/>
	<xsl:include href="filegen.xsl"/>
	<xsl:include href="map.xsl"/>
	<xsl:variable name="resolved.document">
		<xsl:apply-templates select="map" mode="map"/>
	</xsl:variable>
	<xsl:template match="/">
		<xsl:call-template name="create.static.files"/>
		<xsl:call-template name="create.opf"/>
		<xsl:call-template name="create.ncx"/>
		<xsl:call-template name="create.toc"/>
		<xsl:apply-templates select="$resolved.document//topic"/>
		<!--xsl:copy-of select="$resolved.document"/-->
	</xsl:template>
</xsl:stylesheet>
