<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:transform
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

  <!ENTITY FE_fonto "https://github.com/revuloj/voko-cikado/blob/master/txt/tei2/fundamento.xml">

]>

<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://saxon.sf.net/"
  version="2.0"
  extension-element-prefixes="saxon" 
>

<!--

XSLT-stildifinoj por fundamento.xml (La Fundamento de Eo). 
Ĝi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.

(c) 2001-2022 che Wolfram DIESTEL
    permesilo GPL 2.0

-->

<xsl:import href="teixlite.xsl"/>

<xsl:variable name="stylesheet">fundamento.css</xsl:variable>
<xsl:variable name="content_level1" select="'part'"/>
<xsl:variable name="content_level2" select="'chapter'"/>

<!-- ĵeto de komencliteroj al indeksĉapitroj -->
<xsl:variable name="map_from" select="'abc&ccirc;defg&gcirc;h&hcirc;ij&jcirc;klmnoprs&scirc;tu&ubreve;vz&circ;&breve;-&Ccirc;&Gcirc;&Hcirc;&Jcirc;&Scirc;&Ubreve;'"/>
<xsl:variable name="map_to" select="'ABCCDEFGGHHIJJKLMNOPRSSTUUVZXXXCFHJSU'"/>


<xsl:template match="/TEI.2/text/front">
  <xsl:apply-templates/>
  <hr/>
  
  <!-- enmetu enhavtabelon -->
  <xsl:for-each select="..">
    <xsl:call-template name="table-of-content">
      <xsl:with-param name="level1" select="$content_level1"/>
      <xsl:with-param name="level2" select="$content_level2"/>
    </xsl:call-template>
  </xsl:for-each>

  <ul class="content">
    <li class="content">esperanta indekso &dash; &gcirc;i ne apartenas
      al la Fundamento, sed faciligas trovi ion en &gcirc;i:<br/>
      <xsl:for-each select="/">
        <xsl:call-template name="wordindex"/>
      </xsl:for-each>
    </li>
  </ul>
  <hr/>

</xsl:template>

<xsl:template name="table-of-content">
  <xsl:param name="level1"/>
  <xsl:param name="level2"/>

  <h3 class="contentTitle">Enhavo</h3>
  <ul class="content">
  <xsl:for-each select=".//div[@type=$level1]|.//text[@rend='doc']">

    <xsl:variable name="ref">
      <xsl:choose>
        <xsl:when test="@rend='doc'">
          <xsl:value-of select="@id"/>
          <xsl:text>.html</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>#</xsl:text>
          <xsl:value-of select="@id"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="refstr">
      <xsl:choose>
        <xsl:when test="self::text">
          <xsl:apply-templates select=".//docTitle" mode="index"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select=".//head[1]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <li class="content">
      <a href="{$ref}">
        <xsl:value-of select="$refstr"/>  
      </a>
      <xsl:if test="($level2!='') and (.//div[@type=$level2])">
        <ul>
          <xsl:for-each select=".//div[@type=$level2]">
<!--            <xsl:variable name="ref">
              <xsl:choose>
                <xsl:when test="ancestor::node()[@rend='doc']">
                  <xsl:value-of select="ancestor::node()[@rend='doc']/@id"/>
                  <xsl:text>.html#</xsl:text>
                  <xsl:value-of select="@id"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>#</xsl:text>
                  <xsl:value-of select="@id"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
-->
   <xsl:variable name="ref">
      <xsl:choose>
        <xsl:when test="@rend='doc'">
          <xsl:value-of select="@id"/>
          <xsl:text>.html</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>#</xsl:text>
          <xsl:value-of select="@id"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

            <li class="subcontent">
              <a href="{$ref}">
                <xsl:apply-templates select="./head[1]" mode="toc"/>
              </a>
            </li>
          </xsl:for-each>
        </ul>
      </xsl:if>
    </li>
  </xsl:for-each>
  </ul>
</xsl:template>

<xsl:template match="docTitle" mode="index">
  <xsl:value-of select="titlePart[@type='main']"/>
</xsl:template>

<!-- teiHeader -->
<xsl:template match="teiHeader">
     <address>
       fonto: <a target="_new" href="&FE_fonto;">fundamento.xml (ĉe Github)</a>
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
            <!-- por ekzercaro skribu §xx -->
            <xsl:if test="ancestor::text[@id='ekz']">
              <xsl:if test="@n">
                <xsl:text>&para; </xsl:text>
                <xsl:value-of select="@n"/>
                <xsl:text>. </xsl:text>            
              </xsl:if>
            </xsl:if>
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

    <!-- kapo por ĉapitroj de literoj en UV -->
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
              <a href="uv_{@n}.html"><xsl:value-of select="head"/></a>
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
  <xsl:if test="self::div">
    <div class="footnotes">
      <xsl:call-template name="footnotes"/>
    </div>
  </xsl:if>

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


