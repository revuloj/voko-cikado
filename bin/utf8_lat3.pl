#!/usr/bin/perl

# konvertas al lat3 de utf8
# voku: utf8_lat3.pl <dosieroj>

foreach $file (@ARGV) {

    open FILE, $file or die "Ne povis legi $file: $!\n";
    $_ = join('',<FILE>);
    close FILE;

    # konverti la e-literojn de Lat-3 al utf-8
    s/\304\210/\306/g; #Cx
    s/\304\234/\330/g; #Gx
    s/\304\244/\246/g; #Hx 
    s/\304\264/\254/g; #Jx
    s/\305\234/\336/g; #Sx
    s/\305\254/\335/g; #Ux
    s/\304\211/\346/g; #cx
    s/\304\235/\370/g; #gx
    s/\304\245/\266/g; #hx
    s/\304\265/\274/g; #jx
    s/\305\235/\376/g; #sx
    s/\305\255/\375/g; #ux
    s/\342\200\225/---/g;
    s/\020\034/"/g;
    s/\020\036/"/g;

    open FILE, ">$file" or die "Ne povis skribi $file: $!\n";
    print FILE;
    close FILE;
};








