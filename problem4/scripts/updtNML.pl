#!/usr/local/bin/perl
use Tie::File;
use POSIX;
tie @array, 'Tie::File', 'X0.dat' or die;
@X=split(" ",$array[0]);
@XL=split(" ",$array[1]);
@XU=split(" ",$array[2]);
$dlta=$array[3];
untie @array;
$matched=0;
$ndv=36;
$elimit = 100;
tie @array, 'Tie::File', 'directTT.nml' or die;
$strXL="";
$strXU="";
$strl="";
$stru="";
for $i (0..$ndv-1){
#	$strXL.=$XL[$i].",";
#	$strXU.=$XU[$i].",";	
	$strl=$X[$i]-$dlta;
	$stru=$X[$i]+$dlta;
	$strXL.=$strl.",";
	$strXU.=$stru.",";	

}
chop $strXL;
chop $strXU;
$LB="LB(1:".$ndv.")=".$strXL;
$array[4] = $LB;
$UB="UB(1:".$ndv.")=".$strXU;
$array[5] = $UB;
$array[9] = "eval_lim=".$elimit;
$array[12] = "eps_fmin=0.1";
untie @array;

