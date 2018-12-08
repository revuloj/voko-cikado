<!DOCTYPE xsl:stylesheet
[
<!ENTITY leftquot "\guillemotright{}">
<!ENTITY rightquot "\guillemotleft{}">
<!ENTITY singleleftquot "\guilsinglright{}">
<!ENTITY singlerightquot "\guilsinglleft{}">

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

]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
		version="1.0"
                extension-element-prefixes="xt">

<!--

XSLT-stildifinoj por senchesa.xml (La Senchesa Rakonto). 
Ghi importas la bazajn regulojn de teixlite_latex.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.

(c) 2001 che Wolfram DIESTEL
    licenco GPL 2.0

-->

<xsl:import href="teixlite_latex.xsl"/>


<!-- dokumento -->


<xsl:template match="/">\documentclass[a4paper,12pt]{book}
\usepackage[esperanto]{babel}
\usepackage[latin3]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[dvips]{graphicx,color}
\usepackage{picins}

\definecolor{maroon}{rgb}{.5,0,0}
\definecolor{teal}{rgb}{0,.5,.5}

\sloppy

\begin{document}
<xsl:apply-templates/>
\end{document}
</xsl:template>


<xsl:template match="front">
\frontmatter
\pagestyle{empty}
  <xsl:apply-templates/>
</xsl:template>

<!-- titolpagho -->

<xsl:template match="titlePage">
\begin{center}
<xsl:apply-templates/>
\end{center}
\newpage
\pagestyle{plain}
</xsl:template>


<xsl:template match="docAuthor">
\color{maroon} {
{\LARGE <xsl:apply-templates/>}}

\vspace{4\baselineskip}
</xsl:template>


<xsl:template match="docTitle">
<xsl:apply-templates/>
\vfill
</xsl:template>


<xsl:template match="titlePart[@type='main']">
\color{teal} {
\textsc{\Huge <xsl:apply-templates/>}
}

\vspace{3\baselineskip}
</xsl:template>


<xsl:template match="titlePart[@type='main']/lb">
<xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="titlePart">
\color{maroon} {
{\Large <xsl:apply-templates/>\\}
}
</xsl:template>


<xsl:template match="titlePart/hi[@rend='big']"
>{\LARGE <xsl:apply-templates/>}</xsl:template>


<xsl:template match="docImprint/date"><xsl:apply-templates/></xsl:template>

<!-- dividoj -->

<xsl:template match="div[@type='chapter']">
\chapter*{<xsl:value-of select="head"/>}
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="div[@type='color']">
  <xsl:choose>
    <xsl:when test="@rend='maroon'">
\color{maroon} {        
        <xsl:apply-templates/>
}    
    </xsl:when>
    <xsl:otherwise>
\color{teal} {
        <xsl:apply-templates/>
}
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="front/div">
\section*{<xsl:value-of select="head"/>}
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="div[@type='second_page']/div/div">
\subsection*{}
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="p[position()=1 and not (@rend)]">
<xsl:apply-templates select="figure"/>
\vspace{\baselineskip}
\noindent <xsl:apply-templates select="node()[not(self::figure)]"/>
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


<xsl:template match="figure[@rend='initial']">
\parpic{\includegraphics{img/<xsl:value-of 
  select="substring-before(
              substring-after(
		unparsed-entity-uri(@entity),'senchesa/'),'.')"/>.eps}}
</xsl:template>


<xsl:template match="figure">
\begin{center}
\includegraphics{img/<xsl:value-of 
  select="substring-before(
              substring-after(
		unparsed-entity-uri(@entity),'senchesa/'),'.')"/>.eps}
\end{center}
</xsl:template>


</xsl:stylesheet>











