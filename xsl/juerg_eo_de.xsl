<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:transform
[
  <!ENTITY leftquot '"'>
  <!ENTITY rightquot '"'>
  <!ENTITY stel "*">
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

  <!ENTITY OA_fonto "https://github.com/revuloj/voko-cikado/blob/master/txt/tei2/juerg_eo_de.xml">

]>

<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://saxon.sf.net/"
  version="2.0"
  extension-element-prefixes="saxon" 
>

<!--

XSLT-stildifinoj por ofcaldonoj.xml (La Oficialaj Aldonoj al la UV). 
Ĝi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.

(c) 2023 ĉe Wolfram DIESTEL
    permesilo GPL 2.0

-->

<xsl:import href="teixlite.xsl"/>

<xsl:variable name="stylesheet">juerg_eo_de.css</xsl:variable>
<xsl:variable name="content_level1" select="'part'"/> 
<xsl:variable name="content_level2" select="'letter'"/>


<xsl:template match="docTitle" mode="index">
  <xsl:value-of select="titlePart[@type='main']"/>
</xsl:template>

<!-- teiHeader -->
<xsl:template match="teiHeader">
     <address>
       fonto: <a target="_new" href="&OA_fonto;">ofcaldonoj.xml (ĉe Github)</a>
     </address>
</xsl:template>


<xsl:template name="header">

  <xsl:choose>
 
    <!-- TEXT header -->
    <xsl:when test="self::text">
      <div class="header">
      <!-- navigeblo al antaŭa dokumento -->
      <xsl:for-each select="(preceding-sibling::text[@rend='doc'] | ./div[@id='antparol']) [last()]"> 
        <span class="header_left">
          <a href="{@id}.html">
            <xsl:text>&lt;&lt;&nbsp;</xsl:text>
            <xsl:value-of select="(.//titlePart[@type='main']|head)[1]"/>
          </a>
        </span>
      </xsl:for-each>

      <!-- aktuala dokumento kun navigeblo supren-->
      <span class="header_center">        
        <xsl:text> </xsl:text>
        <a href="index.html">
          <xsl:for-each select="(//front//docAuthor)[1]">
            <xsl:value-of select="."/>:
          </xsl:for-each>
          <xsl:value-of select="(//front//titlePart[@type='main'])[1]"/>
        </a>
      </span>
      </div>
    </xsl:when>

    <!-- DIV header -->
    <xsl:when test="self::div[@type='chapter' or @type='section']">
      <div class="header">

      <!-- navigeblo al la antaŭa ĉapitro -->
      <xsl:for-each select="preceding-sibling::div[@rend='doc'][1]"> 
        <span class="header_left">
          <a href="{@id}.html">
            <xsl:text>&lt;&lt;&nbsp;</xsl:text>
            <xsl:apply-templates select="head" mode="toc"/>
          </a>
        </span>
      </xsl:for-each>

      <span class="header_center">
        <xsl:text> </xsl:text>
        <!-- navigeblo al la enhavanta dokumento (do supren) -->
        <a href="index.html">
          <xsl:value-of select="(//front//titlePart[@type='main'])[1]"/>
        </a>
        &dash;
        <xsl:for-each select="(ancestor::text[@rend='doc'])[1]">
          <a href="{@id}.html">
            <xsl:value-of select=".//titlePart[@type='main'][1]"/>
          </a>
        </xsl:for-each>
      </span>  
      </div>
    </xsl:when>

    <!-- kapo por ĉapitroj de literoj en la vortaro -->
    <xsl:when test="self::div[@type='letter']">
      <div class="uv_header">
      <p align="center">
        <xsl:text> </xsl:text>
        <a href="index.html">
          <xsl:value-of select="(//front[1]//titlePart[@type='main'])[1]"/>
        </a>
        &dash;
        <xsl:for-each select="(ancestor::text[@rend='doc'])[1]">
          <a href="{@id}.html">
            <xsl:value-of select=".//titlePart[@type='main'][1]"/>
          </a>
        </xsl:for-each>
      <br/>

      <xsl:variable name="n" select="@n"/>
        <xsl:for-each select="../div[@type='letter']">
          <xsl:choose>
            <xsl:when test="$n=current()/@n">
              <span class="letter_aktuala"><xsl:value-of select="head"/></span>
            </xsl:when>
            <xsl:otherwise>
              <a href="{@id}.html"><xsl:value-of select="head"/></a>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="not(@n='Z')">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </p>
      </div>
    </xsl:when>

  </xsl:choose>
  <hr/>
</xsl:template>

