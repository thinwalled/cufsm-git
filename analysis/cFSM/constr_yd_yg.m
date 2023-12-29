function [Ryd]=constr_yd_yg(node,elem,node_prop,Rys,nmno)
%
%this routine creates the constraint matrix, Ryd, that defines relationship 
% between base vectors for distortional buckling, 
% and base vectors for global buckling,
% but for y DOFs of main nodes only
%
%
%input/output data
%   node, elem - same as elsewhere throughout this program
%   node_prop - array of [original node nr, new node nr, nr of adj elems, node type]
%   Rys - constrain matrix, see function 'constr_ys_ym'
%   nmno - nr of main nodes
%   
% S. Adany, Mar 04, 2004
%
nnode=length(node(:,1));
nelem=length(elem(:,1));
A=zeros(nnode);
for i=1:nelem
    node1=elem(i,2);
    node2=elem(i,3);
    dx=node(node2,2)-node(node1,2);
    dz=node(node2,3)-node(node1,3);
    dA=sqrt(dx*dx+dz*dz)*elem(i,4);
    ind=find(node_prop(:,1)==node1);
    node1=node_prop(ind,2);
    ind=find(node_prop(:,1)==node2);
    node2=node_prop(ind,2);
    A(node1,node1)=A(node1,node1)+2*dA;
    A(node2,node2)=A(node2,node2)+2*dA;
    A(node1,node2)=A(node1,node2)+dA;
    A(node2,node1)=A(node2,node1)+dA;
end
%
Rysm=eye(nmno);
Rysm((nmno+1):nnode,1:nmno)=Rys;
Ryd=Rysm'*A*Rysm;
