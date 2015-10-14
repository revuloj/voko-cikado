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

XSLT-stildifinoj por fabeloj*.tei (Fabeloj de H.C. Andersen). 
Ghi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.

(c) 2001 che Wolfram DIESTEL
    licenco GPL 2.0

-->

<xsl:import href="teixlite.xsl"/>

<xsl:template match="q[@who]">
  <i><xsl:value-of select="@who"/>. </i>
  <xsl:text>&dash; </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="note">
  [<i><xsl:apply-templates/></i>]
</xsl:template>


</xsl:stylesheet>











