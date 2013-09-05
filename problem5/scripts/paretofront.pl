#!/usr/local/bin/perl
#use strict;
#use warnings;
use Tie::File;
use File::Copy;

my($ifname) = 'input.dat';
my(@array) = {};
my(@b) = (0,0);
my(@t) = (0,0);
my($lno) = 0;
my($i) = 0;
my($dummy) = 0;
my($tol) = 0.000000001;
my($NDV) = 12;
my($M) = 6;
my($N) = $NDV+$M-1;
tie @array, 'Tie::File', $ifname or die;
open OUT, ">", "skyline.dat" or die;

#if($#ARGV<1){
#	print OUT $dummy, "\n";
#}

while(@array){
	$temp = shift(@array);
	@b = split(" ",$temp);
	$i = 0;
	#print "b: ",@b,"\n";
	while ($i <= $#array) {
		$temp = $array[$i];
		@t = split(" ",$temp);
		$cnt=0;
		if(@t){
	#		print "t: ",@t,"\n";
			for $k($NDV..$N){	
				if(abs($b[$k]-$t[$k])<=$tol){
					$cnt=$cnt+1;
				}
			}
			if($cnt==$M){
				splice @array,$i,1; #duplicate rows with same obj values
	#			print "duplicate rows with same obj values\n";			
			}
			else{
				$cnt=0;
				for $k($NDV..$N){	
					if( ($b[$k]<$t[$k]) or (abs($b[$k]-$t[$k])<=$tol) ) 
						{ $cnt = $cnt+1; }
				}
				if($cnt==$M){
					splice @array,$i,1;
	#				print "b dominates\n";
				}else{
					$cnt=0;
					for $k($NDV..$N){				
						if( ($t[$k]<$b[$k]) or (abs($t[$k]-$b[$k])<=$tol) ) 
							{$cnt=$cnt+1;}
					}
					if($cnt==$M){
						@b = @t;
						splice @array,$i,1;
	#					print "t dominates\n";
					}
					else{
						$i++;
	#					print "indifferent\n";
					}
				}
			}
		}
	}
	for $j(0..$#b){	
		print OUT $b[$j], " ";
	}
	print OUT "\n";

	$numND = $numND+1;
	$i = 0;
	#print "size array: ",$#array,"\n";
	#print "b: ",@b,"\n";
	while($i <= $#array){
		$temp = $array[$i];
		@t = split(" ",$temp);
	#	print "t: ",@t,"\n";
		$k=0;
		$cnt = 0;
		for $k($NDV..$N){	
			if(abs($b[$k]-$t[$k])<=$tol){
				$cnt=$cnt+1;
			}
		}
		if($cnt==$M){
			splice @array,$i,1; #duplicate rows with same obj values
	#		print "while 2: dup rows",@b,"\n",@t,"\n"			
		}else{
			$cnt=0;
			for $k($NDV..$N){	
				if( ($b[$k]<$t[$k]) or (abs($b[$k]-$t[$k])<=$tol) ) 
					{ $cnt = $cnt+1; }
			}
			if($cnt==$M){
				splice @array,$i,1;
	#			print "while 2: b dominates\n";
			}else{
				$i++;
			}
		}
	}
}
untie @array;
close(OUT);
