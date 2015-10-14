#!/usr/local/bin/perl -w

# eltiras autorojn kaj titolojn el la XML-fontoj de la verkoj 

$dir = "xml";
$verbose = 1;

print "<?xml version='1.0' encoding='utf-8' ?>\n";

print "<!DOCTYPE verkolisto [\n";
print "<!ENTITY Ccirc \"&#x0108;\">\n";
print "<!ENTITY ccirc \"&#x0109;\">\n";
print "<!ENTITY Gcirc \"&#x011c;\">\n";
print "<!ENTITY gcirc \"&#x011d;\">\n";
print "<!ENTITY Hcirc \"&#x0124;\">\n";
print "<!ENTITY hcirc \"&#x0125;\">\n";
print "<!ENTITY Jcirc \"&#x0134;\">\n";
print "<!ENTITY jcirc \"&#x0135;\">\n";
print "<!ENTITY Scirc \"&#x015c;\">\n";
print "<!ENTITY scirc \"&#x015d;\">\n";
print "<!ENTITY Ubreve \"&#x016c;\">\n";
print "<!ENTITY ubreve \"&#x016d;\">\n";
print "<!ENTITY dash \"&#x2015;\">\n";
print "<!ENTITY elipse \"...\">\n";
print "<!ENTITY dro \"D-ro\">\n";
print "]>\n\n";

print "<verkolisto>\n";

opendir DIR,"$dir" or die "Ne povas malfermi ujon \"$dir\": $!\n";
while ($file = readdir DIR) {
    if ($file =~ /\.xml$/ and $file !~ /^senchesa/ and $file !~ /^merkato/) {
	
	$title='';
	$author = '';
	$translator = '';

	open FILE, "$dir/$file" or die "Ne povas malfermi dosieron $dir/$file: $!\n";

	warn "$file...\n" if ($verbose);
	while (<FILE>) {
	    if (/<title>(.*)<\/title>/) { $title = $1; }
	    elsif (/<author>(.*)<\/author>/) { $author = $1; }
	    elsif (/<resp>.*tradukis.*<\/resp>/) {
		my $name=<FILE>;
		if ($name=~/<name>(.*?)<\/name>/) {
		    $translator = $1;
		}
	    }


	    if (/<\/fileDesc>/) {
		warn "Ne trovighis titolo en la dosierkapo.\n" unless ($title);
		warn "Ne trovighis autoro en la dosierkapo.\n" unless ($author);
		last;
	    }

	    last if ($title and $author and $translator);
	}

	if ($title or $author) {
	    $ujo = $file; $ujo=~s/\.xml$//;
	    print "  <verko dosiero=\"$ujo/index.html\">\n";
	    print "    <titolo>$title</titolo>\n" if ($title);
	    print "    <autoro>$author</autoro>\n" if ($author);
	    print "    <tradukinto>$translator</tradukinto>\n" if ($translator);
	    print "  </verko>\n";
	}
    }
}
closedir DIR;

print "</verkolisto>\n";


