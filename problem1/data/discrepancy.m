XX=importdata('skyline.dat',' ');
m=3;
ndv=12;
maxd=0.0;
areaT=0.0;
X=XX(:,ndv+1:ndv+m);
n=size(X,1);
Y=XX(:,ndv+1:ndv+m-1);
for i=1:n
	X(i,m)=X(i,m)+1;
%	if X(i,m)<=0.0000000001 
%		for j=1:m-1
%			Y(i,j)=Y(i,j)-X(i,m)+1;
%			X(i,m)=1;
%		end
%	end
		for j=1:m-1
			Y(i,j)=Y(i,j)/X(i,m);
		end
end
if m>3
	T = delaunayn(Y);
else
	DT=DelaunayTri(Y);
	T=DT.Triangulation();
end
T=unique(T,'rows');
[nt ne]=size(T);
A=zeros(ne,ne);
vol = zeros(nt);
tvol = 0.0;
for i=1:nt
	for j=1:ne
		A(j,1:ne-1)=Y(T(i,j),:);
	end
	A=A';
	A(ne,:)=ones(1,ne);	
	vol(i) = abs((1/factorial(ne-1))*det(A));
	tvol = tvol + vol(i);
end
%disp(vol);
d=0.0;
v=0.0;
for i=1:nt-1
	v=v+vol(i);
	nv = v/tvol;
	dis = abs((i/nt)-nv);
	if(dis>d)
		d = dis;
	end
end
disp(d);
