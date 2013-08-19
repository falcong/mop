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
$tol = 0.00000001;
$NDV = 12;
$M=3;
tie @array, 'Tie::File', $ifname or die;
open OUT, ">", "skyline.dat" or die;

#if($#ARGV<1){
#	print OUT $dummy, "\n";
#}

while(@array){
	$temp = shift(@array);
	@b = split(" ",$temp);
	$i = 0;
#	print "b: ",@b,"\n";
	while ($i <= $#array) {
		$temp = $array[$i];
		@t = split(" ",$temp);
		if(@t){
		#	print "t: ",@t,"\n";
			$r = &isEqual(@b,@t);
#			print "r=",$r,"\n";
			if($r>0){
				splice @array,$i,1; #duplicate rows with same obj values			
			}
			else{
				$r = &dominates(@b,@t);
				$r = &isEqual(@b,@t);
				print "r=",$r,"\n";
				if( $r > 0) {
					splice @array,$i,1;
		#			print "b dominates\n";
				}
				else { 
					$r = &dominates(@t,@b);
					$r = &isEqual(@b,@t);
					print "t dominates r=",$r,"\n";
					if( $r > 0) {
						@b = @t;
						splice @array,$i,1;
			#			print "t dominates\n";
					}
				}
			}
		}
	}
	print OUT $b[0], " ", $b[1], " ", $b[2]," ", $b[3]," ", $b[4]," ", $b[5]," ", 
	$b[6]," ", $b[7]," ", $b[8]," ", $b[9]," ", $b[10]," ", $b[11]," ", $b[12],
	" ", $b[13]," ", $b[14],"\n";

	$numND = $numND+1;
	$i = 0;
	while($i <= $#array){
		$temp = $array[$i];
		@t = split(" ",$temp);
		if( &isEqual(@b,@t)==1){
			splice @array,$i,1; #duplicate rows with same obj values			
		}
		elsif( &dominates(@b,@t)==1){ 
			splice @array,$i,1;
		}
		else {
		$i++;}
	}
}
untie @array;
close(OUT);

sub isEqual{
@t1=split(" ",$_[0]);
@t2=split(" ",$_[1]);
$cnt=1;
#print "isequal: NDV and M",$NDV, " ", $M,"\n";
for $i (0..$M-1){
	if( abs($t1[$NDV+$i]-$t2[$NDV+$i])<=$tol){
			$cnt=$cnt+1;
		}
}
if($cnt==$M){
	return 1;
}
return 0;

}

sub dominates{
@t1=split(" ",$_[0]);
@t2=split(" ",$_[1]);
print "t1,t2",@t1,"\t",@t2,"\n";
$cnt=1;
#print "dominates: NDV and M",$NDV, " ", $M,"\n";
for $i (0..$M-1){
	if( ($t1[$NDV+$i]<$t2[$NDV+$i]) or (abs($t1[$NDV+$i]-$t2[$NDV+$i])<=$tol) ){
			$cnt=$cnt+1;
		}
}
if($cnt==$M){
	return 1;
}
return 0;
}
