PROGRAM ComputeGD
USE REAL_PRECISION
		IMPLICIT NONE
		!local variables
		REAL(KIND = R8)::x1
		REAL(KIND = R8)::x2
		REAL(KIND = R8):: f1
		REAL(KIND = R8):: f2
		REAL(KIND = R8):: g
		REAL(KIND = R8):: h
		REAL(KIND = R8)::alpha, pi, q

		OPEN(110, FILE="GD.dat", STATUS='OLD')
		alpha = 2
		pi = 3.14
		q = 4

		do x1=0,1,0.002
			do x2=0,1,0.002
				f1 = x1
				g=1+10*x2

				h = 1 - (f1/g)**alpha - (f1/g)*Sin(2*pi*q*f1)
				f2 = g*h
				if(f1<1.1 .and. f2<1.1) then
					write(110,*)x1, x2, f1, f2
				end if
			end do
		end do
		
		CLOSE(110)
END PROGRAM ComputeGD
