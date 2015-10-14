#!/usr/bin/perl

# (c) 2002 che Wolfram Diestel
# uzebla lau GPL 2.0

print <<EOH;
<?xml-stylesheet type="text/xml" href="biblio.xsl"?>

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

<!-- hebreaj literoj -->
<!ENTITY alef   "&#x05d0;">
<!ENTITY bet    "&#x05d1;">
<!ENTITY gimel  "&#x05d2;">
<!ENTITY dalet  "&#x05d3;">
<!ENTITY he     "&#x05d4;">
<!ENTITY vav    "&#x05d5;">
<!ENTITY zain  "&#x05d6;">
<!ENTITY het    "&#x05d7;">
<!ENTITY tet    "&#x05d8;">
<!ENTITY jod    "&#x05d9;">
<!ENTITY kaf    "&#x05db;">
<!ENTITY lamed  "&#x05dc;">
<!ENTITY mem    "&#x05de;">
<!ENTITY nun    "&#x05e0;">
<!ENTITY samekh "&#x05e1;">
<!ENTITY ain   "&#x05e2;">
<!ENTITY pe     "&#x05e4;">
<!ENTITY cadi  "&#x05e6;">
<!ENTITY kof    "&#x05e7;">
<!ENTITY resh   "&#x05e8;">
<!ENTITY shin   "&#x05e9;">
<!ENTITY tav    "&#x05ea;">


<!-- aliaj literoj -->
<!ENTITY leftquot "&#x201e;">
<!ENTITY rightquot "&#x201c;">
<!ENTITY dash "&#x2015;"> 

]>

<!-- \$Id\$ -->
<!-- 
  \$Log\$

-->

<TEI.2>
<teiHeader>

  <fileDesc>
    <titleStmt>
      <title>La Sankta Biblio</title>
      <respStmt>
        <resp>enkomputiligita de</resp>
        <name>Charles R. L. Power</name>
      </respStmt>
      <respStmt>
        <resp>adaptita al TEI de</resp>
        <name>Wolfram DIESTEL</name>
      </respStmt>
    </titleStmt>
    <editionStmt>
      <edition>\$Id\$</edition>
    </editionStmt>
    <extent>5263 kB</extent>
    <publicationStmt>
      <publisher>Brita kaj Alilada Biblia Societo</publisher>
      <pubPlace>Londono</pubPlace>
      <publisher>Nacia Biblia Societo de Skotlando</publisher>
      <pubPlace>Edinburgo</pubPlace>
      <date>1990</date>
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
      <p>
        Mi ne tre certas, &ccirc;u mi uzis plej &gcirc;ustan manieron
        formuli la tekston en TEI-formo. Sed jen kiel mi faris.
      </p>
      <p>
        La du testamentoj aperas kiel du tekstoj (&lt;text&gt;)
        kun propraj titolpa&gcirc;oj. La unuopaj libroj estas
        apartigitaj per &lt;div type="book"&gt;. La &ccirc;apitroj
        per &lt;div type="chapter"&gt;. Krome la partoj de la
        psalmaro estas apartigitaj per &lt;div type="psalmbook"&gt;,
        la psalmoj per &lt;div type="psalm"&gt;. La &ccirc;apitroj kaj
        psalmoj cetere estas numeritaj.
      </p>
      <p>
       La unuopaj versoj estas koditaj per &lt;l&gt; kaj la alineoj
       per &lt;lg&gt;. En la biblio pli longaj paroloj aperas versforme
       kun dekstren &scirc;ovita teksto. Ilin mi markis per la atributo
       rend='indent' kaj la versfinojn (linirompojn) per &lt;lb/&gt;.
      </p>
      <p>
       Se mi uzus por la alineoj &lt;p&gt; mi ne scius kiel disigi la
       unuopajn versojn tiel, ke oni povu ilin ekstrakti facile. Eble 
       estus anka&ubreve; bone marki &ccirc;iujn parolojn per &lt;q&gt;, 
       sed tio signifus multe da redakta laboro sen tro granda gajno, 
       &ccirc;ar en la prezento la mallongaj paroloj ne estas speciale 
       emfazitaj. La pli longaj estas jam markitaj kiel menciite.
      </p>
      <p>
       &Ccirc;apitrokomencoj ofte aperas majuskle en mia ekzemplero de la 
       Biblio, tiujn eble oni marku per &lt;hi&gt;, sed mi ankora&ubreve; 
       ne realigis tion. 
      </p>
      <p>
       Foje okazas, ke verso etendi&gcirc;as trans alineoj. Mi tiam
       enmetis en la dua parto atributon rend='cont' kaj saman versnumeron.
      </p>
      <p>
        La mallongaj priskriboj de la psalmoj aperas en &lt;head&gt;.
        La "Sela"-oj en &lt;hi rend='sela'&gt;. En la originalo ili
        aperas &ccirc;e la dekstra tekstorando kun pli malgrandaj tipoj.
        La psalmo 119 estas iom aparta pro la hebreaj literoj kaj la
        piednoto. Piednoto aperas anka&ubreve; en iu alia loko.
      </p>
    </editorialDecl>    
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
      <docTitle>
        <titlePart type="main">La Sankta Biblio</titlePart>
        <titlePart type="subtitle">Malnova kaj Nova Testamentoj<lb/>
          Tradukitaj el la Originalaj Lingvoj</titlePart>
       </docTitle>
      <docImprint>
         <pubPlace>Londono</pubPlace><lb/>
         <publisher>Brita kaj Alilanda Biblia Societo</publisher><lb/>
         <pubPlace>Edinburgo</pubPlace><lb/>
         <publisher>Nacia Biblia Societo de Skotlando</publisher>
      </docImprint>
    </titlePage>
  </front>

  <group>

