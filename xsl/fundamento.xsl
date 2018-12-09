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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
		version="1.0"
                extension-element-prefixes="xt">

<!--

XSLT-stildifinoj por fundamento.xml (La Fundamento de Eo). 
Ghi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.

(c) 2001 che Wolfram DIESTEL
    licenco GPL 2.0

-->

<xsl:import href="teixlite.xsl"/>

<xsl:variable name="stylesheet">fundamento.css</xsl:variable>
<xsl:variable name="content_level1" select="'part'"/>
<xsl:variable name="content_level2" select="'chapter'"/>

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
                <xsl:value-of select=".//head[1]"/>
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

<xsl:template name="header">

  <xsl:choose>
 
    <xsl:when test="self::text">
      <div class="header">
      <xsl:for-each select="(preceding-sibling::text[@rend='doc'] | ./div[@id='antparol']) [last()]"> 
        <span class="header_left">
          <a href="{@id}.html">
            <xsl:text>&lt;&lt;&nbsp;</xsl:text>
            <xsl:value-of select="(.//titlePart[@type='main']|head)[1]"/>
          </a>
        </span>
      </xsl:for-each>

      <span class="header_center">
        <xsl:text> </xsl:text>
        <a href="index.html">
          <xsl:for-each select="//front[1]//docAuthor">
            <xsl:value-of select="."/>:
          </xsl:for-each>
          <xsl:value-of select="//front[1]//titlePart[@type='main']"/>
        </a>
      </span>
      </div>
    </xsl:when>

    <xsl:when test="self::div[@type='chapter' or @type='section']">
      <div class="header">
      <xsl:for-each select="preceding-sibling::div[@rend='doc'][1]"> 
        <span class="header_left">
          <a href="{@id}.html">
            <xsl:text>&lt;&lt;&nbsp;</xsl:text>
            <xsl:if test="@n">
              <xsl:text>&para; </xsl:text>
              <xsl:value-of select="@n"/>
              <xsl:text>. </xsl:text>            
            </xsl:if>
            <xsl:value-of select="head"/>
          </a>
        </span>
      </xsl:for-each>

      <span class="header_center">
        <xsl:text> </xsl:text>
        <a href="index.html">
          <xsl:value-of select="//front[1]//titlePart[@type='main']"/>
        </a>
        &dash;
        <xsl:for-each select="ancestor::text[@rend='doc'][1]">
          <a href="{@id}.html">
            <xsl:value-of select=".//titlePart[@type='main'][1]"/>
          </a>
        </xsl:for-each>
      </span>  
      </div>
    </xsl:when>

    <xsl:when test="self::div[@type='letter']">
      <div class="uv_header">
      <p align="center">
        <xsl:text> </xsl:text>
        <a href="index.html">
          <xsl:value-of select="//front[1]//titlePart[@type='main']"/>
        </a>
        &dash;
        <xsl:for-each select="ancestor::text[@rend='doc'][1]">
          <a href="{@id}.html">
            <xsl:value-of select=".//titlePart[@type='main'][1]"/>
          </a>
        </xsl:for-each>
      <br/>

      <xsl:variable name="n" select="@n"/>
        <xsl:for-each select="../div[@type='letter']">
          <xsl:choose>
            <xsl:when test="$n=current()/@n">
              <xsl:value-of select="head"/>
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
            <xsl:if test="@n">
              <xsl:text>&para; </xsl:text>
              <xsl:value-of select="@n"/>
              <xsl:text>. </xsl:text>            
            </xsl:if>          
            <xsl:value-of select="head"/>
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

<xsl:template match="note[@rend='footnote']">
  <span class="note">(<xsl:apply-templates/>)</span>
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
  <strong>
  <a name="{generate-id()}"/>
  <xsl:apply-templates/>
  <xsl:text> </xsl:text>
  </strong>
</xsl:template>

<xsl:template match="emph[@lang='eo']">
  <em>
  <a name="{generate-id()}"/>
  <xsl:apply-templates/>
  </em>
</xsl:template>

<xsl:template match="hi[@lang='eo']">
  <strong>
  <a name="{generate-id()}"/>
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
  <strong>
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
    <xsl:when test="position()=last()-1">
      <xsl:apply-templates/><xsl:text>. </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/><xsl:text> | </xsl:text>	
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- esperanta vortindekso -->

<xsl:key name="eoletters" match="
	 //list[@type='dict']/label |
	 //emph[@lang='eo'] | 
	 //hi[@lang='eo']"
	 use="translate(substring(.,1,1),
    'abc&ccirc;defg&gcirc;h&hcirc;ij&jcirc;klmnoprs&scirc;tu&ubreve;vz&circ;&breve;&Ccirc;&Gcirc;&Hcirc;&Jcirc;&Scirc;&Ubreve;',
    'ABCCDEFGGHHIJJKLMNOPRSSTUUVZXXCFHJSU')"/>

<xsl:key name="eowords" match="
	 //list[@type='dict']/label |
	 //emph[@lang='eo'] | 
	 //hi[@lang='eo']"
         use="."/>

