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

<xsl:variable name="content_level1" select="'story'"/>
<xsl:variable name="content_level2" select="''"/>

<xsl:variable name="titolbildo">../bld/lasta/lasta.jpg</xsl:variable>

<xsl:template name="titolbildo">
  <xsl:if test="not(ancestor::group)">
    <p class="titolbildo">
    <img align="center" src="{$titolbildo}"/>
    </p>
  </xsl:if>
</xsl:template>

<xsl:template match="lg[@lang='fr']/l">
  <span class="l"><i><xsl:apply-templates/></i></span><br/>
</xsl:template>

<xsl:template match="note">
  [<i><xsl:apply-templates/></i>]
</xsl:template>



</xsl:stylesheet>











