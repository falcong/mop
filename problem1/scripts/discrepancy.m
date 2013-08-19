XX=importdata('skyline.dat',' ');
ndv=12;
maxd=0.0;
areaT=0.0;
X=XX(:,ndv+1:ndv+3);
n=size(X,1);
Y=XX(:,ndv+1:ndv+2);
for i=1:n
	if X(i,3)<=0.0000000000001 
		Y(i,1)=Y(i,1)-X(i,3)+1;
		Y(i,2)=Y(i,2)-X(i,3)+1;
		X(i,3)=X(i,3)-X(i,3)+1;
	end
		Y(i,1)=Y(i,1)/X(i,3);
		Y(i,2)=Y(i,2)/X(i,3);
end
DT=DelaunayTri(Y);
T=DT.Triangulation();
%disp(T);
nt=size(T,1);
for i=1:nt
	A=X(T(i,1),:);
	B=X(T(i,2),:);
	C=X(T(i,3),:);
	M=[j,k,l;B(1)-A(1),B(2)-A(2),B(3)-A(3);C(1)-A(1),C(2)-A(2),C(3)-A(3)];
	areaT = areaT + abs((1/2)*det(M));
	disp(areaT);
	d = abs ((i/nt)-areaT);
%	disp(d);
	if(d>maxd)
		maxd=d;
	end
end
disp(maxd);

