#!/usr/bin/perl

$VOKO = "/home/revo/voko";
$BASE_DIR = "/home/revo/verkoj";
#$XSL = "$VOKO/bin/xslt.sh";
$XSL = "/home/revo/verkoj/bin/xslt.sh";
$XSL2 = "/usr/local/bin/xsltproc";
$XSL_DIR = "$BASE_DIR/xsl";
$XML_DIR = "$BASE_DIR/xml";

if (not $ARGV[0] or $ARGV[0] eq '-h' or $ARGV[0] eq '--help') {
    help_screen();
}

$verko = shift @ARGV;
$stilo = shift @ARGV;

$stilo = $verko unless ($stilo);


unless (-f "$XSL_DIR/$stilo.xsl") {
    die "Ne ekzistas stildosiero \"$XSL_DIR/$stilo.xsl\"\n";
}

unless (-f "$XML_DIR/$verko.xml") {
    die "Ne ekzistas verkodosiero \"$XML_DIR/$verko.xml\"\n";
}

mkdir($verko);
chdir($verko);
#if ($verko eq 'fundamento') {
	print "${XSL} $XML_DIR/$verko.xml $XSL_DIR/$stilo.xsl > index.html\n";
	`${XSL} $XML_DIR/$verko.xml $XSL_DIR/$stilo.xsl > index.html`; 
#} else {
#	# Biblio estas tro granda por "xt"
#        print "${XSL2} $XSL_DIR/$stilo.xsl $XML_DIR/$verko.xml > index.html\n";
#        `${XSL2} $XSL_DIR/$stilo.xsl $XML_DIR/$verko.xml > index.html`;
#}
patch_html();



sub patch_html {

open XML, "$XML_DIR/$verko.xml" or die "$!\n";
    while (<XML>) {
	if ($_ =~ m/\044Id:.*,v\s+([\d\.\s\/\:]+).*\044/) {
	    $ver = $1;
	    $ver =~ s/\s+$//;
	    
	    open HTML, "index.html" or die "$!\n";
	    $text = join('',<HTML>);
	    close HTML;
	
	    $str = "<address><a href=\"../xml/$verko.xml\">$verko.xml</a> $ver; ".
	    "stilo: <a href=\"../xsl/teixlite.xsl\">teixlite.xsl</a>";
	    
	    unless ($stilo eq "teixlite") {
		$str .=  ", <a href=\"../xsl/$stilo.xsl\">$stilo.xsl</a>";
	    }
	    $str .= "</address>\n";
	    
	    $text =~ s/(?:<hr>)?\s*<\/body>/<hr>$str<\/body>/is;
	    
	    open HTML, ">index.html" or die "$!\n";
	    print HTML $text;
	    close HTML;
	    
	    close XML;

	    last;
	}
    }

}


sub help_screen {

print <<EOH;

uzo: xml2html <verko> [<stilo>]

EOH
}