<!-- gramatikojn metu en proprajn dosierojn -->

<xsl:template match="text[@id='gra']/body">
  <center>
    <xsl:apply-templates select="head"/>
  </center>
  <hr/>
  <!-- enhavtabelo por la kvin gramatikoj -->
  <ul>
    <xsl:for-each select="./div[@type='chapter']">
      <li class="content"><a href="{@id}.html">
        <xsl:value-of select="head"/>
      </a></li>
    </xsl:for-each>
  </ul>
  <xsl:apply-templates select="div"/>
</xsl:template>

<!-- ekzercojn metu en proprajn dosierojn -->

<xsl:template match="text[@id='ekz']/body"> 
  <center>
    <xsl:apply-templates select="head"/>
  </center>
  <hr/>
  <p align="center">
    <xsl:for-each select="./div[@type='section']">
      <a href="ekz_{@n}.html">&para; <xsl:value-of select="@n"/></a>
      <xsl:text>, </xsl:text>
    </xsl:for-each>
  </p>
  <xsl:apply-templates select="div"/>
</xsl:template>

<xsl:template match="text[@id='ekz']//div[@type='section']">
  <xsl:result-document method="html" href="ekz_{@n}.html">	
  <html>
   <head>
     <link title="stilo" type="text/css" rel="stylesheet"
     href="../css/{$stylesheet}" />
     <title>ekzercaro &para; <xsl:value-of select="@n"/>.</title>
   </head>
   <body background="../bld/papero.jpg">
     <xsl:call-template name="header"/>
     <h1>
      <xsl:text>&para; </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>.</xsl:text>
     </h1>
     <xsl:apply-templates/>
     <xsl:call-template name="footer"/>
   </body>
  </html>
  </xsl:result-document>
</xsl:template>


<!-- litersekciojn de UV en proprajn dosierojn -->

<xsl:template match="text[@id='univort']/body">
  <p align="center">
    <xsl:for-each select="./div[@type='letter']">
      <a href="uv_{@n}.html"><xsl:value-of select="head"/></a>
      <xsl:if test="not(@n='Z')">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </p>
  <hr/>
  <xsl:apply-templates select="./div[@type='section']"/>
  <xsl:apply-templates select="./div[@type='letter']"/>	
</xsl:template>

<xsl:template match="text[@id='univort']/body/div[@type='section']/p">
  <p class="first_p">
  <xsl:apply-templates/>
  </p>
  <hr/>
</xsl:template>

<xsl:template match="text[@id='univort']//div[@type='letter']">
  <xsl:result-document method="html" href="uv_{@n}.html">	
  <html>
   <head>
     <link title="stilo" type="text/css" rel="stylesheet"
     href="../css/{$stylesheet}" />
     <title>universala vortaro <xsl:value-of select="@n"/></title>
   </head>
   <body background="../bld/papero.jpg">
     <xsl:call-template name="header"/>
     <xsl:apply-templates/>
     <xsl:call-template name="footer"/>
   </body>
  </html>
  </xsl:result-document>
</xsl:template>


<!-- akademiajn korektojn po lingvo metu en propran dosieron -->

<xsl:template match="text[@id='akkor']/body">
  <center>
    <xsl:apply-templates select="head"/>
  </center>
  <!-- enhavtabelo por la kvin lingvoj de korekto -->
  <ul>
    <xsl:for-each select="./div[@type='chapter']">
      <li class="content"><a href="{@id}.html">
        <xsl:apply-templates select="head" mode="toc"/>
      </a></li>
    </xsl:for-each>
  </ul>
  <hr/>
  <xsl:apply-templates select="div"/>
  <xsl:for-each select="div[@type='prolog']">
    <xsl:call-template name="footer"/>
  </xsl:for-each>
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
  <p>
  <strong><xsl:value-of select="@n"/>. </strong>
  <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="list[@rend='a)']/item[@n]">
  <p>
  <xsl:value-of select="@n"/>)
  <xsl:apply-templates/>
  </p>
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

<xsl:template match="div[@id='antparol']/list[@rend='1.']/item[@n]" priority="1">
  <p class="p">
  <xsl:value-of select="@n"/>. 
  <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="address[@rend='right']">
  <p class="right">
  <xsl:apply-templates/>
  </p>