EOH


foreach $file (@ARGV) { 

    if ($file =~ /^01/) {
	print <<EOMT;

<!-- ************* LA MALNOVA TESTAMENTO *************** -->
    
    <text id="MT">
      <front rend="index">
        <titlePage>
          <docTitle>
            <titlePart type="main">La Malnova Testamento</titlePart>
            <titlePart type="translator">
              el la hebrea originalo tradukis<lb/>
              <name>Lazaro Ludoviko Zamenhof</name>
            </titlePart> 
          </docTitle>
          <docImprint>
            <pubPlace>Londono</pubPlace><lb/>
            <publisher>Brita kaj Alilanda Biblia Societo</publisher>
          </docImprint>
        </titlePage>       
      </front>
      <body>


EOMT

    } elsif ($file =~ /^40/) {
	 print <<EONT;
      </body>
    </text>


<!-- ************** LA NOVA TESTAMENTO **************** -->

    <text id="NT">
      <front rend="index">
        <titlePage>
          <docTitle>
            <titlePart type="main">La Nova Testamento</titlePart>
            <titlePart type="subtitle">de<lb/>nia Sinjoro kaj Savanto<lb/>
              <name>Jesuo Kristo</name></titlePart>
          </docTitle>
          <docImprint>
            <pubPlace>Londono</pubPlace><lb/>
            <publisher>Brita kaj Alilanda Biblia Societo</publisher>
          </docImprint>
        </titlePage>       
      </front>
      <body>


EONT
    }
    insert_text($file);

};

print <<EOF;
      </body>
    </text> 
  </group>
</text>
</TEI.2>
EOF


