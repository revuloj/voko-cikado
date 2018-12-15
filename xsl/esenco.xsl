<!DOCTYPE xsl:stylesheet 
[
<!ENTITY nbsp "&#x00a0;">
]>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
                version="1.0"
                extension-element-prefixes="xt">

<!--

XSLT-stildifinoj por esenco.xml (Esenco kaj estonteco de Zamenhof). 
Ghi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.

(c) 2002 che Wolfram DIESTEL
    permesilo GPL 2.0

-->

<xsl:import href="teixlite.xsl"/>

<xsl:variable name="content_level1" select="'part'"/>
<xsl:variable name="content_level2" select="'subchapter'"/>

<xsl:template match="list[@type='inline']">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="list[@type='inline']/item">
  <xsl:text>(</xsl:text>
  <xsl:value-of select="@n"/>
  <xsl:text>)&nbsp;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