<xsl:template name="footer">
  <hr/>
  <!-- <xsl:if test="self::div">
    <div class="footnotes">
      <xsl:call-template name="footnotes"/>
    </div>
 </xsl:if> -->

  <div class="footer">
  <xsl:choose>
    <xsl:when test="self::text|self::div[@id='antparol']">
      <xsl:for-each select="following::text[@rend='doc'][1]">
        <a href="{@id}.html">
          <xsl:value-of select=".//titlePart[@type='main'][1]"/>
          <xsl:text>&nbsp;&gt;&gt;</xsl:text>
        </a>
      </xsl:for-each>
    </xsl:when>

    <xsl:when test="self::div[@type='chapter' or @type='section']">
      <xsl:for-each select="following-sibling::div[@rend='doc'][1]">
        <a href="{@id}.html">
          <!-- por ekzercaro skribu §xx -->
          <xsl:if test="ancestor::text[@id='ekz']">
            <xsl:if test="@n">
              <xsl:text>&para; </xsl:text>
              <xsl:value-of select="@n"/>
              <xsl:text>. </xsl:text>            
            </xsl:if>
          </xsl:if>
          <xsl:apply-templates select="head" mode="toc"/>
          <xsl:text>&nbsp;&gt;&gt;</xsl:text>
        </a>
      </xsl:for-each>
    </xsl:when>
  </xsl:choose>

  </div>
</xsl:template>


<xsl:template match="titlePart[@rend='small']">
  <p class="smallTitle">
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="titlePage/byline">
  <span class="author"><xsl:apply-templates/></span><br/>
</xsl:template>

<!-- tabeloj -->

<xsl:template match="table">
  <table align="center" cellspacing="15">
  <xsl:apply-templates/>
  </table>
</xsl:template>


<xsl:template match="cell">
  <td valign="top" align="center">
  <xsl:if test="rows">
    <xsl:attribute name="rowspan"><xsl:value-of select="@rows"/></xsl:attribute>
  </xsl:if>
  <xsl:if test="cols">
    <xsl:attribute name="colspan"><xsl:value-of select="@cols"/></xsl:attribute>
  </xsl:if>
  <xsl:apply-templates/>
  </td>
</xsl:template>


<!-- listoj -->

<xsl:template match="list/head|head[@type='subtitle1']">
  <h4><xsl:apply-templates/></h4>
</xsl:template>


<!-- Transformado de "Vortaraj listoj" -->

<xsl:template match="list[@type='dict']">
  <div class="dict">
  <xsl:apply-templates select="item"/>
  </div>
</xsl:template>

<!-- antaŭ ĉiu "item" povas aperi "label" kun la kapvorto -->
<xsl:template match="list[@type='dict']/label">  
  <strong>  <!-- id="{generate-id()}" -->
    <xsl:attribute name="id">
      <xsl:call-template name="inx-id"/>
    </xsl:attribute>
    <!-- ĉar <note> ne estas permesita en <label> ni uzas @rend
      ekz-e por marki per steleto -->
    <xsl:value-of select="@rend"/>
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
  </strong>
</xsl:template>

<xsl:template name="inx-id">
  <xsl:value-of select="ancestor::node()[@id][1]/@id"/>
  <xsl:text>_n</xsl:text>
  <xsl:number level="any" from="div[@id]|list[@id]" count="label|item|emph|hi|index"/>
</xsl:template>


<xsl:template match="ref">
  <xsl:variable name="file" select="//div[@type='letter' and .//label[@id=current()/@target]]/@id"/>
  <strong>
    <a href="{$file}.html#{@target}">
      <xsl:apply-templates/>
    </a>
  </strong>
</xsl:template>  

<!-- strukturita enhavo de vortlistero vorto + difino + derivaĵoj -->

<xsl:template match="list[@type='dict']/item">
  <p class="dict-entry">
  <xsl:if test="preceding-sibling::label[1]/@id">
    <xsl:attribute name="id">
      <xsl:value-of select="preceding-sibling::label[1]/@id"/>
    </xsl:attribute>
  </xsl:if>
  <xsl:apply-templates select="preceding-sibling::label[1]"/>
  <xsl:apply-templates/>
  <xsl:text>. </xsl:text>
  </p>
</xsl:template>


<!-- reguloj por derivaĵoj enŝovitaj sub la ĉefaj kapvortoj -->

<xsl:template match="list[@type='deriv']">
  <xsl:apply-templates select="item"/>
</xsl:template>

<xsl:template match="list[@type='deriv']/label">
  <strong> <!-- id="{generate-id()}" -->
    <xsl:attribute name="id">
      <xsl:call-template name="inx-id"/>
    </xsl:attribute>
  <xsl:apply-templates/>
  <xsl:text> </xsl:text>
  </strong>
</xsl:template>

<xsl:template match="list[@type='deriv']/item">
  <span class="dict-subentry">
  <xsl:if test="preceding-sibling::label[1]/@id">
    <xsl:attribute name="id">
      <xsl:value-of select="preceding-sibling::label[1]/@id"/>
    </xsl:attribute>
  </xsl:if>  
  <xsl:apply-templates select="preceding-sibling::label[1]"/>
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::label">
    <xsl:text>; </xsl:text>
  </xsl:if>
  </span>
</xsl:template>


</xsl:transform>
