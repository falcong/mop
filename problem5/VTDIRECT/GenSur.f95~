		PROGRAM GenSur
		USE REAL_PRECISION
		USE linear_shepard_mod, ONLY: LSHEP

		IMPLICIT NONE
		INTEGER :: I, J, K, IER, M, N, NR, ierr
  		REAL(KIND=R8), ALLOCATABLE :: FA(:,:), F(:), A(:,:), RW(:), X(:,:), RS_XT(:)

		!
		! N is the dimension of the test data
		! M is the dimension of the objective space
		! NR is the number of samples per dimension for the test points
		! 

		N = 12
		M = 6
		OPEN(75, FILE="tregion.dat", STATUS='OLD')
		READ (75,*) NR
	   ALLOCATE ( A(N,NR), X(N,NR), FA(M,NR), F(NR), RW(NR), RS_XT(N) )
	   DO I= 1, NR
	    read(75,*) X(:,I), FA(:,I)
	   END DO
	   CLOSE(75)
		
  	   OPEN(95, FILE="lshepwa.dat", STATUS='OLD', POSITION='APPEND')
		write(95,*)N
		write(95,*)NR
		do J=1,NR	
		  write(95,*)X(:,J)
		end do

		do I=1, M

			F = FA(I,:)
			
		 	CALL LSHEP ( N, NR, X, F, A, RW, IER )
			!   WRITE ( *, * ) 'IER = ', IER
			IF (IER > 0) THEN
					IF(IER > 2) THEN
				   WRITE ( *, * ) 'Error return from LSHEP, IER = ', IER
				   STOP
					END IF
			END IF

			write(95,*)F
			do K=1,NR	
			  write(95,*)A(:,K)
			end do
			write(95,*)RW
		end do

		DEALLOCATE(X)
		DEALLOCATE(A)
		DEALLOCATE(F)
		DEALLOCATE(FA)
		DEALLOCATE(RW)
		DEALLOCATE(RS_XT)

		END PROGRAM GenSur
