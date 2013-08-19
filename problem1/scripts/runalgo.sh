#!/bin/bash
matlab -nojvm -nodesktop -r "dtriangulation;exit;"
stty echo
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/scripts/remsim.pl
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/scripts/rmdups.pl wtA.dat

perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/scripts/updtNMLBP.pl
/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/VTDIRECT/tmain
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/scripts/updtNMLBPU.pl
/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/VTDIRECT/tmain
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/scripts/updtNML.pl
/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/VTDIRECT/tmain

perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/scripts/gentr.pl
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/scripts/copylncnt.pl tregion.dat
/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/VTDIRECT/GenSur

/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/NOMAD/test.exe
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/scripts/rmdups.pl RSMOutTest.dat
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/scripts/copylncnt.pl RSMOutTest.dat
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/scripts/copylncnt.pl RSMOutTest1.dat
/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/VTDIRECT/tskyline

cp blank.dat RSMOutTest1.dat
cp blank.dat RSMOutTest.dat
cp blank.dat lshepwa.dat

cp skyline.dat input.dat
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem1/scripts/paretofront.pl

