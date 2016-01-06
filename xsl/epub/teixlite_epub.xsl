<!DOCTYPE xsl:stylesheet 
[
<!ENTITY leftquot '"'>
<!ENTITY rightquot '"'>
<!ENTITY dash  "&#x2015;">
<!ENTITY nbsp "&#x00a0;">

]>

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xt="http://www.jclark.com/xt"
  xmlns="http://www.w3.org/1999/xhtml"
  version="1.0"
  extension-element-prefixes="xt">



<xsl:output method="xhtml" version="1.1" encoding="utf-8"
	doctype-public="-//W3C//DTD XHTML 1.1//EN"
	doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
/>
<xsl:strip-space elements="text"/>

<!--

XSLT-stildifinoj por TEI-Lite-dokumentoj. 

(c) 2001-2011 che Wolfram DIESTEL
    lau GPL 2.0

Ghi entenas nur la bazajn regulojn kaj estu importata de dokument-specifa
stil-dosiero. Eblas ankau meti la apartajn regulojn en
la TEI-dokumenton mem.

TEI-dokumentoj uzataj kun tiuj chi stildifinoj sekvu kelkajn
konvenciojn:

1) La elemento <front>, en kiu aperu la enhavtabelo havu atributon rend="index"
   La eroj <text> au <div>, kiuj aperu en la enhavtabelo havu atributon rend="inx"
   kaj atributon "id" servanta kiel referenc-marko.

-->

<!-- kelkaj variabloj -->

<xsl:variable name="stylesheet">teixlite_epub.css</xsl:variable>

<!-- dokumento -->

<xsl:template match="/">
  <html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link title="dokumento-stilo" type="text/css" rel="stylesheet"
  href="css/{$stylesheet}" />
  <title><xsl:value-of select="//titleStmt/title"/></title>
  </head>
  <body>
    <xsl:apply-templates/>
  </body>
  </html>
</xsl:template>

<!-- teiHeader -->


<!-- subtekstoj kaj subdividoj -->

<xsl:template match="text[@rend='doc']|div[@rend='doc']">
  <xt:document method="xhtml" 
    version="1.1" 
    encoding="utf-8" 	
    doctype-public="-//W3C//DTD XHTML 1.1//EN"
    doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
    href="{@id}.xhtml">
    <xsl:call-template name="subdoc"/>
  </xt:document>
</xsl:template>

<xsl:template match="text|div">
  <xsl:if test="@id">
    <a id="{@id}"/>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="@type">
      <div class="{@type}">
        <xsl:apply-templates/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="subdoc">
  <html xmlns="http://www.w3.org/1999/xhtml">
   <head>
     <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
     <link title="stilo" type="text/css" rel="stylesheet"
     href="css/{$stylesheet}" />
     <title>
     <xsl:call-template name="title-string"/>
     </title>
   </head>
   <body>
     <xsl:apply-templates/>
   </body>
  </html>
</xsl:template>

<xsl:template match="teiHeader"/>

<!-- titolpagh(j) kaj enhavtabelo -->

<xsl:template match="front">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template name="title-string">
   <xsl:value-of select="(.//head)[1]"/>
</xsl:template>

<xsl:template match="titlePage">
  <div class="center"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="docTitle">
  <xsl:choose>
    <xsl:when test="titlePart">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <h1><xsl:apply-templates/></h1>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="titolbildo"/>
</xsl:template>

<xsl:template name="titolbildo"/>

<xsl:template match="titlePage/byline">
  <xsl:apply-templates/><br/>
</xsl:template>

<xsl:template match="docAuthor">
  <h2 class="author"><xsl:apply-templates/></h2>
</xsl:template>

<xsl:template match="titlePart|docEdition">
  <b class="titlePart"><xsl:apply-templates/></b><br/>
</xsl:template>

<xsl:template match="titlePart[@type='main']">
  <h1 class="mainTitle"><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="docImprint">
  <p class="docImprint"><cite><xsl:apply-templates/></cite></p>
</xsl:template>

<!-- alineaj tekst-elementoj -->

<xsl:template match="head">
  <h3 class="head"><xsl:apply-templates/></h3>
</xsl:template>

<xsl:template match="p">
  <p class="p"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="p[position()=1 and not (@rend)]">
  <p class="first_p"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="p[@rend='signed']">
  <p class="signed"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="signed">
  <p class="signed"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="p[@rend='center']">
  <p class="center"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="lb">
  <br/>
</xsl:template>

<xsl:template match="lb[@type='hyph']"/>

<xsl:template match="lg">
  <div align="center" class="lg"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="lg[@type='stanza']">
  <p align="center" class="stanza"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="lg[@rend='left']">
  <p class="lg_left"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="l">
  <span class="l"><xsl:apply-templates/></span><br/>
