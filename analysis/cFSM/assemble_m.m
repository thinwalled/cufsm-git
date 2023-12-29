function [K,Kg]=assemble_m(K,Kg,k,kg,nodei,nodej,nnodes)
%BWS
%1997
%Add the element contribution to the global stiffness matrix for single
%longitudinal term m

%modifed on Jul 10, 2009 by Z. Li

%Submatrices for the initial stiffness
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
%Submatrices for the geometric stiffness
kg11=kg(1:2,1:2);
kg12=kg(1:2,3:4);
kg13=kg(1:2,5:6);
kg14=kg(1:2,7:8);
kg21=kg(3:4,1:2);
kg22=kg(3:4,3:4);
kg23=kg(3:4,5:6);
kg24=kg(3:4,7:8);
kg31=kg(5:6,1:2);
kg32=kg(5:6,3:4);
kg33=kg(5:6,5:6);
kg34=kg(5:6,7:8);
kg41=kg(7:8,1:2);
kg42=kg(7:8,3:4);
kg43=kg(7:8,5:6);
kg44=kg(7:8,7:8);
%
%
K2=zeros(4*nnodes,4*nnodes);
K3=zeros(4*nnodes,4*nnodes);
%
%The additional terms for K are stored in K2
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
%The additional terms for Kg are stored in K3
K3(nodei*2-1:nodei*2,nodei*2-1:nodei*2)=kg11;
K3(nodei*2-1:nodei*2,nodej*2-1:nodej*2)=kg12;
K3(nodej*2-1:nodej*2,nodei*2-1:nodei*2)=kg21;
K3(nodej*2-1:nodej*2,nodej*2-1:nodej*2)=kg22;
%
K3(skip+nodei*2-1:skip+nodei*2,skip+nodei*2-1:skip+nodei*2)=kg33;
K3(skip+nodei*2-1:skip+nodei*2,skip+nodej*2-1:skip+nodej*2)=kg34;
K3(skip+nodej*2-1:skip+nodej*2,skip+nodei*2-1:skip+nodei*2)=kg43;
K3(skip+nodej*2-1:skip+nodej*2,skip+nodej*2-1:skip+nodej*2)=kg44;
%
K3(nodei*2-1:nodei*2,skip+nodei*2-1:skip+nodei*2)=kg13;
K3(nodei*2-1:nodei*2,skip+nodej*2-1:skip+nodej*2)=kg14;
K3(nodej*2-1:nodej*2,skip+nodei*2-1:skip+nodei*2)=kg23;
K3(nodej*2-1:nodej*2,skip+nodej*2-1:skip+nodej*2)=kg24;
%
K3(skip+nodei*2-1:skip+nodei*2,nodei*2-1:nodei*2)=kg31;
K3(skip+nodei*2-1:skip+nodei*2,nodej*2-1:nodej*2)=kg32;
K3(skip+nodej*2-1:skip+nodej*2,nodei*2-1:nodei*2)=kg41;
K3(skip+nodej*2-1:skip+nodej*2,nodej*2-1:nodej*2)=kg42;
%
Kg=Kg+K3;