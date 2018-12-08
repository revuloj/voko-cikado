<!DOCTYPE xsl:stylesheet>

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


<!-- titolpagho -->

<xsl:template match="titlePage">
\begin{center}
<xsl:apply-templates/>
\end{center}
\newpage
</xsl:template>

<xsl:template match="docTitle">
<xsl:apply-templates/>
\vfill
</xsl:template>

<xsl:template match="titlePart[@type='main']">
\textsc{\Huge <xsl:apply-templates/>\\}

\vspace{3\baselineskip}
</xsl:template>

<xsl:template match="titlePart">
 <xsl:apply-templates/>\\
</xsl:template>

<xsl:template match="docImprint">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="docImprint/date"><xsl:apply-templates/></xsl:template>

</xsl:stylesheet>











