function [K]=spring_assemble(K,k,nodei,nodej,nnodes,m_a)
%
%Add the (spring) contribution to the global stiffness matrix

%Outputs:
% K: global elastic stiffness matrix
% K and Kg: totalm x totalm submatrices. Each submatrix is similar to the
% one used in original CUFSM for single longitudinal term m in the DOF order
%[u1 v1...un vn w1 01...wn 0n]m'.

% Z. Li, June 2008
% modified by Z. Li, Aug. 09, 2009
% Z. Li, June 2010
% adapted for springs BWS Dec 2015

totalm = length(m_a); %Total number of longitudinal terms m
K2=sparse(zeros(4*nnodes*totalm,4*nnodes*totalm));
K3=sparse(zeros(4*nnodes*totalm,4*nnodes*totalm));
skip=2*nnodes;
for i=1:1:totalm
    for j=1:1:totalm
        %Submatrices for the initial stiffness
        k11=k(8*(i-1)+1:8*(i-1)+2,8*(j-1)+1:8*(j-1)+2);
        k12=k(8*(i-1)+1:8*(i-1)+2,8*(j-1)+3:8*(j-1)+4);
        k13=k(8*(i-1)+1:8*(i-1)+2,8*(j-1)+5:8*(j-1)+6);
        k14=k(8*(i-1)+1:8*(i-1)+2,8*(j-1)+7:8*(j-1)+8);
        k21=k(8*(i-1)+3:8*(i-1)+4,8*(j-1)+1:8*(j-1)+2);
        k22=k(8*(i-1)+3:8*(i-1)+4,8*(j-1)+3:8*(j-1)+4);
        k23=k(8*(i-1)+3:8*(i-1)+4,8*(j-1)+5:8*(j-1)+6);
        k24=k(8*(i-1)+3:8*(i-1)+4,8*(j-1)+7:8*(j-1)+8);
        k31=k(8*(i-1)+5:8*(i-1)+6,8*(j-1)+1:8*(j-1)+2);
        k32=k(8*(i-1)+5:8*(i-1)+6,8*(j-1)+3:8*(j-1)+4);
        k33=k(8*(i-1)+5:8*(i-1)+6,8*(j-1)+5:8*(j-1)+6);
        k34=k(8*(i-1)+5:8*(i-1)+6,8*(j-1)+7:8*(j-1)+8);
        k41=k(8*(i-1)+7:8*(i-1)+8,8*(j-1)+1:8*(j-1)+2);
        k42=k(8*(i-1)+7:8*(i-1)+8,8*(j-1)+3:8*(j-1)+4);
        k43=k(8*(i-1)+7:8*(i-1)+8,8*(j-1)+5:8*(j-1)+6);
        k44=k(8*(i-1)+7:8*(i-1)+8,8*(j-1)+7:8*(j-1)+8);
        %
        K2(4*nnodes*(i-1)+nodei*2-1:4*nnodes*(i-1)+nodei*2,4*nnodes*(j-1)+nodei*2-1:4*nnodes*(j-1)+nodei*2)=k11;
        if nodej~=0
            K2(4*nnodes*(i-1)+nodei*2-1:4*nnodes*(i-1)+nodei*2,4*nnodes*(j-1)+nodej*2-1:4*nnodes*(j-1)+nodej*2)=k12;
            K2(4*nnodes*(i-1)+nodej*2-1:4*nnodes*(i-1)+nodej*2,4*nnodes*(j-1)+nodei*2-1:4*nnodes*(j-1)+nodei*2)=k21;
            K2(4*nnodes*(i-1)+nodej*2-1:4*nnodes*(i-1)+nodej*2,4*nnodes*(j-1)+nodej*2-1:4*nnodes*(j-1)+nodej*2)=k22;
        end
        %
        K2(4*nnodes*(i-1)+skip+nodei*2-1:4*nnodes*(i-1)+skip+nodei*2,4*nnodes*(j-1)+skip+nodei*2-1:4*nnodes*(j-1)+skip+nodei*2)=k33;
        if nodej~=0
            K2(4*nnodes*(i-1)+skip+nodei*2-1:4*nnodes*(i-1)+skip+nodei*2,4*nnodes*(j-1)+skip+nodej*2-1:4*nnodes*(j-1)+skip+nodej*2)=k34;
            K2(4*nnodes*(i-1)+skip+nodej*2-1:4*nnodes*(i-1)+skip+nodej*2,4*nnodes*(j-1)+skip+nodei*2-1:4*nnodes*(j-1)+skip+nodei*2)=k43;
            K2(4*nnodes*(i-1)+skip+nodej*2-1:4*nnodes*(i-1)+skip+nodej*2,4*nnodes*(j-1)+skip+nodej*2-1:4*nnodes*(j-1)+skip+nodej*2)=k44;
        end        %
        K2(4*nnodes*(i-1)+nodei*2-1:4*nnodes*(i-1)+nodei*2,4*nnodes*(j-1)+skip+nodei*2-1:4*nnodes*(j-1)+skip+nodei*2)=k13;
        if nodej~=0
            K2(4*nnodes*(i-1)+nodei*2-1:4*nnodes*(i-1)+nodei*2,4*nnodes*(j-1)+skip+nodej*2-1:4*nnodes*(j-1)+skip+nodej*2)=k14;
            K2(4*nnodes*(i-1)+nodej*2-1:4*nnodes*(i-1)+nodej*2,4*nnodes*(j-1)+skip+nodei*2-1:4*nnodes*(j-1)+skip+nodei*2)=k23;
            K2(4*nnodes*(i-1)+nodej*2-1:4*nnodes*(i-1)+nodej*2,4*nnodes*(j-1)+skip+nodej*2-1:4*nnodes*(j-1)+skip+nodej*2)=k24;
        end
        %
        K2(4*nnodes*(i-1)+skip+nodei*2-1:4*nnodes*(i-1)+skip+nodei*2,4*nnodes*(j-1)+nodei*2-1:4*nnodes*(j-1)+nodei*2)=k31;
        if nodej~=0
            K2(4*nnodes*(i-1)+skip+nodei*2-1:4*nnodes*(i-1)+skip+nodei*2,4*nnodes*(j-1)+nodej*2-1:4*nnodes*(j-1)+nodej*2)=k32;
            K2(4*nnodes*(i-1)+skip+nodej*2-1:4*nnodes*(i-1)+skip+nodej*2,4*nnodes*(j-1)+nodei*2-1:4*nnodes*(j-1)+nodei*2)=k41;
            K2(4*nnodes*(i-1)+skip+nodej*2-1:4*nnodes*(i-1)+skip+nodej*2,4*nnodes*(j-1)+nodej*2-1:4*nnodes*(j-1)+nodej*2)=k42;
        end
        %
    end
end
K=K+K2;
