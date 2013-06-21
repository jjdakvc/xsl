<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" version="1.0" encoding="UTF-8" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
    <xsl:param name="libDir"/>
    <xsl:param name="workDir"/>
    <xsl:template match="/">
        <html>
            <xsl:apply-templates/>
        </html>
    </xsl:template>
    <xsl:template match="ALAdocument">
        <head>
            <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
            <!--h3 class="title">
                <xsl:value-of select="title"/>
            </h3-->
        </head>
        <body>
            <div id="bodytext">
                <xsl:apply-templates select="*[not(self::title)]"/>
            </div>
        </body>
    </xsl:template>
 <!-- LINKS -->
    <xsl:template match="links">
        <div id="main_content">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
 <!-- SECTIONS -->
    <xsl:template match="sect1">
        <xsl:if test="title/text()|title/*/text()">
            <h4 class="section-title" id="{@id}">
                <xsl:value-of select="title"/>
            </h4>
        </xsl:if>
        <xsl:apply-templates select="para|ul|ol|pre|image"/>
    </xsl:template>
    <xsl:template match="section[@outputclass]">
        <div>
            <xsl:attribute name="class">
                <xsl:value-of select="@outputclass"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
 <!-- CONCEPTS HANDLER -->
    <xsl:template match="concept">
        <div class="instruct">
            <br/>
            <xsl:if test="title/text()">
                <h4>
                    <xsl:value-of select="title"/>
                    <xsl:text>:</xsl:text>
                </h4>
            </xsl:if>
            <br/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
 <!-- PARAGRAPH -->
    <xsl:template match="para[not(parent::fig)]">
        <p>
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@outputclass='underTitle'">
                <xsl:attribute name="style">
                    <xsl:value-of select="string('font-weight:bold;color:#007AAF')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="para[parent::fig]">
        <br> - <i>
                <xsl:apply-templates/>
            </i> - </br>
    </xsl:template>    
    
 <!-- MISC TAG FOR USING CSS -->
    <xsl:template match="b">
        <xsl:choose>
            <xsl:when test="@outputclass='h4'">
                <h4>
                    <xsl:apply-templates/>
                </h4>
            </xsl:when>
            <xsl:otherwise>
                <b>
                    <xsl:apply-templates/>
                </b>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="i">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>
 <!-- REFERENCES HANDLER -->
    <xsl:template match="xref">
        <a>
            <xsl:attribute name="rel">
                <xsl:value-of select="string('nofollow')"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="@scope='external'">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@href"/>
                    </xsl:attribute>
                    <xsl:value-of select="./text()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@href"/>
                    </xsl:attribute>
                    <xsl:attribute name="class">
                        <xsl:value-of select="string('xref')"/>
                    </xsl:attribute>
                    <img src="css/images/internalLink.png" alt="this link"/>
                </xsl:otherwise>
            </xsl:choose>
        </a>
    </xsl:template>
    <xsl:template match="draft-comment"/>
 <!-- HANDLE ALL IMAGES AND ITS ATTRIBUTE -->
    <xsl:template match="image">
        <xsl:variable name="jpg">
            <xsl:value-of select="translate(@href,'.tif','.jpg')"/>
        </xsl:variable>
        <xsl:variable name="url">http://209.165.154.34/exist/rest<xsl:value-of select="$workDir"/>/<xsl:value-of select="replace(@href,'%20',' ')"/>
        </xsl:variable>
        <img>
            <xsl:attribute name="src">
                <xsl:choose>
                    <xsl:when test="@scope='external'">
                        <xsl:value-of select="@href"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$url"/>
                    </xsl:otherwise>
                </xsl:choose>
                <!--xsl:value-of select="string('')"/-->
            </xsl:attribute>
            <!--xsl:choose>
                <xsl:when test="@scale">
                    <xsl:attribute name="width">
                        <xsl:value-of select="@scale"/>%</xsl:attribute>
                    <xsl:attribute name="height">
                        <xsl:value-of select="@scale"/>%</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="@width">
                        <xsl:attribute name="width">
                            <xsl:value-of select="@width"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@height">
                        <xsl:attribute name="height">
                            <xsl:value-of select="@height"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="@outputclass='float'">
                <xsl:attribute name="style">
                    float:<xsl:value-of select="@align"/>; padding:6pt;
                </xsl:attribute>
            </xsl:if-->
            <xsl:attribute name="border">0</xsl:attribute>
        </img>
    </xsl:template>
    <xsl:template match="ul|ol|pre|li">
        <xsl:copy>
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="local-name(.)='ul' and @outputclass='nobullet'">
                <xsl:attribute name="class">
                    <xsl:value-of select="string('noBullet')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tt">
        <span>
            <xsl:if test="local-name(.)='tt'">
                <xsl:attribute name="style">
                    <xsl:value-of select="string('color:#007AAF;')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="ph">
        <span>
            <xsl:if test="local-name(.)='ph' and @outputclass='small'">
                <xsl:attribute name="style">
                    <xsl:value-of select="string('font-size:0.8em;')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="prolog|shortdesc|searchtitle|titlealts"/>
    <xsl:template match="*">
        <xsl:apply-templates/>
    </xsl:template>
 <!-- TABLES, TRAINING SCHEDULE -->
    <xsl:template match="thead">
        <thead>
            <xsl:apply-templates/>
        </thead>
    </xsl:template>
    <xsl:template match="tbody">
        <tbody>
            <xsl:apply-templates/>
        </tbody>
    </xsl:template>
    <xsl:template match="row">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    <xsl:template match="entry[../parent::tbody]">
        <td>
            <xsl:choose>
                <xsl:when test="@align and @valign">
                    <xsl:attribute name="style">
                        <xsl:value-of select="concat('text-align:',@align,';vertical-align:',@valign)"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@align">
                    <xsl:attribute name="style">
                        <xsl:value-of select="concat('text-align:',@align)"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@valign">
                    <xsl:attribute name="style">
                        <xsl:value-of select="concat('vertical-align:',@valign)"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <xsl:if test="ancestor::table[1][@outputclass='banner']">
                <xsl:attribute name="class">
                    <xsl:value-of select="string('banner')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@namest">
                <xsl:variable name="namest" select="normalize-space(@namest)"/>
                <xsl:variable name="nameend" select="normalize-space(@nameend)"/>
                <xsl:attribute name="colspan">
                    <xsl:value-of select="count(../../../colspec[normalize-space(@colname)=$nameend]/preceding-sibling::colspec) - count(../../../colspec[normalize-space(@colname)=$namest]/preceding-sibling::colspec) + 1"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@morerows">
                <xsl:attribute name="rowspan">
                    <xsl:value-of select="number(normalize-space(@morerows))+1"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </td>
    </xsl:template>
    <xsl:template match="entry[../parent::thead]">
        <th>
            <xsl:choose>
                <xsl:when test="@align and @valign">
                    <xsl:attribute name="style">
                        <xsl:value-of select="concat('text-align:',@align,';vertical-align:',@valign)"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@align">
                    <xsl:attribute name="style">
                        <xsl:value-of select="concat('text-align:',@align)"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@valign">
                    <xsl:attribute name="style">
                        <xsl:value-of select="concat('vertical-align:',@valign)"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <xsl:if test="@namest">
                <xsl:variable name="namest" select="normalize-space(@namest)"/>
                <xsl:variable name="nameend" select="normalize-space(@nameend)"/>
                <xsl:attribute name="colspan">
                    <xsl:value-of select="count(../../../colspec[normalize-space(@colname)=$nameend]/preceding-sibling::colspec) - count(../../../colspec[normalize-space(@colname)=$namest]/preceding-sibling::colspec) + 1"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@morerows">
                <xsl:attribute name="rowspan">
                    <xsl:value-of select="number(normalize-space(@morerows))+1"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </th>
    </xsl:template>
    <xsl:template match="table">
        <xsl:choose>
            <xsl:when test="@outputclass='center'">
                <div class="center">
                    <table align="left">
                        <xsl:apply-templates/>
                    </table>
                </div>
            </xsl:when>
            <xsl:when test="@outputclass='schedule'">
                <table width="470">
                    <xsl:apply-templates/>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <table>
                    <xsl:attribute name="cellpadding">2</xsl:attribute>
                    <xsl:attribute name="cellspacing">2</xsl:attribute>
                    <xsl:if test="@frame='none'">
                        <xsl:attribute name="class">
                            <xsl:value-of select="string('noFrame')"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>
                </table>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="indexterm"/>
</xsl:stylesheet>