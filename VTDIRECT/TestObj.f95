		MODULE TestObj_MOD
		USE REAL_PRECISION
		CONTAINS

		SUBROUTINE TestObj(X, OBJ)
		IMPLICIT NONE
		REAL(KIND = R8), DIMENSION(:), INTENT(IN):: X
		REAL(KIND = R8), INTENT(OUT):: OBJ

		!local variables
		INTEGER::i, N, cnt, infeasible
		INTEGER::iflag
		INTEGER:: ierr ! Error status for file I/O.
		REAL(KIND = R8)::tol
		REAL(KIND = R8), DIMENSION(:), ALLOCATABLE :: XX
		REAL(KIND = R8), DIMENSION(3)::wt
		REAL(KIND = R8), DIMENSION(12)::UB, LB
		REAL(KIND = R8):: f1
		REAL(KIND = R8):: f2
		REAL(KIND = R8):: f3
		REAL(KIND = R8):: f1_t
		REAL(KIND = R8):: f2_t
		REAL(KIND = R8):: f3_t
		REAL(KIND = R8):: g
		REAL(KIND = R8)::SumXi, pi

		tol = 1.0e-13
		iflag = 0
		cnt = 0
		N = 12
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
			READ(75,*,IOSTAT=ierr)XX,f1_t,f2_t,f3_t
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
					f1=1.0e+13	
					f2=1.0e+13	
					f3=1.0e+13	
					iflag=1
					exit
				ELSE
					do i=3,N,1
						SumXi = SumXi + (X(i)-0.5)**2 - Cos(20*pi*(X(i)-0.5))
					end do
					!write(*,*) 'Sum ',SumXi
					g   = 100 * (10.0 + SumXi);
					!write(*,*) 'g ',g
					f1 = 0.5*X(1)*X(2)*(1+g)
				  	f2  = 0.5*X(1)*(1-X(2))*(1+g)
				  	f3  = 0.5*(1-X(1))*(1+g)
		!			WRITE(*,*) 'Evaluate ', X, f1, f2, f3

					EXIT
				END IF
			ELSE 
				do i = 1, N, 1
					IF( (abs(X(i)-XX(i))<=tol) ) THEN
						cnt = cnt + 1
					END IF
				end do
				if(cnt.eq.N) then
					f1 = f1_t
					f2 = f2_t
					f3 = f3_t
					iflag = 1
				!	WRITE(*,*) 'off the shelf ', X, f1, f2					
					EXIT
				end if
			END IF
			cnt = 0
		END DO
		CLOSE(75)

		
		OBJ = wt(1)*f1+wt(2)*f2+wt(3)*f3

		IF(iflag == 0) THEN
			OPEN(85, FILE="RSMInTest.dat", STATUS='OLD', POSITION='APPEND')
			WRITE(85,*)X,f1,f2,f3
		!	WRITE(*,*)'Write X:',X
			CLOSE(85)
		END IF

		DEALLOCATE(XX)

		END SUBROUTINE TestObj

		END MODULE TestObj_MOD

