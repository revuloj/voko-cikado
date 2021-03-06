<!DOCTYPE xsl:transform 
[
  <!ENTITY Ccirc  "&#x0108;">
  <!ENTITY dash "&#x2015;">
  <!ENTITY leftquot '"'>
  <!ENTITY rightquot '"'>
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

<!--
<xsl:template match="note">
  [<i><xsl:apply-templates/></i>]
</xsl:template>
-->

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
    <sup>&#x2193;<xsl:number from="div[@rend='doc']" level="any"/></sup>
  </a>
  <xsl:text>)</xsl:text>
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
      <sup>&#x2191;<xsl:number from="div[@rend='doc']"  level="any"/></sup>
    </a>
    <xsl:text>) </xsl:text>
    <xsl:apply-templates/>
    </p>
  </xsl:for-each>
</xsl:template>

<xsl:template name="footnote-id">
  <xsl:value-of select="ancestor::div[@rend='doc']/@id"/>
  <xsl:text>_</xsl:text>
  <xsl:number from="div[@rend='doc']"  level="any"/>
</xsl:template>

<xsl:template match="note[@type='footnote']/label">
  &dash; <i><xsl:value-of select="."/></i>
</xsl:template>

</xsl:transform>