</xsl:template>
<!--
<xsl:template match="note[@rend='footnote']">
  <span class="note">(<xsl:apply-templates/>)</span>
</xsl:template>
-->

<!-- ne montru kapnotojn en la enhav-tabelo! -->
<xsl:template match="head/note" mode="toc"/>

<xsl:template match="index">
  <span>
    <xsl:attribute name="id">
      <xsl:call-template name="inx-id"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </span>
  <!-- [<xsl:value-of select="@level1"/>] -->
</xsl:template>


<!-- montru piednotojn ne ene, sed fine de dokumento (div) -->
<xsl:template match="note[(@rend='footnote') or (@rend='footnoteref')]">
  <xsl:text>(</xsl:text>
  <a>
    <xsl:attribute name="id">
      <xsl:text>fn_</xsl:text>
      <xsl:call-template name="footnote-id"/>
    </xsl:attribute>
    <xsl:attribute name="href">
      <xsl:text>#</xsl:text>
      <xsl:call-template name="footnote-id"/>
    </xsl:attribute>
    <xsl:text>&#x2193;</xsl:text><xsl:call-template name="footnote-id"/>
  </a>
  <xsl:text>)</xsl:text>
</xsl:template>


<xsl:template name="footnotes">
  <xsl:for-each select=".//note[@rend='footnote']">
    <p>
      <xsl:attribute name="id">
        <xsl:call-template name="footnote-id"/>
      </xsl:attribute>
    <xsl:text>(</xsl:text>
    <a>
      <xsl:attribute name="href">
        <xsl:text>#fn_</xsl:text>
        <xsl:call-template name="footnote-id"/>
      </xsl:attribute>
      <xsl:text>&#x2191;</xsl:text><xsl:call-template name="footnote-id"/>
    </a>
    <xsl:text>) </xsl:text>
    <xsl:apply-templates/>
    </p>
  </xsl:for-each>
</xsl:template>

<xsl:template name="footnote-id">
  <xsl:value-of select="@n"/>
</xsl:template>


<xsl:template match="list/head">
  <h4><xsl:apply-templates/></h4>
</xsl:template>


<!-- Transformado de "Universala Vortaro" -->

<xsl:template match="list[@type='dict']">
  <div class="dict">
  <xsl:apply-templates select="item"/>
  </div>
</xsl:template>

<xsl:template match="list[@type='dict']/label">
  <strong>  <!-- id="{generate-id()}" -->
    <xsl:attribute name="id">
      <xsl:call-template name="inx-id"/>
    </xsl:attribute>
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
  </strong>
</xsl:template>
<!--
<xsl:template name="label-id">
  <xsl:value-of select="ancestor::list[@type='dict'][1]/@id"/>
  <xsl:text>_</xsl:text>
  <xsl:number level="any" from="list[@type='dict']"/>
</xsl:template>
-->
<xsl:template name="inx-id">
  <xsl:value-of select="ancestor::node()[@id][1]/@id"/>
  <xsl:text>_n</xsl:text>
  <xsl:number level="any" from="div[@id]|list[@id]" count="label|item|emph|hi|index"/>
</xsl:template>

<xsl:template match="label[@rend='hidden']" priority="2"/>

<xsl:template match="emph[@lang='eo']">
  <em> <!-- id="{generate-id()}"-->
    <xsl:attribute name="id">
      <xsl:call-template name="inx-id"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </em>
</xsl:template>

<xsl:template match="hi[@lang='eo']">
  <strong> <!-- id="{generate-id()}" -->
    <xsl:attribute name="id">
      <xsl:call-template name="inx-id"/>
    </xsl:attribute>
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
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
  <strong> <!-- id="{generate-id()}" -->
    <xsl:attribute name="id">
      <xsl:call-template name="inx-id"/>
    </xsl:attribute>
  <xsl:apply-templates/>
  <xsl:text> </xsl:text>
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
    <xsl:when test="position()=last()">
      <xsl:apply-templates/><xsl:text>. </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/><xsl:text> | </xsl:text>	
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Akademiaj korektoj de UV -->
<xsl:template match="text[@id='akkor']//div[@type='chapter']">
  <xsl:result-document method="html" href="{@id}.html">	
  <html>
   <head>
     <link title="stilo" type="text/css" rel="stylesheet"
     href="../css/{$stylesheet}" />
     <title>Akademiaj korektoj &dash; <xsl:value-of select="head"/>.</title>
   </head>
   <body background="../bld/papero.jpg">
     <xsl:call-template name="header"/>
     <h1>
      <xsl:apply-templates select="head"/>
     </h1>
     <xsl:apply-templates select="div|list|salute|p|signed"/>
     <xsl:call-template name="footer"/>
   </body>
  </html>
  </xsl:result-document>
