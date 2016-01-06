<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet
[
  <!ENTITY leftquot '"'>
  <!ENTITY rightquot '"'>
  <!ENTITY para "&#x00a7;">
  <!ENTITY dash "&#x2015;">
  <!ENTITY nbsp "&#x00a0;">
 
  <!ENTITY Ccirc "&#x0108;">
  <!ENTITY ccirc "&#x0109;">
  <!ENTITY Gcirc "&#x011c;">
  <!ENTITY gcirc "&#x011d;">
  <!ENTITY Hcirc "&#x0124;">
  <!ENTITY hcirc "&#x0125;">
  <!ENTITY Jcirc "&#x0134;">
  <!ENTITY jcirc "&#x0135;">
  <!ENTITY Scirc "&#x015c;">
  <!ENTITY scirc "&#x015d;">
  <!ENTITY Ubreve "&#x016c;">
  <!ENTITY ubreve "&#x016d;">

  <!ENTITY circ "^">
  <!ENTITY breve "&#x02d8;">

]>

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xt="http://www.jclark.com/xt"
  xmlns="http://www.w3.org/1999/xhtml"
  version="1.0"
  extension-element-prefixes="xt">

<!--

XSLT-stildifinoj por fundamento.xml (La Fundamento de Eo). 
Ghi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.

(c) 2001 che Wolfram DIESTEL
    licenco GPL 2.0

-->

<xsl:import href="teixlite_epub.xsl"/>

<xsl:variable name="stylesheet">fundamento_epub.css</xsl:variable>
<xsl:variable name="content_level1" select="'part'"/>
<xsl:variable name="content_level2" select="'chapter'"/>

<xsl:template match="/TEI.2/text/front">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="docTitle" mode="index">
  <xsl:value-of select="titlePart[@type='main']"/>
</xsl:template>

<xsl:template match="titlePart[@rend='small']">
  <h2 class="smallTitle">
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<xsl:template match="titlePart">
  <h2 class="titlePart">
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<xsl:template match="titlePart[@type='number']">
  <h1 class="titlePart_number">
    <xsl:apply-templates/>
  </h1>
</xsl:template>

<xsl:template match="titlePart[@type='main']">
  <h1 class="mainTitle"><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="div[@type='chapter']/head">
  <h2 class="head"><xsl:apply-templates/></h2>
</xsl:template>

<!-- gramatikoj -->

<xsl:template match="text[@id='gra']/body">
  <!--  <hr/>
  <div class="center">
    <xsl:apply-templates select="head"/>
  </div>
  <hr/> -->
  <xsl:apply-templates select="div"/>
</xsl:template>

<!-- metu duan titolon komence de la franca gramatiko -->
<xsl:template match="div[@id='gra_fr']/head">
  <div class="center">
    <xsl:apply-templates select="../../head"/>
  </div>
  <hr/> 
  <h2 class="head">
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<!-- ekzercojn ne metu en proprajn dosierojn -->

<xsl:template match="text[@id='ekz']/body"> 
  <xt:document method="xhtml" 
    version="1.1" 
    encoding="utf-8" 	
    doctype-public="-//W3C//DTD XHTML 1.1//EN"
    doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
    href="{div[1]/@id}.xhtml">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <link title="stilo" type="text/css" rel="stylesheet"
          href="css/{$stylesheet}" />
          <title>
          <xsl:call-template name="title-string"/>
        </title>
      </head>
      <body>
        <div class="center">
          <xsl:apply-templates select="head"/>
        </div>
        <hr/>
        <xsl:apply-templates select="div"/>
      </body>
    </html>
  </xt:document>
</xsl:template>

<xsl:template match="text[@id='ekz']//div[@type='section']">
  <div id="{@id}">
    <h2>
      <xsl:text>&para; </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>.</xsl:text>
    </h2>
    <xsl:apply-templates/>
  </div>
</xsl:template>


<!-- litersekciojn de UV en proprajn dosierojn -->

<xsl:template match="text[@id='univort']/body">
  <!--  <p class="center">
    <xsl:for-each select="div[@type='letter']">
      <a href="uv_{@n}.xhtml"><xsl:value-of select="head"/></a>
      <xsl:if test="not(@n='Z')">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </p> 
  <hr/> -->
  <xsl:apply-templates select="div[@type='section']"/>
  <xsl:apply-templates select="div[@type='letter']"/>	
</xsl:template>

<xsl:template match="text[@id='univort']/body/div[@type='section']/p">
  <p class="first_p">
  <xsl:apply-templates/>
  </p>
  <hr/>
</xsl:template>

