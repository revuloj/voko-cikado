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

<xsl:variable name="content_level1" select="'part'"/>
<xsl:variable name="content_level2" select="'subchapter'"/>

</xsl:stylesheet>