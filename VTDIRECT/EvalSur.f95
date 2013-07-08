program EvalSur
use REAL_PRECISION

implicit none

INTEGER :: ierr ! Error status for file I/O.
INTEGER :: M, N1, N2, i, j, k, cnt
REAL(KIND = R8), DIMENSION(12) :: xs,xt
REAL(KIND = R8), DIMENSION(15) :: xf
REAL(KIND = R8),DIMENSION(3) :: ft, fs, fst
REAL(KIND = R8):: tol, sumerrf1,sumerrf2,sumerrf3,rms1,rms2,rms3,SumXi,pi,g

	M = 12
	tol=1e-13
	cnt=0
	sumerrf1=0.0
	sumerrf2=0.0
	sumerrf3=0.0
	SumXi=0.0
	pi = 3.14159265359
	
	open(175, FILE="RSMOutTest.dat", STATUS='OLD')
	read(175,*)N1
	write(*,*)'N1 ',N1
	do 
		read(175,*,IOSTAT=ierr)xt
		write(*,*)xt
		if(ierr > 0) then
			write(*,*) 'Read failed'
			exit
		else if (ierr < 0) then
			exit
		else
			open(176, FILE="RSMOutTest1.dat", STATUS='OLD')			
			read(176,*)N2
			do i=1,N2
				read(176,*)xf
				xs(1:12)=xf(1:12)
				fs(1:3)=xf(13:15)
				do j=1,M
					if(abs(xt(j)-xs(j))<=tol) then
						cnt=cnt+1
					end if
				end do
				if(cnt==M)then
					fs(1:M)=fst(1:M)
					close(176)
					exit
				end if
			end do
			close(176)
		end if	
		do i=3,M,1
			SumXi = SumXi + (xt(i)-0.5)**2 - Cos(20*pi*(xt(i)-0.5))
		end do
		!write(*,*) 'Sum ',SumXi
		g   = 100 * (10.0 + SumXi);
		!write(*,*) 'g ',g
		ft(1) = 0.5*xt(1)*xt(2)*(1+g)
	  	ft(2)  = 0.5*xt(1)*(1-xt(2))*(1+g)
	  	ft(3)  = 0.5*(1-xt(1))*(1+g)
!			WRITE(*,*) 'Evaluate ', X, f1, f2, f3
		sumerrf1=sumerrf1+((fs(1)-ft(1))**2)
		sumerrf2=sumerrf2+((fs(2)-ft(2))**2)
		sumerrf3=sumerrf3+((fs(3)-ft(3))**2)
	write(*,*)'N1 ',N1
	end do			
	close(175)
	open(175, FILE="RSMOutTest.dat", STATUS='OLD')
	read(175,*)N1
	close(175)
			write(*,*)'sums ',sumerrf1,sumerrf2,sumerrf3
			write(*,*)'N1 ',N1
			write(*,*)sumerrf1/N1
			rms1=sqrt(sumerrf1/N1)
			rms2=sqrt(sumerrf2/N1)
			rms3=sqrt(sumerrf3/N1)
		write(*,*)'rms:',rms1,rms2,rms3

END PROGRAM EvalSur
