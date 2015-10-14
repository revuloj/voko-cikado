<!DOCTYPE xsl:stylesheet>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
		version="1.0"
                extension-element-prefixes="xt">

<!--

XSLT-stildifinoj por proverb.xml (Proverbaro Esperanta). 
Ghi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.

(c) 2001 che Wolfram DIESTEL
    licenco GPL 2.0

-->

<xsl:import href="teixlite.xsl"/>

<xsl:variable name="stylesheet">proverb.css</xsl:variable>

<!-- faru propran alineon por chiu proverbo -->

<xsl:template match="lg[@rend='left']">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="l">
  <p class="l"><xsl:apply-templates/></p>
</xsl:template>

</xsl:stylesheet>











