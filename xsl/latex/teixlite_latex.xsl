<!DOCTYPE xsl:stylesheet 
[
<!ENTITY leftquot "``">
<!ENTITY rightquot "''">
<!ENTITY singleleftquot "`">
<!ENTITY singlerightquot "'">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
		version="1.0"
                extension-element-prefixes="xt">



<xsl:output method="text" encoding="utf-8"/>
<xsl:strip-space elements="text p q"/>

<!--

XSLT-stildifinoj por TEI-Lite-dokumentoj. 

(c) 2001 che Wolfram DIESTEL
    licenco GPL 2.0

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

<!-- dokumento -->

<xsl:template match="/">\documentclass[a4paper,12pt]{book}
\usepackage[esperanto]{babel}
\usepackage[latin3]{inputenc}
\usepackage[T1]{fontenc}

\begin{document}
<xsl:apply-templates/>
\end{document}
</xsl:template>


<!-- teiHeader -->

<xsl:template match="teiHeader"/>




<!-- subtekstoj kaj subdividoj -->

<xsl:template match="body">
\mainmatter
\pagestyle{plain}
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="div[@type='chapter']">
  <xsl:choose>
    <xsl:when test="head">
\chapter{<xsl:value-of select="head"/>}
    </xsl:when>
    <xsl:otherwise>
\chapter*{}
    </xsl:otherwise>
  </xsl:choose>
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="div">
  <xsl:choose>
    <xsl:when test="head">
\section{<xsl:value-of select="head"/>}
    </xsl:when>
    <xsl:otherwise>
\section*{}
    </xsl:otherwise>
  </xsl:choose>
<xsl:apply-templates/>
</xsl:template>


<!-- titolpagh(j) kaj enhavtabelo -->

<xsl:template match="front">
\frontmatter
\pagestyle{empty}
  <xsl:apply-templates/>

  <!-- enmetu enhavtabelon -->
  <xsl:if test="@rend='index'">
\tableofcontents</xsl:if>
</xsl:template>

<xsl:template match="front/div">
\section*{<xsl:value-of select="head"/>}
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="titlePage">
<xsl:apply-templates mode="titlePage"/>
\maketitle
</xsl:template>

<xsl:template match="docTitle" mode="titlePage">
  <xsl:choose>
    <xsl:when test="titlePart">
      <xsl:apply-templates mode="titlePage"/>
    </xsl:when>
    <xsl:otherwise>
\title{<xsl:apply-templates mode="titlePage"/>}
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="docAuthor" mode="titlePage">
\author{<xsl:apply-templates mode="titlePage"/>}
</xsl:template>

<xsl:template match="titlePart[@type='main']" mode="titlePage">
\title{<xsl:apply-templates mode="titlePage"/>}
</xsl:template>

<xsl:template match="docImprint" mode="titlePage">
<xsl:apply-templates mode="titlePage"/>
</xsl:template>

<xsl:template match="docImprint/date" mode="titlePage">
\date{<xsl:apply-templates mode="titlePage"/>}
</xsl:template>

<xsl:template match="lb" mode="titlePage">
  <xsl:text>\\</xsl:text>
</xsl:template>

<!-- alineaj tekst-elementoj -->

<xsl:template match="head">
</xsl:template>

<xsl:template match="p">
<xsl:apply-templates/>
<xsl:text>

</xsl:text>
</xsl:template>

<xsl:template match="p[position()=1 and not (@rend)]">
\noindent <xsl:apply-templates/>
</xsl:template>

<xsl:template match="signed|p[@rend='signed']">
\begin{flushright}
<xsl:apply-templates/>
\end{flushright}
</xsl:template>

<xsl:template match="p[@rend='center']">
\begin{center}
<xsl:apply-templates/>
\end{center}
</xsl:template>

<xsl:template match="lb">
  <xsl:text>\\</xsl:text>
</xsl:template>

<xsl:template match="lb[@type='hyph']">\-</xsl:template>

<xsl:template match="lg">
\begin{flushleft}
\begin{verse}
<xsl:apply-templates/>
\end{verse}
\end{flushleft}
</xsl:template>

<xsl:template match="lg[@rend='center']">
\begin{center}
<xsl:apply-templates/>
\end{center}
</xsl:template>

<xsl:template match="lg[@type='stanza']">
<xsl:apply-templates/>

</xsl:template>

<xsl:template match="l"><xsl:apply-templates/>\\
</xsl:template>

<!--
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

-->

<!-- enliniaj tekstelementoj -->

<xsl:template match="mentioned|p/title">
  <xsl:text>&leftquot;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&rightquot;</xsl:text>
</xsl:template>

<xsl:template match="q">
  <xsl:choose>
    <xsl:when test="@rend='&#34; '">
      <xsl:text>&leftquot;</xsl:text>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:when test="@rend='  '">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:when test="@rend=' &#34;'">
      <xsl:apply-templates/>
      <xsl:text>&rightquot;</xsl:text>
    </xsl:when>
    <xsl:when test='@rend="&#39;"'>
      <xsl:text>&singleleftquot;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&singlerightquot;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>&leftquot;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&rightquot;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="emph|foreign">
<xsl:text>\emph{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="hi">
<xsl:text>\textbf{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="hi[@rend='italic']">
<xsl:text>\textit{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="hi[@rend='big']">
<xsl:text>\textsc{\LARGE </xsl:text>
<xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match='q[@rend="&#39;"]'>
  <xsl:text>&singleleftquot;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&singlerightquot;</xsl:text>
</xsl:template>

<!--
<xsl:template match="xref">
  <a href="{.}">
  <xsl:apply-templates/>
  </a>
</xsl:template>

-->

<xsl:template match="text()">
  <xsl:value-of select="."/>
</xsl:template>


</xsl:stylesheet>











