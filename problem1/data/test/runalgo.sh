#!/bin/bash
matlab -nojvm -nodesktop -r "dtriangulation;exit;"
stty echo
perl ../remsim.pl
perl ../rmdups.pl wtA.dat

perl ../updtNML.pl
/home/shubhangi/VT/PhD/Research/mathsoft/VTDIRECT95/tmain

perl ../gentr.pl
perl ../copylncnt.pl tregion.dat
../GenSur
../test.exe
perl ../rmdups.pl RSMOutTest.dat
perl ../copylncnt.pl RSMOutTest.dat
perl ../copylncnt.pl RSMOutTest1.dat
#/home/shubhangi/VT/PhD/Research/mathsoft/VTDIRECT95/EvalSur
#perl ../evalsur.pl

#perl ../updtTR.pl

/home/shubhangi/VT/PhD/Research/mathsoft/VTDIRECT95/tskyline
cp blank.dat RSMOutTest1.dat
cp blank.dat RSMOutTest.dat
cp blank.dat lshepwa.dat

cp RSMInTest.dat input.dat
perl ../paretofront.pl

