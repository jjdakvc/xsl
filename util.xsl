<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ds="http://www.daksys.com" exclude-result-prefixes="xs fn ds xsl">
	<xsl:function name="ds:get.normalized.text">
		<xsl:param name="element"/>
		<!--xsl:variable name="normalized.text" select="replace(lower-case(translate(normalize-space(string-join($element//text(),'')),' ,:;/\.—[]()?+–™','-')),'&amp;','and')"/-->
		<xsl:variable name="normalized.text" select="replace(lower-case(translate(normalize-space(string-join($element/text(),'')),' ,:;/\.—[]()?+–™','-')),'&amp;','and')"/>
		<xsl:value-of select="$normalized.text"/>
	</xsl:function>
	<xsl:template name="write.html.file">
		<xsl:param name="content"/>
		<xsl:param name="file.name"/>
		<xsl:result-document href="{concat('file:/',$output.folder,$file.name)}" exclude-result-prefixes="xs fn ds" encoding="UTF-8" indent="no" method="xml" omit-xml-declaration="no" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" standalone="no">
			<xsl:copy-of select="$content"/>
		</xsl:result-document>
	</xsl:template>
	<xsl:template name="write.xml.file">
		<xsl:param name="content"/>
		<xsl:param name="file.name"/>
		<xsl:param name="pd"/>
		<xsl:param name="sd"/>
		<xsl:param name="standalone">no</xsl:param>
		<xsl:choose>
			<xsl:when test="$pd">
				<xsl:result-document href="{concat('file:/',$output.folder,$file.name)}" exclude-result-prefixes="xs fn ds" encoding="UTF-8" indent="no" method="xml" omit-xml-declaration="no" doctype-public="{$pd}" doctype-system="{$sd}" standalone="{$standalone}">
					<xsl:copy-of select="$content"/>
				</xsl:result-document>
			</xsl:when>
			<xsl:otherwise>
				<xsl:result-document href="{concat('file:/',$output.folder,$file.name)}" exclude-result-prefixes="xs fn ds" encoding="UTF-8" indent="no" method="xml" omit-xml-declaration="no" standalone="{$standalone}">
					<xsl:copy-of select="$content"/>
				</xsl:result-document>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="write.text.file">
		<xsl:param name="content"/>
		<xsl:param name="file.name"/>
		<xsl:result-document href="{concat('file:/',$output.folder,$file.name)}" exclude-result-prefixes="xs fn ds" encoding="UTF-8" indent="no" method="text" omit-xml-declaration="yes">
			<xsl:copy-of select="$content"/>
		</xsl:result-document>
	</xsl:template>
	<xsl:template name="echo.id">
		<xsl:if test="@id and not(normalize-space(@id)='')">
			<xsl:attribute name="id" select="@id"/>
		</xsl:if>
	</xsl:template>
	<!--resolves ..\ in URLs-->
	<xsl:template name="relative.to.absolute">
		<xsl:param name="path"/>
		<xsl:choose>
			<xsl:when test="contains($path,'..')">
				<xsl:variable name="new.path">
					<xsl:value-of select="replace($path,'/[^/\.]*?/\.\.','')"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="contains($new.path,'..')">
						<xsl:call-template name="relative.to.absolute">
							<xsl:with-param name="path" select="$new.path"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$new.path"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$path"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="lastIndexOf">
		<!-- declare that it takes two parameters - the string and the char -->
		<xsl:param name="string"/>
		<xsl:param name="char"/>
		<xsl:choose>
			<!-- if the string contains the character... -->
			<xsl:when test="contains($string, $char)">
				<!-- call the template recursively... -->
				<xsl:call-template name="lastIndexOf">
					<!-- with the string being the string after the character-->
					<xsl:with-param name="string" select="substring-after($string, $char)"/>
					<!-- and the character being the same as before -->
					<xsl:with-param name="char" select="$char"/>
				</xsl:call-template>
			</xsl:when>
			<!-- otherwise, return the value of the string -->
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		<xsl:template name="substring-before-last">
		<xsl:param name="input"/>
		<xsl:param name="marker"/>
		<xsl:variable name="mid" select="ceiling(string-length($input) div 2)"/>
		<xsl:variable name="temp1" select="substring($input,1,$mid)"/>
		<xsl:variable name="temp2" select="substring($input,$mid + 1)"/>
		<xsl:choose>
			<xsl:when test="$temp2 and contains($temp2,$marker)">
				<xsl:value-of select="$temp1"/>
				<xsl:call-template name="substring-before-last">
					<xsl:with-param name="input" select="$temp2"/>
					<xsl:with-param name="marker" select="$marker"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains(substring($input,$mid - string-length($marker) + 1), $marker)">
				<xsl:value-of select="substring-before($input, $marker)"/>
			</xsl:when>
			<xsl:when test="contains($temp1,$marker)">
				<xsl:call-template name="substring-before-last">
					<xsl:with-param name="input" select="$temp1"/>
					<xsl:with-param name="marker" select="$marker"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
