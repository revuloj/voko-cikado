#!/usr/bin/perl

$VOKO = "/home/revo/voko";
$BASE_DIR = "/home/revo/verkoj";
$XSL = "$VOKO/bin/xslt.sh";
$XSL_DIR = "$BASE_DIR/xsl";
$XML_DIR = "$BASE_DIR/xml";
$tmp = "$BASE_DIR/tmp";

while (@ARGV[0] =~ /^-/) {
  if ($ARGV[0] =~ /^--?h/) {
	help_screen();
	exit;
  } elsif ($ARGV[0] eq '-p') {
        $postscript = 1;
        shift @ARGV;
  }
}

if (not $ARGV[0]) {
    help_screen();
    exit;
}

$verko = shift @ARGV;
$stilo = shift @ARGV;

unless ($stilo) {
  if (-f "$XSL_DIR/${verko}_latex.xsl") {
    $stilo = "${verko}_latex";
  } else {
    $stilo = "teixlite_latex";
  }
}

unless (-f "$XSL_DIR/$stilo.xsl") {
    die "Ne ekzistas stildosiero \"$XSL_DIR/$stilo.xsl\"\n";
}

unless (-f "$XML_DIR/$verko.xml") {
    die "Ne ekzistas verkodosiero \"$XML_DIR/$verko.xml\"\n";
}

chdir($verko);
print "${XSL} $XML_DIR/$verko.xml $XSL_DIR/$stilo.xsl > $tmp/$verko.texx\n";
`${XSL} $XML_DIR/$verko.xml $XSL_DIR/$stilo.xsl > $tmp/$verko.texx`; 

print "polurado $tmp/$verko.texx -> $verko.tex\n";
finalize_file("$tmp/$verko.texx","$verko.tex");
unlink("$tmp/$verko.texx");

if ($postscript) {

  print "latex $verko.tex -> $verko.dvi\n";
  `latex $verko.tex`;

  print "latex $verko.tex -> $verko.dvi\n";
  `latex $verko.tex`;

#  print "dvips $verko.dvi -> $verko.ps\n";
#  `dvips $verko.dvi`;

  print "dvipdf $verko.dvi -> $verko.pdf\n";
  `dvipdf $verko.dvi`;
}


sub finalize_file {
    my ($in,$out) = @_;
    my $line;

   
    open IN,"$in" or die "Ne povas legi \"$in\"\n";
    open OUT,">$out" or die "Ne povas malfermi \"$out\"\n";

    while ($line = <IN>) {
	print OUT utf8_lat3($line);
    }

    close IN;
    close OUT;
}


sub utf8_lat3 {
    my $line=shift;
    # aldoni eskapsignon al specialaj signoj
    # tio devus okazi antaue, cha jam la speciala
    # TeX-sintaksaj signoj estas ene, sed ne
    # konvertighu tie chi.
    # $line =~ s/([\#\$%\^\{\}&_\\])/\\$1/g;

    # konverti la  ne-askiajhojn de utf-8 al Lat-3/LaTeX
    $line =~ s/\304\210/\306/g; #Cx
    $line =~ s/\304\234/\330/g; #Gx
    $line =~ s/\304\244/\246/g; #Hx 
    $line =~ s/\304\264/\254/g; #Jx
    $line =~ s/\305\234/\336/g; #Sx
    $line =~ s/\305\254/\335/g; #Ux
    $line =~ s/\304\211/\346/g; #cx
    $line =~ s/\304\235/\370/g; #gx
    $line =~ s/\304\245/\266/g; #hx
    $line =~ s/\304\265/\274/g; #jx
    $line =~ s/\305\235/\376/g; #sx
    $line =~ s/\305\255/\375/g; #ux

    $line =~ s/\303\244/\344/g; #u"
    $line =~ s/\303\266/\366/g; #o"
    $line =~ s/\303\274/\374/g; #u"

    $line =~ s/\302\251/\\copyright /g; #(c)
    $line =~ s/\342\200\225/---/g; #streko

    return $line;
}


sub help_screen {

print <<EOH;

uzo: xml2latex [-p] <verko> [<stilo>]

  -p krom *.tex-dosiero faru ankau dvi,ps kaj pdf-version

EOH
}







