<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
                version="1.0"
                extension-element-prefixes="xt">
 
<!--
 
XSLT-stildifinoj por merkato.xsl (Enkonduko en la Socialan Merkatekonomion).
Ghi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.
 
(c) 2001 che Wolfram DIESTEL
    licenco GPL 2.0
 
-->


<!-- metu subchapitrojn en la indekson, sed ne faru apartan
     dosieron por ili -->


<xsl:import href="teixlite.xsl"/>

<xsl:variable name="content_level1" select="'chapter'"/>
<xsl:variable name="content_level2" select="'subchapter'"/>


<!-- aspekto de la subchapitroj -->

<xsl:template match="div[@type='subchapter']/head">
  <h4 class="subhead"><xsl:apply-templates/></h4>
</xsl:template>

<xsl:template match="div[@type='subchapter']/head" mode="index">
  <span class="toc-subhead"><xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="docImprint"/>

</xsl:stylesheet> 