sub insert_text {
    my $file = shift;

    open IN, $file;


    $/="\r\n\r\n"; # legu poalinee

    # devus veni la libronomo
    $line = <IN>; $line =~ s/^\s*(.*?)\s*$/$1/;
    $line =  lat3_ccirc($line); 
    $file =~ /(\d{2})biblio\.([0-9a-z]{3})\.txt/;
    print "<!-- LIBRO: $line -->\n\n";
    print "        <div type='book' n='$1' id='libro_$2' rend='doc'>\n\n";
    $label = $title = $line;
    $title =~ s/^I{1,3}\.\s*//;
    $title = 'LA '.$title if ($line =~ /^(?:PSALMARO|PREDIKANTO)$/);
    $title = 'LA SENTENCOJ DE SALOMONO' if ($line eq 'SENTENCOJ');
    $title = 'ALTA KANTO DE SALOMONO' if ($line eq 'ALTA KANTO');
    $title = 'PLORKANTO DE JEREMIA' if ($line eq 'PLORKANTO');
    $title = 'LA AGOJ DE LA APOSTOLOJ' if ($line eq 'LA AGOJ');
    if ($title =~ /^(?:KORINTANOJ|TESALONIKANOJ|TIMOTEO)$/) {
	$title = 'LA '.(($label =~ /^I\./)?'UNUA':'DUA')
	    .' EPISTOLO DE LA APOSTOLO PA&Ubreve;LO AL LA <lb/>'
	    .$title;
    }
    if ($title =~ /^(PETRO|JOHANO)$/) {
	$title = 'LA '.(($label =~ /^I\./)?'UNUA':
			($label =~ /^II\./)?'DUA':'TRIA')
	    .' EPISTOLO &Gcirc;ENERALA DE <lb/>'
	    .$title;
    }
    if ($line =~ /^(GALATOJ|EFESANOJ|FILIPIANOJ|KOLOSEANOJ|ROMANOJ)$/) {
	$title = 'LA EPISTOLO DE LA APOSTOLO PA&Ubreve;LO AL LA <lb/>'.$title;
	$label = 'AL LA '.$label;
    }
    if ($line =~ /^(TITO|FILEMON)$/) {
	$title = 'LA EPISTOLO DE LA APOSTOLO PA&Ubreve;LO AL <lb/>'.$title;
	$label = 'AL '.$label;
    }
    if ($line =~ /^(HEBREOJ)$/) {
	$title = 'LA EPISTOLO AL LA <lb/>'.$title;
	$label = 'AL LA'.$label;
    }
    if ($line =~ /^(JAKOBO|JUDAS)$/) {
	$title = 'LA EPISTOLO &Gcirc;ENERALA DE <lb/>'.$title;
	$label = 'DE '.$label;
    }
    if ($line =~ /^(?:MATEO|MARKO|LUKO|JOAHNO)$/) {
	$label = 'S. '.$label;
	$title = 'SANKTA '.$title;
    }
    print "          <index index='content' level1='$label'/>\n";
    print "          <head>$title</head>\n";

    $first_chapter = 1;
    $psalmo=($file =~ /^19/);

    # povus veni la libro-subtitolo (unua libro de moseo ks.)
    $line =  <IN>; 
    $line =  lat3_ccirc($line); 

    unless ($line =~ /apitro/) {
	$line =~ s/^\s*(.*?)\s*$/$1/;

	# eble la libro enhavas nur unu chapitron?
	if ($line =~ /^1/) {
	    alineo("&Ccirc;apitro 1");
	    alineo($line);
	} else {
	# temas pri subtitolo
	    if ($psalmo) {
		print "\n\n          <div type='psalm_book'>\n  ";
	    }
	    print "          <head>$line</head>\n\n";
	}
    } else {
	alineo($line);
    }

    # devus veni la unua chapitro de la libro, traktu tion
    # en alineo-funkcio
    while (<IN>) { alineo($_); }
#print "<p></p>\n";
    print "</div>\n\n"; # fino de lasta chapitro
    if ($psalmo) {
	print "          </div>\n\n"; # fino de la lasta psalmlibro
	$psalmo = 0;
    }
    print "        </div>\n\n"; #fino de la libro

    close IN;
}


sub alineo {
    my $par=shift;

#    $par =~ s/^\s*//;
#    $par =~ s/\s*$//;
    $par =~ s/\r//sg;

    # e-literoj
    $par = lat3_ccirc($par);

    # Komenco de nova chapitro?
    if ($par =~ /^\s*&Ccirc;apitro\s*(\d{1,2})\s*$/i) {
	print "</div>\n\n" unless ($first_chapter);
	print "<div type='chapter' n='$1'>\n\n";
	$first_chapter=0;
	$psalmo=0;
	$verse_cnt=1; # rekomencu versnombradon
	return;
    }
    # Komenco de nova psalmo?
    elsif ($par =~ /^\s*Psalmo\s*(\d{1,3})\s*$/i) {
	print "</div>\n\n" unless ($first_chapter);
	print "<div type='psalm' n='$1'>\n\n";
	$first_chapter=0;
	$psalmo = 1;
	$psalmo_nr=$1;
	$verse_cnt=1; # rekomencu versnombradon
	return;
    }
    # Komenco de nova psalmlibro
    elsif ($psalmo and ($par =~ /^LIBRO/)) {
	$par =~ s/\s*$//;
	print "</div>\n\n"; $first_chapter=1;
	print "          </div>\n\n";
	print "          <div type='psalm_book'>\n";
	print "            <head>$par</head>\n\n";
	return;
    }
    # Titollinio de psalmo?
    elsif ($psalmo and ($verse_cnt == 1) and ($par !~ /^1/)) {
	$par =~ s/\s*$//;

	if ($par =~ s/^\*\s*//) { # unu piednoto en psalmo 119
	    print "  <note type='footnote'>$par</note>\n\n";
	} elsif ($par =~ /^\s*ALEF\./) {
	    $head119 = "  <head>&alef; ALEF.</head>\n\n";
	} else {
	    print "  <head>$par</head>\n\n";
	}
	return;
    }
    # hebrea litero en psalmo 119
    elsif ($psalmo and ($psalmo_nr == 119)) {
	if ($par =~ /^\s{10}\s*[A-Z\&cir;]{2,15}\./) {
	    $par =~ s/\.\s*$//;
	    $par =~ s/^\s*//;
	    $head119 = "  <head>".heb_lit($par)." $par.</head>\n\n";
	    return;
	}
    }
    
    # unu piednoto ignorenda char traktighas pli malsupre
    return if ($par =~ /^\*\s+Heb/);

    # aliaj anstatauigoj
    $par =~ s/"(.*?)"/&leftquot;$1&rightquot;/sg;
    $par =~ s/\s*--\s*/ &dash; /sg;

    # deshovo?
    if ($par =~ /^[ \d]{5}/) {
	print "  <lg rend='indent' type='para'>\n";
	print $head119; $head119='';
	versoj($par,'indent');
    } else {
	print "  <lg type='para'>\n";
	versoj($par);
    }
  
    print "  </lg>\n\n";
}

