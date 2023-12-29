function [K,Kg]=create_Ks(m,node,elem,elprop,prop,a,BC);
%
%called from base_update, while only single longitudinal term m involved
%
%created on Aug 28, 2006, by S. Adany
%modified on Jul 10, 2009 by Z. Li

%MATRIX SIZES
nnodes = length(node(:,1));
nelems = length(elem(:,1));
%
%ZERO OUT THE GLOBAL MATRICES
K=sparse(zeros(nnodes*4,nnodes*4));
Kg=sparse(zeros(nnodes*4,nnodes*4));
%
%ASSEMBLE THE GLOBAL STIFFNESS MATRICES
for i=1:nelems
    %Generate element stiffness matrix (k) in local coordinates
        t=elem(i,4);
        b=elprop(i,2);
        matnum=elem(i,5);
        row=find(matnum==prop(:,1));
        Ex=prop(row,2);
        Ey=prop(row,3);
        vx=prop(row,4);
        vy=prop(row,5);
        G=prop(row,6);
    [k_l]=klocal_m(Ex,Ey,vx,vy,G,t,a,b,m,BC);
    %Generate geometric stiffness matrix (kg) in local coordinates
        Ty1=node(elem(i,2),8)*t;
        Ty2=node(elem(i,3),8)*t;
    [kg_l]=kglocal_m(a,b,m,Ty1,Ty2,BC);
    %Transform k and kg into global coordinates
        alpha=elprop(i,3);
    [k,kg]=trans_m(alpha,k_l,kg_l);
    %Add element contribution of k to full matrix K and kg to Kg
        nodei=elem(i,2);
        nodej=elem(i,3);
    [K,Kg]=assemble_m(K,Kg,k,kg,nodei,nodej,nnodes);
end
