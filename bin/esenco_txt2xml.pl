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
      <title>Esenco kaj Estonteco de la Lingvo internacia</title>
      <author>D-ro L. L. Zamenhof</author>
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
    <extent>XX kB</extent>
    <publicationStmt>
      <publisher>Wolfram Diestel</publisher>
      <pubPlace>Lepsiko</pubPlace>
      <date>2002</date>
    </publicationStmt>
    <sourceDesc>
      <p>
      La kruda teksto estas registrita je <date>1993-08-21</date> 
      de <name>HIROTAKA Masaaki</name>. &Gcirc;i aperis sur la
      pa&gcirc;aoj 253-297 de la <title>Fundamenta Krestomatio</title>.
      </p>
    </sourceDesc>
  </fileDesc>

  <encodingDesc>
    <projectDesc>
      <p>Tiu teksto esti&gcirc;is kadre de projekto
      celanta disponigi gravajn verkojn de la esperanta literaturo
      en XML-igita formo por ebligi konvertadon al aliaj formoj
      kaj a&ubreve;tomatan traser&ccirc;adon je cita&jcirc;oj.</p>
    </projectDesc>
  </encodingDesc>

  <profileDesc>
    <langUsage>
      <language id="eo">Esperanto</language>
    </langUsage>
  </profileDesc>
</teiHeader>
<text lang="eo">

 <front>
    <titlePage>
      <docAuthor>d-ro L. L. Zamenhof</docAuthor>
      <docTitle>
        <titlePart type="series">Fundamenta Krestomatio, 17 eld., 
          p. 253-297</titlePart>
        <titlePart type="main">Esenco kaj Estonteco de la Lingvo 
           internacia</titlePart>
      </docTitle>
    </titlePage>
  </front>

  <body>

    <head>Esenco kaj Estonteco de Ideo de Lingvo 
           internacia</head>

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

    $/="\r\n   "; # legu poalinee

    while (<IN>) { alineo($_); }

    close IN;
}


sub alineo {
    my $par=shift;

    $par =~ s/^\s*//;
    $par =~ s/\s*$//;
    $par =~ s/\r//sg;

    # e-literoj
    $par =~ s/([cghjs])\^/&$1circ;/sig;
    $par =~ s/(u)\^/&$1breve;/sig;

    # paroloj
    $par =~ s/"(.*?)"/<q>$1<\/q>/sg;

    # strekoj ktp.
    $par =~ s/---/&dash;/sg;
    $par =~ s/\.{3}/&elipse;/sg;			     
  
    print "<p>$par</p>\n\n";
}