<xsl:template name="wordindex">

  <!-- elektu por chiu litero unu reprezentanton -->
  <xsl:for-each select=
    "(//list[@type='dict']/label |
	    //emph[@lang='eo'] | 
	    //hi[@lang='eo'])
	    [count(.|key('eoletters',
	    translate(substring(.,1,1),
    'abc&ccirc;defg&gcirc;h&hcirc;ij&jcirc;klmnoprs&scirc;tu&ubreve;vz&circ;&breve;&Ccirc;&Gcirc;&Hcirc;&Jcirc;&Scirc;&Ubreve;',
    'ABCCDEFGGHHIJJKLMNOPRSSTUUVZXXCFHJSU'))[1])=1]">

       <!-- ordigu ilin -->
       <xsl:sort lang="eo" case-order="upper-first" />
      
       <xsl:call-template name="letter"/>
 
  </xsl:for-each>
</xsl:template>

<xsl:template name="letter">

  <xsl:variable name="firstletter">
    <xsl:value-of select="translate(substring(.,1,1),
     'abc&ccirc;defg&gcirc;h&hcirc;ij&jcirc;klmnoprs&scirc;tu&ubreve;vz&circ;&breve;&Ccirc;&Gcirc;&Hcirc;&Jcirc;&Scirc;&Ubreve;',
     'ABCCDEFGGHHIJJKLMNOPRSSTUUVZXXCFHJSU')"/>
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
       <title>ea vortindekso, litero <xsl:value-of
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
        <xsl:value-of select="//front[1]//titlePart[@type='main']"/>
      </a>
      <xsl:text>&dash; esperanta indekso</xsl:text>
    </span>
  </div>
</xsl:template>

<xsl:template name="entry">
  <strong>
    <xsl:apply-templates/>:
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
	 <xsl:value-of select="generate-id()"/>
       </xsl:attribute>
       <xsl:text>Ekzerc. &para; </xsl:text>
	  <xsl:value-of select="ancestor::div[@type='section']/@n"/>
      </xsl:when>

      <!-- UNIVERSALA VORTARO -->
      <xsl:when test="ancestor::text[@id='univort']">
       <xsl:attribute name="href">
         <xsl:text>uv_</xsl:text>
         <xsl:value-of select="ancestor::div[@type='letter']/@n"/>
         <xsl:text>.html#</xsl:text>
	 <xsl:value-of select="generate-id()"/>
        </xsl:attribute>
       <xsl:text>UV </xsl:text>
        <xsl:value-of select="ancestor::div[@type='letter']/@n"/>
      </xsl:when>

      <!-- ANTAUPAROLO -->
      <xsl:when test="ancestor::div[@id='antparol']">
       <xsl:attribute name="href">
         <xsl:text>antparol.html#</xsl:text>
	 <xsl:value-of select="generate-id()"/>
        </xsl:attribute>
       <xsl:text>Antaŭparolo</xsl:text>
      </xsl:when>

      <!-- GRAMATIKO FRANCA -->
      <xsl:when test="ancestor::div[@id='gra_fr']">
       <xsl:attribute name="href">
         <xsl:text>gra_fr.html#</xsl:text>
         <xsl:value-of select="generate-id()"/>
       </xsl:attribute>
       <xsl:text>Gram. fr.</xsl:text>
      </xsl:when>

       <!-- GRAMATIKO ANGLA -->
      <xsl:when test="ancestor::div[@id='gra_en']">
       <xsl:attribute name="href">
         <xsl:text>gra_en.html#</xsl:text>
	 <xsl:value-of select="generate-id()"/>
        </xsl:attribute>
       <xsl:text>Gram. angl.</xsl:text>
      </xsl:when>

      <!-- GRAMATIKO GERMANA -->
      <xsl:when test="ancestor::div[@id='gra_de']">
       <xsl:attribute name="href">
         <xsl:text>gra_de.html#</xsl:text>
	 <xsl:value-of select="generate-id()"/>
       </xsl:attribute>
       <xsl:text>Gram. germ.</xsl:text>
      </xsl:when>

      <!-- GRAMATIKO RUSA -->
      <xsl:when test="ancestor::div[@id='gra_ru']">
       <xsl:attribute name="href">
         <xsl:text>gra_ru.html#</xsl:text>
	 <xsl:value-of select="generate-id()"/>
       </xsl:attribute>
       <xsl:text>Gram. rus.</xsl:text>
      </xsl:when>

      <!-- GRAMATIKO POLA -->
      <xsl:when test="ancestor::div[@id='gra_pl']">
       <xsl:attribute name="href">
         <xsl:text>gra_pl.html#</xsl:text>
	 <xsl:value-of select="generate-id()"/>
       </xsl:attribute>
       <xsl:text>Gram. pola</xsl:text>
      </xsl:when>
    
  </xsl:choose>
  </a>

  <xsl:if test="position() != last()">
    <xsl:text> | </xsl:text>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>














