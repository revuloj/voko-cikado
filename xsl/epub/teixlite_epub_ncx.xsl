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

  <xsl:variable name="content_level1" select="'part'"/>
  <xsl:variable name="content_level2" select="'chapter'"/>

  <xsl:template match="/">

    <ncx
      xmlns="http://www.daisy.org/z3986/2005/ncx/"
      version="2005-1"
      xml:lang="eo">
      <head>
        <meta name="dc:Title" content="{//titleStmt/title}"/>
        <meta name="dtb:uid" content="{//editionStmt/edition}"/>
        <meta name="dtb:depth" content="2"/>
        <meta name="dtb:totalPageCount" content="0"/>
        <meta name="dtb:maxPageNumber" content="0"/>
      </head>
      <docTitle>
        <text><xsl:value-of select="//titleStmt/title"/></text>
      </docTitle>
      <navMap>
        <xsl:call-template name="table-of-content">
          <xsl:with-param name="level1" select="$content_level1"/>
          <xsl:with-param name="level2" select="$content_level2"/>
        </xsl:call-template>
      </navMap>
    </ncx>

  </xsl:template>



  <xsl:template name="table-of-content">
    <xsl:param name="level1"/>
    <xsl:param name="level2"/>

    <!--    <xsl:for-each select=".//div[@type=$level1]|.//text[@type=$level1]"> -->
    <xsl:for-each select=".//div[@type=$level1]|.//text[@rend='doc']">
      <xsl:variable name="ref">
        <xsl:choose>
          <xsl:when test="@rend='doc'">
            <xsl:value-of select="@id"/>
            <xsl:text>.xhtml</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>#</xsl:text>
            <xsl:value-of select="@id"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="refstr">
        <xsl:choose>
          <xsl:when test="self::text">
            <xsl:apply-templates select=".//docTitle" mode="index"/>
          </xsl:when>
          <xsl:otherwise> 
          <xsl:value-of select=".//head[1]"/>
        </xsl:otherwise>
      </xsl:choose> 
      </xsl:variable>
      <xsl:variable name="m">
        <xsl:number level="any" count="//div[@type=$level1]|//text[@rend='doc']|//div[@type=$level2]"/>
      </xsl:variable>
      
      <navPoint playOrder="{$m}" id="{@id}">
        <navLabel>
          <text><xsl:value-of select="normalize-space($refstr)"/></text>
        </navLabel>
        <content src="{$ref}"/>
        
        <xsl:if test="($level2!='') and (.//div[@type=$level2])">
          
          <xsl:for-each select=".//div[@type=$level2]">
            
            <xsl:variable name="ref">
              <xsl:choose>
                <xsl:when test="@rend='doc'">
                  <xsl:value-of select="@id"/>
                  <xsl:text>.xhtml</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>#</xsl:text>
                  <xsl:value-of select="@id"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="m">
              <xsl:number level="any" count="//div[@type=$level1]|//text[@rend='doc']|//div[@type=$level2]"/>
            </xsl:variable>
       
            <navPoint playOrder="{$m}" id="{@id}">
              <navLabel>
                <text><xsl:value-of select="normalize-space(.//head[1])"/></text>
              </navLabel>
              <content src="{$ref}"/>
            </navPoint>
            
          </xsl:for-each>
        </xsl:if>
        
      </navPoint>
    </xsl:for-each>
    
  </xsl:template>

  <xsl:template match="docTitle" mode="index">
    <xsl:value-of select="titlePart[@type='main']"/>
  </xsl:template>

</xsl:stylesheet>
