		MODULE TestObjSur_MOD
		USE REAL_PRECISION
		USE linear_shepard_mod, ONLY: LSHEP, LSHEPVAL
		CONTAINS

		SUBROUTINE TestObjSur(XT, OBJ)
		IMPLICIT NONE
		INTEGER :: I, IER, J, K, M, N
  		REAL(KIND=R8), ALLOCATABLE :: F1(:), F2(:), F3(:), A(:,:), RW(:), X(:,:)
		REAL(KIND = R8), DIMENSION(1), INTENT(OUT):: OBJ
		REAL(KIND = R8), DIMENSION(12), INTENT(IN):: XT
		REAL(KIND = R8):: obj1
		REAL(KIND = R8):: obj2
		REAL(KIND = R8):: obj3
		REAL(KIND = R8), DIMENSION(3):: wt

		OPEN(65, FILE="weight.dat", STATUS='OLD')
		READ(65,*) wt
		CLOSE(65)

 	  OPEN(222, FILE="lshepwa.dat", STATUS='OLD')

	  read(222,*)M
	  read(222,*)N

	  ALLOCATE ( A(M,N), X(M,N), F1(N), F2(N), F3(N), RW(N) )

	  do J=1,N	
		  read(222,*)X(:,J)
	  end do
	  read(222,*)F1
	  do K=1,N	
		  read(222,*)A(:,K)
	  end do
	  read(222,*)RW	  
	
 	  obj1 =  LSHEPVAL( XT, M, N, X, F1, A, RW, IER )

	  read(222,*)F2
	  do K=1,N	
		  read(222,*)A(:,K)
	  end do
	  read(222,*)RW	  

	  obj2 =  LSHEPVAL( XT, M, N, X, F2, A, RW, IER )

	  read(222,*)F3
	  do K=1,N	
		  read(222,*)A(:,K)
	  end do
	  read(222,*)RW	  
	  obj3 =  LSHEPVAL( XT, M, N, X, F3, A, RW, IER )
	  close(222)


		!write(*,*)XT,' ',obj1,' ',obj2,' ',obj3
		open(500, file="RSMOutTest1.dat", status='old', position='APPEND')									
		write(500,*)XT, obj1, obj2, obj3
		close(500)

		OBJ = wt(1) * obj1 + wt(2) * obj2 + wt(3) * obj3 

		DEALLOCATE(X)
		DEALLOCATE(A)
		DEALLOCATE(F1)
		DEALLOCATE(F2)
		DEALLOCATE(F3)
		DEALLOCATE(RW)
		END SUBROUTINE TestObjSur

		END MODULE TestObjSur_MOD
