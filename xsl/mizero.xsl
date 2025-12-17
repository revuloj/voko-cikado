<!DOCTYPE xsl:stylesheet 
[
  <!ENTITY dash "&#x2015;">
  <!ENTITY leftquot '"'>
  <!ENTITY rightquot '"'>
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
		version="1.0"
                extension-element-prefixes="xt">

<!--

XSLT-stildifinoj por lasta.xml (La Lasta). 
Ĝi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne aŭ alie difinitajn tie.

(c) 2021 ĉe Wolfram DIESTEL
    permesilo GPL 2.0

-->


<xsl:import href="teixlite.xsl"/>

<xsl:variable name="content_level1" select="'chapter'"/>
<xsl:variable name="content_level2" select="''"/>

<xsl:template match="*[@rend='«»']">
<xsl:text>«</xsl:text><xsl:apply-templates/><xsl:text>»</xsl:text>
</xsl:template>

<xsl:template match="*[@rend='« ']">
<xsl:text>«</xsl:text><xsl:apply-templates/>
</xsl:template>

<xsl:template match="*[@rend='«-']">
<xsl:text>«</xsl:text><xsl:apply-templates/><xsl:text> &dash;</xsl:text>
</xsl:template>

<xsl:template match="*[@rend='-»']">
<xsl:text>&dash; </xsl:text><xsl:apply-templates/><xsl:text>»</xsl:text>
</xsl:template>


<xsl:template match="note">
  [<i><xsl:apply-templates/></i>]
</xsl:template>



</xsl:stylesheet>











