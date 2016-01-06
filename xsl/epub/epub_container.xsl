<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output
    method="xml" 
    version="1.0" 
    encoding="utf-8" 	
    doctype-public="-//NISO//DTD ncx 2005-1//EN"
    doctype-system="http://www.daisy.org/z3986/2005/ncx-2005-1.dtd"/>

  <xsl:template match="/">

    <container version="1.0" 
      xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
      <rootfiles>
        <rootfile full-path="content.opf"
          media-type="application/oebps-package+xml"/>
      </rootfiles>
    </container>

  </xsl:template>

</xsl:stylesheet>
