PROGRAM TestLSHEP
USE REAL_PRECISION
USE TestObjSur_MOD  ! The module for obj function

IMPLICIT NONE

REAL(KIND = R8), DIMENSION(12) :: c
REAL(KIND = R8), DIMENSION(1):: f

	OPEN(365, FILE="X0.dat", STATUS='OLD')
	READ(365,*) c
	CLOSE(365)

	CALL TestObjSur(c,f)
	write(*,*)c
	write(*,*)f
END PROGRAM TestLSHEP
