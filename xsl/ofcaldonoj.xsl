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
            <xsl:variable name="ref">
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

<!--
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
-->
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
            <!-- por ekzercaro skribu §xx 
            <xsl:if test="ancestor::text[@id='ekz']">
              <xsl:if test="@n">
                <xsl:text>&para; </xsl:text>
                <xsl:value-of select="@n"/>
                <xsl:text>. </xsl:text>            
              </xsl:if>
            </xsl:if>
            -->
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
            <!--
            <xsl:otherwise>
              <a href="uv_{@n}.html"><xsl:value-of select="head"/></a>
            </xsl:otherwise>
            -->
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


<xsl:template match="list[@rend='1)']/item[@n]">
  <p class="p">
  <xsl:value-of select="@n"/>) 
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

<!-- ne montru index-terminojn en la normala teksto, sed ja en la indekso -->
<xsl:template match="index/term"/>

<xsl:template match="index/term" mode="index">
  <xsl:apply-templates/>
</xsl:template>

<!-- subpremu alnotojn en indeksigitaj kapvortoj -->
<xsl:template match="label/note" mode="index"/>
<xsl:template match="item/note" mode="index"/>

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
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
  </strong>
</xsl:template>

<xsl:template name="inx-id">
  <xsl:value-of select="ancestor::node()[@id][1]/@id"/>
  <xsl:text>_n</xsl:text>
  <xsl:number level="any" from="div[@id]|list[@id]" count="label|emph|hi|index"/>
</xsl:template>

<!--
<xsl:template name="label-id">
  <xsl:value-of select="ancestor::list[@type='dict'][1]/@id"/>
  <xsl:text>_</xsl:text>
  <xsl:number level="any" from="list[@type='dict']"/>
</xsl:template>
-->

<xsl:template match="list[@type='dict']/label/note[not(@rend='footnote')]
  |list[@type='dict']/item/note[not(@rend='footnote')]">
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="label[@rend='hidden']" priority="2"/>

<!-- emfazojn kun ido <index> ni ankaŭ ebligas adresi el la indekso -->

<xsl:template match="emph[index]|foreign[index]">
  <em> <!-- id="{generate-id()}"-->
    <xsl:attribute name="id">
      <xsl:call-template name="inx-id"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </em>
</xsl:template>

<xsl:template match="hi[index]">
  <strong> <!--id="{generate-id()}"-->
    <xsl:attribute name="id">
      <xsl:call-template name="inx-id"/>
    </xsl:attribute>
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
  </strong>
</xsl:template>


<!-- strukturita enhavo de vortlistero vorto + pluraj tradukoj ks -->

<xsl:template match="list[@type='dict']/item[list]">
  <p class="dict-entry">
  <xsl:apply-templates select="preceding-sibling::label[1]"/>
  <xsl:apply-templates select="list[@type='def']"/>
  <xsl:apply-templates select="list[@type='tr']"/>
  </p>
  <xsl:apply-templates select="list[@type='deriv']"/>
  <xsl:apply-templates select="note"/>
</xsl:template>

<!-- kelkaj vortlistoj, ekz-e en OA 2 estas simplaj (nur <item>, sed ne <label>)
ni evitu tamen krampigon per <li>...</li> -->
<xsl:template match="list[@type='dict' and not(label)]/item[index]">
  <p class="dict-entry"> <!-- id="{generate-id()}" -->
    <xsl:attribute name="id">
      <xsl:call-template name="inx-id"/>
    </xsl:attribute>
    <strong><xsl:apply-templates/></strong>
  </p>
</xsl:template>


<!-- apartaj reguloj por vortlisto en OA8, kie enestas difino antaŭ la
listo de tradukoj -->

<xsl:template match="list[@type='dict' and @rend='def_tr']/item" priority="1">
  <p  class="dict-entry"> <!--id="{generate-id()}"-->
    <xsl:attribute name="id">
      <xsl:call-template name="inx-id"/>
    </xsl:attribute>
    <xsl:apply-templates select="preceding-sibling::label[1]"/>
    <xsl:apply-templates select="list[@type='def']"/>
    <xsl:apply-templates select="note"/> <!-- montru la notojn en la fluo de la difino -->
  </p>
  <xsl:apply-templates select="list[@type='deriv']"/>
</xsl:template>

<xsl:template match="list[@type='dict' and @rend='def_tr']//item[@lang='eo']" priority="1">
  <xsl:apply-templates/>
  <xsl:text> &dash; </xsl:text>
</xsl:template>

