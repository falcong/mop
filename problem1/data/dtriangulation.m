digits(20);
ndv=12;
XX=importdata('skyline.dat',' ');
X=XX(:,ndv+1:ndv+3);
n=size(X,1);
Y=XX(:,ndv+1:ndv+2);
Yc=zeros(3);
for i=1:n
	if X(i,3)<=0.0000000001 
		Y(i,1)=Y(i,1)-X(i,3)+1;
		Y(i,2)=Y(i,2)-X(i,3)+1;
		X(i,3)=1;
	end
		Y(i,1)=Y(i,1)/X(i,3);
		Y(i,2)=Y(i,2)/X(i,3);
end
A=[0,0,1;0,1,0;1,0,0];
dlmwrite('wtA.dat',A,'delimiter',' ');
B=zeros(n,n);
B(1:n,1:n)=-1.0;
flg=1;
Xc=zeros(1,ndv);
Xlb=zeros(1,ndv);
Xub=zeros(1,ndv);
if n<3
	if n>1
		for j=1:n
			for k=1:n
				if j~=k
	  		   	B(j,k)=norm(X(j,:)-X(k,:));
					B(k,j)=B(j,k);
				end
			end
		end
	else
		flg=0;		
		Xc=X(n,:);
	end	
else
	DT=DelaunayTri(Y);
	E=edges(DT);
%	E=importdata('edges.dat',' ');
	m=size(E,1);
	j=0;k=0;
	for i=1:m
		 j=E(i,1);
		 k=E(i,2);
		 B(j,k)=norm(X(j,:)-X(k,:));
		 B(k,j)=B(j,k);
	end
end
if(flg)
	csum=0.0;
	cnt=0;
	avgd=0.0;
	distmap=zeros(n,2);
	for i=1:n
		 for j=1:n
		     if B(i,j)>0
		         csum=csum+B(i,j);
		         cnt = cnt+1;
			  end
		 end
		if cnt>0
			avgd=csum/cnt;
			s=[i,avgd];
			distmap(i,:)=s;
		end
		cnt=0;
		csum=0.0;
	end
	distmap=sortrows(distmap,-2);
	Xi=zeros(1,n);
	dlta=0.0;
	argmaxd=0;
	found=0;
	iflg=0;
	YY=importdata('Xc.dat',' ');
	if ~isempty(YY)	
		for i=1:n
			argmaxd=distmap(i,1);
			Xi=XX(argmaxd,1:ndv);
			for j=1:size(YY,1)
				S=abs(YY(j,1:ndv)-Xi);
				t=sum(S(:)<1.0e-2);
				if t==12
					found=j;
					break;
				end
			end
			if found
				if YY(found,ndv+4)>0.05
					disp('found');
					YY(found,ndv+4)=YY(found,ndv+4)/2;
					dlta=YY(found,ndv+4);
					dlmwrite('Xc.dat',YY,'delimiter',' ');								
					Xc=Xi;
					break;
				else
%					disp('found elsecase');
					found=0;
					continue;
				end						
			else
				for i=1:size(YY,1)
				%	disp(norm(XX(argmaxd,1:ndv)-YY(i,1:ndv),2));
					disp(norm(XX(argmaxd,ndv+1:ndv+3)-YY(i,ndv+1:ndv+3),2));
					if(norm(XX(argmaxd,1:ndv)-YY(i,1:ndv),2)<0.02 | norm(XX(argmaxd,ndv+1:ndv+3)-YY(i,ndv+1:ndv+3),2)<0.02) 
						iflg=1;
						break;
					end
				end
				if iflg>0
					iflg=0;
					found=0;
					continue;				
				else
					Xc=Xi;
					dlta=0.2;
					Yc=XX(argmaxd,ndv+1:ndv+3);		
					s=[Xc,Yc,dlta];
					%disp(s);
					dlmwrite('Xc.dat',s,'-append','delimiter',' ');		
					break;
				end
			end
			found=0;
			iflg=0;
		end
	else
		dlta=0.2;
		argmaxd=distmap(1,1);
		Xc=XX(argmaxd,1:ndv);
		Yc=XX(argmaxd,ndv+1:ndv+3);
		s=[Xc,Yc,dlta];
		dlmwrite('Xc.dat',s,'delimiter',' ');
	end	
csum=0.0;
z=0;
for i=1:n
	if B(argmaxd,i)>0
		D=abs(X(argmaxd,:)-X(i,:));
		m=size(D,2);
		WT=zeros(1,m);
		for j=1:m
			if D(:,j)>0
				csum=csum+(1/D(:,j));
			else
				WT(j)=0.0;
				z=j;
			end
		end
%		if z>0
%			c=0.8/csum;
%		else
			c=1/csum;
%		end	
		for j=1:m
			if j~=z
				WT(j)=c*(1/D(:,j));
			end 
		end
		dlmwrite('wtA.dat',WT,'-append','delimiter',' ');
	end
	csum=0.0;
	z=0;
end
end
dlmwrite('X0.dat',Xc,'delimiter',' ');
Xlb=Xc-dlta;
for i=1:ndv
	if(Xlb(i)<0)
		Xlb(i)=0;
	end
end
dlmwrite('X0.dat',Xlb,'-append','delimiter',' ');
Xub=Xc+dlta;
for i=1:ndv
	if(Xub(i)>1)
		Xub(i)=1;
	end
end
dlmwrite('X0.dat',Xub,'-append','delimiter',' ');
dlmwrite('X0.dat',dlta,'-append');
disp('Done!');
