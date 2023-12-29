function [Rp]=constr_planar_xz(node,elem,prop,node_prop,DOFperm,m,a,BC)
%
%this routine creates the constraint matrix, Rp, that defines relationship 
% between x,z DOFs of any non-corner nodes + teta DOFs of all nodes, 
% and the x,z displ DOFs of corner nodes
% if GBT-like assumptions are used
%
%
%input/output data
%   node, elem, prop  - same as elsewhere throughout this program
%   node_prop - array of [original node nr, new node nr, nr of adj elems, node type]
%   DOFperm - permutation matrix, so that 
%            (orig-displ-vect) = (DOFperm) × (new-displ-vector)
%   
% S. Adany, Feb 06, 2004
% Z. Li, Jul 10, 2009
%
%to count corner-, edge- and sub-nodes
nno=length(node_prop(:,1));
ncno=0;
neno=0;
nsno=0;
for i=1:nno
    if node_prop(i,4)==1
        ncno=ncno+1;
    end
    if node_prop(i,4)==2
        neno=neno+1;
    end
    if node_prop(i,4)==3
        nsno=nsno+1;
    end
end
nmno=ncno+neno; %nr of main nodes
%
ndof=4*nno; %nro of DOFs
%
%to create the full global stiffness matrix (for transverse bending)
[K]=Kglobal_transv(node,elem,prop,m,a,BC);
%
%to re-order the DOFs
K=DOFperm'*K*DOFperm;
%
%to have partitions of K
Kpp=[];
Kpc=[];
[Kpp]=K((nmno+2*ncno+1):(ndof-nsno),(nmno+2*ncno+1):(ndof-nsno));
[Kpc]=K((nmno+2*ncno+1):(ndof-nsno),(nmno+1):(nmno+2*ncno));
%
%to form the constraint matrix
%[Rp]=-inv(Kpp)*Kpc;
[Rp]=-Kpp\Kpc;
