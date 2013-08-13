#!/usr/local/bin/perl
use Tie::File;
use POSIX;
tie @array, 'Tie::File', 'X0.dat' or die;
#print "here 1", $array[1],"\n";

@XL=split(" ",$array[1]);
@XU=split(" ",$array[2]);
print "XL= ",@XL,"\n";
print "XU= ",@XU,"\n";
untie @array;
$matched=0;
$ndv=20;
untie @array;
open OUT, ">", "tregion.dat" or die;
tie @array, 'Tie::File', 'RSMInTest.dat' or die;
print $#array,"\n";
for $i (0..$#array){
	@X=split(" ",$array[$i]);
	for $j (0..$ndv-1){
		if( ($X[$j]>=$XL[$j]) && ($X[$j]<=$XU[$j]) ){
			$matched=$matched+1;
		}
	}
#	print "matched = ",$matched,"\n";	
	if($matched==$ndv){
		for $k (0..$#X){
			print OUT $X[$k]," ";
		}
		print OUT "\n";
	}
	$matched=0;
}
untie @array;
close OUT;
