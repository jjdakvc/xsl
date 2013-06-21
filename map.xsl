<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:template match="map" mode="map">
		<dita>
			<xsl:apply-templates mode="map" select="./topicref|./mapref"/>
		</dita>
	</xsl:template>
	<xsl:template match="map" mode="mapinmap">
		<xsl:param name="relative.path"/>
		<xsl:apply-templates mode="map" select="./topicref|./mapref">
			<xsl:with-param name="relative.path" select="$relative.path"/>
		</xsl:apply-templates>
	</xsl:template>
	<!--loads a topicref-->
	<xsl:template match="topicref" mode="map">
		<xsl:param name="relative.path"/>
		<xsl:variable name="href" select="concat($relative.path,'/',@href)"/>
		     <xsl:variable name="file.path">
					<xsl:call-template name="relative.to.absolute">
						<xsl:with-param name="path" select="concat('file:///',replace($input.dir,'\\','/'),$href)"/><!--this is what is affecting the filepath-->
					</xsl:call-template>
				</xsl:variable>
				<xsl:message select="$file.path"/>
				<xsl:call-template name="get.ditamap.atts">
					<xsl:with-param name="topic" select="document($file.path)/*"/>
					<xsl:with-param name="topicref" select="."/>
			   </xsl:call-template>
	</xsl:template>
	<!--this will take the outputclass attribute from the topicref (e.g. page-break) and copy it to the topic XML-->
	<xsl:template name="get.ditamap.atts">
		<xsl:param name="topic"/>
		<xsl:param name="topicref"/>
		<xsl:element name="topic">
			<xsl:attribute name="xtrf" select="$topicref/@href"/>
			<xsl:for-each select="$topic/@*">
				   <xsl:attribute name="{local-name(.)}" select="."/>
			</xsl:for-each>
			<xsl:for-each select="$topic/node()">
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
