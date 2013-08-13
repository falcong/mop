#!/usr/local/bin/perl
use Tie::File;
use File::Copy;

my($ifname) = $ARGV[0];
my($lnCount) = 0;
my($source) = "temp.dat";

open TMP, ">temp.dat" or die "can't open temp file\n";

tie @array, 'Tie::File', $ifname or die;
$lnCount = @array;

print TMP $lnCount, "\n";

foreach(@array){
print TMP $_,"\n";
}
untie @array;
close TMP;

copy($source,$ifname) or die "Copy failed: $!";
