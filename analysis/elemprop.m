function [elprop]=elemprop(node,elem,nnodes,nelems)
%BWS
%1998 (last modified)
%
%INPUT
%node: [node# x z dofx dofz dofy dofrot stress] nnodes x 8;
%elem: [elem# nodei nodej t] nelems x 4;
%OUTPUT
%elprop: [elem# width alpha]
%
elprop=zeros(nelems,3);
%
for i=1:nelems
	nodei = elem(i,2);
	nodej = elem(i,3);
	   xi = node(nodei,2);
	   zi = node(nodei,3);
	   xj = node(nodej,2);
	   zj = node(nodej,3);
	   dx = xj - xi;
	   dz = zj - zi;
	width = sqrt(dx^2 + dz^2);
	alpha = atan2(dz,dx);
	elprop(i,:)=[i width alpha];
end
	
	
