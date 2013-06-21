<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:template name="create.css.file">
		<xsl:variable name="contents">
		body
			{
				background-color: #ffffff;
				color: #000000;
				text-align:left;
				font-family:"Arial";
			}
		 </xsl:variable>
		<xsl:call-template name="write.text.file">
			<xsl:with-param name="file.name">OEBPS/stylesheet.css</xsl:with-param>
			<xsl:with-param name="content" select="$contents"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
