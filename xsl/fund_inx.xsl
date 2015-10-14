<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet
[
  <!ENTITY leftquot '"'>
  <!ENTITY rightquot '"'>
  <!ENTITY para "&#x00a7;">

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

<xsl:template match="/">
  <html>
  <head>
  <title><xsl:value-of select="//titleStmt/title"/></title>
  </head>
  <body>
    <xsl:call-template name="wordindex"/>
  </body>
  </html>
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
  <h1>esperanta vortindekso</h1>

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
       <xsl:sort lang="eo"/>
      
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
        aliaj
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

 <xt:document method="html" href="vortinx_{$firstletter}.html"> 
   <html>
     <head><title>ea vortindekso, litero <xsl:value-of
   select="$firstletter"/>
     </title></head>
     <body>

   <!-- la litero kiel titolo -->
   <h1><xsl:value-of select="$letterdesc"/></h1>

    <!-- elektu chiujn vortojn kun sama komenclitero -->

       <xsl:for-each select="key('eoletters',$firstletter)
			[count(.|key('eowords',.)[1])=1]"> 

         <!-- ordigu ilin -->
         <xsl:sort lang="eo"/> 
         <!-- kaj listigu nun -->
         <xsl:call-template name="entry" mode="inx"/>
    </xsl:for-each> 
  </body>
  </html>
  </xt:document>
</xsl:template>

<xsl:template name="entry" mode="inx">
  <strong>
    <xsl:apply-templates/>:
  </strong>
  <xsl:for-each select="key('eowords',.)">
     <xsl:call-template name="ref" mode="inx"/>
  </xsl:for-each><br/>
</xsl:template>

<xsl:template name="ref" mode="inx">
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











