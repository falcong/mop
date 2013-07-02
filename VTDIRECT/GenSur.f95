		PROGRAM GenSur
		USE REAL_PRECISION
		USE linear_shepard_mod, ONLY: LSHEP

		IMPLICIT NONE
		INTEGER :: I, J, K, IER, M, N, ierr
  		REAL(KIND=R8), ALLOCATABLE :: F1(:), F2(:), F3(:), A(:,:), RW(:), X(:,:), RS_XT(:)

		OPEN(75, FILE="tregion.dat", STATUS='OLD')
		READ (75,*) N

		!
		! M is the dimension of the test data
		! N is the number of samples per dimension for the test points
		! 
		M=12
	  ALLOCATE ( A(M,N), X(M,N), F1(N), F2(N), F3(N), RW(N), RS_XT(M) )
	  DO I= 1, N
	   read(75,*) X(:,I), F1(I), F2(I), F3(I)
		write(*,*)X(:,I)
	  END DO
	  CLOSE(75)
	!
	! Perform Linear Shepard interpolation on a uniform grid
	! of N1**M points.  Calculate and report the error.
	!
	 CALL LSHEP ( M, N, X, F1, A, RW, IER )
 !   WRITE ( *, * ) 'IER = ', IER
	  IF (IER > 0) THEN
				IF(IER > 2) THEN
		      WRITE ( *, * ) 'Error return from LSHEP, IER = ', IER
		      STOP
				END IF
	  END IF
	  do J=1,N	
		  write(*,*)A(:,J)
	  end do

  	  OPEN(95, FILE="lshepwa.dat", STATUS='OLD', POSITION='APPEND')
	  write(95,*)'M'
	  write(95,*)M
	  write(95,*)'N'
	  write(95,*)N
	  write(95,*)'X'
	  do J=1,N	
		  write(95,*)X(:,J)
	  end do
	  write(95,*)'F1'
	  write(95,*)F1
	  write(95,*)'A'
	  do K=1,N	
		  write(95,*)A(:,K)
	  end do
	  write(95,*)'RW'
	  write(95,*)RW

	!
	! Perform Linear Shepard interpolation on a uniform grid
	! of N1**M points.  Calculate and report the error.
	!
	  CALL LSHEP ( M, N, X, F2, A, RW, IER )
 !   WRITE ( *, * ) 'IER = ', IER
	  IF (IER > 0) THEN
				IF(IER > 2) THEN
		      WRITE ( *, * ) 'Error return from LSHEP, IER = ', IER
		      STOP
				END IF
	  END IF
	  write(95,*)'F2'
	  write(95,*)F2
	  write(95,*)'A'
	  do K=1,N	
		  write(95,*)A(:,K)
	  end do
	  write(95,*)'RW'
	  write(95,*)RW

	!
	! Perform Linear Shepard interpolation on a uniform grid
	! of N1**M points.  Calculate and report the error.
	!
	  CALL LSHEP ( M, N, X, F3, A, RW, IER )
   ! WRITE ( *, * ) 'IER = ', IER
	  IF (IER > 0) THEN
				IF(IER > 2) THEN
		      WRITE ( *, * ) 'Error return from LSHEP, IER = ', IER
		      STOP
				END IF
	  END IF
	  write(95,*)'F3'
	  write(95,*)F3
	  write(95,*)'A'
	  do K=1,N	
		  write(95,*)A(:,K)
	  end do
	  write(95,*)'RW'
	  write(95,*)RW


		DEALLOCATE(X)
		DEALLOCATE(A)
		DEALLOCATE(F1)
		DEALLOCATE(F2)
		DEALLOCATE(F3)
		DEALLOCATE(RW)
		DEALLOCATE(RS_XT)

		END PROGRAM GenSur
