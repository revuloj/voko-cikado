<!DOCTYPE xsl:stylesheet 
[
  <!ENTITY Ccirc  "&#x0108;">
  <!ENTITY dash "&#x2015;">
  <!ENTITY leftquot '"'>
  <!ENTITY rightquot '"'>
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
		version="1.0"
                extension-element-prefixes="xt">

<!--

XSLT-stildifinoj por fumejo.xml (La fumejo de l'opio). 
Ĝi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne aŭ alie difinitajn tie.

(c) 2017-2018 ĉe Wolfram DIESTEL
    licenco GPL 2.0

-->


<xsl:import href="teixlite.xsl"/>

<xsl:variable name="titolbildo">../bld/fumejo/fumejo_ant.jpg</xsl:variable>
<xsl:variable name="fonbildo">../bld/fumejo/fumejo_fon.jpg</xsl:variable>

<xsl:template name="titolbildo">
  <xsl:if test="not(ancestor::group)">
    <p class="titolbildo">
    <img align="center" src="{$titolbildo}"/>
    </p>
  </xsl:if>
</xsl:template>

<xsl:template name="fonbildo">
  <xsl:if test="not(ancestor::group)">
    <p class="center">
    <img class="center" src="{$fonbildo}"/>
    </p>
  </xsl:if>
</xsl:template>

<xsl:template match="p[@rend='fonbildo']">
  <xsl:call-template name="fonbildo"/>
</xsl:template>

<xsl:template match="note">
  [<i><xsl:apply-templates/></i>]
</xsl:template>



</xsl:stylesheet>