</xsl:template>

<xsl:template match="list">
  <xsl:choose>
    <xsl:when test="@type='ordered'">
      <ol>
      <xsl:apply-templates/>
      </ol>
    </xsl:when>
    <xsl:otherwise>
      <ul>
      <xsl:apply-templates/>
      </ul>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="item">
  <li><xsl:apply-templates/></li>
</xsl:template>

<xsl:template match="note">
  <p class="note"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="note[@rend='right']">
  <p align="right" class="note">
  <xsl:apply-templates/>
  </p>
</xsl:template>


<!-- emfazoj -->

<xsl:template match="mentioned|p/title">
  <xsl:text>&leftquot;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&rightquot;</xsl:text>
</xsl:template>

<xsl:template match="emph|foreign">
  <em>
  <xsl:apply-templates/>
  </em>
</xsl:template>

<xsl:template match="hi">
  <strong>
  <xsl:apply-templates/>
  </strong>
</xsl:template>

<xsl:template match="hi[@rend='italic']|title[@rend='italic']">
  <i>
  <xsl:apply-templates/>
  </i>
</xsl:template>

<!-- citiloj -->

<xsl:template match="q">
  <xsl:choose>
    <xsl:when test="@rend='&#34;'">
      <xsl:text>&leftquot;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&rightquot;</xsl:text>
    </xsl:when>
    <xsl:when test='@rend="&#39;"'>
      <xsl:text>&#x201a;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&#x2019;</xsl:text>
    </xsl:when>
    <xsl:when test="@rend='--'">
      <xsl:text>&dash; </xsl:text>
      <xsl:apply-templates/>
      <xsl:text> &dash;</xsl:text>
    </xsl:when>
    <xsl:when test="@rend='- '">
      <xsl:text>&dash; </xsl:text>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:when test="@rend=' -'">
      <xsl:apply-templates/>
      <xsl:text> &dash;</xsl:text>    
    </xsl:when>
    <xsl:when test="@rend='&#34;&#34;'">
      <xsl:text>&leftquot;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&rightquot;</xsl:text>
    </xsl:when>
    <xsl:when test="@rend='&#34;&#34;-'">
      <xsl:text>&leftquot;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&rightquot; &dash;</xsl:text>
    </xsl:when>
    <xsl:when test="@rend='&#34;-'">
      <xsl:text>&leftquot;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text> &dash;</xsl:text>
    </xsl:when>
    <xsl:when test="@rend='-&#34;'">
      <xsl:text>&dash; </xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&rightquot;</xsl:text>
    </xsl:when>
    <xsl:when test="@rend='&#34; ' or @rend='begin'">
      <xsl:text>&leftquot;</xsl:text>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:when test="@rend=' &#34;' or @rend='end'">
      <xsl:apply-templates/>
      <xsl:text>&rightquot;</xsl:text>
    </xsl:when>
    <xsl:when test="@rend='  '">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>&leftquot;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&rightquot;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- referencoj -->

<xsl:template match="xref">
  <a href="{.}">
  <xsl:apply-templates/>
  </a>
</xsl:template>

<!-- dramo -->

<xsl:template match="stage">
  <p><i class="stage"><xsl:apply-templates/></i></p>
</xsl:template>

<xsl:template match="sp//stage">
  <i class="stage"><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="speaker">
  <span class="speaker"><xsl:apply-templates/></span>. &dash;
</xsl:template>

<xsl:template match="sp">
  <p class="sp"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="sp/p[position()=1]">
<xsl:apply-templates/>
</xsl:template>

<!-- tabeloj -->

<xsl:template match="table">
  <table>
  <xsl:if test="@rend">
    <xsl:attribute name="border">1</xsl:attribute>
    <xsl:attribute name="rules"><xsl:value-of select="@rend"/></xsl:attribute>
  </xsl:if>
  <xsl:apply-templates/>
  </table>
</xsl:template>

<xsl:template match="table/head">
  <caption><big>
  <xsl:apply-templates/>
  </big></caption>
</xsl:template>

<xsl:template match="row">
  <tr>
  <xsl:apply-templates/>
  </tr>
</xsl:template>

<xsl:template match="cell">
  <td>
  <xsl:if test="rows">
    <xsl:attribute name="rowspan"><xsl:value-of select="@rows"/></xsl:attribute>
  </xsl:if>
  <xsl:if test="cols">
    <xsl:attribute name="colspan"><xsl:value-of select="@cols"/></xsl:attribute>
  </xsl:if>
  <xsl:apply-templates/>
  </td>
</xsl:template>

<!-- teksto -->

<xsl:template match="text()">
  <xsl:value-of select="."/>
</xsl:template>


</xsl:stylesheet>











