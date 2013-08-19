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
my($NDV) = 12;
my($M) = 3;
my($N) = $NDV+$M-1;
tie @array, 'Tie::File', $ifname or die;
tie @array1, 'Tie::File', $sfname or die;
#open OUT, ">", "skyline.dat" or die;

#print "array1 and array sizes: ",$#array1,"\t",$#array,"\n";
while(@array){
	$temp = shift(@array);
	@b = split(" ",$temp);
	$i = 0;
	$flg=1;
	#print "b: ",@b,"\t",$#array1,"\n";
	while ($i <= $#array1) {
		$temp = $array1[$i];
		@t = split(" ",$temp);
		$cnt=0;
		if(@t){
		#print "t: ",@t,"\n";
		for $k($NDV..$N){if(abs($b[$k]-$t[$k])<=$tol){$cnt=$cnt+1);}}
		if($cnt==$M){
			$flg=0;
			last;
		}else{
			$cnt=0;
			for $k($NDV..$N){
				if( ( (($b[$k]<$t[$k]) or (abs($b[$k]-$t[$k])<=$tol) ) ) 
					{ $cnt = $cnt+1; }
			}
			if($cnt==$M){
				$flg=0;
				last;
			}
		}

		if(abs($b[$NDV]-$t[$NDV])<=$tol and abs($b[$NDV+1]-$t[$NDV+1])<=$tol and 
			abs($b[$NDV+2]-$t[$NDV+2])<=$tol){
			#splice @array,$i,1; #duplicate rows with same obj values			
		#	print "same obj values\n";
			$flg=0;
		#	$i=$i+1;
			last;
		}
		elsif( ( (($b[$NDV]<$t[$NDV]) or (abs($b[$NDV]-$t[$NDV])<=$tol) ) and 
			 (($b[$NDV+1]<$t[$NDV+1]) or (abs($b[$NDV+1]-$t[$NDV+1])<=$tol) ) and 
			 (($b[$NDV+2]<$t[$NDV+2]) or (abs($b[$NDV+2]-$t[$NDV+2])<=$tol) ) ) and 
			 ( ($b[$NDV]<$t[$NDV]) or ($b[$NDV+1]<$t[$NDV+1]) or ($b[$NDV+2]<$t[$NDV+2]))
		) { 
			splice @array1,$i,1;
			#print "b dominates\n";
		}
		elsif( ( (($t[$NDV]<$b[$NDV]) or (abs($t[$NDV]-$b[$NDV])<=$tol) ) and 
			    (($t[$NDV+1]<$b[$NDV+1]) or (abs($t[$NDV+1]-$b[$NDV+1])<=$tol) ) and 
			    (($t[$NDV+2]<$b[$NDV+2]) or (abs($t[$NDV+2]-$b[$NDV+2])<=$tol) ) ) and 
			    ( ($t[$NDV]<$b[$NDV]) or ($t[$NDV+1]<$b[$NDV+1]) or ($t[$NDV+2]<$b[$NDV+2]))
		) { 
		#	print "t dominates\n";
			$flg=0;
			last;
		}
		else{
		#	print "indifferent\n";
			$i=$i+1;
		}
		}
	}
	#print "arraysize = ",$#array1, "\t", @b, "\n";
	if($flg==1){
		open OUT, ">>", "skyline.dat" or die;
		for $j (0..$#b){
			print OUT $b[$j]," ";
		}
		print OUT "\n";
		close OUT;
	}
}
untie @array;
untie @array1;
