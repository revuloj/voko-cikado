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
]>


<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://saxon.sf.net/"
  version="2.0"
  extension-element-prefixes="saxon" 
>


<!-- (c) 2023 ĉe Wolfram Diestel
     laŭ permesilo GPL 2.0

  Tiu transformilo kreas JSON-indekson de Fudamento de Esperanto resp. Oficialaj Aldonoj.  
  Ni uzos la indekson por ligi Revo-artikolojn en la tezaŭro al la fontoj den Fde kaj OA.
-->


<xsl:output method="text" encoding="utf-8"/>

<!-- la kadra strukturo de la artikolo - ties dosiernomo kiel ŝlosilo -->

<xsl:template match="/">
  <xsl:text>{</xsl:text>
  <xsl:call-template name="wordindex"/>
    <!-- pro fina komo ni simple alpendigas malplenan eron -->
  <xsl:text>"__":[]
} 
</xsl:text>
</xsl:template>

<!-- esperanta vortindekso -->

  <!--
    Ni kreas indekson de ĉiuj indeksendaj vortoj laŭ ties normigita teksto.
    Ni bezonas gin, ĉar ni volas montri ciun vorton en la indekso nur unufoje kun
    la listo de aperoj apud gi:
    - ni indeksas ĉiujn aperojn de <label> kaj aliajn elementojn markitajn per ena <index/>
    - aldone ni indeksas emfaziztajn tekstojn kun lang="eo", eble ni aldonu tie <index/>
      en la fontodosiero pro klareco(?)
    - ni elektas la tekstan enahvon (ignorante ekze enajn <note>...</note>) kaj forigante marĝenajn spacsignojn
  -->

<xsl:key name="eowords" match="
	 //list[@type='dict']//label[not(@rend='hidden')] |
   //emph[@lang='eo'] | //hi[@lang='eo'] |
   //item[index and not(index/node())] | 
   //emph[index and not(index/node())] | 
   //hi[index and not(index/node())] | 
   //index[text()] | //index/term"
         use="normalize-space(text())"/>

<xsl:template name="wordindex">

  <!-- elektu por chiu litero unu reprezentanton -->
  <xsl:for-each select=
    "(//list[@type='dict']//label[not(@rend='hidden')] |
      //emph[@lang='eo'] | //hi[@lang='eo'] |
      //item[index and not(index/node())] | 
      //emph[index and not(index/node())] | 
      //hi[index and not(index/node())] | 
      //index[text()] | //index/term)
	    [count(.|key('eowords',normalize-space(text()))[1])=1]">

       <!-- ordigu ilin -->
       <xsl:sort lang="eo" case-order="upper-first" />      
       <xsl:call-template name="entry"/>
 
  </xsl:for-each>
</xsl:template>


<!-- indekseroj konsistas el kapvorto kaj listo de referencoj -->
<xsl:template name="entry">
  <xsl:text>"</xsl:text>
    <xsl:choose>
      <xsl:when test="index/term">
        <xsl:apply-templates select="index"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  <xsl:text>":[</xsl:text>
  <xsl:for-each select="key('eowords',normalize-space(text()))">
     <xsl:call-template name="ref"/>
  </xsl:for-each>  <xsl:text>],
</xsl:text>
</xsl:template>

<!-- subpremu alnotojn en indeksigitaj kapvortoj -->
<xsl:template match="label/note"/>
<xsl:template match="item/note"/>

<!-- evitu aparte linirompojn... -->
<xsl:template match="text()">
  <xsl:value-of select="normalize-space()"/>
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
  <xsl:number level="any" from="node()[@id]" count="label|emph|hi|index"/>
</xsl:template>


<xsl:template name="ref">
  <xsl:choose>
    <!-- EKZERCARO -->
    <xsl:when test="ancestor::text[@id='ekz']">
      <xsl:text>"</xsl:text>
      <xsl:text>ekz_</xsl:text>
      <xsl:value-of select="ancestor::div[@type='section']/@n"/>
      <xsl:text>.html#</xsl:text>
      <xsl:call-template name="inx-id"/>
<!--
      <xsl:choose>
        <xsl:when test="self::label">
          <xsl:call-template name="label-id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id()"/>
        </xsl:otherwise>
      </xsl:choose> 
