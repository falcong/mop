#!/usr/local/bin/perl
use Tie::File;
use POSIX;
tie @array, 'Tie::File', 'tdata.dat' or die;
for $i (0..$#array){
	@t = split(" ",$array[$i]);
#	$t[1]=$t[1]*1000;
#	$t[2]=$t[2]*1000;
	$str = ($i+1)."\t".$t[1]."\t".$t[2];
	$array[$i]=	$str;
}
untie @array;


