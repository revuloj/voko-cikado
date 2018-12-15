<!DOCTYPE xsl:stylesheet 
[
<!ENTITY nbsp "&#x00a0;">
<!ENTITY ubreve "&#x016d;">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
		version="1.0"
                extension-element-prefixes="xt">


<!--

XSLT-stildifinoj por paroloj.tei (Zamenhofaj paroloj). 
Ghi importas la bazajn regulojn el teixlite.xsl kaj 
enhavas mem nur la dokument-specifajn regulojn.

(c) 2001 che Wolfram DIESTEL
    licenco GPL 2.0

-->

<xsl:import href="teixlite.xsl"/>
<xsl:variable name="content_level1" select="'speech'"/>
<xsl:variable name="content_level2" select="'xxx'"/>

<!-- teiHeader -->

<xsl:template match="teiHeader">
  <center>
  <xsl:apply-templates select="fileDesc/titleStmt|fileDesc/sourceDesc"
		       mode="teiHeader"/>
  </center>
</xsl:template>

<xsl:template match="title" mode="teiHeader">
  <h1><xsl:apply-templates mode="teiHeader"/></h1>
</xsl:template>

<xsl:template match="author" mode="teiHeader">
  <p><xsl:apply-templates mode="teiHeader"/></p>
</xsl:template>


<xsl:template match="respStmt"
	      mode="teiHeader">
  <cite><xsl:apply-templates/></cite><br/>
</xsl:template>

<xsl:template match="sourceDesc"
	      mode="teiHeader">
  <p><i>fonto:</i> <xsl:apply-templates select="//xref"/></p>
</xsl:template>

<xsl:template match="publicationStmt|extent|langUsage" 
	      mode="teiHeader"/>


<xsl:template match="teiHeader"
	      mode="piedlinio">
  <!-- <xsl:apply-templates select="fileDesc/publicationStmt"
		       mode="piedlinio"/> -->
</xsl:template>

<xsl:template match="publicationStmt"
	      mode="piedlinio">
  <address>
  <!-- enmetu referencon al XML-dosiero... -->

  <xsl:value-of select="publisher"/>
  <xsl:text>, </xsl:text>
  <xsl:value-of select="pubPlace"/>
  </address>
</xsl:template>

  <!-- ellasu la precipan titolpaghon "front", char
       la informoj jam aperas el la teiHeader -->
<xsl:template match="front/titlePage"/>

<xsl:template match="text[@rend='doc']/docTitle">
  <h3><xsl:apply-templates/></h3>
</xsl:template>

<xsl:template match="titlePart[@type='main']">
  <h3><xsl:apply-templates/></h3>
</xsl:template>

<xsl:template match="titlePage/byline">
  <p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="docImprint">
  <p align="right"><cite><xsl:apply-templates/></cite></p>
</xsl:template>

<xsl:template name="header">
  <div class="header">

  <xsl:for-each select="preceding-sibling::node()[@rend='doc'][1]">
    <span class="header_left">
      <a href="{@id}.html">
        <xsl:text>&lt;&lt;&nbsp;Anta&ubreve;a Parolado</xsl:text>
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
      <xsl:text>Sekva Parolado&nbsp;&gt;&gt;</xsl:text>
    </a>
  </xsl:for-each>
  </div>
</xsl:template>

</xsl:stylesheet>











