function [b_v_l,ngm,ndm,nlm]=base_column(node,elem,prop,a,BC,m_a)
%
%this routine creates base vectors for a column with length a for all the
%specified longitudinal terms in m_a

%assumptions
%   othogonalization is not performed unless the user wants
%   orthogonalization is done by solving the eigen-value problem within each sub-space
%   normalization is not done

%input data
%   node,elem,prop - basic data
%   BC: ['S-S'] a string specifying boundary conditions to be analyzed:
    %'S-S' simply-pimply supported boundary condition at loaded edges
    %'C-C' clamped-clamped boundary condition at loaded edges
    %'S-C' simply-clamped supported boundary condition at loaded edges
    %'C-F' clamped-free supported boundary condition at loaded edges
    %'C-G' clamped-guided supported boundary condition at loaded edges
%   m_a - longitudinal terms (half-wave numbers)

%output data
%   b_v_l - base vectors (each column corresponds to a certain mode)
%   assemble for each half-wave number m on its diagonal 
%   b_v_l=diag(b_v_m)
%   for each half-wave number m, b_v_m
%           columns 1..ngm: global modes
%           columns (ngm+1)..(ngm+ndm): dist. modes
%           columns (ngm+ndm+1)..(ngm+ndm+nlm): local modes
%           columns (ngm+ndm+nlm+1)..ndof: other modes
%   ngm,ndm,nlm - number of G,D,L modes, respectively
%

% S. Adany, Aug 28, 2006
% B. Schafer, Aug 29, 2006
% Z. Li, Dec 22, 2009
% Z. Li, June 2010

node(:,8)=node(:,8)*0+1; %set up stress to 1.0 for finding Kg and K for axial modes

% natural base first
% properties all the longitudinal terms share
[elprop,m_node,m_elem,node_prop,nmno,ncno,nsno,ndm,nlm,DOFperm]=base_properties(node,elem);

%construct the base for all the longitudinal terms
nnodes = length(node(:,1));
ndof_m= 4*nnodes;
totalm=length(m_a);
b_v_l=zeros(ndof_m*totalm);
for ml=1:totalm
    [Rx,Rz,Rp,Ryd,Rys,Rud]=mode_constr(node,elem,prop,node_prop,m_node,m_elem,DOFperm,m_a(ml),a,BC);
    [dy,ngm]=yDOFs(node,elem,m_node,nmno,ndm,Ryd,Rud);
    [b_v_m]=base_vectors(dy,elem,elprop,a,m_a(ml),node_prop,nmno,ncno,nsno,ngm,ndm,nlm,Rx,Rz,Rp,Rys,DOFperm);
    b_v_l((ndof_m*(ml-1)+1):ndof_m*ml,(ndof_m*(ml-1)+1):ndof_m*ml)=b_v_m;
end



