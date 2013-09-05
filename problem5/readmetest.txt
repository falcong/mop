rm *.o *.mod *.exe *.*~ *~

g++ -ansi -Wall -O3  -I/home/shubhangi/nomad.3.5.1/src -I. -c nomad.cpp 

g95 -c REAL_PRECISION.f blas.f lapack.f linear_shepard.f95 TestObjSur.f95 test.f

g++ -o test.exe *.o /home/shubhangi/nomad.3.5.1/lib/nomad.a -lm -ansi -Wall -O3 /home/shubhangi/g95-install/lib/gcc-lib/i686-pc-linux-gnu/4.0.3/libf95.a


For RyuTP and DrCTP 
change the aggregate obj definition
