<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:opf="http://www.idpf.org/2007/opf"
  xmlns="http://www.idpf.org/2007/opf"
  version="1.0">

  <xsl:output method="xml"
    version="1.0" 
    encoding="utf-8"
    indent="yes"/> 	


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
        <dc:title><xsl:value-of select="//titleStmt/title"/></dc:title>
        <dc:identifier id="dcidid" opf:scheme="file">senchesa_nur_elcherpo</dc:identifier>
        <dc:subject>Esperanto, verko</dc:subject>
        <dc:date>2010</dc:date>
        <meta name="cover" content="cover-image"/>
      </metadata>
      <manifest>
        <item id="ncx" href="content.ncx" media-type="application/x-dtbncx+xml"/>
        <item id="senchesa_css" href="css/senchesa_epub.css" media-type="text/css"/>
        <item id="teixlite_css" href="css/teixlite_epub.css" media-type="text/css"/>
        <item id="liberation_ttf" href="ttf/LiberationSerif-Regular.ttf" media-type="application/x-font-truetype"/>
        <item id="cover" href="index.xhtml" media-type="application/xhtml+xml"/>
        <item id="cover-image" href="img/titolo.jpg" media-type="image/jpeg"/>
        <xsl:call-template name="manifest_list"/>
      </manifest>
      <spine toc="ncx">
        <itemref idref="cover" linear="no"/>
        <xsl:call-template name="spine_list"/>
      </spine>
      <guide>  
        <reference href="index.xhtml" type="cover" title="Titolpa&#x011d;o"/>
      </guide>
    </package>

</xsl:template>

<xsl:template name="manifest_list">                           
  <xsl:for-each select="//text[@rend='doc']|//div[@rend='doc']">
    <item id="{@id}" href="{@id}.xhtml" media-type="application/xhtml+xml"/>
  </xsl:for-each>
  <xsl:for-each select="//figure">
    <item id="{@entity}" media-type="image/gif" 
      href="img/{
       substring-before(
              substring-after(
		unparsed-entity-uri(@entity),'senchesa/'),'.')
      }.gif"/>
  </xsl:for-each>
</xsl:template>

<xsl:template name="spine_list">                              
  <xsl:for-each select="//text[@rend='doc']|//div[@rend='doc']">
    <itemref idref="{@id}"/>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
