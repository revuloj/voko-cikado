<!DOCTYPE xsl:transform 
[
<!ENTITY leftquot '&#x201e;'>
<!ENTITY rightquot '&#x201c;'>

<!ENTITY dash  "&#x2015;">
<!ENTITY nbsp "&#x00a0;">

]>

<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://saxon.sf.net/"
  version="2.0"
  extension-element-prefixes="saxon" 
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
>

<xsl:param name="content_level1"/>
<xsl:param name="content_level2"/>

<xsl:output method="html" version="4.0" encoding="utf-8"/>
<xsl:strip-space elements="text"/>

<xsl:variable name="xml_src" select="'https://github.com/revuloj/verkoj/tree/master/txt/tei_esf/tekstoj'"/>


<!--

XSLT-stildifinoj por TEI-Lite-dokumentoj. 

(c) 2001-2021 che Wolfram DIESTEL
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

<xsl:variable name="stylesheet">teixlite.css</xsl:variable>
<xsl:variable name="_content_level1">
  <xsl:choose>
    <xsl:when test="$content_level1">
      <xsl:value-of select="$content_level1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'chapter'"/>
      </xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<xsl:variable name="_content_level2">
  <xsl:choose>
    <xsl:when test="$content_level2">
      <xsl:value-of select="$content_level2"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'subchapter'"/>
      </xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<!-- dokumento -->

<xsl:template match="/">
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link title="dokumento-stilo" type="text/css" rel="stylesheet"
  href="../css/{$stylesheet}" />
  <title><xsl:value-of select="//titleStmt/title"/></title>
  </head>
  <body background="../bld/papero.jpg">
    <xsl:apply-templates/>
  </body>
  </html>
</xsl:template>

<xsl:template match="TEI">
    <xsl:apply-templates select="teiHeader" mode="header"/>
    <xsl:apply-templates select="*[not(self::teiHeader)]"/>
    <xsl:apply-templates select="teiHeader" mode="footer"/>
</xsl:template>

<!-- teiHeader -->

<xsl:template match="teiHeader" mode="header">
  <xsl:apply-templates select=".//biblStruct"/>
</xsl:template>

<xsl:template match="biblStruct">
  <xsl:apply-templates select=".//title|.//author"/>
</xsl:template>

<xsl:template match="teiHeader" mode="footer">
  <xsl:variable name="file" select="substring-after(base-uri(),'tekstoj/')"/>
  <hr/>
  <address>
    fonto: <a target="_new" href="{$xml_src}/{$file}">
      <xsl:value-of select="$file"/>
    </a>
    <!-- xsl:value-of select="substring-before(substring-after(.,',v'),' revo')"/ -->
  </address>
</xsl:template>


<!-- subtekstoj kaj subdividoj -->

<xsl:template match="text[@rend='doc']|div[@rend='doc']">
  <xsl:result-document method="html" encoding="utf-8" href="{@id}.html">
    <xsl:call-template name="subdoc"/>
  </xsl:result-document>
</xsl:template>

<xsl:template match="text|div">
  <xsl:if test="@id">
    <a name="{@id}"/>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="@type">
      <div class="@type">
        <xsl:apply-templates/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="subdoc">
  <html>
   <head>
     <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
     <link title="stilo" type="text/css" rel="stylesheet"
     href="../css/{$stylesheet}" />
     <title>
     <xsl:call-template name="subdoc-title"/>
     </title>
   </head>
   <body background="../bld/papero.jpg">
     <xsl:call-template name="header"/>
     <xsl:apply-templates/>
     <xsl:call-template name="footer"/>
   </body>
  </html>
</xsl:template>

<!-- kap- kaj piedlinioj -->

<xsl:template name="header">
  <div class="header">

  <xsl:for-each select="preceding-sibling::node()[@rend='doc'][1]">
    <span class="header_left">
      <a href="{@id}.html">
        <xsl:text>&lt;&lt;&nbsp;</xsl:text>
        <xsl:value-of select="head[1]"/>
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
  <hr/>
</xsl:template>

<xsl:template name="footer">
  <hr/>
  <div class="footer">
  <xsl:for-each select="following-sibling::node()[@rend='doc'][1]">
    <a href="{@id}.html">
      <xsl:value-of select="head[1]"/>
      <xsl:text>&nbsp;&gt;&gt;</xsl:text>
    </a>
  </xsl:for-each>
  </div>
</xsl:template>

<!-- titolpagh(j) kaj enhavtabelo -->

<xsl:template match="front">
  <xsl:apply-templates/>
  <hr/>
  
  <!-- enmetu enhavtabelon -->
  <xsl:if test="@rend='index'">
    <xsl:for-each select="..">
      <xsl:call-template name="table-of-content">
        <xsl:with-param name="level1" select="$_content_level1"/>
        <xsl:with-param name="level2" select="$_content_level2"/>
      </xsl:call-template>
    </xsl:for-each>
    <hr/>
  </xsl:if>
</xsl:template>

<xsl:template name="table-of-content">
  <xsl:param name="level1"/>
  <xsl:param name="level2"/>

  <h3 class="contentTitle">Enhavo</h3>
  <ul class="content">
  <xsl:for-each select=".//div[@type=$level1]|.//text[@type=$level1]">

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
          <xsl:call-template name="table-of-content-head"/>
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

            <li class="subcontent">
              <a href="{$ref}">
                <xsl:call-template name="table-of-content-head"/>
              </a>
            </li>
          </xsl:for-each>
        </ul>
      </xsl:if>
    </li>
  </xsl:for-each>
  </ul>
</xsl:template>

<xsl:template name="subdoc-title">
   <xsl:value-of select="(.//head)[1]"/>
</xsl:template>

<xsl:template name="table-of-content-head">
   <xsl:apply-templates select="(.//head)[1]" mode="index"/>
</xsl:template>

<xsl:template match="titlePage">
  <center><xsl:apply-templates/></center>
</xsl:template>

<xsl:template match="title">
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


<xsl:template match="title[@type='subordinate']">
  <h2><xsl:apply-templates/></h2>
</xsl:template>

<xsl:template name="titolbildo"/>

<xsl:template match="titlePage/byline">
  <xsl:apply-templates/><br/>
</xsl:template>

<xsl:template match="docAuthor|author">
  <b class="author"><xsl:apply-templates/></b><br/>
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
  <p align="right" class="signed"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="signed">
  <p align="right" class="signed"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="p[@rend='center']">
  <p align="center" class="center"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="lb">
  <br/>
</xsl:template>

<xsl:template match="lb[@type='hyph']"/>

<xsl:template match="lg">
  <center class="lg"><xsl:apply-templates/></center>
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
  <blockquote class="note"><xsl:apply-templates/></blockquote>
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

<xsl:template match="hi[@rend='italic']|title[@rend='italic']" priority="1">
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

<xsl:template match="sp/p[position()=1]" priority="1">
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

</xsl:transform>











