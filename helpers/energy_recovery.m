function [se]=energy_recovery(prop,node,elem,mode,L)
%BWS
%7 January 2004
%Calculate all membrane and bending strain energy for any mode shape
%
%Input
%node: [node# x z dofx dofz dofy dofrot stress] nnodes x 8;
%elem: [elem# nodei nodej t mat#] nelems x 5;
%mode: vector of displacements global dof [u1 v1...un vn w1 01...wn 0n]',
%      example is shapes(:,i,j) where i is length index, j is mode index
%L: length at which mode is taken, i.e., lengths(i)
%y L distance where strain is desired, typically at L=0 or L/2
%
%Output
%se = [sem seb]
%
nnodes=length(node(:,1));
for i=1:length(elem(:,1))
	%Get element geometry
	nodei = elem(i,2);	   nodej = elem(i,3);
	xi = node(nodei,2);	   xj = node(nodej,2);
	zi = node(nodei,3);	   zj = node(nodej,3);
    b = sqrt((xj-xi)^2+(zj-zi)^2);
    t = elem(i,4);
	%Determine the global element displacements
	%dbar is the nodal displacements for the element in global
	%coordinates. dbar=(u1 v1 u2 v2 w1 o1 w2 o2)';
	dbar(1:2,1)=mode(2*nodei-1:2*nodei);
	dbar(3:4,1)=mode(2*nodej-1:2*nodej);
	dbar(5:6,1)=mode(2*nnodes+2*nodei-1:2*nnodes+2*nodei);
	dbar(7:8,1)=mode(2*nnodes+2*nodej-1:2*nnodes+2*nodej);
	%transform the dbar to local coordinates d
	phi=atan2(-(zj-zi),(xj-xi));
	d=gammait(phi,dbar);
    %determine the local element stiffness
	m=1;
    a=L;
	matnum=elem(i,5);
    row=find(matnum==prop(:,1));
    Ex=prop(row,2);
	Ey=prop(row,3);
	vx=prop(row,4);
	vy=prop(row,5);
	G=prop(row,6);
	[k_l]=klocal(Ex,Ey,vx,vy,G,t,a,b,m);
    se(i,1)=0.5*d(1:4)'*k_l(1:4,1:4)*d(1:4);
    se(i,2)=0.5*d(5:8)'*k_l(5:8,5:8)*d(5:8);
end
