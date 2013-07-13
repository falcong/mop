! This file (sample_main.f95) contains a test program that calls VTdirect,
! the sequential implementation of DIRECT, to optimize five test
! objective functions defined in the file objfunc.f95.

PROGRAM TEST_MAIN
USE VTdirect_MOD  ! The module for VTdirect.
!USE TestObjSur_MOD  ! The module for obj function
USE TestObj_MOD  ! The module for obj function
IMPLICIT NONE

! Local variables.
CHARACTER(len=12) :: nmlfile ! Name list file name.
CHARACTER(len=2) :: objnm ! Objective function short names.
INTEGER :: ierr ! error status 
INTEGER :: ind, indx ! loop index
INTEGER :: chkpt_start ! Checkpointing method option given
  ! in the namelist file.
INTEGER :: c_switch ! Convex hull processing option.
INTEGER :: eval_lim ! Limit on number of function evaluations.
INTEGER :: i ! Loop counter.
INTEGER :: iter_lim ! Limit on number of iterations.
INTEGER, PARAMETER :: MAX_N=154 ! The maximum problem dimension due to the
  ! limited array sizes for 'LB' and 'UB' (lower and upper bounds) given in
  ! the namelist file. Users can change it to accommodate a particular
  ! application.
INTEGER :: N ! Problem dimension given in the namelist file.
INTEGER :: n_optbox ! Number of best boxes given in the namelist file.
INTEGER :: Nv ! Problem dimensions for verification.
INTEGER :: status ! Return status from VTdirect().
INTEGER :: test_opt ! Test option for selecting objective functions.
INTEGER :: numND ! Number of nondominated solutions so far
INTEGER :: evl, evl_orig ! Dynamic eval lim 
REAL(KIND = R8) :: diam_lim ! Minimum box diameter given in the namelist file.
REAL(KIND = R8) :: eps_fmin ! Tolerance (in the namelist file) defining the
  ! minimum acceptable potential improvement in a potentially optimal box.
REAL(KIND = R8) :: FMIN ! Objective function value at X.
REAL(KIND = R8), DIMENSION(:), ALLOCATABLE :: L, U ! Lower and upper bounds
  ! defining n-dimensional search space.
REAL(KIND = R8), DIMENSION(MAX_N) :: LB, UB ! Lower and upper bounds given in
  ! the namelist file.
REAL(KIND = R8) :: min_sep ! Minimum separation (in the namelist file) between
  ! center points of the best boxes.
REAL(KIND = R8) :: objf_conv ! The smallest acceptable relative improvement
  ! in FMIN between iterations, specified in the namelist file.
REAL(KIND = R8), DIMENSION(:), ALLOCATABLE :: Wa ! Weight array.
REAL(KIND = R8), DIMENSION(MAX_N) :: weight ! A positive real array for
  ! computing the distance between two points X and Y as:
  ! SQRT(SUM( (X-Y)*diag(weight)*(X-Y) )).
REAL(KIND = R8), DIMENSION(:), ALLOCATABLE :: X ! Minimizing vector.
REAL(KIND = R8) :: wt ! weight for aggregating objectives
REAL(KIND = R8), DIMENSION(2) :: c
REAL(KIND = R8) :: f
REAL(KIND = R8), DIMENSION(:), ALLOCATABLE :: f1_t, f2_t, x1_t, x2_t
TYPE(HyperBox), DIMENSION(:), ALLOCATABLE :: box_set ! An empty array of TYPE
  ! (Hyperbox) to be filled with as many as SIZE(box_set) best boxes if the
  ! optional argument BOX_SET is set.
REAL(KIND = R8), DIMENSION(4,3) :: wts
!REAL(KIND = R8), DIMENSION(3) :: wts

! Procedure interfaces for objective functions.
INTERFACE
  FUNCTION  Obj_TEST(c, iflag) RESULT(f)
!		USE TestObjSur_MOD
		USE TestObj_MOD
    USE REAL_PRECISION, ONLY : R8
    REAL(KIND = R8), DIMENSION(:), INTENT(IN):: c
    INTEGER, INTENT(OUT):: iflag
    REAL(KIND = R8):: f
  END
END INTERFACE

! Name lists for problem configuration 'PROBLEM', optimization parameters
! 'OPTPARM', and checkpointing options 'CHKPTOP'.
NAMELIST /PROBLEM/ N, LB, UB
NAMELIST /OPTPARM/ iter_lim, eval_lim, diam_lim, objf_conv, eps_fmin, &
  c_switch, min_sep, weight, n_optbox
