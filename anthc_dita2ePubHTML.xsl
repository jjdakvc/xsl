<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ds="http://www.daksys.com" exclude-result-prefixes="xs fn ds xsl">
	<xsl:output encoding="UTF-8" method="xml"/>
	<xsl:template match="topic">
		<xsl:variable name="contents">
			<html xmlns="http://www.w3.org/1999/xhtml">
				<head>
					<xsl:apply-templates select="title" mode="title"/>
					<link href="stylesheet.css" type="text/css"/>
				</head>
				<body style="font-family:Arial">
				    <xsl:variable name="topic-level" select="count(preceding-sibling::topic)"/>
				     <xsl:variable name="appendix-count" select="count(preceding-sibling::topic[child::appendix])"/>
				     <xsl:variable name="appendix-level">
				       <xsl:number value="$appendix-count+1" format="A"/>    
				     </xsl:variable>
				    <table style="width:100%;">
					   <tbody>
					        <tr>
							 <td style="width:33%;"></td>
							 <td style="text-align:center;border-bottom:2px solid;width:33%;">
								<h1 xmlns="http://www.w3.org/1999/xhtml">
									<xsl:attribute name="style">text-align:center;font-weight:normal;text-transform:uppercase;</xsl:attribute>
									<xsl:choose>
										<xsl:when test="child::chapter">
										 <xsl:value-of select="$topic-level"/>
										</xsl:when>
										<xsl:when test="child::appendix">
										  <xsl:value-of select="$appendix-level"/>
										</xsl:when>
									</xsl:choose>
									</h1><!--use div rather than h1-->
							 </td>
							 <td style="width:33%;"></td>
							</tr>
						 </tbody>
					</table>
				    <xsl:apply-templates/>
				</body>
			</html>
		</xsl:variable>
		<xsl:variable name="file.name" select="if(contains(@xtrf,'#'))then(replace(replace(substring-before(@xtrf,'#'),'.*/',''),'xml','xhtml'))else(replace(replace(@xtrf,'.*/',''),'xml','xhtml'))"/>
		<xsl:call-template name="write.html.file">
			<xsl:with-param name="file.name" select="concat('OEBPS/',$file.name)"/>
			<xsl:with-param name="content" select="$contents"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="title-meta">
		<!--h1 xmlns="http://www.w3.org/1999/xhtml"--><xsl:apply-templates/><!--/h1-->
	</xsl:template>
	<xsl:template match="title">
	<xsl:variable name="appendix-count" select="count(ancestor::topic/preceding-sibling::topic[child::appendix])"/>
     <xsl:variable name="topic-level">
		 <xsl:choose>
			<xsl:when test="ancestor::chapter">
				 <xsl:value-of select="count(ancestor::topic/preceding-sibling::topic)"/>
			</xsl:when>
			<xsl:when test="ancestor::appendix">
				 <xsl:number value="$appendix-count+1" format="A"/>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="parent::chapter|parent::appendix">
			<h1 xmlns="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="style">text-align:center;font-weight:normal;text-transform:uppercase;</xsl:attribute>
			<xsl:call-template name="echo.id"/>		
			<xsl:apply-templates/>
			</h1>
		</xsl:when>
		<xsl:when test="parent::sect1">
		    <!--xsl:variable name="topic-level" select="count(ancestor::topic/preceding-sibling::topic)"/-->
		   <xsl:variable name="sect1-level" select="count(parent::sect1/preceding-sibling::sect1)"/>
		    <h2 xmlns="http://www.w3.org/1999/xhtml" style="margin-left:-25px">
			<xsl:call-template name="echo.id"/>
			<xsl:value-of select="concat($topic-level,'.',$sect1-level,' ')"/>
			<xsl:apply-templates/>
			</h2>
		</xsl:when>
		<xsl:when test="parent::sect2">
		   <xsl:variable name="sect1-level" select="count(ancestor::sect1/preceding-sibling::sect1)"/>
		    <xsl:variable name="sect2-level" select="count(parent::sect2/preceding-sibling::sect2)+1"/>
			<h3 xmlns="http://www.w3.org/1999/xhtml" style="margin-left:-25px">
			<xsl:call-template name="echo.id"/>
			<xsl:value-of select="concat($topic-level,'.',$sect1-level,'.',$sect2-level,' ')"/>
			<xsl:apply-templates/>
			</h3>
		</xsl:when>
		<xsl:when test="parent::sect3">
		    <xsl:variable name="sect1-level" select="count(ancestor::sect1/preceding-sibling::sect1)"/>
		    <xsl:variable name="sect2-level" select="count(ancestor::sect2/preceding-sibling::sect2)+1"/>
		     <xsl:variable name="sect3-level" select="count(parent::sect3/preceding-sibling::sect3)+1"/>
			<h4 xmlns="http://www.w3.org/1999/xhtml" style="margin-left:-25px">
			<xsl:call-template name="echo.id"/>
			<xsl:value-of select="concat($topic-level,'.',$sect1-level,'.',$sect2-level,'.',$sect3-level,' ')"/>
			<xsl:apply-templates/>
			</h4>
		</xsl:when>
		<xsl:when test="parent::sect4">
		    <xsl:variable name="sect1-level" select="count(ancestor::sect1/preceding-sibling::sect1)"/>
		    <xsl:variable name="sect2-level" select="count(ancestor::sect2/preceding-sibling::sect2)+1"/>
		     <xsl:variable name="sect3-level" select="count(ancestor::sect3/preceding-sibling::sect3)+1"/>
		      <xsl:variable name="sect4-level" select="count(parent::sect4/preceding-sibling::sect4)+1"/>
			<h5 xmlns="http://www.w3.org/1999/xhtml" style="margin-left:-25px">
			<xsl:call-template name="echo.id"/>
			<xsl:value-of select="concat($topic-level,'.',$sect1-level,'.',$sect2-level,'.',$sect3-level,'.',$sect4-level,' ')"/>
			<xsl:apply-templates/>
			</h5>
		</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="title" mode="title">
		<title xmlns="http://www.w3.org/1999/xhtml">
			<xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</title>
	</xsl:template>
	<xsl:template match="ALAdocument">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="chapter">
	<div xmlns="http://www.w3.org/1999/xhtml">
	     <xsl:call-template name="echo.id"/>
		<xsl:apply-templates/>
	</div>
	</xsl:template>
	<xsl:template match="appendix">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="sect1">
		<div xmlns="http://www.w3.org/1999/xhtml" style="margin-left:50px;">
		    <xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="sect2">
		<div xmlns="http://www.w3.org/1999/xhtml" style="margin-left:50px;">
			<xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="sect3">
		<div xmlns="http://www.w3.org/1999/xhtml"  style="margin-left:50px;">
			<xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="sect4">
		<div xmlns="http://www.w3.org/1999/xhtml" style="margin-left:50px;">
			<xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="para">
		<p xmlns="http://www.w3.org/1999/xhtml">
			<xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="emphasis">
	<xsl:choose>
		<xsl:when test="@role='italic'">
		<i xmlns="http://www.w3.org/1999/xhtml">
			<xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</i>
		</xsl:when>
		<xsl:when test="@role='operator'">
		<strong xmlns="http://www.w3.org/1999/xhtml">
			<xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</strong>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	<xsl:template match="b">
   </xsl:template>
	<xsl:template match="i">
	</xsl:template>
	<xsl:template match="u">
		<span xmlns="http://www.w3.org/1999/xhtml" style="text-decoration:underline">
			<xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="sup">
		<sup xmlns="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates/>
		</sup>
	</xsl:template>
	<xsl:template match="sub">
		<sub xmlns="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates/>
		</sub>
	</xsl:template>
	<xsl:template match="tt">
		<span xmlns="http://www.w3.org/1999/xhtml">
			<xsl:call-template name="echo.id"/>
			<xsl:attribute name="style"><xsl:value-of select="string('color:#007AAF;')"/></xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="ph">
		<span xmlns="http://www.w3.org/1999/xhtml">
			<xsl:call-template name="echo.id"/>
			<xsl:if test="@outputclass='small'">
				<xsl:attribute name="style"><xsl:value-of select="string('font-size:0.8em;')"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="unorderedlist">
		<ul xmlns="http://www.w3.org/1999/xhtml" style="margin-left:50px;">
			<xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>
	<xsl:template match="orderedlist">
		<ol xmlns="http://www.w3.org/1999/xhtml" style="margin-left:50px;">
			<xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</ol>
	</xsl:template>
	<xsl:template match="simplelist">
		<ol xmlns="http://www.w3.org/1999/xhtml" style="margin-left:50px;">
			<xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</ol>
	</xsl:template>
	<xsl:template match="IfThenList">
		<ol xmlns="http://www.w3.org/1999/xhtml" style="margin-left:50px;">
			<xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</ol>
	</xsl:template>
	<xsl:template match="member">
		<li xmlns="http://www.w3.org/1999/xhtml" style="list-style-type:none">
		<xsl:call-template name="echo.id"/>
		<div style="padding-left:1em;display:block;">
		<xsl:apply-templates/>
		</div>
		</li>
	</xsl:template>
	<xsl:template match="listitem">
	<xsl:variable name="list-level">
      <xsl:value-of select="count(ancestor-or-self::orderedlist)"/>	
	</xsl:variable>
	<li xmlns="http://www.w3.org/1999/xhtml">
	<xsl:call-template name="echo.id"/>
	 <xsl:choose>
	    <xsl:when test="parent::IfThenList">
	        <xsl:attribute name="style">list-style-type:none;</xsl:attribute>
	    </xsl:when>
		<xsl:when test="parent::orderedlist">
			 <xsl:choose>
				<xsl:when test="($list-level mod 3=1)">
				   <xsl:attribute name="style">list-style-type:lower-alpha;</xsl:attribute>			
				</xsl:when>
				<xsl:when test="($list-level mod 3=2)">
				   <xsl:attribute name="style">list-style-type:lower-roman;</xsl:attribute>			
				</xsl:when>
				<xsl:otherwise>
				   <xsl:attribute name="style">list-style-type:lower-alpha;</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="parent::unorderedlist">
			 <xsl:choose>
				<xsl:when test="($list-level mod 3=1)">
				   <xsl:attribute name="style">list-style-type:circle;</xsl:attribute>			
				</xsl:when>
				<xsl:when test="($list-level mod 3=2)">
				   <xsl:attribute name="style">list-style-type:square;</xsl:attribute>			
				</xsl:when>
				<xsl:otherwise>
				   <xsl:attribute name="style">list-style-type:circle;</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
		     <xsl:choose>
				<xsl:when test="($list-level mod 3=1)">
				   <xsl:attribute name="style">list-style-type:lower-alpha;</xsl:attribute>			
				</xsl:when>
				<xsl:when test="($list-level mod 3=2)">
				   <xsl:attribute name="style">list-style-type:lower-roman;</xsl:attribute>			
				</xsl:when>
				<xsl:otherwise>
				   <xsl:attribute name="style">list-style-type:lower-alpha;</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
	<div style="padding-left:1em;display:block;">
	<xsl:apply-templates/>
	</div>
	 </li>
	</xsl:template>
   
   <xsl:template match="Exampleset">
   <div style="background-color:#d6decd">
   <xsl:call-template name="echo.id"/>
   <xsl:apply-templates/>
   </div>
   </xsl:template>	
   
   <xsl:template match="Exampleentry">
   <div xmlns="http://www.w3.org/1999/xhtml">
   <xsl:apply-templates/>
   </div>
   </xsl:template>
   
   <xsl:template match="simplesect">
   <xsl:apply-templates/>
   </xsl:template>
   
   <xsl:template match="footnote">
   <xsl:apply-templates/>
   </xsl:template>

	<xsl:template match="mref">
	<xsl:variable name="mref-rid" select="@rid"/>
	<xsl:variable name="mref-src">
	   <xsl:choose>
					<xsl:when test="ancestor::chapter|ancestor::appendix">
					  <xsl:value-of select="concat(replace(ancestor::topic//meta-item[@id=$mref-rid]//rda-item/@targetdoc,'.xml','.xhtml'),'#',ancestor::topic//meta-item[@id=$mref-rid]//rulenumber/@rid)"/>
					</xsl:when>
		</xsl:choose>
	  </xsl:variable> 
	<a xmlns="http://www.w3.org/1999/xhtml" href="{$mref-src}">
		<xsl:apply-templates/>
	</a>
	</xsl:template>
	<xsl:template match="table">
		<table xmlns="http://www.w3.org/1999/xhtml">
			<xsl:if test="@frame='none'">
				<xsl:attribute name="class">noFrame</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	<xsl:template match="thead">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="tgroup">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="tbody">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="row">
		<tr xmlns="http://www.w3.org/1999/xhtml">
			<xsl:call-template name="echo.id"/>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>
	<xsl:template match="entry[../parent::tbody]">
		<td xmlns="http://www.w3.org/1999/xhtml">
			<xsl:call-template name="echo.id"/>
			<xsl:choose>
				<xsl:when test="@align and @valign">
					<xsl:attribute name="style"><xsl:value-of select="concat('text-align:',@align,';vertical-align:',@valign)"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="@align">
					<xsl:attribute name="style"><xsl:value-of select="concat('text-align:',@align)"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="@valign">
					<xsl:attribute name="style"><xsl:value-of select="concat('vertical-align:',@valign)"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
			<xsl:if test="ancestor::table[1][@outputclass='banner']">
				<xsl:attribute name="class"><xsl:value-of select="string('banner')"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@namest">
				<xsl:variable name="namest" select="normalize-space(@namest)"/>
				<xsl:variable name="nameend" select="normalize-space(@nameend)"/>
				<xsl:attribute name="colspan"><xsl:value-of select="count(../../../colspec[normalize-space(@colname)=$nameend]/preceding-sibling::colspec) - count(../../../colspec[normalize-space(@colname)=$namest]/preceding-sibling::colspec) + 1"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@morerows">
				<xsl:attribute name="rowspan"><xsl:value-of select="number(normalize-space(@morerows))+1"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</td>
	</xsl:template>
	<xsl:template match="entry[../parent::thead]">
		<th xmlns="http://www.w3.org/1999/xhtml">
			<xsl:call-template name="echo.id"/>
			<xsl:choose>
				<xsl:when test="@align and @valign">
					<xsl:attribute name="style"><xsl:value-of select="concat('text-align:',@align,';vertical-align:',@valign)"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="@align">
					<xsl:attribute name="style"><xsl:value-of select="concat('text-align:',@align)"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="@valign">
					<xsl:attribute name="style"><xsl:value-of select="concat('vertical-align:',@valign)"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
			<xsl:if test="@namest">
				<xsl:variable name="namest" select="normalize-space(@namest)"/>
				<xsl:variable name="nameend" select="normalize-space(@nameend)"/>
				<xsl:attribute name="colspan"><xsl:value-of select="count(../../../colspec[normalize-space(@colname)=$nameend]/preceding-sibling::colspec) - count(../../../colspec[normalize-space(@colname)=$namest]/preceding-sibling::colspec) + 1"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@morerows">
				<xsl:attribute name="rowspan"><xsl:value-of select="number(normalize-space(@morerows))+1"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</th>
	</xsl:template>
	<xsl:template match="ulink">
	<xsl:variable name="ulink-src" select="@url"/>
	<a xmlns="http://www.w3.org/1999/xhtml" href="{$ulink-src}">
	<xsl:call-template name="echo.id"/>
	<xsl:apply-templates/>
	</a>
	</xsl:template>
	<xsl:template match="xref">
		<xsl:variable name="target" select="replace(@href,'.*/','')"/>
		<xsl:variable name="html.target" select="replace($target,'\.xml','.xhtml')"/>
		<a  xmlns="http://www.w3.org/1999/xhtml" href="{$html.target}" style="text:decoration:none">
			<xsl:call-template name="echo.id"/>
			<img src="images/magnifying_glass.jpg" alt="Link"/>
		</a>
	</xsl:template>
	<xsl:template match="image">
		<xsl:variable name="image.path">
			<xsl:choose>
				<xsl:when test="contains(@href,'/')">
					<xsl:value-of select="concat('images/',replace(@href,'.*/',''))"/>
				</xsl:when>
				<xsl:when test="contains(@href,'\')">
					<xsl:value-of select="concat('images/',replace(@href,'.*\\',''))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('images/',@href)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<img xmlns="http://www.w3.org/1999/xhtml" src="{$image.path}" alt="Image"/>
	</xsl:template>
	<xsl:template match="fig">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="note">
		<xsl:variable name="note.word">
			<xsl:choose>
				<xsl:when test="@type = 'caution'">Caution</xsl:when>
				<xsl:when test="@type = 'other' and lower-case(@othertype)='warning'">Warning</xsl:when>
				<xsl:otherwise>Note</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div xmlns="http://www.w3.org/1999/xhtml"><xsl:value-of select="$note.word"/>: <xsl:apply-templates/></div>
	</xsl:template>
	<xsl:template match="indexterm"/>
	<xsl:template match="draft-comment"/>
	<xsl:template match="prolog|shortdesc|searchtitle|titlealts"/>
	<xsl:template match="colspec"/>
	<xsl:template match="*">
		<!--<xsl:copy-of select="."/>-->
	</xsl:template>
</xsl:stylesheet>
