<!DOCTYPE xsl:stylesheet
[
  <!ENTITY leftquot '"'>
  <!ENTITY rightquot '"'>
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
                xmlns="http://www.w3.org/1999/xhtml"
		version="1.0"
                extension-element-prefixes="xt">

<!--

XSLT-stildifinoj por senchesa.xml (La Senchesa Rakonto). 
Ghi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.

(c) 2001 che Wolfram DIESTEL
    licenco GPL 2.0

-->

<xsl:import href="teixlite_epub.xsl"/>
<xsl:variable name="stylesheet">senchesa_epub.css</xsl:variable>

<!-- ellasu la antuainformojn en la elcherpajho kaj
anstataue metu nur titolbildon -->

<xsl:template match="/">
  <html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <style type="text/css" title="override_css">
    @page { padding: 0pt; margin:0pt }
    body { text-align: center; padding:0pt; margin: 0pt; }
    div { margin: 0pt; padding: 0pt; }
    .titolbildo { width: 100%; }
  </style>
  <title><xsl:value-of select="//titleStmt/title"/></title>
  </head>
  <body>
    <xsl:apply-templates/>
  </body>
  </html>
</xsl:template>

<xsl:template match="front">
  <div id="cover-image">
    <img src="img/titolo.jpg" alt="{//titleStmt/title}" class="titolbildo"/>   
  </div>
</xsl:template>

<xsl:template match="titlePart[@type='main']/lb">
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="titlePage">
  <div class="center"><xsl:apply-templates/></div>
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

<!--enmetu nur la chapitrokomencojn -->
<xsl:template match="div[@type='chapter' and position() &gt; 3]/div[position() &gt; 1]">
  <div class='{@rend}'>
    <p class="center"><xsl:text>[...]</xsl:text></p>
  </div>
</xsl:template>

<xsl:template match="div[@type='chapter']/head">
  <h2 class='head'>
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<xsl:template match="figure[@rend='initial']">
  <img src="img/{
       substring-before(
              substring-after(
		unparsed-entity-uri(@entity),'senchesa/'),'.')
		}.gif" alt="{figDesc}" class="initialo"/>
</xsl:template>

<xsl:template match="figure[@rend='initial' and (@entity='Gx' 
                     or @entity='Jx' or @entity='Sx' or @entity='Cx' or @entity='Z')]">
  <img src="img/{
       substring-before(
              substring-after(
		unparsed-entity-uri(@entity),'senchesa/'),'.')
		}.gif" alt="{figDesc}" class="initialo_{@entity}"/>
</xsl:template>

<xsl:template match="figure">
  <img class="sxildo" src="img/{
       substring-before(
              substring-after(
		unparsed-entity-uri(@entity),'senchesa/'),'.')
		}.gif" alt="{figDesc}"/>
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
  <div class="lg_center"><xsl:apply-templates/></div>
</xsl:template>

</xsl:stylesheet>











