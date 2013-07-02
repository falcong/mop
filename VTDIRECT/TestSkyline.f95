PROGRAM TestSkyline
USE REAL_PRECISION
USE TestObj_MOD  ! The module for obj function

IMPLICIT NONE

INTEGER :: ierr ! Error status for file I/O.
INTEGER :: M, N, indx, indx1
REAL(KIND = R8), DIMENSION(:,:), ALLOCATABLE :: X
REAL(KIND = R8), DIMENSION(12) :: c
REAL(KIND = R8) :: f

	M = 12
	OPEN(75, FILE="RSMOutTest.dat", STATUS='OLD')
	READ(75,*) N
!	WRITE(*,*) N
  ALLOCATE(X(M,N))
	DO indx=1, N, 1
		READ(75,*) X(:,indx)
	END DO
	CLOSE(75)
	DO indx=1, N, 1
		DO indx1=1, M
			c(indx1) = X(indx1,indx)
		END DO
		!WRITE(*,*) c
		CALL TestObj(c,f)
	END DO
!	CALL system('perl ./cplncnt.pl')
  DEALLOCATE(X)
!	OPEN(75, FILE="RSMOutTest.dat", ACTION = 'READ', STATUS ='OLD')
!	READ(75,*) numND
!	WRITE(*,*) numND
!	DO indx=1, numND, 1
!		READ(75,*) c(1), c(2), f1, f2
!		WRITE(*,*) c(1), c(2), f1, f2
!		CALL TestObj(c,f)
!	END DO
END PROGRAM TestSkyline
