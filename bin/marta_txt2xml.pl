#!/usr/bin/perl

print <<EOH;
<?xml-stylesheet type="text/xml" href="marta.xsl"?>

<!DOCTYPE TEI.2 PUBLIC "-//TEI//DTD TEI Lite XML ver. 1//EN" "teixlite.dtd" 
[

<!-- e-aj literoj -->
<!ENTITY Ccirc "&#x0108;">
<!ENTITY ccirc "&#x0109;">
<!ENTITY Gcirc "&#x011c;">
<!ENTITY gcirc "&#x011d;">
<!ENTITY Hcirc "&#x0124;">
<!ENTITY hcirc "&#x0125;">
<!ENTITY Jcirc "&#x0134;">
<!ENTITY jcirc "&#x0135;">
<!ENTITY Scirc "&#x015c;">
<!ENTITY scirc "&#x015d;">
<!ENTITY Ubreve "&#x016c;">
<!ENTITY ubreve "&#x016d;">

<!-- aliaj literoj -->
<!ENTITY dash "&#x2015;"> 
<!ENTITY elipse "...">
<!ENTITY TRISTELO "* * *">
<!ENTITY dro "D-ro">
<!ENTITY sro "S-ro">

<!ENTITY leftquot "&#x201e;">
<!ENTITY rightquot "&#x201c;">

]>

<!-- \$Id\$ -->
<!-- 
  \$Log\$

-->

<TEI.2>
<teiHeader>

  <fileDesc>
    <titleStmt>
      <title>Marta</title>
      <author>Eliza Orzeszko</author>
      <respStmt>
        <resp>tradukis</resp>
        <name>d-ro L. L. Zamenhof</name>
      </respStmt>
      <respStmt>
        <resp>enkomputiligita de</resp>
        <name>HIROTAKA Masaaki</name>
      </respStmt>
      <respStmt>
        <resp>adaptita al TEI de</resp>
        <name>Wolfram DIESTEL</name>
      </respStmt>
    </titleStmt>
    <editionStmt>
      <edition>\$Id\$</edition>
    </editionStmt>
    <extent>560 kB</extent>
    <publicationStmt>
      <publisher>Esperanta Centra Librejo</publisher>
      <pubPlace>Paris</pubPlace>
      <date>1924</date>
    </publicationStmt>
    <sourceDesc>
      <p>Vidu la redaktan noton.</p>
    </sourceDesc>
  </fileDesc>

  <encodingDesc>
    <projectDesc>
      <p>Tiu teksto esti&gcirc;is kadre de projekto
      celanta disponigi gravajn verkojn de la esperanta literaturo
      en XML-igita formo por ebligi konvertadon al aliaj formoj
      kaj a&ubreve;tomatan traser&ccirc;adon je cita&jcirc;oj.</p>
    </projectDesc>
    <editorialDecl>

      <p>En la originala romano la paroloj estas markitaj ne per
      citiloj, sed per longaj strekoj. Por konservi tion mi
      uzis en la atributo rend la sekvajn kombinojn: '- ', '--', ' -', '""', '""-',
      '"-', '-"', '" ', ' "', '  '. Tiu kun la spacoj okazas, se pensado etendi&gcirc;as
      tra pluraj alineoj.</p>

      <p>Kiel emfazajn elementojn estas uzataj diversloke emph, mentioned, foreign.
      La lastan ekzemple por la pluraj francaj paroloj</p>

      <p>La apartigilo, kiun mi skribis per &lt;p rend='center'&gt;&amp;TRISTELO;&lt;p&gt;,
      en la originalo aperas kiel piramideto de tri steloj. D-ro kaj S-ro aperas sen la streko,
      sed kun altigita "ro".</p>
    </editorialDecl>    
  </encodingDesc>

  <profileDesc>
    <langUsage>
      <language id="eo">Esperanto</language>
      <language id="fr">franca lingvo</language>
    </langUsage>
  </profileDesc>
</teiHeader>
<text lang="eo">

 <front>
    <titlePage>
      <docAuthor>Eliza Orzeszko</docAuthor>
      <docTitle>
        <titlePart type="series">Esperanto - Verkaro de &dro; Zamenhof</titlePart>
        <titlePart type="main">Marta</titlePart>
        <titlePart type="category">Rakonto</titlePart>
        <titlePart type="translator">
          el pola lingvo, kun permeso de la a&ubreve;torino<lb/>tradukis 
          <name>&dro; L. L. Zamenhof</name>
        </titlePart>
      </docTitle>
      <docEdition>
        dua eldono
      </docEdition>
      <docImprint>
         <pubPlace>Paris</pubPlace>
         <publisher>Esperantista Centra Librejo</publisher>
         <date>1924</date>
      </docImprint>
    </titlePage>
  </front>

  <body>

    <head>Marta</head>

EOH

foreach $file (@ARGV) { insert_text($file)};

print <<EOF;
  </body>
</text>
</TEI.2>
EOF


sub insert_text {
    my $file = shift;
	
    open IN, $file;

    # ignoru komencajn liniojn
    while ($line=<IN> and ($line =~ /^\\/)) {};

    $/="\r\n\r\n"; # legu poalinee

    while (<IN>) { alineo($_); }

    close IN;
}


sub alineo {
    my $par=shift;

    $par =~ s/^\s*//;
    $par =~ s/\s*$//;
    $par =~ s/\r//sg;

    if (($par =~ /\*\s*\*\s*\*/) or ($par =~ /^\.{3}$/)) {
	print "<p rend='center'>&TRISTELO;</p>";
	return;
    }

    # e-literoj
    $par =~ s/([cghjs])\^/&$1circ;/sig;
    $par =~ s/(u)\^/&$1breve;/sig;

    # paroloj
    if ($par =~ /^---/) {
	$par =~ s/---\s*(.*?)\s*---/<q rend='--'>$1<\/q>/sg;
	$par =~ s/---\s*(.*?)\s*$/<q rend='- '>$1<\/q>/sg;
    }

    # strekoj ktp.
    $par =~ s/---/&dash;/sg;
    $par =~ s/\.{3}/&elipse;/sg;			     
  
    $par =~ s/S-ro/&sro;/sg;

    $par =~ s/"(.*?)"/&leftquot;$1&rightquot;/sg;

    print "<p>$par</p>\n\n";
}






