#!/usr/local/bin/perl
use Tie::File;
use POSIX;

@ft={};
@xt={};
@xsf={};
@ft0={};
@fs={};
@fs0={};
@SumRhos={};
$cnt=0;
$tol=0.000000001;
$pi = 3.14159265359;
$rho1=-1000000.0;
$rho2=-1000000.0;
$rho3=-1000000.0;
$m1=$m2=$m3=0.0;

for $i (0..2){
	$SumRhos[$i]=0.0;
	$ft[$i]=0.0;
	$ft0[$i]=0.0;
	$fs[$i]=0.0;
	$fs0[$i]=0.0;
}
for $i (0..11){
	$xt[$i]=0.0;
}

for $i (0..14){
	$xsf[$i]=0.0;
}

$SumXi=0.0;

tie @array1, 'Tie::File', 'RSMOutTest.dat' or die;
$N1=$array1[0];

#print "N1= ",$N1,"\n";

for $i(1..$N1){
#	print "i= ",$i,"\n";
	@xt=split(" ",$array1[$i]);
#	print "xt= ",@xt,"\n";
	for $j(2..11){
		$SumXi = $SumXi + ($xt[$j]-0.5)^2 - cos(20*$pi*($xt[$j]-0.5));
	}
	$g   = 100 * (10.0 + $SumXi);
	$ft[0] = 0.5*$xt[0]*$xt[1]*(1+$g);
  	$ft[1]  = 0.5*$xt[0]*(1-$xt[1])*(1+$g);
  	$ft[2]  = 0.5*(1-$xt[0])*(1+$g);
	if($i==1){
		$ft0[0]=$fs0[0]=$ft[0];
		$ft0[1]=$fs0[1]=$ft[1];
		$ft0[2]=$fs0[2]=$ft[2];
	}
	$SumXi=0;
	if($i>1){
		tie @array2, 'Tie::File', 'RSMOutTest1.dat' or die;
		$N2=$array2[0];
		for $j(1..$N2){
			$cnt=0;
			@xsf=split(" ",$array2[$j]);
			for $k(0..11){
				if(abs($xt[$k]-$xsf[$k])<=$tol){
					$cnt=$cnt+1;
				}
			}
#			print $cnt," ";
			if($cnt==12){
				$fs[0]=$xsf[12];
				$fs[1]=$xsf[13];
				$fs[2]=$xsf[14];
#				print "fs= ",$fs[0]," ",$fs[1]," ",$fs[2],"\n";
#				print "fs0= ",$fs0[0]," ",$fs0[1]," ",$fs0[2],"\n";
#				print "diff2 ", $fs0[1]-$fs[1],"\n";
#				print "diff22 ", $ft0[1]-$ft[1],"\n";
				if(abs($fs0[0]-$fs[0])>0.000000000000001){
					$m1=($ft0[0]-$ft[0])/($fs0[0]-$fs[0]);
#					print "if1 rho ",$rho1,"\n";					
#					print "if1 m1",$m1,"\n";
					if($m1>$rho1){
						$rho1=$m1;
					}
#					$SumRhos[0]=$SumRhos[0]+(($ft0[0]-$ft[0])/($fs0[0]-$fs[0]));
				}
				if(abs($fs0[1]-$fs[1])>0.000000000000001){
					$m2=($ft0[1]-$ft[1])/($fs0[1]-$fs[1]);
#					print "if2 rho ",$rho2,"\n";					
#					print "if2 m1",$m2,"\n";

					if($m2>$rho2){
						$rho2=$m2;
					}
#					$SumRhos[1]=$SumRhos[1]+(($ft0[1]-$ft[1])/($fs0[1]-$fs[1]));
				}
				if(abs($fs0[2]-$fs[2])>0.000000000000001){
					$m3=($ft0[2]-$ft[2])/($fs0[2]-$fs[2]);
#					print "if3 rho ",$rho3,"\n";					
#					print "if3 m1",$m3,"\n";

					if($m3>$rho3){
						$rho3=$m3;
					}	
#					$SumRhos[2]=$SumRhos[2]+(($ft0[2]-$ft[2])/($fs0[2]-$fs[2]));
				}
				break;
			}
		}
		untie @array2;
	}
#	print "sumrhos ",$SumRhos[0]," ",$SumRhos[1]," ",$SumRhos[2],"\n";
}
#for $i(0..2){
#	$SumRhos[$i]=$SumRhos[$i]/($N1-1);
#}
#print "avgrhos ",$SumRhos[0]," ",$SumRhos[1]," ",$SumRhos[2],"\n";
print "max rhos: ",$rho1," ",$rho2," ",$rho3,"\n";
untie @array1;

