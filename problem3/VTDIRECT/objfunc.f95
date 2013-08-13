! This file (objfunc.f95) contains five test objective functions for
! both VTdirect and pVTdirect.
!

! For all the objective functions:
! On input:
! c     - Point coordinates.
!
! On output:
! f     - Function value at 'c'.
! iflag - A flag that is used to indicate the status of the
!         function evaluation. It is 0 for normal status.
!
! Obj_GR: Griewank function.
! The function formula is
! f(c) = 1+sum(c(i)^2/d)-product(cos(c(i)/sqrt(i))),
! where d = 500.0 (a bigger d value gives more local minima) and
! i is the summation index ranging from 1 to N (the number of
! dimensions). The global minimum is f(c)=0 at c(:)=(0,...,0), when c
! is in [-20, 30]^N.
!
FUNCTION Obj_TEST(c,iflag) RESULT(f)
!USE TestObjSur_MOD
USE TestObj_MOD
IMPLICIT NONE

REAL(KIND = R8), DIMENSION(:), INTENT(IN) :: c
INTEGER, INTENT(OUT) :: iflag
REAL(KIND = R8) :: f

	f=0.0_R8
	CALL TestObj(c,f)
!	CALL TestObjSur(c,f)
	iflag=0

	RETURN
END FUNCTION Obj_TEST
