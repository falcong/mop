#!/usr/local/bin/perl
use Tie::File;
use POSIX;
tie @array, 'Tie::File', 'skyline.1.edge' or die;
open OUT, ">", "edges.dat" or die;
for $i (1..$#array-1){
	@t = split(" ",$array[$i]);
	print OUT $t[1],"\t",$t[2],"\n";
}
close OUT;
untie @array;


