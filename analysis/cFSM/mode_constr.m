function [Rx,Rz,Rp,Ryd,Rys,Rud]=mode_constr(node,elem,prop,node_prop,m_node,m_elem,DOFperm,m,a,BC)
%
%this routine creates the constraint matrices necessary for mode
%separation/classification for each specified half-wave number m
% 
%assumtions
%   GBT-like assumptions are used
%   the cross-section must not be closed and must not contain closed parts
%  
%   must check whether 'Warp' works well for any open section !!! 
%
%
%input/output data
%   node, elem, prop  - same as elsewhere throughout this program
%   m_node [main nodes] - array of [nr, x, z, orig node nr, nr of adj meta-elems, m-el-1, m-el-2, ...]
%   m_elem [meta-elements] - array of [nr, main-node-1, main-node-2, nr of sub-nodes, sub-no-1, sub-nod-2, ...]
%   node_prop - array of [original node nr, new node nr, nr of adj elems, node type]
%   
%   
%notes:
%   m-el-? is positive if the starting node of m-el-? coincides with
%      the given m-node, otherwise negative
%   node types: 1-corner, 2-edge, 3-sub
%   sub-node numbers are the original one, of course
%
% S. Adany, Mar 10, 2004
% Z. Li, Jul 10, 2009

%to create Rx and Rz constraint matrices
[Rx,Rz]=constr_xz_y(m_node,m_elem);
%
%to create Rp constraint matrix for the rest of planar DOFs
[Rp]=constr_planar_xz(node,elem,prop,node_prop,DOFperm,m,a,BC);
%
%to create Rys constraint matrix for the y DOFs of sub-nodes
[Rys]=constr_ys_ym(node,m_node,m_elem,node_prop);
%
%to create Ryd for y DOFs of main nodes for distortional buckling
[Ryd]=constr_yd_yg(node,elem,node_prop,Rys,length(m_node(:,1)));
%
%to create Rud for y DOFs of undefinite main nodes
[Rud]=constr_yu_yd(m_node,m_elem);