-->             
      <xsl:text>","</xsl:text>      
      <xsl:text>FE&nbsp;&para;</xsl:text>
	    <xsl:value-of select="ancestor::div[@type='section']/@n"/>
      <xsl:text>"</xsl:text>
    </xsl:when>

    <!-- UNIVERSALA VORTARO -->
    <xsl:when test="ancestor::text[@id='univort']">
      <xsl:text>"</xsl:text>      
      <xsl:text>uv_</xsl:text>
      <xsl:value-of select="ancestor::div[@type='letter']/@n"/>
      <xsl:text>.html#</xsl:text>
      <xsl:call-template name="inx-id"/>
      <!--
      <xsl:choose>
        <xsl:when test="self::label">
          <xsl:call-template name="label-id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id()"/>
        </xsl:otherwise>
      </xsl:choose>
      -->
      <xsl:text>","</xsl:text>      
      <xsl:text>UV&nbsp;</xsl:text>
      <xsl:value-of select="ancestor::div[@type='letter']/@n"/>
      <xsl:text>"</xsl:text>
    </xsl:when>

    <!-- AKADEMIAJ KOREKTOJ -->
    <xsl:when test="ancestor::text[@id='akkor']">
      <xsl:text>"</xsl:text>      
      <xsl:value-of select="ancestor::div[@type='chapter']/@id"/>
      <xsl:text>.html#</xsl:text>
      <xsl:call-template name="inx-id"/>
<!--
      <xsl:choose>
        <xsl:when test="self::label">
          <xsl:call-template name="label-id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id()"/>
        </xsl:otherwise>
      </xsl:choose> 
      -->       
      <xsl:text>","</xsl:text>      
      <xsl:text>AK&nbsp;</xsl:text>
      <xsl:value-of select="ancestor::div[@type='chapter']/@n"/>
      <!--xsl:value-of select="ancestor::div[@type='letter']/@n"/-->
      <xsl:text>"</xsl:text>
    </xsl:when>

    <!-- ANTAUPAROLO -->
    <xsl:when test="ancestor::div[@id='antparol']">
      <xsl:text>"</xsl:text>      
      <xsl:text>antparol.html#</xsl:text>
      <xsl:call-template name="inx-id"/>
      <xsl:text>","</xsl:text>      
      <xsl:text>Antaŭparolo</xsl:text>
      <xsl:text>"</xsl:text>
    </xsl:when>

    <!-- GRAMATIKO FRANCA -->
    <xsl:when test="ancestor::div[@id='gra_fr']">
      <xsl:text>"</xsl:text>      
      <xsl:text>gra_fr.html#</xsl:text>
      <xsl:call-template name="inx-id"/>
      <xsl:text>","</xsl:text>      
      <xsl:text>FG&nbsp;fr.</xsl:text>
      <xsl:text>"</xsl:text>
    </xsl:when>

    <!-- GRAMATIKO ANGLA -->
    <xsl:when test="ancestor::div[@id='gra_en']">
      <xsl:text>"</xsl:text>      
      <xsl:text>gra_en.html#</xsl:text>
      <xsl:call-template name="inx-id"/>
      <xsl:text>","</xsl:text>      
      <xsl:text>FG&nbsp;angl.</xsl:text>
      <xsl:text>"</xsl:text>
    </xsl:when>

    <!-- GRAMATIKO GERMANA -->
    <xsl:when test="ancestor::div[@id='gra_de']">
      <xsl:text>"</xsl:text>      
      <xsl:text>gra_de.html#</xsl:text>
      <xsl:call-template name="inx-id"/>
      <xsl:text>","</xsl:text>      
      <xsl:text>FG&nbsp;germ.</xsl:text>
      <xsl:text>"</xsl:text>
    </xsl:when>

    <!-- GRAMATIKO RUSA -->
    <xsl:when test="ancestor::div[@id='gra_ru']">
      <xsl:text>"</xsl:text>      
      <xsl:text>gra_ru.html#</xsl:text>
      <xsl:call-template name="inx-id"/>
      <xsl:text>","</xsl:text>      
      <xsl:text>FG&nbsp;rus.</xsl:text>
      <xsl:text>"</xsl:text>
    </xsl:when>

    <!-- GRAMATIKO POLA -->
    <xsl:when test="ancestor::div[@id='gra_pl']">
      <xsl:text>"</xsl:text>      
      <xsl:text>gra_pl.html#</xsl:text>
      <xsl:call-template name="inx-id"/>
      <xsl:text>","</xsl:text>      
      <xsl:text>FG&nbsp;pola</xsl:text>
      <xsl:text>"</xsl:text>
    </xsl:when>
    
    <!-- OA 1..9 -->
    <xsl:when test="ancestor::text[starts-with(@id,'oa_')]">
      <xsl:text>"</xsl:text>      
      <xsl:value-of select="ancestor::text[@rend='doc']/@id"/>
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
      <xsl:text>","</xsl:text>      
      <xsl:text>OA&nbsp;</xsl:text>
      <xsl:value-of select="ancestor::text/@n"/>
      <xsl:if test="ancestor::div[@type='part']">
        <xsl:text>,</xsl:text>
        <xsl:value-of select="ancestor::div[@type='part'][1]/@n"/>
      </xsl:if>
      <xsl:text>"</xsl:text>
    </xsl:when>

  </xsl:choose>

  <xsl:if test="position() != last()">
    <xsl:text>, </xsl:text>
  </xsl:if>

</xsl:template>


</xsl:transform>
