#!/usr/bin/perl

#use Time::Piece;
#use POSIX qw(strftime);

$VOKO = "/home/revo/voko";
$BASE_DIR = "/home/revo/verkoj";
#$XSL = "$VOKO/bin/xslt.sh";
$XSL = "/home/revo/verkoj/bin/xslt.sh";
$XSL2 = "/usr/local/bin/xsltproc";
$XSL_DIR = "$BASE_DIR/xsl/epub";
$XML_DIR = "$BASE_DIR/xml";

#$tm=localtime;
#my ($day,$month,$year)=($tm->mday,$tm->month,$tm->year);
#my $date = localtime->strftime("%Y-%m-%d");

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
my $date = sprintf("%04d-%02d-%02d", ($year+1900),($mon+1),$mday);
print "...$date\n";

if (not $ARGV[0] or $ARGV[0] eq '-h' or $ARGV[0] eq '--help') {
    help_screen();
}

$verko = shift @ARGV;
$stilo = shift @ARGV;

$stilo = $verko."_epub" unless ($stilo);


unless (-f "$XSL_DIR/$stilo.xsl") {
    die "Ne ekzistas stildosiero \"$XSL_DIR/$stilo.xsl\"\n";
}

unless (-f "$XML_DIR/$verko.xml") {
    die "Ne ekzistas verkodosiero \"$XML_DIR/$verko.xml\"\n";
}

mkdir($verko."-epub");
chdir($verko."-epub");
mkdir("META-INF");

print "${XSL} $XML_DIR/$verko.xml $XSL_DIR/$stilo.xsl > index.xhtml\n";
`${XSL} $XML_DIR/$verko.xml $XSL_DIR/$stilo.xsl > index.xhtml`; 


patch_html();


sub patch_html {

    open HTML, "index.xhtml" or die "$!\n";
    $text = join('',<HTML>);
    close HTML;
	
    $text =~ s/xmlns=""//g;
    $text =~ s/<!--\s*\$hodiau\$\s*-->/$date/g;
    
    open HTML, ">index.xhtml" or die "$!\n";
    print HTML $text;
    close HTML;
	    
}


sub help_screen {

print <<EOH;

uzo: xml2html <verko> [<stilo>]

EOH
}



