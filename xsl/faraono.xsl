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
<xsl:variable name="content_level2" select="'subchapter'"/>

<xsl:template match="q[@who]">
  <i><xsl:value-of select="@who"/>. </i>
  <xsl:text>&dash; </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="note">
  [<i><xsl:apply-templates/></i>]
</xsl:template>


</xsl:transform>