</xsl:template>

<!-- esperanta vortindekso -->

<xsl:key name="eoletters" match="
	 //list[@type='dict']//label[not(@rend='hidden')] |
	 //emph[@lang='eo'] | 
	 //hi[@lang='eo'] |
   //index/@level1"
	 use="translate(substring(.,1,1),$map_from,$map_to)"/>

<xsl:key name="eowords" match="
	 //list[@type='dict']//label[not(@rend='hidden')] |
	 //emph[@lang='eo'] | 
	 //hi[@lang='eo'] |
   //index/@level1"
         use="."/>

<xsl:template name="wordindex">

  <!-- elektu por chiu litero unu reprezentanton -->
  <xsl:for-each select=
    "(//list[@type='dict']//label[not(@rend='hidden')] |
	    //emph[@lang='eo'] | 
	    //hi[@lang='eo'] |
      //index/@level1)
	    [count(.|key('eoletters',
	    translate(substring(.,1,1),$map_from,$map_to))[1])=1]">

       <!-- ordigu ilin -->
       <xsl:sort lang="eo" case-order="upper-first" />
      
       <xsl:call-template name="letter"/>
 
  </xsl:for-each>
</xsl:template>

<xsl:template name="letter">

  <xsl:variable name="firstletter">
    <xsl:value-of select="translate(substring(.,1,1),$map_from,$map_to)"/>
  </xsl:variable>

  <xsl:variable name="letterdesc">
    <xsl:choose>
      <xsl:when test="$firstletter='C'">
        <xsl:text>C, &Ccirc;</xsl:text>
      </xsl:when>
      <xsl:when test="$firstletter='G'">
        <xsl:text>G, &Gcirc;</xsl:text>
      </xsl:when>
      <xsl:when test="$firstletter='C'">
        <xsl:text>H, &Hcirc;</xsl:text>
      </xsl:when>
      <xsl:when test="$firstletter='J'">
        <xsl:text>J, &Jcirc;</xsl:text>
      </xsl:when>
      <xsl:when test="$firstletter='C'">
        <xsl:text>S, &Scirc;</xsl:text>
      </xsl:when>
      <xsl:when test="$firstletter='C'">
        <xsl:text>U, &Ubreve;</xsl:text>
      </xsl:when>
      <xsl:when test="$firstletter='X'">
        <xsl:text>specialaj</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$firstletter"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <a href="vortinx_{$firstletter}.html">
    <xsl:value-of select="$letterdesc"/>
  </a>
   <xsl:if test="position() != last()">
    <xsl:text>, </xsl:text>
  </xsl:if>

 <xsl:result-document method="html" href="vortinx_{$firstletter}.html"> 
   <html>
     <head>
       <title>e-a vortindekso, litero <xsl:value-of
         select="$firstletter"/>
       </title>
     </head>
     <body background="../bld/papero.jpg">
       <xsl:call-template name="indexheader"/>

   <!-- la litero kiel titolo -->
   <h1><xsl:value-of select="$letterdesc"/></h1>

    <!-- elektu chiujn vortojn kun sama komenclitero -->

    <xsl:for-each select="key('eoletters',$firstletter)
			[count(.|key('eowords',.)[1])=1]"> 

        <!-- ordigu ilin -->
        <xsl:sort lang="eo"/> 
        <!-- kaj listigu nun -->
        <!-- sencimigo:
        :<xsl:value-of select="local-name()"/>:<xsl:value-of select="."/>:
        -->
        <xsl:call-template name="entry"/>
    </xsl:for-each> 
  </body>
  </html>
  </xsl:result-document>
</xsl:template>

<xsl:template name="indexheader">
  <div class="header">
    <span class="header_center">
      <a href="index.html">
        <xsl:value-of select="(//front[1]//titlePart[@type='main'])[1]"/>
      </a>
      <xsl:text>&dash; esperanta indekso</xsl:text>
    </span>
  </div>
</xsl:template>

<xsl:template name="entry">
  <strong>
    <xsl:apply-templates select="." mode="index"/>:
  </strong>
  <xsl:for-each select="key('eowords',.)">
     <xsl:call-template name="ref"/>
  </xsl:for-each><br/>
</xsl:template>


