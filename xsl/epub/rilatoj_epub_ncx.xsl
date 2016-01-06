<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.daisy.org/z3986/2005/ncx/"
  version="1.0">

  <xsl:output method="xml"
    doctype-public="-//NISO//DTD ncx 2005-1//EN"
    doctype-system="http://www.daisy.org/z3986/2005/ncx-2005-1.dtd"
    version="1.1" 
    encoding="utf-8" 
    indent="yes"
    />

  <xsl:variable name="letters" select="'ABCĈDEFGĜHĤIJĴKLMNOPRSŜTUŬVZ'"/>

  <xsl:template name="file-name">
    <xsl:param name="letter"/>
    
    <xsl:choose>
      <xsl:when test="$letter='Ĉ'">
        <xsl:text>Cx</xsl:text>
      </xsl:when>
      <xsl:when test="$letter='Ĝ'">
        <xsl:text>Gx</xsl:text>
      </xsl:when>
      <xsl:when test="$letter='Ĥ'">
        <xsl:text>Hx</xsl:text>
      </xsl:when>
      <xsl:when test="$letter='Ĵ'">
        <xsl:text>Jx</xsl:text>
      </xsl:when>
      <xsl:when test="$letter='Ŝ'">
        <xsl:text>Sx</xsl:text>
      </xsl:when>
      <xsl:when test="$letter='Ŭ'">
        <xsl:text>Ux</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$letter"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>.xhtml</xsl:text>
  </xsl:template>


  <xsl:template match="/">

    <ncx
      xmlns="http://www.daisy.org/z3986/2005/ncx/"
      version="2005-1"
      xml:lang="eo">
      <head>
        <meta name="dc:Title" content="Vortaro de rilatoj"/>
        <meta name="dtb:uid" content="vortaroj_de_rilatoj"/>
        <meta name="dtb:depth" content="1"/>
        <meta name="dtb:totalPageCount" content="0"/>
        <meta name="dtb:maxPageNumber" content="0"/>
      </head>
      <docTitle>
        <text>Vortaro de rilatoj</text>
      </docTitle>
      <navMap>
        <navPoint playOrder="0" id="titolo">
          <navLabel>
            <text>Titolpaĝo</text>
          </navLabel>
          <content src="index.xhtml"/>
        </navPoint>
        <xsl:call-template name="table-of-content">
          <xsl:with-param name="nletter" select="1"/>
        </xsl:call-template>
      </navMap>
    </ncx>

  </xsl:template>



  <xsl:template name="table-of-content">
    <xsl:param name="nletter"/>

    <xsl:variable name="letter" select="substring($letters,$nletter,1)"/>
    <xsl:variable name="file">
      <xsl:call-template name="file-name">
        <xsl:with-param name="letter" select="$letter"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$letter">
      <navPoint playOrder="{$nletter}" id="litero_{$letter}">
        <navLabel>
          <text>&#x2015; <xsl:value-of select="$letter"/> &#x2015;</text>
        </navLabel>
        <content src="{$file}"/>
      </navPoint>
      <xsl:call-template name="table-of-content">
        <xsl:with-param name="nletter" select="1+$nletter"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>
