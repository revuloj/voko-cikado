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
  Ni uzos la indekson por ligi Revo-artikolojn en la tezaŭro al la fontoj de FdE kaj OA.
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
    Ni bezonas ĝin, ĉar ni volas montri ĉiun vorton en la indekso nur unufoje kun
    la listo de aperoj apud gi:
    - ni indeksas ĉiujn aperojn de <label> kaj aliajn elementojn markitajn per ena <index/>
    - aldone ni indeksas emfaziztajn tekstojn kun lang="eo", eble ni aldonu tie <index/>
      en la fontodosiero pro klareco(?)
    - ni elektas la tekstan enahvon (ignorante ekze enajn <note>...</note>) kaj forigante marĝenajn spacsignojn
  -->

<xsl:key name="eowords" match="
	 //list[@type='dict']/label"
         use="normalize-space(.)"/>

<xsl:template name="wordindex">

  <!-- elektu por chiu kapvorto unu reprezentanton -->
  <xsl:for-each select=
    "//list[@type='dict']/label[count(.|key('eowords',normalize-space(.))[1])=1]">

       <!-- ordigu ilin -->
       <xsl:sort lang="eo" case-order="upper-first" />      
       <xsl:call-template name="entry"/>
 
  </xsl:for-each>
</xsl:template>


<!-- indekseroj konsistas el kapvorto kaj listo de referencoj -->
<xsl:template name="entry">
  <xsl:text>"</xsl:text>
    <xsl:apply-templates select="."/> 
  <xsl:text>":[</xsl:text>
  <xsl:for-each select="key('eowords',normalize-space(.))">
     <xsl:call-template name="ref"/>
  </xsl:for-each>  <xsl:text>],
</xsl:text>
</xsl:template>

<!-- evitu aparte linirompojn... -->
<xsl:template match="text()">
  <xsl:value-of select="normalize-space()"/>
</xsl:template>

<xsl:template name="inx-id">
  <xsl:value-of select="ancestor::node()[@id][1]/@id"/>
  <xsl:text>_n</xsl:text>
  <xsl:number level="any" from="div[@id]|list[@id]" count="label|item"/>
</xsl:template>

<!--
<xsl:template name="inx-id">
  <xsl:value-of select="ancestor::node()[@id][1]/@id"/>
  <xsl:text>_n</xsl:text>
  <xsl:number level="any" from="div[@id]|list[@id]" count="label|item|emph|hi|index"/>
</xsl:template>
-->

<xsl:template name="ref">

  <xsl:if test="ancestor::div[@id='jed_vortaro']">
    <xsl:text>"</xsl:text>      
    <xsl:text>jed_</xsl:text>
    <xsl:value-of select="ancestor::div[@type='letter']/@n"/>
    <xsl:text>.html#</xsl:text>
    <xsl:call-template name="inx-id"/>
    <xsl:text>","</xsl:text>      
    <xsl:text>JED&nbsp;</xsl:text>
    <xsl:value-of select="ancestor::div[@type='letter']/@n"/>
    <xsl:text>"</xsl:text>
  </xsl:if>

  <xsl:if test="position() != last()">
    <xsl:text>, </xsl:text>
  </xsl:if>

</xsl:template>

</xsl:transform>
 