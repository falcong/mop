#!/bin/bash
matlab -nojvm -nodesktop -r "dtriangulation;exit;"
stty echo
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem5/scripts/remsim.pl
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem5/scripts/rmdups.pl wtA.dat

perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem5/scripts/updtNML.pl
/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem5/VTDIRECT/tmain

perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem5/scripts/gentr.pl
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem5/scripts/copylncnt.pl tregion.dat
/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem5/VTDIRECT/GenSur

/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem5/NOMAD/test.exe
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem5/scripts/rmdups.pl RSMOutTest.dat
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem5/scripts/copylncnt.pl RSMOutTest.dat
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem5/scripts/copylncnt.pl RSMOutTest1.dat

/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem5/VTDIRECT/tskyline
cp blank.dat lshepwa.dat
cp blank.dat RSMOutTest1.dat
cp blank.dat RSMOutTest.dat

cp skyline.dat input.dat
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem5/scripts/paretofront.pl

perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem5/scripts/updtSkyline.pl 

#/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem5/VTDIRECT/EvalSur
