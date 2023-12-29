function [K]=assemble_single(K,k,nodei,nodej,nnodes)
%
%this routine adds the element contribution to the global stiffness matrix
%basically it does the same as rutine 'assemble', however:
%   it does not care about Kg (geom stiff matrix)
%   only involves single half-wave number m

% S. Adany, Feb 06, 2004
% Z. Li, Jul 10, 2009
%
%submatrices for the initial stiffness
k11=k(1:2,1:2);
k12=k(1:2,3:4);
k13=k(1:2,5:6);
k14=k(1:2,7:8);
k21=k(3:4,1:2);
k22=k(3:4,3:4);
k23=k(3:4,5:6);
k24=k(3:4,7:8);
k31=k(5:6,1:2);
k32=k(5:6,3:4);
k33=k(5:6,5:6);
k34=k(5:6,7:8);
k41=k(7:8,1:2);
k42=k(7:8,3:4);
k43=k(7:8,5:6);
k44=k(7:8,7:8);
%
%
K2=zeros(4*nnodes,4*nnodes);
%
%the additional terms for K are stored in K2
skip=2*nnodes;
K2(nodei*2-1:nodei*2,nodei*2-1:nodei*2)=k11;
K2(nodei*2-1:nodei*2,nodej*2-1:nodej*2)=k12;
K2(nodej*2-1:nodej*2,nodei*2-1:nodei*2)=k21;
K2(nodej*2-1:nodej*2,nodej*2-1:nodej*2)=k22;
%
K2(skip+nodei*2-1:skip+nodei*2,skip+nodei*2-1:skip+nodei*2)=k33;
K2(skip+nodei*2-1:skip+nodei*2,skip+nodej*2-1:skip+nodej*2)=k34;
K2(skip+nodej*2-1:skip+nodej*2,skip+nodei*2-1:skip+nodei*2)=k43;
K2(skip+nodej*2-1:skip+nodej*2,skip+nodej*2-1:skip+nodej*2)=k44;
%
K2(nodei*2-1:nodei*2,skip+nodei*2-1:skip+nodei*2)=k13;
K2(nodei*2-1:nodei*2,skip+nodej*2-1:skip+nodej*2)=k14;
K2(nodej*2-1:nodej*2,skip+nodei*2-1:skip+nodei*2)=k23;
K2(nodej*2-1:nodej*2,skip+nodej*2-1:skip+nodej*2)=k24;
%
K2(skip+nodei*2-1:skip+nodei*2,nodei*2-1:nodei*2)=k31;
K2(skip+nodei*2-1:skip+nodei*2,nodej*2-1:nodej*2)=k32;
K2(skip+nodej*2-1:skip+nodej*2,nodei*2-1:nodei*2)=k41;
K2(skip+nodej*2-1:skip+nodej*2,nodej*2-1:nodej*2)=k42;
K=K+K2;
%