NAMELIST /CHKPTOP/ chkpt_start

!data wts /0,0,1,0.33,0,1,0,0.33,1,0,0,0.34/
!data wts /1,0,0/
! Prepare the objective function names, problem dimensions, test results
! for verification.
objnm = 'TT'
Nv = 2

	WRITE (*,*) "VTdirect test results:"
	OPEN(UNIT=555, FILE='results1.dat', STATUS='OLD', POSITION='APPEND', IOSTAT=ierr)
   IF (ierr /= 0) THEN
    WRITE (*,FMT='(3A,I3)') "Error opening results file"
    STOP
	 END IF
! Print out the header of test results.
! Loop calling VTdirect subroutine to optimize five test functions.

  ! Read the namelists for the current 'test_opt'. This serves as an
  ! example of varying input parameters at run-time for calling VTdirect.
  nmlfile = 'directTT.nml'
  OPEN(UNIT=111, FILE=nmlfile, IOSTAT=status)
  IF (status /= 0) THEN
    WRITE (*,FMT='(3A,I3)') "Error opening file ",nmlfile,":",status
    STOP
  END IF
  READ(UNIT=111, NML=PROBLEM, IOSTAT=status)
  IF (status /= 0) THEN
    CLOSE(UNIT=111)
    WRITE (*,FMT='(3A,I3)') "Error reading name list PROBLEM in ",nmlfile, &
      ":",status
    STOP
  END IF
  READ(UNIT=111, NML=OPTPARM, IOSTAT=status)
  IF (status /= 0) THEN
    CLOSE(UNIT=111)
    WRITE (*,FMT='(3A,I3)') "Error reading name list OPTPARM in ",nmlfile, &
      ":", status
    STOP
  END IF
  READ(UNIT=111, NML=CHKPTOP, IOSTAT=status)
  IF (status /= 0) THEN
    CLOSE(UNIT=111)
    WRITE (*,FMT='(3A,I3)') "Error reading name list CHKPTOP in ",nmlfile, &
      ":", status
    STOP
  END IF
  CLOSE(UNIT=111)
  ! Check the sanity of the input parameters from the namelist.
  IF (N <= MAX_N) THEN
    ALLOCATE(L(N))
    ALLOCATE(U(N))
    ALLOCATE(X(N))
    ALLOCATE(Wa(N))
  ELSE
    STOP "Please make MAX_N larger in this main program."
  END IF
  L(1:N) = LB(1:N)
  U(1:N) = UB(1:N)
  Wa(1:N) = weight(1:N)
  IF ( (objf_conv < 0.0_R8) .OR. (objf_conv > 1.0_R8) .OR.  &
       (eps_fmin < 0.0_R8) .OR. (eps_fmin > 1.0_R8) ) THEN
    STOP "ERROR: objf_conv or eps_fmin is out of range."
  END IF
  IF ( (c_switch < 0) .OR. (c_switch > 1) ) THEN
    STOP "ERROR: c_switch is out of range."
  END IF
  IF ( (n_optbox < 1) .OR. ( (n_optbox > 1) .AND. &
                             (min_sep < EPSILON(0.0_R8)) ) ) THEN
    STOP "ERROR: min_sep or n_optbox is out of range."
  END IF
  IF ( (chkpt_start < 0) .OR. (chkpt_start > 2) ) THEN
    STOP "ERROR: chkpt_start is out of range."
  END IF
	evl_orig = eval_lim
  DO ind = 1, 4, 1
	 evl = evl_orig
!	 DO wt = 0, 2, 1
		OPEN(25, FILE="RSMOutTest.dat", STATUS='REPLACE')
		CLOSE(25)
	! 	evl = evl + 10
	 	eval_lim = evl
!		WRITE(*,*) 'do loop wt and eval lim', wt, 'and ', eval_lim
	 	OPEN(UNIT=666, FILE='weight.dat', STATUS='OLD', IOSTAT=ierr)
	 	  IF (ierr /= 0) THEN
  		  WRITE (*,FMT='(3A,I3)') "Error opening weight file"
  		  STOP
		 	END IF		
			WRITE(666,*) wts(ind,1),wts(ind,2),wts(ind,3)
