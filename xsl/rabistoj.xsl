<!DOCTYPE xsl:stylesheet 
[
<!ENTITY leftquot '&#xab;'>
<!ENTITY rightquot '&#xbb;'>

<!ENTITY dash  "&#x2015;">
<!ENTITY nbsp "&#x00a0;">
<!ENTITY nbts '&#x202F;'>

]>
<!-- « » -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
 
<!--
 
XSLT-stildifinoj por revizoro.xsl (La Revizoro).
Ghi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.
 
(c) 2001 che Wolfram DIESTEL
    licenco GPL 2.0
 
-->
 
<xsl:import href="teixlite.xsl"/>

<xsl:variable name="stylesheet">rabistoj.css</xsl:variable>
<xsl:variable name="content_level1" select="'act'"/>
<xsl:variable name="content_level2" select="'xxx'"/>


<xsl:template match="div[@type='scene']/head">
  <h4 class="head"><xsl:apply-templates/></h4>
</xsl:template>


<xsl:template match="sp//speaker">
  <xsl:choose>
    <xsl:when test="following-sibling::*[1][self::stage]">
      <span class="speaker"><xsl:apply-templates/></span>,
    </xsl:when>
    <xsl:otherwise>
      <span class="speaker"><xsl:apply-templates/></span>. &dash;
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="div/stage[@rend='head1']">
  <p class="stage"><strong><xsl:apply-templates/></strong></p>
</xsl:template>


<xsl:template match="div/stage[@rend='head2']">
  <p class="stage"><xsl:apply-templates/></p>
</xsl:template>


<xsl:template match="div/stage[not(@rend)]">
  <p class="stage">(<i><xsl:apply-templates/></i>)</p>
</xsl:template>


<xsl:template match="sp//stage">
  <xsl:choose>
    <xsl:when test="preceding-sibling::*[1][self::speaker] and following-sibling::*[1][self::p]">
      <i class="stage"><xsl:apply-templates/></i>. &dash;
    </xsl:when>
    <xsl:when test="preceding-sibling::*[1][self::speaker] and following-sibling::*[1][self::lg]">
      <i class="stage"><xsl:apply-templates/></i>
    </xsl:when>
    <xsl:otherwise>
      (<i class="stage"><xsl:apply-templates/></i>)
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="q">
    <xsl:text>&leftquot;&nbts;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&nbts;&rightquot;</xsl:text>
</xsl:template>



</xsl:stylesheet> 







