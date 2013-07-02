#!/usr/local/bin/perl
use Tie::File;
use POSIX;
$ndv=3;
$str="";
tie @array, 'Tie::File', 'wtA.dat' or die;
for $i (0..$#array){
	@t = split(" ",$array[$i]);
	for $j (0..$ndv-1){
		if($t[$j]<=0.01){
			$t[$j]=0;
		}
		elsif(abs($t[$j]-1)<=0.01){
			$t[$j]=1;
		}
		$str=$str.$t[$j]."\t";
	}
	$array[$i]=$str;
	$str="";	
}
untie @array;
