#!/bin/bash
matlab -nojvm -nodesktop -r "dtriangulation;exit;"
stty echo
perl ./remsim.pl
perl ./rmdups.pl wtA.dat
perl ./updtNMLBP.pl
/home/shubhangi/VT/PhD/Research/mathsoft/VTDIRECT95/tmain
perl ./updtNMLBPU.pl
/home/shubhangi/VT/PhD/Research/mathsoft/VTDIRECT95/tmain
perl ./updtNML.pl
/home/shubhangi/VT/PhD/Research/mathsoft/VTDIRECT95/tmain
perl ./gentr.pl
perl ./copylncnt.pl tregion.dat
#./GenSur
#perl ./copylncnt.pl RSMInTest.dat
./test.exe
perl ./copylncnt.pl RSMOutTest.dat
/home/shubhangi/VT/PhD/Research/mathsoft/VTDIRECT95/tskyline
#perl ./rmlncnt.pl RSMInTest.dat
cp RSMInTest.dat input.dat
perl ./paretofront.pl
cp blank.dat lshepwa.dat