<xsl:template match="list[@type='dict' and @rend='def_tr']//item[@lang!='eo']" priority="1">
  <i><xsl:value-of select="@lang"/></i>:
  <xsl:apply-templates/>
  <xsl:choose>
    <xsl:when test="position()=last()">
      <xsl:text>. </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>, </xsl:text>	
    </xsl:otherwise>
  </xsl:choose>  
</xsl:template>

<xsl:template match="list[@type='dict' and @rend='def_tr']/item/note" priority="1">
  <xsl:text> &dash; </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<!-- apartaj reguloj por difinlistoj de OA9 (sen tradukoj) -->

<xsl:template match="list[@type='dict' and @rend='def']/item" priority="1">
  <p class="dict-entry"> <!-- id="{generate-id()}" -->
    <xsl:attribute name="id">
      <xsl:call-template name="inx-id"/>
    </xsl:attribute>
    <xsl:apply-templates select="preceding-sibling::label[1]"/>
    <xsl:apply-templates select="text()|eg|foreign"/>
  </p>
  <xsl:apply-templates select="list[@type='def']"/>
  <xsl:apply-templates select="list[@type='deriv']"/>
  <xsl:apply-templates select="note"/>
</xsl:template>

<xsl:template match="item/eg|item/foreign">
  <i><xsl:apply-templates/></i>
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
  <p class="dict-subentry">
  <xsl:apply-templates select="preceding-sibling::label[1]"/>
  <xsl:apply-templates/>
  </p>
</xsl:template>


<!-- listo kun tradukoj -->

<xsl:template match="list[@type='tr']">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="list[@type='tr']/item">
  <xsl:choose>
    <xsl:when test="position()=last()">
      <xsl:apply-templates/><xsl:text>. </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/><xsl:text> | </xsl:text>	
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- listo kun difinoj esperantaj -->

<xsl:template match="list[@type='def']">
<ol class="dict-entry">
  <xsl:apply-templates/>
</ol>
</xsl:template>

<!-- pli enŝovita... -->
<xsl:template match="list[@type='deriv']/item/list[@type='def']" priority="1">
<ol class="dict-subentry">
  <xsl:apply-templates/>
</ol>
</xsl:template>

<xsl:template match="item[@rend='def' and not(list)]">
  <p class="dict-entry">
    <xsl:apply-templates select="preceding-sibling::label[1]"/>
    <i><xsl:apply-templates/></i>
  </p>
</xsl:template>

<xsl:template match="item[@rend='ref' and not(list)]">
  <p class="dict-entry">
    <xsl:apply-templates select="preceding-sibling::label[1]"/>
    <xsl:apply-templates/>
  </p>
</xsl:template>



<!-- esperanta vortindekso -->

  <!--
    Ni kreas indekson de ĉiuj indekseroj laŭ ties komenclitero. Ni
    bezonos ĝin por krei liston de vortoj en ĉiu literĉapitro de la indekso:
    - ni indeksas ĉiujn aperojn de <label> kaj aliajn elementojn markitajn per ena <index/>
    - ni elektas la unuan literon de teksta enhavo (ignorante ekze enajn <note>...</note>)
    - la unuan literon ni ĵetas la majuskloj de alfabeto, specialsignojn ("-"...) ni ĵetas al "0"
  -->
<xsl:key name="eoletters" match="
	 //list[@type='dict']//label[not(@rend='hidden')] |
   //item[index and not(index/node())] | 
   //emph[index and not(index/node())] | 
   //hi[index and not(index/node())] |
   //index/term"
	 use="translate(substring(normalize-space(text()),1,1),$map_from,$map_to)"/>

  <!--
    Ni kreas indekson de ĉiuj indeksendaj vortoj laŭ ties normigita teksto.
    Ni bezonas gin, ĉar ni volas montri ciun vorton en la indekso nur unufoje kun
    la listo de aperoj apud gi:
    - ni indeksas ĉiujn aperojn de <label> kaj aliajn elementojn markitajn per ena <index/>
    - ni elektas la tekstan enahvon (ignorante ekze enajn <note>...</note>) kaj forigante marĝenajn spacsignojn
  -->

<xsl:key name="eowords" match="
	 //list[@type='dict']//label[not(@rend='hidden')] |
   //item[index and not(index/node())] | 
   //emph[index and not(index/node())] | 
   //hi[index and not(index/node())]|
   //index/term"
         use="normalize-space(text())"/>

<xsl:template name="wordindex">

  <!-- elektu por chiu litero unu reprezentanton -->

<!--//list[@type='dict']//label[not(@rend='hidden')] |
	    //list[@type='dict']/item[not(list)] -->

