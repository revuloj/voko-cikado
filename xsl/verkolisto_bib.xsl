<!DOCTYPE xsl:transform>

<!-- 
    (c) 2021 ĉe Wolfram DIESTEL
    laŭ permesilo GPL 2.0

    eltiras bibliografiajn informojn el la TEI-XML-strukturo por faciligi la aldonon al la bibliografiod de Revo / redaktiloj -->

<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://saxon.sf.net/"
  version="2.0"
  extension-element-prefixes="saxon" 
  xmlns:tei="http://www.tei-c.org/ns/1.0">

    <xsl:param name="xml_base_url"/>
    <xsl:param name="steloj_base_url"/>
    <xsl:param name="tekstaro_base_url"/>

    <xsl:variable name="xml" select="'/txt/tei2/'"/>
    <xsl:variable name="esf" select="'/txt/tei_esf/tekstoj/'"/>
    <xsl:variable name="collection" select="concat($xml_base_url,$xml,'?select=*.xml')"/>
    <xsl:variable name="collection_esf" select="concat($xml_base_url,$esf,'?select=*.xml')"/>

    <xsl:output method="xml" indent="yes"/>
  
    <xsl:template match="/">
        <bibliografio>
            <xsl:apply-templates 
                select="collection($collection)//teiHeader/fileDesc"/>
            <xsl:apply-templates 
                select="collection($collection_esf)//tei:teiHeader//tei:biblStruct"/>
        </bibliografio>
    </xsl:template>


    <xsl:template match="fileDesc">
        <!-- xsl:variable name="dosiero" select="substring-before(substring-after(.,'$Id: '),'.xml')"/-->
        <xsl:variable name="dosiero" select="substring-before(substring-after(base-uri(),$xml),'.xml')"/>
        <xsl:if test="not($dosiero='senchesa') and not($dosiero='merkato')">
            <vrk mll="{$dosiero}">
                <url><xsl:value-of select="concat($steloj_base_url,$dosiero)"/></url>
                <xsl:for-each select="titleStmt/author[1]">
                    <aut><xsl:value-of select="."/></aut>
                </xsl:for-each>
                <xsl:for-each select="titleStmt/respStmt[contains(resp[1],'tradukis')]/name">
                    <trd>
                    <xsl:choose>
                        <xsl:when test="contains(.,'(')">
                            <xsl:value-of select="substring-before(.,'(')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                    </trd>
                </xsl:for-each>
                <xsl:for-each select="titleStmt/title[1]">
                    <tit><xsl:value-of select="."/></tit>
                </xsl:for-each>

                <xsl:for-each select=".//publicationStmt[1]">
                    <eld><xsl:apply-templates/></eld>
                </xsl:for-each>
            </vrk>
        </xsl:if>
    </xsl:template>

    <xsl:template
        match="tei:biblStruct">
        <!-- xsl:variable name="dosiero" select="substring-before(substring-after(.,'$Id: '),'.xml')"/-->
        <xsl:variable name="dosiero" select="substring-before(substring-after(base-uri(),$esf),'.xml')"/>
        <vrk mll="{$dosiero}">
            <url><xsl:value-of select="concat($tekstaro_base_url,$dosiero)"/></url>
            <xsl:for-each select="(.//tei:author)[1]">
                <aut><xsl:value-of select="."/></aut>
            </xsl:for-each>
            <xsl:for-each select=".//tei:respStmt[contains(tei:resp[1],'tradukis')]/tei:name">
                <trd>
                <xsl:choose>
                    <xsl:when test="contains(.,'(')">
                        <xsl:value-of select="substring-before(.,'(')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
                </trd>
            </xsl:for-each>
            <xsl:for-each select="(.//tei:title)[1]">
                <tit><xsl:value-of select="."/></tit>
            </xsl:for-each>
<!--
    <eld>
      <nom>J. R&eacute;gulo</nom>
      <lok>La Laguna</lok>
      <dat>1963</dat>
    </eld>
-->

            <xsl:for-each select=".//tei:imprint[1]">
                <eld><xsl:apply-templates/></eld>
            </xsl:for-each>

        </vrk>
    </xsl:template>


<!--
    <publicationStmt>
      <publisher>Sennacieca Asocio Tutmonda</publisher>
      <pubPlace>Leipzig</pubPlace>
      <date>1929</date>
    </publicationStmt>

    ==>

    <eld>
      <nom>J. R&eacute;gulo</nom>
      <lok>La Laguna</lok>
      <dat>1963</dat>
    </eld>
-->

    <xsl:template match="publisher|tei:publisher">
        <nom><xsl:value-of select="."/></nom>
    </xsl:template>

    <xsl:template match="pubPlace|tei:pubPlace">
        <lok><xsl:value-of select="."/></lok>
    </xsl:template>

    <xsl:template match="date|tei:date">
        <dat><xsl:value-of select="."/></dat>
    </xsl:template>

</xsl:transform>