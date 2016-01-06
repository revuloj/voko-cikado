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
        <dc:identifier id="dcidid" opf:scheme="CVS-ID"><xsl:value-of select="//editionStmt/edition"/></dc:identifier>
        <dc:subject>Esperanto, verko</dc:subject>
        <dc:description><xsl:value-of select="//titleStmt/author"/>:
        <xsl:value-of select="//titleStmt/title"/></dc:description>
        <dc:relation>http://www.steloj.de/</dc:relation>
        <dc:creator><xsl:value-of select="//titleStmt/author"/></dc:creator>
        <dc:publisher><xsl:value-of select="//publicationStmt/publisher"/></dc:publisher>
        <dc:date><xsl:value-of select="//publicationStmt/date"/></dc:date>
      </metadata>
      <manifest>
        <item id="ncx" href="content.ncx" media-type="application/x-dtbncx+xml"/>

        <!-- ########## trovu manieron tion automate eltrovi ############ -->
        <item id="fundamento_css" href="css/fundamento_epub.css" media-type="text/css"/>
        <item id="teixlite_css" href="css/teixlite_epub.css" media-type="text/css"/>
        <item id="index" href="index.xhtml" media-type="application/xhtml+xml"/>
        <xsl:call-template name="manifest_list"/>
      </manifest>
      <spine toc="ncx">
        <itemref idref="index"/> 
        <xsl:call-template name="spine_list"/>
      </spine>
    </package>

</xsl:template>

<xsl:template name="manifest_list">                           
  <xsl:for-each select="//text[@rend='doc']|//div[@rend='doc']">
    <item id="{@id}" href="{@id}.xhtml" media-type="application/xhtml+xml"/>
  </xsl:for-each>
</xsl:template>

<xsl:template name="spine_list">                              
  <xsl:for-each select="//text[@rend='doc']|//div[@rend='doc']">
    <itemref idref="{@id}"/>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
