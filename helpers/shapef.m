function dl=shapef(links,d,b);
%BWS
%1998
%
%links: the number of additional line segments used to show the disp shape
%d: the vector of nodal displacements
%b: the actual length of the element
%
inc=1/links;
xb=(inc:inc:1-inc);  %location of additional displacements
for i=1:length(xb)
	N1=(1-3*xb(i)^2+2*xb(i)^3);
	N2=xb(i)*b*(1-2*xb(i)+xb(i)^2);
	N3=3*xb(i)^2-2*xb(i)^3;
	N4=xb(i)*b*(xb(i)^2-xb(i));
	N=[(1-xb(i))	0		xb(i)	0	0	0	0	0
	   0		(1-xb(i))	0	xb(i)	0	0	0	0
	   0		0		0	0	N1	N2	N3	N4];
	dl(:,i)=N*d;
end