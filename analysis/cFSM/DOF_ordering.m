function [DOFperm]=DOF_ordering(node_prop)

%this routine re-orders the DOFs, 
%according to the need of forming shape vectors for various buckling modes 
%
%input/output data
%   node_prop - array of [original node nr, new node nr, nr of adj elems, node type]
%   DOFperm - permutation matrix, so that 
%            (orig-displ-vect) = (DOFperm) × (new-displ-vector)
%   
%notes:
% (1)  node types: 1-corner, 2-edge, 3-sub
% (2)  the re-numbering of long. displ. DOFs of main nodes, which may be
%      necessary for dist. buckling, is not included here but handled
%      separately when forming Ry constraint matrix
%
% S. Adany, Feb 06, 2004
%
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
%
%to form permutation matrix
%
DOFperm=zeros(4*nno);
%
%x DOFs
ic=0;
ie=0;
is=0;
for i=1:nno
    if node_prop(i,4)==1 %corner nodes
        ic=ic+1;
        DOFperm((2*i-1),(nmno+ic))=1;
    end
    if node_prop(i,4)==2 %edge nodes
        ie=ie+1;
        DOFperm((2*i-1),(nmno+2*ncno+ie))=1;
    end
    if node_prop(i,4)==3 %sub nodes
        is=is+1;
        DOFperm((2*i-1),(4*nmno+is))=1;
    end
end
%
%y DOFs
ic=0;
is=0;
for i=1:nno
    if (node_prop(i,4)==1) | (node_prop(i,4)==2) %corner or edge node
        ic=ic+1;
        DOFperm((2*i),ic)=1;
    end
    if node_prop(i,4)==3 %sub node
        is=is+1;
        DOFperm((2*i),(4*nmno+3*nsno+is))=1;
    end
end
%
%z DOFs
ic=0;
ie=0;
is=0;
for i=1:nno
    if node_prop(i,4)==1 %corner node
        ic=ic+1;
        DOFperm((2*nno+2*i-1),(nmno+ncno+ic))=1;
    end
    if node_prop(i,4)==2 %edge node
        ie=ie+1;
        DOFperm((2*nno+2*i-1),(nmno+2*ncno+neno+ie))=1;
    end
    if node_prop(i,4)==3 %sub node
        is=is+1;
        DOFperm((2*nno+2*i-1),(4*nmno+nsno+is))=1;
    end
end
%
%teta DOFs
ic=0;
is=0;
for i=1:nno
    if (node_prop(i,4)==1) | (node_prop(i,4)==2) %corner or edge node
        ic=ic+1;
        DOFperm((2*nno+2*i),(3*nmno+ic))=1;
    end
    if node_prop(i,4)==3 %sub node
        is=is+1;
        DOFperm((2*nno+2*i),(4*nmno+2*nsno+is))=1;
    end
end
