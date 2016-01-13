<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet
[
  <!ENTITY leftquot '"'>
  <!ENTITY rightquot '"'>
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
                xmlns="http://www.w3.org/1999/xhtml"
		version="1.0"
                extension-element-prefixes="xt"
  doctype-public="-//W3C//DTD XHTML 1.1//EN"
  doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<!--

XSLT-stildifinoj por tez_ret.xml (tezauro de Reta Vortaro).
Transformreguloj por krei XHTML-dokumenton por EPub libro.

(c) 2010-2016 ĉe Wolfram DIESTEL
    licenco GPL 2.0

    klarigoj de strukturiloj:

     k = kapvorto
     r = referenco
     @c = celo
     t = traduko

     La tezaŭro konsistas el nodoj, kiuj respondas al sencoj de la vortoj.
     El ĉiu nodo iras referencoj al aliaj nodoj. Ĉiu referenco havas tipon kiel sinonimo, supernocio k.s.

-->

<xsl:output method="xhtml" version="1.1" encoding="utf-8"
	doctype-public="-//W3C//DTD XHTML 1.1//EN"
	doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
/>

<xsl:strip-space elements="k prt malprt super sub sin ant trd"/>

<xsl:param name="verbose" select="'false'"/>
<xsl:param name="warn-about-dead-refs" select="'false'"/>


<!-- xsl:variable name="fakoj">../cfg/fakoj.xml</xsl:variable -->

<xsl:variable name="lower" select="'abcĉdefgĝhĥijĵklmnoprsŝtuŭvz'"/>  
<xsl:variable name="upper" select="'ABCĈDEFGĜHĤIJĴKLMNOPRSŜTUŬVZ'"/>
<xsl:variable name="root" select="/"/>

<!-- esperanta vortindekso -->

<xsl:key name="eoletters" match="//nod" use="translate(substring(k,1,1),$lower,$upper)"/>
<xsl:key name="eowords" match="//nod" use="k"/>


<xsl:template name="file-name">
  <xsl:param name="str"/>

  <xsl:variable name="letter" select="translate(substring($str,1,1),$lower,$upper)"/>

  <xsl:choose>
    <xsl:when test="$letter='Ĉ'">
      <xsl:text>Cx</xsl:text>
    </xsl:when>
    <xsl:when test="$letter='Ĝ'">
      <xsl:text>Gx</xsl:text>
    </xsl:when>
    <xsl:when test="$letter='Ĥ'">
      <xsl:text>Hx</xsl:text>
    </xsl:when>
    <xsl:when test="$letter='Ĵ'">
      <xsl:text>Jx</xsl:text>
    </xsl:when>
    <xsl:when test="$letter='Ŝ'">
      <xsl:text>Sx</xsl:text>
    </xsl:when>
    <xsl:when test="$letter='Ŭ'">
      <xsl:text>Ux</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$letter"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>.xhtml</xsl:text>
</xsl:template>


<xsl:template name="wordindex">
  <xsl:param name="nletter"/>
  <xsl:variable name="letter" select="substring($upper,$nletter,1)"/>

  <xsl:if test="$letter">
    <xsl:call-template name="letter">
      <xsl:with-param name="firstletter" select="$letter"/>
    </xsl:call-template>

    <xsl:call-template name="wordindex">
      <xsl:with-param name="nletter" select="1+$nletter"/>
    </xsl:call-template>
  </xsl:if>

</xsl:template>



<xsl:template name="letter">
  <xsl:param name="firstletter"/>

  <xsl:variable name="letterdesc">
    <xsl:value-of select="$firstletter"/>
  </xsl:variable>

  <xsl:variable name="file">
    <xsl:call-template name="file-name">
      <xsl:with-param name="str" select="$firstletter"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:message>
    <xsl:value-of select="$file"/>
  </xsl:message>


  <xt:document 
    href="{$file}" 
    method="xhtml" 
    version="1.1"
    encoding="utf-8" 
    indent="no"
    doctype-public="-//W3C//DTD XHTML 1.1//EN"
    doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
    
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <link title="stilo" type="text/css" rel="stylesheet" href="css/rilatoj_epub.css"/>
      <title>Rilatoj inter vortoj, litero <xsl:value-of select="$letterdesc"/></title>
    </head>
    <body> 

      <h1 id="{$firstletter}">
        <xsl:value-of select="$letterdesc"/>
      </h1>
    
      <!-- elektu chiujn vortojn kun sama komenclitero -->
      
      <xsl:for-each select="key('eoletters',$firstletter)
                            [count(.|key('eowords',k)[1])=1]"> 
      
        <!-- ordigu ilin -->
        <xsl:sort lang="eo" select="k"/> 
        <!-- kaj listigu nun -->
        
        <xsl:call-template name="entry"/>
    
      </xsl:for-each> 

    </body>
  </html>
</xt:document>

</xsl:template>

<!-- ________________________________________________________________ -->     

<!-- tie ĉi komenciĝas transformado de rilatoj.xml                    -->
<!-- ________________________________________________________________ -->   


<xsl:template match="/">
  <html>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/> 
      <title>Rilatoj inter vortoj</title>
      <link title="stilo" type="text/css" 
        rel="stylesheet" href="css/rilatoj_epub.css"/>
    </head>
    <body>
      <h1>Rilatoj inter vortoj</h1>
      <p>
        Tiu ĉi vortaro estas eltiraĵo el Reta Vortaro (http://reta-vortaro.de),
        kompilita kiel elektronika libro de Volframo Distel'.
      </p>
      <p>
        <xsl:comment>$hodiau$</xsl:comment>
      </p>
      <h2>
        Signifo de la fakoj:
      </h2>
      <dl class="fako" compact="compact">
      <xsl:for-each select="//fakoj/fako">
          <dt class="kodo"><xsl:value-of select="@kodo"/>:</dt>
          <dd class="klarigo"><xsl:value-of select="."/></dd>
        </xsl:for-each>
      </dl>
      <xsl:call-template name="wordindex">
        <xsl:with-param name="nletter" select="1"/>
      </xsl:call-template>
    </body>
  </html>
</xsl:template>


<xsl:template name="entry">
  <p class="ero">

    <!-- kapvorto kun uzo/fako -->
<xsl:text>
</xsl:text>
    <strong>
      <xsl:for-each select="k">
        <xsl:call-template name="kapvorto"/>
      </xsl:for-each>
    </strong>

    <!-- por ĉiu senco... -->
    <xsl:for-each select="key('eowords',k)">
      <xsl:sort select="k/@n"/>
      <span id="{translate(@mrk,'.','_')}">
        <xsl:text> </xsl:text>
        <xsl:if test="k/@n">
          <b><xsl:value-of select="k/@n"/>.</b>
        </xsl:if>

        <xsl:if test="k/@n and not(uzo|.//r|trd)">
          <i> vd. en Revo</i>
        </xsl:if>

        <xsl:for-each select="uzo">
          <xsl:text> </xsl:text>
          <xsl:call-template name="fak-ref">
            <xsl:with-param name="fak" select="."/>
          </xsl:call-template>
        </xsl:for-each>
        
        <!-- tradukoj -->
        <!-- <xsl:text> </xsl:text> -->
        <xsl:for-each select="trd">
          <xsl:sort select="@lng"/>
          <xsl:if test="not(preceding-sibling::trd[@lng=current()/@lng])">
            <xsl:text> </xsl:text>
            <em><xsl:value-of select="@lng"/></em><xsl:text>:&#160;</xsl:text>
          </xsl:if>
          <xsl:apply-templates/>
          <xsl:if test="following-sibling::trd[@lng=current()/@lng]">
            <xsl:text>; </xsl:text>
          </xsl:if>
          <!-- <xsl:text> </xsl:text>  -->
        </xsl:for-each>

        <!-- referencoj -->
        <xsl:apply-templates select="*[not(self::k) and not(self::uzo) and not(self::trd)]"/>
      </span>
    </xsl:for-each>
    <xsl:text>.</xsl:text>
  </p>
  <!--  <hr/> -->
</xsl:template>

<xsl:template match="trd">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="klr[@tip='ind']" mode="tradukoj"/>

<xsl:template name="fak-ref">
  <xsl:param name="fak"/>
  <xsl:value-of select="$fak"/>
</xsl:template>


<xsl:template name="art-ref">
  <xsl:apply-templates select="k"/>
  <!--  <xsl:variable name="snc" select="substring-after(substring-after(@mrk,'.'),'.')"/>
  <xsl:if test="string-length($snc) &gt; 0">
    <xsl:text> (</xsl:text>
    <xsl:value-of select="$snc"/>
    <xsl:text>)</xsl:text>
  </xsl:if> -->
</xsl:template>


<!-- kapvorto kun senco -->

<xsl:template match="k">
  <xsl:apply-templates/>
  <xsl:if test="@n"><sup><xsl:value-of select="@n"/></sup></xsl:if>
</xsl:template>

<xsl:template name="kapvorto">
   <xsl:apply-templates/>
</xsl:template>



<xsl:template match="dif">
  <xsl:if test="r">
    <xsl:text> =</xsl:text>
    <xsl:call-template name="refs"/>
  </xsl:if>
</xsl:template>


<xsl:template match="sin">
  <xsl:if test="r">
    <xsl:text> &#x21d2;</xsl:text>
    <xsl:call-template name="refs"/>
  </xsl:if>
</xsl:template>


<xsl:template match="ant">
  <xsl:if test="r">
    <xsl:text> &#x21cf;</xsl:text>
    <xsl:call-template name="refs"/>
  </xsl:if>
</xsl:template>


<xsl:template match="super">
  <xsl:if test="r">
    <xsl:text> &#x2197;&#xFE0E;</xsl:text>
    <xsl:call-template name="refs"/>
  </xsl:if>
</xsl:template>


<xsl:template match="sub">
  <xsl:if test="r">
    <xsl:text> &#x2198;&#xFE0E;</xsl:text>
    <xsl:call-template name="refs"/>
  </xsl:if>
</xsl:template>

<xsl:template match="malprt">
  <xsl:if test="r">
    <xsl:text> &#x2191;</xsl:text>
    <xsl:call-template name="refs"/>
  </xsl:if>
</xsl:template>


<xsl:template match="prt">
  <xsl:if test="r">
    <xsl:text> &#x2193;</xsl:text>
    <xsl:call-template name="refs"/>
  </xsl:if>
</xsl:template>


<xsl:template match="lst">
  <xsl:if test="r">
    <xsl:text> &#x21c9;</xsl:text>
    <xsl:call-template name="refs"/>
  </xsl:if>
</xsl:template>


<xsl:template match="vid">
  <xsl:if test="r">
    <xsl:text> &#x2192;</xsl:text>
    <xsl:call-template name="refs"/>
  </xsl:if>
</xsl:template>


<xsl:template name="refs">
  <xsl:text>&#160;</xsl:text>
  <xsl:for-each select="r">
    <!-- evitu duoblajhojn en referencoj; pli sekura estus kompari kapvortojn, ĉar mrk-oj foje diferencas, 
         sed kapvortoj samas; estas malfacile tio per xslt 1, eble uzu xslt 2 por tio kun grupiga elemento -->
    <xsl:if test="not(following-sibling::r[@c=current()/@c])"> 
    
      <xsl:variable name="nod" select="//tez/nod[@mrk=current()/@c or @mrk2=current()/@c]"/>

      <xsl:choose>
  
	<!-- la referenccelo troviĝas kiel nodo en la dosiero -->
        <xsl:when test="$nod">
          <xsl:variable name="file">
            <xsl:call-template name="file-name">
              <xsl:with-param name="str" select="$nod/k"/>
            </xsl:call-template>
          </xsl:variable>
          <a class="tez" href="{$file}#{translate($nod/@mrk,'.','_')}">
            <xsl:apply-templates select="$nod/k"/>
          </a>
        </xsl:when>
	
	<!-- artikolo estas referencita, sed ne senco / nodo de la dosiero, provu trovi la unuan nodon
	de tiu artikolo anstataŭe do -->

	<xsl:when test="not(contains(@c,'.'))">

          <xsl:if test="$warn-about-dead-refs='true'">
            <xsl:message> <!-- eble skribu tion en eraro-dosieron por prezenti al redaktantoj -->
              <xsl:text>nesolvita referenco de </xsl:text>
              <xsl:value-of select="../../@mrk"/>
              <xsl:text> al </xsl:text>
              <xsl:value-of select="@c"/>
            </xsl:message>
          </xsl:if>

	  <xsl:variable name="nod_1" select="//tez/nod[substring-before(@mrk,'.')=current()/@c][1]"/>
	  <xsl:variable name="file">
	    <xsl:call-template name="file-name">
	      <xsl:with-param name="str" select="$nod_1/k"/>
	    </xsl:call-template>
	  </xsl:variable>
	  <a class="tez" href="{$file}#{translate($nod_1/@mrk,'.','_')}">
	    <xsl:apply-templates select="$nod_1/k"/>
	  </a>

	</xsl:when>

	<!-- la referenco estas tute "morta" ... -->
	<xsl:otherwise>
	  <xsl:variable name="first" select="substring-before(@c,'.')"/>
	  <xsl:variable name="rest" select="substring-after(@c,'.')"/>

	  <xsl:if test="$warn-about-dead-refs='true'">
            <xsl:message> <!-- eble skribu tion en eraro-dosieron por prezenti al redaktantoj -->
              <xsl:text>nesolvita referenco de </xsl:text>
              <xsl:value-of select="../../@mrk"/>
              <xsl:text> al </xsl:text>
              <xsl:value-of select="@c"/>
            </xsl:message>
	  </xsl:if>

<!--
	  <xsl:choose>
	    <xsl:when test="contains($rest,'0')">
	      <span class="celmanko">
		<xsl:text>[?</xsl:text>
		<xsl:value-of select="concat(substring-before($rest,'0'),$first,substring-after($rest,'0'))"/>
		<xsl:text>?]</xsl:text>
	      </span>
	    </xsl:when>
	    <xsl:otherwise>
	      <span class="celmanko">
                <xsl:text>[?</xsl:text>
                <xsl:value-of select="@c"/>
		<xsl:text>?]</xsl:text>
	      </span>
	    </xsl:otherwise>
	  </xsl:choose>
-->
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:if test="following-sibling::r">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:if>

  </xsl:for-each>
</xsl:template>


<xsl:template name="replace-string">
  <xsl:param name="text"/>
  <xsl:param name="replace"/>
  <xsl:param name="with"/>
  <xsl:choose>
    <xsl:when test="contains($text,$replace)">
      <xsl:value-of select="substring-before($text,$replace)"/>
      <xsl:value-of select="$with"/>
      <xsl:call-template name="replace-string">
        <xsl:with-param name="text"
          select="substring-after($text,$replace)"/>
        <xsl:with-param name="replace" select="$replace"/>
        <xsl:with-param name="with" select="$with"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>










