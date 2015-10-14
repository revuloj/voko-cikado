<!DOCTYPE xsl:stylesheet 
[
<!ENTITY nbsp "&#x00a0;">
]>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
                version="1.0"
                extension-element-prefixes="xt">

<!--

XSLT-stildifinoj por butiko.xml (La Stranga Butiko). 
Ghi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.

(c) 2002 che Wolfram DIESTEL
    permesilo GPL 2.0

-->

<xsl:import href="teixlite.xsl"/>

<xsl:variable name="stylesheet">butiko.css</xsl:variable>
<xsl:variable name="content_level1" select="'poem'"/>
<xsl:variable name="content_level2" select="'xxxx'"/>

<xsl:template match="body">
  <xsl:apply-templates select="div[@type='foreword']"/>

  <hr/>
  <xsl:call-template name="table-of-content">
    <xsl:with-param name="level1" select="$content_level1"/>
    <xsl:with-param name="level2" select="$content_level2"/>
  </xsl:call-template>
  <hr/>

  <xsl:apply-templates select="div[@type='poem']"/>
  <xsl:apply-templates select="div[@type='epilog']"/>
</xsl:template>


<xsl:template name="table-of-content-head">
   <xsl:apply-templates mode="toc-head" select="(.//head)[1]"/>
</xsl:template>

<xsl:template mode="toc-head" match="head/note"/>
<xsl:template mode="toc-head" match="head">
  <xsl:apply-templates mode="toc-head"/>
</xsl:template>

<!-- shajnas esti cimo en xt tia, ke ne trovighas la precipa titolo,
   do mi helpas malsupre chi trovi ghin -->
<xsl:template name="header">
  <div class="header">

  <xsl:for-each select="preceding-sibling::node()[@rend='doc'][1]">
    <span class="header_left">
      <a href="{@id}.html">
        <xsl:text>&lt;&lt;&nbsp;</xsl:text>
        <xsl:call-template name="table-of-content-head"/>
      </a>
    </span>
  </xsl:for-each>

  <span class="header_center">
    <xsl:text> </xsl:text>
    <a href="index.html">
      <xsl:for-each select="//front[1]//docAuthor">
        <xsl:value-of select="."/>:
      </xsl:for-each>
      <xsl:value-of select="//front[1]//docTitle/titlePart[@type='main']"/> 
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
      <xsl:call-template name="table-of-content-head"/>
      <xsl:text>&nbsp;&gt;&gt;</xsl:text>
    </a>
  </xsl:for-each>
  </div>
</xsl:template>


<xsl:template match="head">
  <xsl:apply-templates select="note"/>
  <h3 class="head"><xsl:apply-templates select="text()|*[not(self::note)]"/></h3>
</xsl:template>


<xsl:template match="figure">
  <p align='center'>
  <img src="{unparsed-entity-uri(@entity)}" alt="{@entity}" vspace="20"/>
  </p>
</xsl:template>


<xsl:template match="lg[@rend='poem']">
  <xsl:apply-templates/>
  <xsl:call-template name="footnotes"/>
</xsl:template>

<xsl:template match="note[@type='footnote']">
  <xsl:text> </xsl:text>
  <a href="#fn_{@rend}"><xsl:value-of select="@rend"/></a>
</xsl:template>

<xsl:template name="footnotes">
  <xsl:if test="..//note[@type='footnote']">
    <hr/>
    <xsl:for-each select="..//note[@type='footnote']">
      <p>
        <a name="fn_{@rend}"/>
        <xsl:value-of select="@rend"/><xsl:text> </xsl:text>
        <xsl:apply-templates select="text()|p|q"/>
      </p>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<xsl:template match="l[@rend='center']">
  <p align="center" class="lcenter">
    <xsl:apply-templates/>
  </p>
</xsl:template>

</xsl:stylesheet>
