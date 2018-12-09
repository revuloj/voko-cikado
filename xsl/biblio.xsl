<!DOCTYPE xsl:stylesheet 
[
<!ENTITY leftquot '"'>
<!ENTITY rightquot '"'>
<!ENTITY dash  "&#x2015;">
<!ENTITY nbsp "&#x00a0;">

]>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
		version="1.0"
                extension-element-prefixes="xt">

<!--

XSLT-stildifinoj por biblio.xml (La Sankta Biblio). 
Ghi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.

(c) 2002 che Wolfram DIESTEL
    permesilo GPL 2.0

-->

<xsl:import href="teixlite.xsl"/>

<xsl:variable name="stylesheet">biblio.css</xsl:variable>
<xsl:variable name="titolbildo">../bld/biblio/lumo.jpg</xsl:variable>

<xsl:template
match="/TEI.2/text//titlePart[@type='main']">
  <h1 class="the_bible"><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template name="titolbildo">
  <xsl:if test="not(ancestor::group)">
    <p class="titolbildo">
    <img align="center" src="{$titolbildo}"/>
    </p>
  </xsl:if>
</xsl:template>

<xsl:template match="div[@type='chapter' or @type='psalm']">
  <div class='dist_chapter'></div>
  <h3 class='chapternr'> <xsl:value-of select="@n"/></h3>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div[@type='psalm']/head">
  <p><em><xsl:apply-templates/></em></p>
</xsl:template>

<xsl:template match="lg[@type='para']">
  <p>
    <xsl:if test="@rend='indent'">
      <xsl:attribute name="class">indent</xsl:attribute>
    </xsl:if>
  <xsl:apply-templates/>
  </p>
</xsl:template>

<!-- normalaj alineoj unua kaj pluaj -->

<xsl:template match="lg[(@type='para') and not (@rend='indent') and 
	      (position()=1)]" priority="1">
  <p class='first_p'>
  <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="lg[(@type='para') and not (@rend='indent') and 
	      (position()>1)]" priority="1">
  <p class='p'>
  <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="lg[position()=1]/l[position()=1]">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="l">
  <xsl:if test="not (@rend='cont')">
    <em class='versenr'><xsl:text> </xsl:text><xsl:value-of select="@n"/></em>
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<!-- poemecaj alineoj -->

<xsl:template match="lg[(@rend='indent') and (position()=1)]/l[position()=1]" priority="1">
  <p class='indent_first'>
  <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="lg/head">
  <h4 class='stanza_head'>
  <xsl:apply-templates/>
  </h4>
</xsl:template>

<xsl:template match="lg[@rend='indent']/l">
  <xsl:choose>
    <xsl:when test="@n='1'">
      <p class='verse_indent_first'>
        <xsl:apply-templates/>
      </p>
    </xsl:when>
    <xsl:when test="@rend='cont'">
      <p class='verse_indent_cont'>
        <xsl:apply-templates/>
      </p>
    </xsl:when>
    <xsl:otherwise>
      <p class='verse_indent'>
      <span class='versenr_indent'><xsl:value-of select="@n"/></span>
      <xsl:text> </xsl:text>
      <span class='versetext_indent'>
        <xsl:apply-templates/>
      </span>
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="lg[@rend='indent']/l/lb[position()=last()]"/>

<xsl:template match="hi[@rend='sela']">
  <span class="sela"><xsl:apply-templates/></span>
</xsl:template>

<!-- pro enhavtabelo -->
<xsl:template match="front">
  <xsl:apply-templates/>
  <hr/>
  
  <!-- enmetu enhavtabelon -->
  <xsl:if test="@rend='index'">
    <h3 class="contentTitle">Enhavo</h3>
    <ul class="content">
      <xsl:for-each select="..//div[index]">
        <li class="content">
          <a href="{@id}.html">
           <xsl:value-of select="index[@index='content']/@level1"/>
          </a>
        </li>
      </xsl:for-each>
    </ul>
    <hr/>
  </xsl:if>
</xsl:template>

<xsl:template name="header">
  <div class="header">

  <xsl:for-each select="preceding-sibling::node()[@rend='doc'][1]">
    <span class="header_left">
      <a href="{@id}.html">
        <xsl:text>&lt;&lt;&nbsp;</xsl:text>
        <xsl:value-of select="index[@index='content']/@level1"/>
      </a>
    </span>
  </xsl:for-each>

  <span class="header_center">
    <xsl:text> </xsl:text>
    <xsl:for-each select="ancestor::text[@id]">
      <a href="index.html#{@id}">
        <xsl:value-of select="front//titlePart[@type='main']"/>
      </a>
    </xsl:for-each>
  </span>

  </div>
  <hr/>
</xsl:template>

<xsl:template name="footer">
  <hr/>
  <div class="footer">
  <xsl:for-each select="following-sibling::node()[@rend='doc'][1]">
    <a href="{@id}.html">
      <xsl:value-of select="index[@index='content']/@level1"/>
      <xsl:text>&nbsp;&gt;&gt;</xsl:text>
    </a>
  </xsl:for-each>
  </div>
</xsl:template>


</xsl:stylesheet>











