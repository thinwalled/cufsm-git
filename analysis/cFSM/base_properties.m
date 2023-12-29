function [elprop,m_node,m_elem,node_prop,nmno,ncno,nsno,ndm,nlm,DOFperm]=base_properties(node,elem)
%
%this routine creates all the data for defining the base vectors from the
%cross section properties
%
% 
%input data
%   node,elem- basic data%
%output data
%   m_node <main nodes> - array of [nr, x, z, orig node nr, nr of adj meta-elems, m-el-1, m-el-2, ...]
%   m_elem <meta-elements> - array of [nr, main-node-1, main-node-2, nr of sub-nodes, sub-no-1, sub-nod-2, ...]
%   node_prop - array of [original node nr, new node nr, nr of adj elems,
%   node type]
%   ngm,ndm,nlm,nom - number of G,D,L,O modes, respectively
%   nmno,ncno,nsno - number of main nodes, corner nodes and sub-nodes, respectively
%   DOFperm - permutation matrix, so that 
%            (orig-displ-vect) = (DOFperm) × (new-displ-vector)
%
% S. Adany, Aug 28, 2006
% B. Schafer, Aug 29, 2006
% Z. Li, Dec 22, 2009

nnodes=length(node(:,1)); 
nelems=length(elem(:,1)); 
[elprop]=elemprop(node,elem,nnodes,nelems); 
[m_node,m_elem,node_prop]=meta_elems(node,elem);
[nmno,ncno,nsno]=node_class(node_prop);
[ndm,nlm]=mode_nr(nmno,ncno,nsno,m_node);
[DOFperm]=DOF_ordering(node_prop);
