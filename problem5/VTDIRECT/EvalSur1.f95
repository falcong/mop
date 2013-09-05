program EvalSur1
use REAL_PRECISION

implicit none

INTEGER :: ierr ! Error status for file I/O.
INTEGER :: M, N1, N2, i, j, k, cnt
REAL(KIND = R8), DIMENSION(12) :: xs,xt,xt0,xs0
REAL(KIND = R8), DIMENSION(15) :: xf
REAL(KIND = R8),DIMENSION(3) :: ft, fs, fst, ftx0, fsx0, sumrhos
REAL(KIND = R8):: tol, sumerrf1,sumerrf2,sumerrf3,rms1,rms2,rms3
REAL(KIND = R8)::SumXi,pi,g,SumRho

	M = 12
	tol=1e-13
	cnt=0
	sumerrf1=0.0
	sumerrf2=0.0
	sumerrf3=0.0
	SumXi=0.0
	SumRho=0.0
	sumrhos(1:3)=0.0
	pi = 3.14159265359
	N1=0
	N2=0
	
	open(175, FILE="RSMOutTest.dat", STATUS='OLD')
	read(175,*)N1
	write(*,*)'N1 ',N1
	do k=1,N1,1
		write(*,*)'k = ',k
		read(175,*,IOSTAT=ierr)xt
		write(*,*)'xt ',xt

	end do
	write(*,*)'sumrhos ',sumrhos(1),sumrhos(2),sumrhos(3)

END PROGRAM EvalSur1
