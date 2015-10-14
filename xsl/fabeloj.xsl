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

<xsl:variable name="content_level1" select="'story'"/>

<xsl:template match="title[@type='head']">
  <h4><xsl:apply-templates/></h4>
</xsl:template>

</xsl:stylesheet>











