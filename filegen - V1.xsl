<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ds="http://www.daksys.com" exclude-result-prefixes="xs fn ds xsl">
	<xsl:template name="create.static.files">
		<xsl:call-template name="create.mimetype.file"/>
		<xsl:call-template name="create.container.file"/>
		<xsl:call-template name="create.css.file"/>
		<xsl:call-template name="create.cover.file"/>
	</xsl:template>
	<xsl:template name="create.mimetype.file">
		<xsl:call-template name="write.text.file">
			<xsl:with-param name="file.name">mimetype</xsl:with-param>
			<xsl:with-param name="content" select="'application/epub+zip'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="create.container.file">
		<xsl:call-template name="write.xml.file">
			<xsl:with-param name="file.name">META-INF/container.xml</xsl:with-param>
			<xsl:with-param name="content">
				<container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
					<rootfiles>
						<rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/>
					</rootfiles>
				</container>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="create.cover.file">
		<xsl:variable name="cover.html">
			<html xml:lang="en">
				<head>
					<title>ALA Cover</title>
				</head>
				<body>
					<p>
						<img src="images/cover.jpeg" alt="RDA Cover Image"/>
					</p>
				</body>
			</html>
		</xsl:variable>
		<xsl:call-template name="write.html.file">
			<xsl:with-param name="file.name">OEBPS/Cover.xhtml</xsl:with-param>
			<xsl:with-param name="content" select="$cover.html"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="create.ncx">
		<xsl:variable name="contents">
			<ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1">
				<head>
					<meta name="dtb:uid" content="urn:uuid:anthc12102012"/>
					<meta name="dtb:depth" content="1"/>
					<meta name="dtb:totalPageCount" content="0"/>
					<meta name="dtb:maxPageNumber" content="0"/>
				</head>
				<docTitle>
					<text>ALA EPUB</text>
				</docTitle>
				<navMap>
					<xsl:call-template name="nav.points"/>
				</navMap>
			</ncx>
		</xsl:variable>
		<xsl:call-template name="write.xml.file">
			<xsl:with-param name="file.name">OEBPS/toc.ncx</xsl:with-param>
			<xsl:with-param name="content" select="$contents"/>
			<xsl:with-param name="pd">-//NISO//DTD ncx 2005-1//EN</xsl:with-param>
			<xsl:with-param name="sd">http://www.daisy.org/z3986/2005/ncx-2005-1.dtd</xsl:with-param>
			<xsl:with-param name="standalone">no</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="nav.points">
		<xsl:for-each select="$resolved.document//topic">
			<xsl:variable name="topic.id">
			 <xsl:choose>
				<xsl:when test="child::chapter">
				   <xsl:value-of select="ds:get.normalized.text(chapter/title)"/>
				</xsl:when>
				<xsl:when test="child::appendix">
				   <xsl:value-of select="ds:get.normalized.text(appendix/title)"/>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
			</xsl:variable>
			<xsl:variable name="file.name" select="if(contains(@xtrf,'#'))then(replace(replace(substring-before(@xtrf,'#'),'.*/',''),'xml','xhtml'))else(replace(replace(@xtrf,'.*/',''),'xml','xhtml'))"/>
			<navPoint xmlns="http://www.daisy.org/z3986/2005/ncx/" id="{$topic.id}" playOrder="{position()}">
				<navLabel>
					<text>
					   <xsl:choose>
							<xsl:when test="child::chapter">
							   <xsl:value-of select="string-join(chapter/title/text(),'')"/>
							</xsl:when>
							<xsl:when test="child::appendix">
							   <xsl:value-of select="string-join(appendix/title/text(),'')"/>
							</xsl:when>
							<xsl:otherwise/>
			            </xsl:choose>
						<!--xsl:value-of select="string-join(title//text(),'')"/-->
					</text>
				</navLabel>
				<content src="{$file.name}"/>
			</navPoint>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="create.opf">
		<xsl:variable name="contents">
			<package xmlns="http://www.idpf.org/2007/opf" unique-identifier="eCHAM" version="2.0">
				<metadata xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">
					<dc:title>ALA RDA EPUB</dc:title>
					<dc:creator opf:role="aut">Dakota Systems</dc:creator>
					<dc:language>en-US</dc:language>
					<dc:rights>Public Domain</dc:rights>
					<dc:publisher>ALA</dc:publisher>
					<dc:identifier id="rda" opf:scheme="UUID">urn:uuid:ala12102012</dc:identifier>
					<meta content="coverImage" name="cover"/>
				</metadata>
				<manifest>
					<item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
					<item id="style" href="stylesheet.css" media-type="text/css"/>
					<item id="coverImage" href="images/cover.jpeg" media-type="image/jpeg"/>
					<item id="cover" href="Cover.xhtml" media-type="application/xhtml+xml"/>
					<item id="tableOfContents" href="tableOfContents.xhtml" media-type="application/xhtml+xml"/>
					<xsl:call-template name="html.items"/>
					<xsl:call-template name="image.items"/>
				</manifest>
				<spine toc="ncx">
					<itemref idref="cover"/>
					<itemref idref="tableOfContents"/>
					<xsl:call-template name="html.itemrefs"/>
				</spine>
				<guide>
					<reference type="toc" title="Table of Contents" href="tableOfContents.xhtml"/>
				</guide>
			</package>
		</xsl:variable>
		<xsl:call-template name="write.xml.file">
			<xsl:with-param name="file.name">OEBPS/content.opf</xsl:with-param>
			<xsl:with-param name="content" select="$contents"/>
			<xsl:with-param name="standalone">yes</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="create.toc">
		<xsl:variable name="contents">
			<html xml:lang="en">
				<head>
					<title>Table of Contents</title>
				</head>
				<body>
					<left>
						<xsl:for-each select="$resolved.document//topic">
							<!--xsl:variable name="topic.id" select="ds:get.normalized.text(title)"/-->
							<!--xsl:variable name="topic-level" select="count(preceding-sibling::topic)"/-->
							<xsl:variable name="appendix-count" select="count(preceding-sibling::topic[child::appendix])"/>
							 <xsl:variable name="topic-level">
								 <xsl:choose>
									<xsl:when test="child::chapter">
										 <xsl:value-of select="count(preceding-sibling::topic)"/>
									</xsl:when>
									<xsl:when test="child::appendix">
										 <xsl:number value="$appendix-count+1" format="A"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="topic.id">
							<!--xsl:choose-->
								<xsl:if test="child::chapter">
								   <xsl:value-of select="ds:get.normalized.text(chapter/title)"/>
								</xsl:if>
								<xsl:if test="child::appendix">
								   <xsl:value-of select="ds:get.normalized.text(appendix/title)"/>
								</xsl:if>
								<xsl:if test="descendant::sect1">
								   <xsl:for-each select="descendant::sect1">
								     <xsl:value-of select="ds:get.normalized.text(./title)"/>
								    </xsl:for-each>
								</xsl:if>
								<xsl:if test="descendant::sect2">
								   <xsl:for-each select="descendant::sect2">
								     <xsl:value-of select="ds:get.normalized.text(./title)"/>
								    </xsl:for-each>
								</xsl:if>
								<xsl:if test="descendant::sect3">
								   <xsl:for-each select="descendant::sect3">
								     <xsl:value-of select="ds:get.normalized.text(./title)"/>
								    </xsl:for-each>
								</xsl:if>
								<xsl:if test="descendant::sect4">
								   <xsl:for-each select="descendant::sect4">
								     <xsl:value-of select="ds:get.normalized.text(./title)"/>
								    </xsl:for-each>
								</xsl:if>
								<!--xsl:otherwise/>
			                 </xsl:choose-->
							</xsl:variable>
							<xsl:variable name="file.name" select="if(contains(@xtrf,'#'))then(replace(replace(substring-before(@xtrf,'#'),'.*/',''),'xml','xhtml'))else(replace(replace(@xtrf,'.*/',''),'xml','xhtml'))"/>
							<div>
							<a href="{$file.name}">
								<xsl:choose>
								<xsl:when test="child::chapter">
								   <xsl:value-of select="concat($topic-level,': ',chapter/title)"/>
								</xsl:when>
								<xsl:when test="child::appendix">
								   <xsl:value-of select="concat($topic-level,': ',appendix/title)"/>
								</xsl:when>
								<xsl:otherwise/>
								 </xsl:choose>
							</a>
							</div>
							<xsl:if test="descendant::sect1">
								<xsl:for-each select="descendant::sect1">
									<xsl:variable name="file.name.sect1" select="concat($file.name,'#',@id)"/>
									   <xsl:variable name="sect1-level" select="count(preceding-sibling::sect1)"/>
										<div style="margin-left:50px">
										<a href="{$file.name.sect1}">
										   <!--xsl:value-of select="'test'"/-->
											<xsl:value-of select="concat($topic-level,'.',$sect1-level,' ',./title)"/>
										 </a>
										 </div>
								  </xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</left>
				</body>
			</html>
		</xsl:variable>
		<xsl:call-template name="write.html.file">
			<xsl:with-param name="file.name">OEBPS/tableOfContents.xhtml</xsl:with-param>
			<xsl:with-param name="content" select="$contents"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="html.items">
		<xsl:for-each select="$resolved.document//topic">
			<!--xsl:variable name="topic.id" select="ds:get.normalized.text(title)"/-->
			<xsl:variable name="topic.id">
			 <xsl:choose>
				<xsl:when test="child::chapter">
				   <xsl:value-of select="ds:get.normalized.text(chapter/title)"/>
				</xsl:when>
				<xsl:when test="child::appendix">
				   <xsl:value-of select="ds:get.normalized.text(appendix/title)"/>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
			</xsl:variable>
			<xsl:variable name="file.name" select="if(contains(@xtrf,'#'))then(replace(replace(substring-before(@xtrf,'#'),'.*/',''),'xml','xhtml'))else(replace(replace(@xtrf,'.*/',''),'xml','xhtml'))"/>
			<item xmlns="http://www.idpf.org/2007/opf" id="{$topic.id}" href="{$file.name}" media-type="application/xhtml+xml"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="image.items">
		<xsl:for-each select="$resolved.document//image">
			<xsl:variable name="image.href" select="replace(@href,'.*/','')"/>
			<xsl:variable name="image.ext" select="substring-after($image.href,'.')"/>
			<xsl:variable name="image.id" select="$image.href"/>
			<xsl:if test="not(preceding::image[replace(@href,'.*/','') = $image.href])">
				<item xmlns="http://www.idpf.org/2007/opf" id="{$image.id}" href="{concat('images/',$image.href)}" media-type="{concat('image/',$image.ext)}"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="html.itemrefs">
		<xsl:for-each select="$resolved.document//topic">
			<!--xsl:variable name="topic.id" select="ds:get.normalized.text(ALAdocument/title-meta/title)"/-->
			<xsl:variable name="topic.id">
			<xsl:choose>
				<xsl:when test="child::chapter">
				   <xsl:value-of select="ds:get.normalized.text(chapter/title)"/>
				</xsl:when>
				<xsl:when test="child::appendix">
				   <xsl:value-of select="ds:get.normalized.text(appendix/title)"/>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
			</xsl:variable>
			<itemref xmlns="http://www.idpf.org/2007/opf" idref="{$topic.id}"/>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
