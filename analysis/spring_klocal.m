function [k]=spring_klocal(ku,kv,kw,kq,a,BC,m_a,discrete,ys)
%
%Generate spring stiffness matrix (k) in local coordinates, modified from
%klocal
%BWS DEC 2015

% Inputs:
% ku,kv,kw,kq spring stiffness values 
% a: length of the strip in longitudinal direction
% BC: ['S-S'] a string specifying boundary conditions to be analyzed:
    %'S-S' simply-pimply supported boundary condition at loaded edges
    %'C-C' clamped-clamped boundary condition at loaded edges
    %'S-C' simply-clamped supported boundary condition at loaded edges
    %'C-F' clamped-free supported boundary condition at loaded edges
    %'C-G' clamped-guided supported boundary condition at loaded edges
% m_a: longitudinal terms (or half-wave numbers) for this length
% discrete == 1 if discrete spring
% ys = location of discrete spring

% Output:
% k: local stiffness matrix, a totalm x totalm matrix of 8 by 8 submatrices.
% k=[kmp]totalm x totalm block matrix
% each kmp is the 8 x 8 submatrix in the DOF order [u1 v1 u2 v2 w1 theta1 w2 theta2]';

%
totalm = length(m_a); %Total number of longitudinal terms m
%
k=sparse(zeros(8*totalm,8*totalm));
z0=zeros(4,4);
for m=1:1:totalm
    for p=1:1:totalm
        %
        km_mp=zeros(4,4);
        kf_mp=zeros(4,4);
        um=m_a(m)*pi;
        up=m_a(p)*pi;
        %
        if discrete
            [I1,I5] = BC_I1_5_atpoint(BC,m_a(m),m_a(p),a,ys);
        else %foundation spring
            [I1,I2,I3,I4,I5] = BC_I1_5(BC,m_a(m),m_a(p),a);
        end
        %
        %asemble the matrix of km_mp
        km_mp=[ ku*I1   0                   -ku*I1      0
                0       kv*I5*a^2/(um*up)   0           -kv*I5*a^2/(um*up) 
                -ku*I1  0                   ku*I1       0
                0       -kv*I5*a^2/(um*up)  0           kv*I5*a^2/(um*up)];
        %
        %asemble the matrix of kf_mp 
         kf_mp=[ kw*I1   0       -kw*I1      0
                0       kq*I1   0           -kq*I1 
                -kw*I1  0       kw*I1       0
                0       -kq*I1  0           kq*I1];      
        %assemble the membrane and flexural stiffness matrices      
        kmp=[km_mp  z0
               z0  kf_mp];

        %add it into local element stiffness matrix by corresponding to m
        k(8*(m-1)+1:8*m,8*(p-1)+1:8*p)=kmp;
    end
end

       
    
        