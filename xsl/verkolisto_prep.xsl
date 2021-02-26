<!DOCTYPE xsl:transform>

<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://saxon.sf.net/"
  version="2.0"
  extension-element-prefixes="saxon" 
  xmlns:tei="http://www.tei-c.org/ns/1.0">

    <xsl:param name="xml_base_url"/>

    <xsl:variable name="xml" select="'/txt/tei2/'"/>
    <xsl:variable name="esf" select="'/txt/tei_esf/tekstoj/'"/>
    <xsl:variable name="collection" select="concat($xml_base_url,$xml,'?select=*.xml')"/>
    <xsl:variable name="collection_esf" select="concat($xml_base_url,$esf,'?select=*.xml')"/>
  
    <xsl:template match="/">
        <verkolisto>
            <xsl:apply-templates 
                select="collection($collection)//teiHeader/fileDesc"/>
            <!-- xsl:apply-templates 
                select="collection($collection_esf)//tei:teiHeader//tei:biblStruct"/ -->
        </verkolisto>
    </xsl:template>

<!--
<verkolisto>
  <verko dosiero="paroloj/index.html">
    <titolo>Paroladoj</titolo>
    <autoro>L. L. Zamenhof</autoro>
  </verko>
 ... 
  -->

    <xsl:template match="fileDesc">
        <!-- xsl:variable name="dosiero" select="substring-before(substring-after(.,'$Id: '),'.xml')"/-->
        <xsl:variable name="dosiero" select="substring-before(substring-after(base-uri(),$xml),'.xml')"/>
        <xsl:if test="not($dosiero='senchesa') and not($dosiero='merkato')">
            <verko dosiero="{$dosiero}/index.html">
                <xsl:for-each select="titleStmt/title[1]">
                    <titolo><xsl:value-of select="."/></titolo>
                </xsl:for-each>
                <xsl:for-each select="titleStmt/author[1]">
                    <autoro><xsl:value-of select="."/></autoro>
                </xsl:for-each>
                <xsl:for-each select="titleStmt/respStmt[contains(resp[1],'tradukis')]/name">
                    <tradukinto>
                    <xsl:choose>
                        <xsl:when test="contains(.,'(')">
                            <xsl:value-of select="substring-before(.,'(')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                    </tradukinto>
                </xsl:for-each>
            </verko>
        </xsl:if>
    </xsl:template>

    <xsl:template
        match="tei:biblStruct">
        <!-- xsl:variable name="dosiero" select="substring-before(substring-after(.,'$Id: '),'.xml')"/-->
        <xsl:variable name="dosiero" select="substring-before(substring-after(base-uri(),$esf),'.xml')"/>
        <verko dosiero="{$dosiero}/index.html">
            <xsl:for-each select="(.//tei:title)[1]">
                <titolo><xsl:value-of select="."/></titolo>
            </xsl:for-each>
            <xsl:for-each select="(.//tei:author)[1]">
                <autoro><xsl:value-of select="."/></autoro>
            </xsl:for-each>
            <xsl:for-each select=".//tei:respStmt[contains(tei:resp[1],'tradukis')]/tei:name">
                <tradukinto>
                <xsl:choose>
                    <xsl:when test="contains(.,'(')">
                        <xsl:value-of select="substring-before(.,'(')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
                </tradukinto>
            </xsl:for-each>
        </verko>
    </xsl:template>

</xsl:transform>