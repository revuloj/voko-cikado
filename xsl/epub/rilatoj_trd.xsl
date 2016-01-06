<!DOCTYPE xsl:stylesheet
[
  <!ENTITY leftquot '"'>
  <!ENTITY rightquot '"'>
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
       		version="1.0"
                extension-element-prefixes="xt">

<!--

Transformreguloj por eltiri tradukojn el indekso de Revo (inx_ord.xml)

(c) 2010-2012 che Wolfram DIESTEL
    licenco GPL 2.0

-->

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<xsl:param name="verbose" select="'false'"/>

<xsl:key name="tradukoj" 
  match="indekso/trd-oj[@lng='de' or @lng='en' or @lng='ru' or @lng='fr' or @lng='hu' or @lng='nl']//v[t]" use="@mrk"/>


<xsl:template match="/">
    <trd>
      <!-- elektu por ĉiu traduklisto/mrk reprezentanton -->
      <xsl:for-each select="//v[count(.|key('tradukoj',@mrk)[1])=1]">
        <v mrk="{@mrk}">
          <xsl:for-each select="key('tradukoj',@mrk)/t">
          <t lng="{ancestor::trd-oj/@lng}">
            <xsl:value-of select="."/>
          </t>
        </xsl:for-each>
      </v>
    </xsl:for-each>
        <!--      <xsl:apply-templates select="indekso/trd-oj[@lng='de' or @lng='en' or @lng='ru' or @lng='fr' or @lng='hu' or @lng='nl']"/> -->
    </trd>
</xsl:template>

<!--
<xsl:template match="trd-oj">
  <xsl:copy-of select="."/>
</xsl:template>
-->

</xsl:stylesheet>










