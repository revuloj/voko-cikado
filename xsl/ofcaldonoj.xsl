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

  <!ENTITY OA_fonto "https://github.com/revuloj/voko-cikado/blob/master/txt/tei2/ofcaldonoj.xml">

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

<xsl:variable name="stylesheet">ofcaldonoj.css</xsl:variable>
<xsl:variable name="content_level1" select="'xxx'"/> <!-- <text@doc> -->
<xsl:variable name="content_level2" select="'part'"/>

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
      al la Oficialaj Aldonoj, sed faciligas trovi ion en tiuj:<br/>
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
  <!-- <xsl:if test="self::div">-->
    <div class="footnotes">
      <xsl:call-template name="footnotes"/>
    </div>
  <!-- </xsl:if> -->

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
  <xsl:value-of select="@rend"/> <!-- kelkaj vortoj havas markon kiel ekz-e steleton -->
  <strong id="{generate-id()}">
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
  </strong>
</xsl:template>

<xsl:template match="list[@type='dict']/label/note">
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="label[@rend='hidden']" priority="2"/>

<xsl:template match="emph[@lang='eo']">
  <em id="{generate-id()}">
    <xsl:apply-templates/>
  </em>
</xsl:template>

<xsl:template match="hi[@lang='eo']">
  <strong id="{generate-id()}">
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
  </strong>
</xsl:template>

<!-- strukturita enhavo de vortlistero vorto + pluraj tradukoj ks-->
<xsl:template match="list[@type='dict']/item[list]">
  <p class="dict-entry">
  <xsl:apply-templates select="preceding-sibling::label[1]"/>
  <xsl:apply-templates select="list[@type='def']"/>
  </p>
  <xsl:apply-templates select="list[@type='deriv']"/>
  <xsl:apply-templates select="note"/>
</xsl:template>


<xsl:template match="list[@type='deriv']">
  <xsl:apply-templates select="item"/>
</xsl:template>

<xsl:template match="list[@type='deriv']/label">
  <strong id="{generate-id()}">
  <xsl:apply-templates/>
  <xsl:text> </xsl:text>
  </strong>
</xsl:template>

<xsl:template match="list[@type='deriv']/item[list]">
  <p class="dict-subentry">
  <xsl:apply-templates select="preceding-sibling::label[1]"/>
  <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="list[@type='def']">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="item[@type='def' and not(list)]">
  <p class="dict-entry">
    <xsl:apply-templates select="preceding-sibling::label[1]"/>
    <i><xsl:apply-templates/></i>
  </p>
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


<!-- esperanta vortindekso -->

<xsl:key name="eoletters" match="
	 //list[@type='dict']//label[not(@rend='hidden')] "
	 use="translate(substring(.,1,1),
    'abc&ccirc;defg&gcirc;h&hcirc;ij&jcirc;klmnoprs&scirc;tu&ubreve;vz&circ;&breve;&Ccirc;&Gcirc;&Hcirc;&Jcirc;&Scirc;&Ubreve;',
    'ABCCDEFGGHHIJJKLMNOPRSSTUUVZXXCFHJSU')"/>

<xsl:key name="eowords" match="
	 //list[@type='dict']//label[not(@rend='hidden')] "
         use="."/>

<xsl:template name="wordindex">

  <!-- elektu por chiu litero unu reprezentanton -->

<!--//list[@type='dict']//label[not(@rend='hidden')] |
	    //list[@type='dict']/item[not(list)] -->

  <xsl:for-each select=
    "( //list[@type='dict']//label[not(@rend='hidden')] )
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

<!-- indekseroj konsistas el kapvorto kaj listo de referencoj -->
<xsl:template name="entry">
  <strong>
    <xsl:apply-templates mode="index"/>:
  </strong>
  <xsl:for-each select="key('eowords',.)">
     <xsl:call-template name="ref"/>
  </xsl:for-each><br/>
</xsl:template>

<!-- subpremu alnotojn en indeksigitaj kapvortoj -->
<xsl:template match="label/note" mode="index"/>

<xsl:template name="ref">
  <!-- OA 1..9 -->
  <xsl:if test="ancestor::text[@rend='doc']">
  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="ancestor::text/@id"/>
      <xsl:text>.html#</xsl:text>
      <xsl:value-of select="generate-id()"/>
    </xsl:attribute>
    <xsl:text>OA </xsl:text>
    <xsl:value-of select="ancestor::text/@n"/>
  </a>
  <xsl:if test="position() != last()">
    <xsl:text> | </xsl:text>
  </xsl:if>
  </xsl:if>    

</xsl:template>


</xsl:transform>














