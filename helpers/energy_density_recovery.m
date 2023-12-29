function [se]=energy_density_recovery(prop,node,elem,mode,L,BC,m_a)
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
%
%Output
%se = [sem seb]
%
%August 2009
%sem and seb are divided by tba to turn it into energy density.
%
%Z. Li, August 2010
%for general boundary conditions.
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
    totalm=length(m_a);%Total number of longitudinal terms
    duv=zeros(4*totalm,1);
    dwo=zeros(4*totalm,1);
    for mn=1:totalm
        dbar(1:2,1)=mode(4*nnodes*(mn-1)+2*nodei-1:4*nnodes*(mn-1)+2*nodei);
        dbar(3:4,1)=mode(4*nnodes*(mn-1)+2*nodej-1:4*nnodes*(mn-1)+2*nodej);
        dbar(5:6,1)=mode(4*nnodes*(mn-1)+2*nnodes+2*nodei-1:4*nnodes*(mn-1)+2*nnodes+2*nodei);
        dbar(7:8,1)=mode(4*nnodes*(mn-1)+2*nnodes+2*nodej-1:4*nnodes*(mn-1)+2*nnodes+2*nodej);
        %transform the dbar to local coordinates d
        phi=atan2(-(zj-zi),(xj-xi));
        d=gammait(phi,dbar);
        duv((4*(mn-1)+1):(4*(mn-1)+4),1)=d(1:4,1);
        dwo((4*(mn-1)+1):(4*(mn-1)+4),1)=d(5:8,1);
    end
    %determine the local element stiffness
    a=L;
	matnum=elem(i,5);
    row=find(matnum==prop(:,1));
    Ex=prop(row,2);
	Ey=prop(row,3);
	vx=prop(row,4);
	vy=prop(row,5);
	G=prop(row,6);
    [k_l]=klocal(Ex,Ey,vx,vy,G,t,a,b,BC,m_a);
    kuv=zeros(4*totalm);
    kwo=zeros(4*totalm);
    for mn=1:totalm
        for mp=1:totalm
        kuv((4*(mn-1)+1):(4*(mn-1)+4),(4*(mp-1)+1):(4*(mp-1)+4))=k_l((8*(mn-1)+1):(8*(mn-1)+4),(8*(mp-1)+1):(8*(mp-1)+4));
        kwo((4*(mn-1)+1):(4*(mn-1)+4),(4*(mp-1)+1):(4*(mp-1)+4))=k_l((8*(mn-1)+5):(8*(mn-1)+8),(8*(mp-1)+5):(8*(mp-1)+8));
        end
    end
	se(i,1)=(0.5*duv'*kuv*duv)/(t*a*b);
    se(i,2)=(0.5*dwo'*kwo*dwo)/(t*a*b);
end
