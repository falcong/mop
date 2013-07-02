		MODULE TestObjSur_MOD
		USE REAL_PRECISION
		USE linear_shepard_mod, ONLY: LSHEP, LSHEPVAL
		CONTAINS

		SUBROUTINE TestObjSur(XT, OBJ)
		IMPLICIT NONE
		INTEGER :: I, IER, J, K, M, N, iflag, ierr, tmatched
  		REAL(KIND=R8), ALLOCATABLE :: F1(:), F2(:), F3(:), A(:,:), RW(:), X(:,:), RS_XT(:)
		REAL(KIND = R8), DIMENSION(12), INTENT(IN):: XT
		REAL(KIND = R8), DIMENSION(12):: XTMP, LB, UB
		REAL(KIND = R8), DIMENSION(1), INTENT(OUT):: OBJ
		REAL(KIND = R8):: obj1
		REAL(KIND = R8):: obj2
		REAL(KIND = R8):: obj3
		REAL(KIND = R8), DIMENSION(3):: wt
		REAL(KIND = R8):: tol
		REAL(KIND = R8)::MaxVol
		REAL(KIND = R8)::MinFrq

		tol = 1.0e-16
		iflag = 0
		tmatched = 0

		OPEN(65, FILE="weight.dat", STATUS='OLD')
		READ(65,*) wt
		CLOSE(65)

		OPEN(75, FILE="tregion.dat", STATUS='OLD')
		READ (75,*) N

		!
		! M is the dimension of the test data
		! N is the number of samples per dimension for the test points
		! 
		M=12
	  ALLOCATE ( A(M,N), X(M,N), F1(N), F2(N), F3(N), RW(N), RS_XT(M) )
	  DO I= 1, N
	   read(75,*) XTMP, F1(I), F2(I), F3(I)
!		write(*,*) XTMP, F1(I), F2(I), F3(I)
		DO J = 1, M
			X(J,I)=XTMP(J)
			IF( (abs(XTMP(J)-XT(J))<=tol)) THEN
					tmatched = tmatched + 1
			END IF
		END DO
!		write(*,*) XTMP, XT, tmatched
		IF(tmatched.eq.M) THEN	
			obj1 = F1(I)
			obj2 = F2(I)
			obj3 = F3(I)
			iflag = 1
			write(*,*)'off the shelf: ',obj1,obj2,obj3		
			EXIT
		END IF
		tmatched=0
	  END DO
	  CLOSE(75)
	  DO I= 1, N
		!	write(*,*) X(:,I),F1(I),F2(I),F3(I)
		END DO
IF(iflag==0) THEN
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

		obj1 =  LSHEPVAL( XT, M, N, X, F1, A, RW, IER )
!	  WRITE(*, *) '---LSHEP----', IER, obj1


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

	  obj2 =  LSHEPVAL( XT, M, N, X, F2, A, RW, IER )
!	  WRITE(*, *) '---LSHEP----', IER, obj2

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

	  obj3 =  LSHEPVAL( XT, M, N, X, F3, A, RW, IER )
	 ! WRITE(*, *) '---LSHEP----', IER, obj3

!		OPEN(85, FILE="RSMOutTest.dat", STATUS='OLD', POSITION='APPEND')
!		WRITE(*,*) XT, obj1, obj2, obj3
!		CLOSE(85)

END IF

		OBJ = wt(1) * obj1 + wt(2) * obj2 + wt(3) * obj3 !--- for my test problem

!		OBJ = wt*obj1/MaxVol+(1-wt)*(-obj2/MinFrq) --- Dr. Canfield's hw prob

		DEALLOCATE(X)
		DEALLOCATE(A)
		DEALLOCATE(F1)
		DEALLOCATE(F2)
		DEALLOCATE(F3)
		DEALLOCATE(RW)
		DEALLOCATE(RS_XT)
		END SUBROUTINE TestObjSur

		END MODULE TestObjSur_MOD