<xsl:template match="text[@id='univort']//div[@type='letter']">
  <xt:document method="xhtml" 
    version="1.1" 
    encoding="utf-8" 	
    doctype-public="-//W3C//DTD XHTML 1.1//EN"
    doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
    href="uv_{@n}.xhtml">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <link title="stilo" type="text/css" rel="stylesheet"
          href="css/{$stylesheet}" />
        <title>
          <xsl:call-template name="title-string"/>
        </title>
      </head>
      <body>
        <!-- xsl:call-template name="header"/ -->
        <xsl:apply-templates/>
        <!-- xsl:call-template name="footer"/ -->
      </body>
    </html>
  </xt:document>
</xsl:template>


<!-- tabeloj -->

<xsl:template match="p[table]">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="table">
  <!-- reordigu la alfabeto-tabelojn tiel, ke kvar cheloj estas sur unu linio -->
  <table class="center" cellspacing="15">
    <xsl:for-each select="descendant::cell[position() mod 4 = 1]">
      <tr>
        <!-- self -->
        <td valign="top" class="center">
          <xsl:apply-templates/>
        </td>
        <!-- kaj tri sekvaj -->
        <xsl:for-each select="following::cell[position() &lt; 4]">
          <td valign="top" class="center">
            <xsl:apply-templates/>
          </td>
        </xsl:for-each> 
      </tr> 
    </xsl:for-each>
  </table>
</xsl:template>

<xsl:template match="hi[@rend='big']">
  <strong class="big">
  <xsl:apply-templates/>
  </strong>
</xsl:template>

<xsl:template match="hi[@rend='handwritten']">
  <em class="handwritten">
  <xsl:apply-templates/>
  </em>
</xsl:template>

<!-- listoj -->

<xsl:template match="list">
  <xsl:choose>
    <xsl:when test="@rend='1.'">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:when test="@rend='a)'">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <ul>
        <xsl:apply-templates/>
      </ul>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="list[@rend='1.']/item[@n]">
  <div>
  <strong><xsl:value-of select="@n"/>. </strong>
  <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="list[@rend='a)']/item[@n]">
  <div>
  <xsl:value-of select="@n"/>)
  <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="div[@id='antparol']/list[@rend='1)']">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="list[@rend='1)']/item[@n]">
  <p class="p">
  <xsl:value-of select="@n"/>) 
  <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="div[@id='antparol']/list/item/p">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div[@id='antparol']/list[@rend='1.']/item[@n]">
  <p class="p">
  <xsl:value-of select="@n"/>. 
  <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="note[@rend='footnote']">
  <span class="note"> (<xsl:apply-templates/>)</span>
</xsl:template>

<xsl:template match="list/head">
  <h4><xsl:apply-templates/></h4>
</xsl:template>


<!-- Transformado de "Universala Vortaro" -->

<!--
<xsl:template match="div[@type='letter']/head">
  <h3 class="head" style="page-break-before: always"><xsl:apply-templates/></h3>
</xsl:template>
-->

<xsl:template match="list[@type='dict']">
  <div class="dict">
  <xsl:apply-templates select="item"/>
  </div>
</xsl:template>

<xsl:template match="list[@type='dict']/label">
  <strong>
  <!-- a id="{generate-id()}"/ -->
  <xsl:apply-templates/>
  </strong>
</xsl:template>

<xsl:template match="emph[@lang='eo']">
  <em>
  <!-- a id="{generate-id()}"/ -->
  <xsl:apply-templates/>
  </em>
</xsl:template>

<xsl:template match="hi[@lang='eo']">
  <strong>
  <!-- a id="{generate-id()}"/ -->
  <xsl:apply-templates/>
  </strong>
</xsl:template>

<xsl:template match="list[@type='dict']/item">
  <p class="dict-entry">
  <xsl:apply-templates select="preceding-sibling::label[1]"/>
  <xsl:apply-templates select="list[@type='def']"/>
  </p>
  <xsl:apply-templates select="list[@type='deriv']"/>
</xsl:template>

<xsl:template match="list[@type='deriv']">
  <xsl:apply-templates select="item"/>
</xsl:template>

<xsl:template match="list[@type='deriv']/label">
  <strong>
  <xsl:apply-templates/>
  </strong>
</xsl:template>

<xsl:template match="list[@type='deriv']/item">
  <p class="dict-subentry">
  <xsl:apply-templates select="preceding-sibling::label[1]"/>
  <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="list[@type='def']">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="list[@type='def']/item">
  <xsl:choose>
    <xsl:when test="position()=last()-1">
      <xsl:apply-templates/><xsl:text>. </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/><xsl:text> | </xsl:text>	
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>