!			WRITE(666,*) wts(1),wts(2),wts(3)
!			WRITE(*,*) wts(ind,1),wts(ind,2),wts(ind,3)
			CLOSE(666)
      IF (n_optbox == 1) THEN ! A single best box output is specified.
        CALL VTdirect(N, L, U, Obj_TEST, X, FMIN, status, SWITCH=c_switch,&
          MAX_ITER=iter_lim, MAX_EVL=eval_lim, MIN_DIA=diam_lim, &
          OBJ_CONV=objf_conv, EPS=eps_fmin, RESTART=chkpt_start)
      ELSE ! The output of multiple best boxes is specified.
        ALLOCATE(box_set(n_optbox)) ! Allocate 'box_set'.
        DO i = 1, SIZE(box_set)
           ALLOCATE(box_set(i)%c(N))
           ALLOCATE(box_set(i)%side(N))
        END DO
        CALL VTdirect(N, L, U, Obj_TEST, X, FMIN, status, SWITCH=c_switch,&
          MAX_ITER=iter_lim, MAX_EVL=eval_lim, MIN_DIA=diam_lim, &
          OBJ_CONV=objf_conv, EPS=eps_fmin, MIN_SEP=min_sep, W=Wa, &
          BOX_SET=box_set, NUM_BOX=n_optbox, RESTART=chkpt_start)
      END IF
  ! Check the returned 'status'.
  IF(status < 10) THEN ! Normal return.
    WRITE (*,113) objnm, status,FMIN,diam_lim,iter_lim,eval_lim
    113 FORMAT(' Test problem',A3,                          &
      ' completed successfully with stopping rule',I2,'.',/ &
      ' Minimum objective function value =',ES15.7,'.',/    &
      ' The minimum box diameter is',ES15.7,',',/           &
      ' the number of iterations is',I8,',',/               &
      ' and the number of objective function evaluations is',I10,'.'/)
    IF (n_optbox == 1) THEN ! Print the result of the single best box.
      WRITE (*,123,ADVANCE='NO') FMIN,X
      123 FORMAT(/," The best box with value",ES15.7," is at X ="/ &
        " (",(T3,5ES15.7))
      WRITE (*,124)
      124 FORMAT(")")
			WRITE(555,*) X, FMIN
    ELSE ! Print the results of multiple best boxes.
      DO i = 1, n_optbox
        WRITE (*,133,ADVANCE='NO') i, box_set(i)%val, box_set(i)%c
        133 FORMAT(/," Best box",I3," has value",ES15.7," at X ="/ &
        " (",(T3,5ES15.7))
        WRITE (*,124)
				WRITE (555,*) box_set(i)%c, box_set(i)%val
      END DO
      DO i = 1, SIZE(box_set)
        DEALLOCATE(box_set(i)%c)
        DEALLOCATE(box_set(i)%side)
      END DO
      DEALLOCATE(box_set) ! Deallocate 'box_set'.
    END IF
  ELSE ! Error return.
    WRITE (*,143) objnm, status
    143 FORMAT(' Test problem ',A2,' failed with error flag',I3,'.'/  &
      ' See comments in VTdirect to interpret flag.'//)
  END IF
  ! Put a separation line in between results.
  WRITE (*,153) test_opt
  153 FORMAT(" ----- End of test results for function",I2,". -----"//)
		
!	CALL system('perl ./skyline.pl')

!	OPEN(75, FILE="outskyline.dat", STATUS='OLD')
!	READ(75,*) numND;
!  ALLOCATE(x1_t(numND))
!  ALLOCATE(x2_t(numND))
!	DO indx=1, numND, 1
!		READ(75,*) x1_t(indx),x2_t(indx)
!	END DO
!	CLOSE(75)
!	DO indx=1, numND, 1
!		c(1) = x1_t(indx)
!		c(2) = x2_t(indx)
!		CALL TestObj(c,f)
!	END DO
!	CALL system('perl ./cplncnt.pl')
!  DEALLOCATE(x1_t)
!  DEALLOCATE(x2_t)
!  END DO
	END DO
	CLOSE(555)
	 ! Deallocate arrays.
  DEALLOCATE(L)
  DEALLOCATE(U)
  DEALLOCATE(X)
  DEALLOCATE(Wa)

END PROGRAM TEST_MAIN

! Include the objective function definitions.
INCLUDE "objfunc.f95"
