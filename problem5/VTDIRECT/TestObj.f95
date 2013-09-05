		MODULE TestObj_MOD
		USE REAL_PRECISION
		CONTAINS

		SUBROUTINE TestObj(X, OBJ)
		IMPLICIT NONE
		REAL(KIND = R8), DIMENSION(:), INTENT(IN):: X
		REAL(KIND = R8), INTENT(OUT):: OBJ

		!local variables
		INTEGER::i, j, k, N, M, cnt, infeasible
		INTEGER::iflag, pflag
		INTEGER:: ierr ! Error status for file I/O.
		REAL(KIND = R8)::tol
		REAL(KIND = R8), DIMENSION(:), ALLOCATABLE :: XX
		REAL(KIND = R8), DIMENSION(6)::wt, Ft, F
		REAL(KIND = R8), DIMENSION(12)::UB, LB
		REAL(KIND = R8):: g
		REAL(KIND = R8)::SumXi, pi

		tol = 1.0e-13
		iflag = 0
		pflag = 0
		cnt = 0
		N = 12
		M = 6
		pi = 3.14159265359
		SumXi = 0.0
		data LB /0,0,0,0,0,0,0,0,0,0,0,0/
		data UB /1,1,1,1,1,1,1,1,1,1,1,1/
		infeasible=0

    	ALLOCATE(XX(N))

		OPEN(65, FILE="weight.dat", STATUS='OLD')
		READ(65,*) wt
		CLOSE(65)

		OPEN(75, FILE="RSMInTest.dat", STATUS='OLD')
		DO
			READ(75,*,IOSTAT=ierr)XX,Ft
		!	WRITE(*,*)'Stored X: ',XX
			IF(ierr > 0) THEN
				WRITE(*,*) 'Read failed'
				EXIT
			ELSE IF (ierr < 0) THEN
		!		WRITE(*,*)'infeasible X'
				do i=1,N,1
					if(X(i)<LB(i).or.X(i)>UB(i)) then
						infeasible=1
						exit
					end if
				end do
				if(infeasible>0) then
					do i=1,M
						F(i)=1.0e+13	
					end do
					iflag=1
					exit
				ELSE
					do j=6,N,1
						!SumXi = SumXi + (X(j)-0.5)**2 - Cos(20*pi*(X(j)-0.5))
						SumXi = SumXi + (X(j)-0.5)**2 
					end do
					!write(*,*) 'Sum ',SumXi
					!g   = 100 * (7.0 + SumXi)
					g   = SumXi
					!write(*,*) 'g ',g
					F(1) = abs((1+g)*Cos(X(1)*(pi/2))*Cos(X(2)*(pi/2))*Cos(X(3)*(pi/2))*Cos(X(4)*(pi/2))*Cos(X(5)*(pi/2)))
				  	F(2)  = abs((1+g)*Cos(X(1)*(pi/2))*Cos(X(2)*(pi/2))*Cos(X(3)*(pi/2))*Cos(X(4)*(pi/2))*Sin(X(5)*(pi/2)))
				  	F(3)  = abs((1+g)*Cos(X(1)*(pi/2))*Cos(X(2)*(pi/2))*Cos(X(3)*(pi/2))*Sin(X(4)*(pi/2)))
					F(4) = abs((1+g)*Cos(X(1)*(pi/2))*Cos(X(2)*(pi/2))*Sin(X(3)*(pi/2)))
					F(5) = abs((1+g)*Cos(X(1)*(pi/2))*Sin(X(2)*(pi/2)))
					F(6) = abs((1+g)*Sin(X(1)*(pi/2)))
		!			WRITE(*,*) 'Evaluate ', X, f1, f2, f3

					EXIT
				END IF
			ELSE 
				do k = 1, N, 1
					IF( (abs(X(k)-XX(k))<=tol) ) THEN
						cnt = cnt + 1
					END IF
				end do
				if(cnt.eq.N) then
					do k=1,M,1
						F(k) = abs(Ft(k))
					end do
					iflag = 1
				!	WRITE(*,*) 'off the shelf ', X, f1, f2					
					EXIT
				end if
			END IF
			cnt = 0
		END DO
		CLOSE(75)
		OBJ = 0
		do i=1,M,1
			OBJ = OBJ + wt(i)*F(i)
		end do
!		OBJ = f1+f2+f3

		IF(iflag == 0) THEN
			OPEN(85, FILE="RSMInTest.dat", STATUS='OLD', POSITION='APPEND')
			WRITE(85,*)X,F
		!	WRITE(*,*)'Write X:',X
			CLOSE(85)
		END IF

		OPEN(86, FILE="pflag.dat", STATUS='OLD')
		read(86,*)pflag
		CLOSE(86)

		if((iflag==0).and.(pflag>0)) then
			open(87, FILE="skyline.dat", STATUS='OLD', POSITION='APPEND')
			WRITE(87,*)X,F
			close(87)
		end if
		DEALLOCATE(XX)

		END SUBROUTINE TestObj

		END MODULE TestObj_MOD

