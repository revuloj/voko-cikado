<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
		version="1.0"
                extension-element-prefixes="xt">

<!--

XSLT-stildifinoj por marta.xml (Marta de E. Orzeszko). 
Ghi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.

(c) 2002 che Wolfram DIESTEL
    permesilo GPL 2.0

-->

<xsl:import href="teixlite.xsl"/>
<xsl:variable name="content_level1" select="'part'"/>
<xsl:variable name="content_level2" select="'subchapter'"/>

<xsl:template match="div[@type='foreword']">
  <xsl:apply-templates/>
  <p align="center">*<br/>* *</p>
</xsl:template>

</xsl:stylesheet>











