		MODULE TestObjSur_MOD
		USE REAL_PRECISION
		USE linear_shepard_mod, ONLY: LSHEP, LSHEPVAL
		CONTAINS

		SUBROUTINE TestObjSur(XT, OBJ)
		IMPLICIT NONE
		INTEGER :: I, IER, J, K, M, N, NR
  		REAL(KIND=R8), ALLOCATABLE :: F(:), A(:,:), RW(:), X(:,:), FT(:), WT(:)
		REAL(KIND = R8), DIMENSION(1), INTENT(OUT):: OBJ
		REAL(KIND = R8), DIMENSION(12), INTENT(IN):: XT

		M = 6
  	   OPEN(222, FILE="lshepwa.dat", STATUS='OLD')

	   read(222,*)N
	   read(222,*)NR

	   ALLOCATE ( A(N,NR), X(N,NR), F(NR), RW(NR), WT(M), FT(M) )

		OPEN(65, FILE="weight.dat", STATUS='OLD')
		READ(65,*) WT
		CLOSE(65)

	   do J=1,NR	
		  read(222,*)X(:,J)
	   end do
		do J=1,M
		  read(222,*)F
		  do K=1,NR	
			  read(222,*)A(:,K)
		  end do
		  read(222,*)RW	
	 	  FT(J) =  LSHEPVAL( XT, N, NR, X, F, A, RW, IER )
		end do
		close(222)

!		write(*,*)XT,FT,WT
		open(500, file="RSMOutTest1.dat", status='old', position='APPEND')									
		write(500,*)XT, FT
		close(500)

		do I=1,M		
			OBJ = OBJ + WT(I) * FT(I)
		end do

!		write(*,*)OBJ
		DEALLOCATE(X)
		DEALLOCATE(A)
		DEALLOCATE(F)
		DEALLOCATE(RW)
		DEALLOCATE(WT)
		DEALLOCATE(FT)		
		END SUBROUTINE TestObjSur

		END MODULE TestObjSur_MOD
