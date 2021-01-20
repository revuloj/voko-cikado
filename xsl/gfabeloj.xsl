<!DOCTYPE xsl:transform 
[
<!ENTITY nbsp "&#x00a0;">
]>

<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://saxon.sf.net/"
  version="2.0"
  extension-element-prefixes="saxon" 
>

<!--

XSLT-stildifinoj por esenco.xml (Esenco kaj estonteco de Zamenhof). 
Ghi importas la bazajn regulojn de teixlite.xsl kaj enhavas nur
specialajn regulojn ne au alie difinitajn tie.

(c) 2002 che Wolfram DIESTEL
    permesilo GPL 2.0

-->

<xsl:import href="teixlite.xsl"/>

<xsl:variable name="content_level1" select="'story'"/>
<xsl:variable name="content_level2" select="'xxx'"/>

</xsl:transform>
