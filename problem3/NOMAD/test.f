      program test

		use REAL_PRECISION
		real(KIND = R8), dimension(20):: x, lb, ub
		real(KIND = R8), dimension(3):: wts

		open(400, file="RSMOutTest.dat", status='old')								
		open(100, file="X0.dat", status='OLD')
		read(100,*) x
		read(100,*) lb
		read(100,*) ub
		close(100)
		write(400,*) x
		open(200, file="wtA.dat", status='OLD')
		do
			read(200,*,iostat=ierr) wts
			write(*,*)wts
			if(ierr > 0) then
				write(*,*) 'Read failed'
				exit
			else if (ierr < 0) then
				exit
			else 
				open(300, file="weight.dat", status='REPLACE')								
				write(300,*) wts
				close(300)
!				write(400,*) x
		      call nomad( 20 , 1 , x , lb , ub , 50 , 0 )
				write(*,*)'sol: ',x
				write(400,*) x
			end if
		end do
		close(200)
		close(400)

      end 




      subroutine bb(xx,fx)
				use TestObjSur_MOD
				!use TestObj_MOD
				use REAL_PRECISION
				implicit none

				real(kind = R8), dimension(20), intent(IN) :: xx
				real(kind = R8), dimension(1), intent(OUT):: fx

				call TestObjSur(xx, fx)
				!call TestObj(xx, fx)
	      	return
		end
