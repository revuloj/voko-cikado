<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:opf="http://www.idpf.org/2007/opf"
  xmlns="http://www.idpf.org/2007/opf"
  version="1.0">

  <xsl:output method="xml"
    version="1.0" 
    encoding="utf-8"
    indent="yes"/> 	


  <xsl:param name="datetime"/>
  <xsl:param name="date"/>

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
    
    <package
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:dc="http://purl.org/dc/elements/1.1/"
      xmlns:opf="http://www.idpf.org/2007/opf"
      xmlns="http://www.idpf.org/2007/opf"
      version="2.0"
      unique-identifier="dcidid">
      <metadata>
        <dc:language xsi:type="dcterms:RFC3066">eo</dc:language>
        <dc:title>Vortaro de rilatoj</dc:title>
        <dc:identifier id="dcidid">
          Vortaro de rilation, 
          <xsl:value-of select="$datetime"/>
        </dc:identifier>
        <dc:subject>Esperanto, lingvo, vortaro</dc:subject>
        <dc:description>Vortaro kun vortrilatoj kaj tradukoj, eltirita el Reta Vortaro</dc:description>
        <dc:relation>http://reta-vortaro.de</dc:relation>
        <dc:publisher>Wolfram Diestel</dc:publisher>
        <dc:date><xsl:value-of select="$date"/></dc:date>
      </metadata>
      <xsl:call-template name="manifest"/>
      <spine toc="ncx">
        <itemref idref="index"/> 
        <xsl:call-template name="spine_list">
          <xsl:with-param name="nletter" select="1"/>
        </xsl:call-template>
      </spine>
    </package>

</xsl:template>

<xsl:template name="manifest">
  <manifest>
    <item id="ncx" href="content.ncx" media-type="application/x-dtbncx+xml"/>
    <item id="rilatoj_css" href="css/rilatoj_epub.css" media-type="text/css"/>
    <item id="libertine_re_otf" href="otf/LinLibertine_Re-4.7.5.otf" media-type="application/x-font-opentype"/>
    <item id="libertine_it_otf" href="otf/LinLibertine_It-4.2.6.otf" media-type="application/x-font-opentype"/>
    <item id="libertine_bd_otf" href="otf/LinLibertine_Bd-4.1.5.otf" media-type="application/x-font-opentype"/>
    <item id="open_font_licence" href="otf/OFL.txt" media-type="text/plain"/>
    <item id="index" href="index.xhtml" media-type="application/xhtml+xml"/>
    <xsl:call-template name="manifest_list">
      <xsl:with-param name="nletter" select="1"/>
    </xsl:call-template>
  </manifest>
</xsl:template>

<xsl:template name="manifest_list">                           
  <xsl:param name="nletter"/>
  <xsl:variable name="letter" select="substring($letters,$nletter,1)"/>
  <xsl:variable name="file">
    <xsl:call-template name="file-name">
      <xsl:with-param name="letter" select="$letter"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$letter">
    <item id="{$letter}" href="{$file}" media-type="application/xhtml+xml"/>
    
    <xsl:call-template name="manifest_list">
      <xsl:with-param name="nletter" select="1+$nletter"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="spine_list">                              
  <xsl:param name="nletter"/>
  <xsl:variable name="letter" select="substring($letters,$nletter,1)"/>

  <xsl:if test="$letter">
    <itemref idref="{$letter}"/>
    <xsl:call-template name="spine_list">
      <xsl:with-param name="nletter" select="1+$nletter"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>