<xsl:template name="ref">
  <a>
  <xsl:choose>
    <!-- EKZERCARO -->
    <xsl:when test="ancestor::text[@id='ekz']">
      <xsl:attribute name="href">
        <xsl:text>ekz_</xsl:text>
        <xsl:value-of select="ancestor::div[@type='section']/@n"/>
        <xsl:text>.html#</xsl:text>
        <xsl:call-template name="inx-id"/>
      </xsl:attribute>
      <xsl:text>FE&nbsp;&para;</xsl:text>
	    <xsl:value-of select="ancestor::div[@type='section']/@n"/>
    </xsl:when>

    <!-- UNIVERSALA VORTARO -->
    <xsl:when test="ancestor::text[@id='univort']">
      <xsl:attribute name="href">
        <xsl:text>uv_</xsl:text>
        <xsl:value-of select="ancestor::div[@type='letter']/@n"/>
        <xsl:text>.html#</xsl:text>
        <xsl:call-template name="inx-id"/>
      </xsl:attribute>
      <xsl:text>UV&nbsp;</xsl:text>
      <xsl:value-of select="ancestor::div[@type='letter']/@n"/>
    </xsl:when>

    <!-- AKADEMIAJ KOREKTOJ -->
    <xsl:when test="ancestor::text[@id='akkor']">
      <xsl:attribute name="href">
        <xsl:value-of select="ancestor::div[@type='chapter']/@id"/>
        <xsl:text>.html#</xsl:text>
        <xsl:call-template name="inx-id"/>     
      </xsl:attribute>
      <xsl:text>AK&nbsp;</xsl:text>
      <xsl:value-of select="ancestor::div[@type='chapter']/@n"/>
      <!--xsl:value-of select="ancestor::div[@type='letter']/@n"/-->
    </xsl:when>

    <!-- ANTAUPAROLO -->
    <xsl:when test="ancestor::div[@id='antparol']">
      <xsl:attribute name="href">
        <xsl:text>antparol.html#</xsl:text>
        <xsl:call-template name="inx-id"/>
        <!-- xsl:value-of select="generate-id()"/-->
      </xsl:attribute>
      <xsl:text>Antaŭparolo</xsl:text>
    </xsl:when>

    <!-- GRAMATIKO FRANCA -->
    <xsl:when test="ancestor::div[@id='gra_fr']">
      <xsl:attribute name="href">
        <xsl:text>gra_fr.html#</xsl:text>
        <xsl:call-template name="inx-id"/>
        <!--xsl:value-of select="generate-id()"/-->
      </xsl:attribute>
      <xsl:text>FG&nbsp;fr.</xsl:text>
    </xsl:when>

    <!-- GRAMATIKO ANGLA -->
    <xsl:when test="ancestor::div[@id='gra_en']">
      <xsl:attribute name="href">
        <xsl:text>gra_en.html#</xsl:text>
        <xsl:call-template name="inx-id"/>
	      <!--xsl:value-of select="generate-id()"/-->
      </xsl:attribute>
      <xsl:text>FG&nbsp;angl.</xsl:text>
    </xsl:when>

    <!-- GRAMATIKO GERMANA -->
    <xsl:when test="ancestor::div[@id='gra_de']">
      <xsl:attribute name="href">
        <xsl:text>gra_de.html#</xsl:text>
        <xsl:call-template name="inx-id"/>
	      <!--xsl:value-of select="generate-id()"/-->
      </xsl:attribute>
      <xsl:text>FG&nbsp;germ.</xsl:text>
    </xsl:when>

    <!-- GRAMATIKO RUSA -->
    <xsl:when test="ancestor::div[@id='gra_ru']">
      <xsl:attribute name="href">
        <xsl:text>gra_ru.html#</xsl:text>
        <xsl:call-template name="inx-id"/>
	      <!--xsl:value-of select="generate-id()"/-->
      </xsl:attribute>
      <xsl:text>FG&nbsp;rus.</xsl:text>
    </xsl:when>

    <!-- GRAMATIKO POLA -->
    <xsl:when test="ancestor::div[@id='gra_pl']">
      <xsl:attribute name="href">
        <xsl:text>gra_pl.html#</xsl:text>
        <xsl:call-template name="inx-id"/>
	      <!-- xsl:value-of select="generate-id()"/-->
      </xsl:attribute>
      <xsl:text>FG&nbsp;pola</xsl:text>
    </xsl:when>
    
  </xsl:choose>
  </a>

  <xsl:if test="position() != last()">
    <xsl:text> | </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="@level1" mode="index">
  <xsl:value-of select="."/>
</xsl:template>

</xsl:transform>
