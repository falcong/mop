#!/usr/local/bin/perl
#use strict;
#use warnings;
use Tie::File;
use File::Copy;

my($ifname) = 'input.dat';
my($sfname) = 'skyline.dat';
my(@array) = {};
my(@b) = {};
my(@t) = {};
my($lno) = 0;
my($i) = 0;
my($flg) = 0;
my($dummy) = 0;
my($tol) = 0.00000001;
my($NDV) = 36;
tie @array, 'Tie::File', $ifname or die;
tie @array1, 'Tie::File', $sfname or die;
#open OUT, ">", "skyline.dat" or die;

while(@array){
	$temp = shift(@array);
	@b = split(" ",$temp);
	$i = 0;
	$flg=0;
#	print "b: ",@b,"\n";
	while ($i <= $#array1) {
		$temp = $array1[$i];
		@t = split(" ",$temp);
		if(@t){
	#	print "t: ",@t,"\n";
		if(abs($b[$NDV]-$t[$NDV])<=$tol and abs($b[$NDV+1]-$t[$NDV+1])<=$tol and 
			abs($b[$NDV+2]-$t[$NDV+2])<=$tol){
			#splice @array,$i,1; #duplicate rows with same obj values			
			break;
		}
		elsif( ( (($b[$NDV]<$t[$NDV]) or (abs($b[$NDV]-$t[$NDV])<=$tol) ) and 
			 (($b[$NDV+1]<$t[$NDV+1]) or (abs($b[$NDV+1]-$t[$NDV+1])<=$tol) ) and 
			 (($b[$NDV+2]<$t[$NDV+2]) or (abs($b[$NDV+2]-$t[$NDV+2])<=$tol) ) ) and 
			 ( ($b[$NDV]<$t[$NDV]) or ($b[$NDV+1]<$t[$NDV+1]) or ($b[$NDV+2]<$t[$NDV+2]))
		) { #RyuTP
			splice @array1,$i,1;
			$flg = 1;
#			print "b dominates\n";
		}
		elsif( ( (($t[$NDV]<$b[$NDV]) or (abs($t[$NDV]-$b[$NDV])<=$tol) ) and 
			    (($t[$NDV+1]<$b[$NDV+1]) or (abs($t[$NDV+1]-$b[$NDV+1])<=$tol) ) and 
			    (($t[$NDV+2]<$b[$NDV+2]) or (abs($t[$NDV+2]-$b[$NDV+2])<=$tol) ) ) and 
			    ( ($t[$NDV]<$b[$NDV]) or ($t[$NDV+1]<$b[$NDV+1]) or ($t[$NDV+2]<$b[$NDV+2]))
		) { 
			break;
#			print "t dominates\n";
		}
		else{
			$flg = 1;}
		}
	}
	if($flg==1){
		for $j(0..$#b){	
			$array1[$#array1+1][$j]=$b[$j];
		}
	}
}
untie @array;
untie @array1;
