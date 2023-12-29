function [K_transv]=Kglobal_transv(node,elem,prop,m,a,BC)
%
%this routine creates the global stiffness matrix for planar displacements
%basically the same way as in the main program, however:
%   only one half-wave number m is considered,
%   only w,teta terms are considered, 
%   plus Ey=vx=vy=0 is assumed
%   plus the longit. displ. DOFs are explicitely eliminated
%   the multipication by 'a' (member length) is not done here, must be done
%      outside of this routine
%
%input/output data
%   node, elem, prop - same as elsewhere throughout this program
%   m - number of half waves
%   K_transv - global stifness matrix (geometric not included)
%   
% S. Adany, Feb 08, 2004
% Z. Li, Jul 10, 2009
%
nnode=length(node(:,1));
nelem=length(elem(:,1));
[elprop]=elemprop(node,elem,nnode,nelem);
[K_transv]=zeros(4*nnode,4*nnode);
%
for i=1:nelem
    %to generate element stiffness matrix (k) in local coordinates
    t=elem(i,4);
    %a=1;
    b=elprop(i,2);
    matnum=elem(i,5);
    row=find(matnum==prop(:,1));
    Ex=prop(row,2);
    Ey=prop(row,3);
    vx=prop(row,4);
    vy=prop(row,5);
    G=prop(row,6);
    %m=1;
    [k_l]=klocal_transv(Ex,Ey,vx,vy,G,t,a,b,m,BC);
    %to transform k into global coordinates
    alpha=elprop(i,3);
    [k]=trans_single(alpha,k_l);
    %to add element contribution of k to full matrix K
    nodei=elem(i,2);
    nodej=elem(i,3);
    [K_transv]=assemble_single(K_transv,k,nodei,nodej,nnode);
end
