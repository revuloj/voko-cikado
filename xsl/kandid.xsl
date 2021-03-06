<!DOCTYPE xsl:transform 
[
  <!ENTITY dash "&#x2015;">
  <!ENTITY leftquot '«'>
  <!ENTITY rightquot '»'>
]>

<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://saxon.sf.net/"
  version="2.0"
  extension-element-prefixes="saxon" 
>

<!--

XSLT-stildifinoj por faraono*.xml (La Faraono). 
Ĝi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne aŭ alie difinitajn tie.

(c) 2001 che Wolfram DIESTEL
    licenco GPL 2.0

-->

<xsl:import href="teixlite.xsl"/>

<xsl:variable name="content_level1" select="'chapter'"/>
<xsl:variable name="content_level2" select="''"/>

<xsl:variable name="titolbildo">../bld/kandid/titolo.jpg</xsl:variable>
<xsl:variable name="ilustro">../bld/kandid/ilustro.png</xsl:variable>


<xsl:template match="titlePart[@type='main']">
  <h1 class="head mainTitle"><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="titlePart[@type='small']">
  <h2 class="head"><xsl:apply-templates/></h2>
</xsl:template>

<xsl:template match="titlePart[@type='subtitle']">
  <h2 class="head"><xsl:apply-templates/></h2>
</xsl:template>

<xsl:template match="docImprint">
  <img align="center" src="{$ilustro}"/>
  <p class="docImprint"><cite><xsl:apply-templates/></cite></p>
</xsl:template>
<xsl:template match="docImprint/date"/> <!-- jam en la ilustro -->

<!--
<xsl:template match="dif[@type='title']/epigraph">
  <div class="title epigraph">
  <xsl:apply-templates/>
  </div>
</xsl:template>
-->

<xsl:template match="div[@id='A']//hi">
  <em><xsl:apply-templates/></em>
</xsl:template>

<xsl:template match="p//name">
  <em><xsl:apply-templates/></em>
</xsl:template>

<xsl:template match="q[@rend='letter']">
  <em class="letter"><xsl:apply-templates/></em>
</xsl:template>

<xsl:template match="q[@rend='«»']">
    <xsl:text>&leftquot;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&rightquot;</xsl:text>
</xsl:template>

<xsl:template match="q[@rend='« ']">
    <xsl:text>&leftquot;</xsl:text>
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="q[@rend='-«']">
    <xsl:text>&dash; &leftquot;</xsl:text>
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="figure">
  <p align='center'>
  <img src="../bld/{substring-after(unparsed-entity-uri(@entity),'/bld/')}" 
    alt="{@entity}" width="600" vspace="20"/><br/>
  <xsl:apply-templates select="figDesc/*"/>
  </p>
</xsl:template>

<!-- montru piednotojn ne ene, sed fine de dokumento (div) -->
<xsl:template match="note[@type='footnote']">
  <xsl:text>(</xsl:text>
  <a>
    <xsl:attribute name="id">
      <xsl:text>fn_</xsl:text>
      <xsl:call-template name="footnote-id"/>
    </xsl:attribute>
    <xsl:attribute name="href">
      <xsl:text>#</xsl:text>
      <xsl:call-template name="footnote-id"/>
    </xsl:attribute>
    <sup>&#x2193;<xsl:number from="div" level="any"/></sup>
  </a>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="div[@type='title']">
  <div class="title">
    <p class="titolbildo">
      <img width="600" align="center" src="{$titolbildo}"/>
    </p>
    <xsl:apply-templates/>
  </div>
  <div class="footnotes">
    <xsl:call-template name="footnotes"/>
  </div>
</xsl:template>

<xsl:template name="footnotes">
  <xsl:for-each select=".//note[@type='footnote']">
    <p>
      <xsl:attribute name="id">
        <xsl:call-template name="footnote-id"/>
      </xsl:attribute>
    <xsl:text>(</xsl:text>
    <a>
      <xsl:attribute name="href">
        <xsl:text>#fn_</xsl:text>
        <xsl:call-template name="footnote-id"/>
      </xsl:attribute>
      <sup>&#x2191;<xsl:number from="div"  level="any"/></sup>
    </a>
    <xsl:text>) </xsl:text>
    <xsl:apply-templates/>
    </p>
  </xsl:for-each>
</xsl:template>

<xsl:template name="footnote-id">
  <xsl:value-of select="ancestor::div/@id"/>
  <xsl:text>_</xsl:text>
  <xsl:number from="div"  level="any"/>
</xsl:template>

<xsl:template match="note[@type='footnote']/label">
  &dash; <i><xsl:value-of select="."/></i>
</xsl:template>

</xsl:transform>











