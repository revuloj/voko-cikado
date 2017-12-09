<!DOCTYPE xsl:transform
[
<!ENTITY nbsp "&#x00a0;">
]>


<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://saxon.sf.net/"
  version="2.0"
  extension-element-prefixes="saxon" >

<!--

XSLT-stildifinoj por krei liston de la verkoj.

(c) 2007-2017 che Wolfram DIESTEL
    permesilo GPL 2.0

-->
<xsl:variable name="listostilo">verkolisto.css</xsl:variable>
<xsl:variable name="verkostilo">verkotitolo.css</xsl:variable>
<xsl:variable name="bildo">bld/ursoajlo.jpg</xsl:variable>

<xsl:output method="html" version="4.0"/>

<xsl:key name="verkoj" match="//verko[autoro]" use="autoro"/>


<xsl:template match="/">
  <html>
    <head>
       <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
       <title>Elekto de originalaj kaj tradukitaj esperantlingvoj verkoj</title>
       <xsl:comment>link rel="SHORTCUT ICON" href="stelo.ico"</xsl:comment>
    </head>

    <frameset cols="33%,*">
      <frame name="listo" src="listo.html"/><xsl:call-template name="listo"/>
      <frame scrolling="yes" name="verko" src="titolo.html"/><xsl:call-template name="titolo"/>

      <noframes>
        <h1>Elekto de originalaj kaj tradukitaj esperantlingvoj verkoj</h1>
        <xsl:apply-templates/>
      </noframes>
    </frameset>
  </html>
</xsl:template>


<xsl:template name="listo">
  <!-- redirect:write select="@dosiero" -->
  <xsl:result-document href="listo.html" method="html" version="4.0"
      encoding="utf-8" indent="no">

   <html>
     <head>
       <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
       <link title="dokumento-stilo" type="text/css" rel="stylesheet"
          href="css/{$listostilo}" />
       <title>Verkolisto</title>
     </head>
     <body background="bld/papero.jpg">
       <xsl:apply-templates select="verkolisto"/>
     </body>
   </html>

  <!-- /redirect:write -->
  </xsl:result-document>
</xsl:template>


<xsl:template name="titolo">
  <!-- redirect:write select="@dosiero" -->
  <xsl:result-document href="titolo.html" method="html" version="4.0"
      encoding="utf-8" indent="no">

   <html>
     <head>
       <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
       <link title="dokumento-stilo" type="text/css" rel="stylesheet"
          href="css/{$verkostilo}" />
       <title>Elekto de originalaj kaj tradukitaj esperantlingvoj verkoj</title>
     </head>
     <body background="bld/papero.jpg">
       <h1>Elekto de originalaj kaj 
        tradukitaj esperantlingvoj verkoj</h1>

       <img src="{$bildo}" alt="titolbildo" align="center" class="titolbildo"/>
        
       <p>Tiuj tekstoj esti&#x011d;is kadre de projekto celanta disponigi
       bazajn tekstojn de Esperanto en unueca stilo en Interreto.
       Inter alie ili uzi&#x011d;as kiel esplormaterialo por laboro
       &#x0109;e <a href="http://purl.org/net/voko/revo/" target="_new">Reta Vortaro</a>.</p>

     </body>
   </html>

  <!-- /redirect:write -->
  </xsl:result-document>
</xsl:template>


<xsl:template match="verkolisto">
  <h1>verkoj</h1>
  <ul class="senautoraj">
    <xsl:for-each select="verko[not(autoro)]">
        <li><xsl:apply-templates select="titolo"/></li>
    </xsl:for-each>
  </ul>
  <ul class="autoroj">
    <xsl:for-each-group select="verko" group-by="autoro">
       <xsl:sort select="autoro"/>
       <li><p class="autoro"><!-- xsl:value-of select="autoro"/-->
 
	 <xsl:variable name="aut">
	   <xsl:value-of select="current-grouping-key()"/>
	 </xsl:variable>
         <xsl:value-of select="$aut"/>
	   
         <xsl:if test="tradukinto">
           <span class="trad"><xsl:text> (trad. </xsl:text>

             <!-- xsl:for-each select="(key('verkoj',autoro)/tradukinto)" -->
             <xsl:for-each select="distinct-values(//verko[autoro=$aut]/tradukinto)">
               <xsl:value-of select="."/>
               <!-- xsl:value-of select="tradukinto"/ -->
               <xsl:if test="position() != last()">
                 <xsl:text>, </xsl:text>
               </xsl:if> 
             </xsl:for-each>
           
             <xsl:text>)</xsl:text>
           </span>
         </xsl:if>

         </p>

         <ul class="verkoj">
         <xsl:for-each select="key('verkoj',autoro)">
           <li><xsl:apply-templates select="titolo"/></li>
         </xsl:for-each>
         </ul>
       </li>
    </xsl:for-each-group>
  </ul>
</xsl:template>

<xsl:template match="titolo">
  <a href="{../@dosiero}" target="verko"><xsl:value-of select="."/></a>
</xsl:template>




</xsl:transform>
