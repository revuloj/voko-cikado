<!DOCTYPE xsl:stylesheet
[
  <!ENTITY leftquot '"'>
  <!ENTITY rightquot '"'>
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
		version="1.0"
                extension-element-prefixes="xt">

<!--

XSLT-stildifinoj por senchesa.xml (La Senchesa Rakonto). 
Ghi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.

(c) 2001 che Wolfram DIESTEL
    licenco GPL 2.0

-->

<xsl:import href="teixlite.xsl"/>
<xsl:variable name="stylesheet">senchesa.css</xsl:variable>

<xsl:template match="titlePart[@type='main']/lb">
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="titlePage">
  <center><xsl:apply-templates/></center>
  <hr/>
</xsl:template>

<xsl:template match="div[@type='color']">
  <xsl:choose>
    <xsl:when test="@rend='maroon'">
      <div class="maroon">
        <xsl:apply-templates/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <div class="teal">
        <xsl:apply-templates/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="figure[@rend='initial']">
  <img src="img/{
       substring-before(
              substring-after(
		unparsed-entity-uri(@entity),'senchesa/'),'.')
		}.gif" alt="{figDesc}" align="left"/>
</xsl:template>

<xsl:template match="figure">
  <center>
  <img src="img/{
       substring-before(
              substring-after(
		unparsed-entity-uri(@entity),'senchesa/'),'.')
		}.gif" alt="{figDesc}" vspace="20"/>
  </center>
</xsl:template>

<xsl:template match="hi[@rend='big']">
  <strong class="big">
  <xsl:apply-templates/>
  </strong>
</xsl:template>

<xsl:template match="lg">
  <p class="lg_left"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="lg[@rend='center']">
  <center class="lg_center"><xsl:apply-templates/></center>
</xsl:template>

</xsl:stylesheet>