sub versoj {
    ($par,$indent) = @_;

#    if ($par =~ /^ {5}/) {
    unless ($par =~ /^\s*$verse_cnt/) {
	# daurigo de la antaua verso
	$verse_cnt--;
	$v = "";
	$v1 = $verse_cnt+1;
    } else {
	$v = $verse_cnt; #=1? '' : $verse_cnt;
	$v1 = $verse_cnt+1;
    }

    while ($par =~ s/^\s*($v)\s*(.+?)\s*(?=$v1|$)/verso($1,$2,$indent)/seg) 
	   {
	       $v = $verse_cnt; #=1? '' : $verse_cnt;
	       $v1 = $verse_cnt+1;
	   };

    die "Ne trovis verson $verse_cnt en\n [".
	   substr($par,0,100)."...]\n" if ($par);
 }

sub verso {
    my ($v,$text) = @_;
    
    if ($indent) {
	$text =~ s/\n/<lb\/>\n    /sg; 
	$text =~ s/(?:<lb\/>)?$/<lb\/>/;
    } else {
	$text =~ s/\n/\n    /sg; 
    }

    if ($psalmo) {
	$text =~ s/\sSela\./<hi rend='sela'>Sela.<\/hi>/sg;
    }

    $text =~ s/Joram\*/"Joram<note type='footnote'>Heb. ".
	"&leftquot;Jehoram&rightquot;, ".
	"kaj en versoj 17, 21-24<\/note>\n"/se;

    if ($v =~ /^\s*$/) {
	print "  <l rend='cont' n='$verse_cnt'>$text<\/l>\n";
    } else {
	print "  <l n='$v'>$text<\/l>\n";
    }
    $verse_cnt++;
    return;
}

sub lat3_ccirc {
    my $par = shift;

    $par =~ s/\306/&Ccirc;/g;
    $par =~ s/\330/&Gcirc;/g;
    $par =~ s/\246/&Hcirc;/g;
    $par =~ s/\254/&Jcirc;/g;
    $par =~ s/\336/&Scirc;/g;
    $par =~ s/\335/&Ubreve;/g;
    $par =~ s/\346/&ccirc;/g;
    $par =~ s/\370/&gcirc;/g;
    $par =~ s/\266/&hcirc;/g;
    $par =~ s/\274/&jcirc;/g;
    $par =~ s/\376/&scirc;/g;
    $par =~ s/\375/&ubreve;/g;
    
    return $par;
}


sub heb_lit {
    my $lit = shift;

    if ($lit eq '&Hcirc;ET') {
	return '&het;';
    } elsif ($lit eq 'SAME&Hcirc;') {
	return '&samekh;';
    } elsif ($lit eq 'RE&Scirc;') {
	return '&resh;';
    } elsif ($lit eq '&Scirc;IN') {
	return '&shin;';
    } else {
	return '&'.lc($lit).';';
    }
}
    