<!-- 
  Ni elektas por ĉiu litero en la indekso 'eoletters' reprezentanton, t.e. la unuan
  vorton, kiu komenciĝas per tiu litero. La truko kun [count(.|key(_,_))[1])=1]
  necesas por XSL 1, postaj eldonoj povus uzi eblecojn de xsl:group!
-->
  <xsl:for-each select="(
      //list[@type='dict']//label[not(@rend='hidden')] |
      //item[index and not(index/node())] | 
      //emph[index and not(index/node())] | 
      //hi[index and not(index/node())] |
      //index/term)
	    [count(.|key('eoletters',
	    translate(substring(normalize-space(text()),1,1),$map_from,$map_to))[1])=1]">

       <!-- ordigu la reprezentantojn laŭ ies unua litero -->
       <xsl:sort select="substring(normalize-space(text()),1,1)" lang="eo"/> <!-- case-order="upper-first"/ -->    
       <!-- xsl:message select="."/ -->

       <!-- traktu la tutan ĉapitron de tiu litero... -->
       <xsl:call-template name="letter"/>
 
  </xsl:for-each>
</xsl:template>

<xsl:template name="letter">

  <!-- ni reprenas la unuan literon de la reprezentanto, ĉar laŭ
    tiu ni poste elektos ĉiujn samliterajn vortojn -->
  <xsl:variable name="firstletter">
    <xsl:value-of select="translate(substring(normalize-space(text()),1,1),$map_from,$map_to)"/>
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

<!--
  <xsl:message>
    <xsl:text>
    LETTER: '</xsl:text><xsl:value-of select="$firstletter"/>
    <xsl:text>'</xsl:text></xsl:message>
-->

  <xsl:if test="$firstletter != '' "> <!-- 
     evitante eraran dosieron: se el iu kaŭzo la vorto ne komenciĝas
     per la literoj a-z, ĉ..ŭ, kaj ^,˘,- ni ignoras ĝin -->

    <a href="vortinx_{$firstletter}.html">
      <xsl:value-of select="$letterdesc"/>
    </a>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>

    <!-- ĉiu literĉapitro estu en aparta dosiero -->
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

        <!-- elektu ĉiujn vortojn kun sama komenclitero.
          La trukon kun [count(.|key('eowords',.)[1])=1] ni
          bezonas, ĉar tio por vorto, kiu aperas plurloke 
          ni tiel traktas nur la unuan reprezentanton
          (duoblajn vortojn ni ne volas duoble en la indekso, sed
          kun ties apeeroj listigite apud la vorto)
        -->

          <xsl:for-each select="key('eoletters',$firstletter)
          [count(.|key('eowords',.)[1])=1]"> 

            <!-- ordigu ilin -->
            <xsl:sort select="text()" lang="eo"/> 
            <!-- kaj listigu nun -->
            <xsl:call-template name="entry"/>
        </xsl:for-each> 
      </body>
      </html>
    </xsl:result-document>
  </xsl:if>
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
  <!--
<xsl:if test="starts-with(text(),'Administra')">
<xsl:message>WINX... <xsl:value-of select="name()"/></xsl:message>
</xsl:if>
-->
    <xsl:choose>
      <xsl:when test="index/term">
        <xsl:apply-templates select="index" mode="index"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="index"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>: </xsl:text>
  </strong>
  <xsl:for-each select="key('eowords',normalize-space(text()))">
     <xsl:call-template name="ref"/>
  </xsl:for-each><br/>
</xsl:template>


<xsl:template name="ref">
  <!-- OA 1..9 -->
  <xsl:if test="ancestor::text[@rend='doc']">
  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="ancestor::text/@id"/>
      <xsl:text>.html#</xsl:text>
        <xsl:call-template name="inx-id"/>
        <!--
        <xsl:choose>
        <xsl:when test="self::label|self::item[index]">
          <xsl:call-template name="label-id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id()"/>
        </xsl:otherwise>
      </xsl:choose>
      -->
    </xsl:attribute>
    <xsl:text>OA&nbsp;</xsl:text>
    <xsl:value-of select="ancestor::text/@n"/>
    <xsl:if test="ancestor::div[@type='part']">
      <xsl:text>,</xsl:text>
      <xsl:value-of select="ancestor::div[@type='part'][1]/@n"/>
    </xsl:if>
  </a>
  <xsl:if test="position() != last()">
    <xsl:text> | </xsl:text>
  </xsl:if>
  </xsl:if>    

</xsl:template>


</xsl:transform>
