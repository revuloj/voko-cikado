<!DOCTYPE xsl:stylesheet 
[
  <!ENTITY Ccirc  "&#x0108;">
  <!ENTITY dash "&#x2015;">
  <!ENTITY leftquot '&#x201e;'>
  <!ENTITY rightquot '&#x201c;'>
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
		version="1.0"
                extension-element-prefixes="xt">

<!--

XSLT-stildifinoj por interrompitax.ml (La interrompita kanto). 
Ĝi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne aŭ alie difinitajn tie.

(c) 2017 che Wolfram DIESTEL
    licenco GPL 2.0

-->

<xsl:import href="teixlite.xsl"/>

<xsl:template match="note">
  [<i><xsl:apply-templates/></i>]
</xsl:template>


</xsl:stylesheet>











