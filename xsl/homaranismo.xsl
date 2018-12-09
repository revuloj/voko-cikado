<!DOCTYPE xsl:stylesheet 
[
<!ENTITY nbsp "&#x00a0;">
<!ENTITY ubreve "&#x016d;">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
		version="1.0"
                extension-element-prefixes="xt">


<!--

XSLT-stildifinoj por paroloj.tei (Zamenhofaj paroloj). 
Ghi importas la bazajn regulojn el teixlite.xsl kaj 
enhavas mem nur la dokument-specifajn regulojn.

(c) 2001 che Wolfram DIESTEL
    licenco GPL 2.0

-->

<xsl:import href="teixlite.xsl"/>
<xsl:variable name="content_level1" select="'article'"/>

<xsl:variable name="content_level2" select="'subchapter'"/>



</xsl:stylesheet>











