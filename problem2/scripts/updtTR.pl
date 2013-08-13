#!/usr/local/bin/perl
use Tie::File;
use POSIX;

@lb={};
@ub={};
@x={};
@lb1={};
@ub1={};
$dlta=0.0;
$strU=$strL="";
$tol=0.0000000000001;
tie @array1, 'Tie::File', 'X0.dat' or die;

$dlta=$array1[3];
if($dlta>0.02){
$dlta=$dlta/4;
for $i(0..11){
	@x = split(" ",$array1[0]);
	$lb1[$i]=$lb[$i]=$x[$i]-$dlta;
	$ub1[$i]=$ub[$i]=$x[$i]+$dlta;
	if($lb[$i]<0){
		$lb1[$i]=0;
	}
	if($ub[$i]>1){
		$ub1[$i]=1;
	}
	$strL=$strL.$lb1[$i].' ';
	$strU=$strU.$ub1[$i].' ';
}
chop($strU);
chop($strL);
$array1[1]=$strL;
$array1[2]=$strU;
$array1[3]=$dlta;

untie @array1;

$strL="LB(1:12)=";
$strU="UB(1:12)=";
for $i(0..11){
	$strL=$strL.$lb[$i].",";
	$strU=$strU.$ub[$i].",";
}
chop($strU);
chop($strL);

tie @array1, 'Tie::File', 'directTT.nml' or die;
$array1[4]=$strL;
$array1[5]=$strU;
untie @array1;

$str="";
tie @array1, 'Tie::File', 'Xc.dat' or die;
#print "x=",@x,"\n";
for $j (0..$#array1){
	@xc = split(" ",$array1[$j]);	
#	print "xc ",@xc,"\n";
	$cnt=0;
	for $i (0..11){
		if(abs($x[$i]-$xc[$i])<=$tol){
			$cnt=$cnt+1;
		}
	}
	if($cnt==12){
		$xc[15]=$dlta;
		for $k (0..$#xc){
			$str=$str.$xc[$k]." ";
		}
		chop($str);
		$array1[$j]=$str;
		break;
	}
}
untie @array1;
}
else{
	$str="eval_lim=";
	tie @array1, 'Tie::File', 'directTT.nml' or die;
	@elim = split("=",$array1[9]);
	$evalim=$elim[1]*2;
	$str=$str.$evalim;
	$array1[9]=$str;
	untie @array1;
}
