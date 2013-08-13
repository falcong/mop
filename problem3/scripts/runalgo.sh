#!/bin/bash
matlab -nojvm -nodesktop -r "dtriangulation;exit;"
stty echo
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem3/scripts/remsim.pl
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem3/scripts/rmdups.pl wtA.dat

perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem3/scripts/updtNML.pl
/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem3/VTDIRECT/tmain

perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem3/scripts/gentr.pl
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem3/scripts/copylncnt.pl tregion.dat
/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem3/VTDIRECT/GenSur
/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem3/NOMAD/test.exe
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem3/scripts/rmdups.pl RSMOutTest.dat
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem3/scripts/copylncnt.pl RSMOutTest.dat
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem3/scripts/copylncnt.pl RSMOutTest1.dat

/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem3/VTDIRECT/tskyline
cp blank.dat RSMOutTest1.dat
cp blank.dat RSMOutTest.dat
cp blank.dat lshepwa.dat

cp RSMInTest.dat input.dat
perl /home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem3/scripts/paretofront.pl



#/home/shubhangi/nomad.3.5.1/examples/interfaces/FORTRAN/MOP/problem2/VTDIRECT/EvalSur
