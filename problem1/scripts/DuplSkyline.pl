#!/usr/local/bin/perl
use Tie::File;
tie @array, 'Tie::File', 'RSMInTest.dat' or die;
open OUT, ">>", "skyline1.dat" or die;
$NDV = 12;
$M = 3;
$cnt=0;
for $i(0..$#array){
	@t = split(" ",$array[$i]);
	for $j (0..$M-1){
		if($t[$NDV+$j]<0.51){
			$cnt = $cnt+1;
		}
	}
	if($cnt==$M){
		foreach (@t){
			print OUT $_," ";
		}
		print OUT "\n";
	}
	$cnt=0;
}
close(OUT);
