		MODULE TestObjSur_MOD
		USE REAL_PRECISION
		USE linear_shepard_mod, ONLY: LSHEP, LSHEPVAL
		CONTAINS

		SUBROUTINE TestObjSur(XT, OBJ)
		IMPLICIT NONE
		INTEGER :: I, IER, J, K, M, N, iflag, ierr
  	REAL(KIND=R8), ALLOCATABLE :: F1(:), F2(:), A(:,:), RW(:), X(:,:), RS_XT(:)
		REAL(KIND = R8), DIMENSION(2), INTENT(IN):: XT
		REAL(KIND = R8), INTENT(OUT):: OBJ
		REAL(KIND = R8):: obj1
		REAL(KIND = R8):: obj2
		REAL(KIND = R8):: wt
		REAL(KIND = R8):: tol
		REAL(KIND = R8)::MaxVol
		REAL(KIND = R8)::MinFrq

		tol = 1.0e-16
		iflag = 0
	  M = 2
		MaxVol = 2.0
		MinFrq = 7.0

		OPEN(65, FILE="weight.dat", STATUS='OLD')
		READ(65,*) wt
		CLOSE(65)

		OPEN(75, FILE="RSMInTest.dat", STATUS='OLD')
		READ (75,*) N

		!
		! M is the dimension of the test data
		! N is the number of samples per dimension for the test points
		! 

	  ALLOCATE ( A(M,N), X(M,N), F1(N), F2(N), RW(N), RS_XT(M) )
	  DO I= 1, N
	    read(75,*) X(1, I), X(2, I), F1(I), F2(I)
			IF( (abs(X(1,I)-XT(1))<=tol) .AND. (abs(X(2,I)-XT(2))<=tol)) THEN
				obj1 = F1(I)
				obj2 = F2(I)
				iflag = 1
				EXIT
			END IF
	  END DO
		CLOSE(75)

IF(iflag==0) THEN

	!
	! Perform Linear Shepard interpolation on a uniform grid
	! of N1**M points.  Calculate and report the error.
	!
	  CALL LSHEP ( M, N, X, F1, A, RW, IER )
	  IF (IER > 0) THEN
				IF(IER > 2) THEN
		      WRITE ( *, * ) 'Error return from LSHEP, IER = ', IER
		      STOP
				END IF
	  END IF

		obj1 =  LSHEPVAL( XT, M, N, X, F1, A, RW, IER )
	  !WRITE(*, *) '---LSHEP----', obj1


	!
	! Perform Linear Shepard interpolation on a uniform grid
	! of N1**M points.  Calculate and report the error.
	!
	  CALL LSHEP ( M, N, X, F2, A, RW, IER )
	  IF (IER > 0) THEN
				IF(IER > 2) THEN
		      WRITE ( *, * ) 'Error return from LSHEP, IER = ', IER
		      STOP
				END IF
	  END IF

	  obj2 =  LSHEPVAL( XT, M, N, X, F2, A, RW, IER )
	  !WRITE(*, *) '---LSHEP----', obj2

		OPEN(85, FILE="RSMOutTest.dat", STATUS='OLD', POSITION='APPEND')
		WRITE(85,*) XT(1), XT(2), obj1, obj2
		CLOSE(85)

END IF

		OBJ = wt * obj1 + (1-wt) * obj2 !--- for my test problem

!		OBJ = wt*obj1/MaxVol+(1-wt)*(-obj2/MinFrq) --- Dr. Canfield's hw prob

		END SUBROUTINE TestObjSur

		END MODULE TestObjSur_MOD
