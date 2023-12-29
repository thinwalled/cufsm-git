function [kg]=kglocal(a,b,Ty1,Ty2,BC,m_a)
%
%Generate geometric stiffness matrix (kg) in local coordinates

% Inputs:
% a: length of the strip in longitudinal direction
% b: width of the strip in transverse direction
% Ty1, Ty2: node stresses
% BC: a string specifying boundary conditions to be analyzed:
    %'S-S' simply-pimply supported boundary condition at loaded edges
    %'C-C' clamped-clamped boundary condition at loaded edges
    %'S-C' simply-clamped supported boundary condition at loaded edges
    %'C-F' clamped-free supported boundary condition at loaded edges
    %'C-G' clamped-guided supported boundary condition at loaded edges
% m_a: longitudinal terms (or half-wave numbers) for this length

% Output:
% kg: local geometric stiffness matrix, a totalm x totalm matrix of 8 by 8 submatrices.
% kg=[kgmp]totalm x totalm block matrix
% each kgmp is the 8 x 8 submatrix in the DOF order [u1 v1 u2 v2 w1 theta1
% w2 theta2]';

% Z. Li, June 2008
% modified by Z. Li, Aug. 09, 2009
% modified by Z. Li, June 2010

totalm = length(m_a); %Total number of longitudinal terms m
kg=sparse(zeros(8*totalm,8*totalm));
%
for m=1:1:totalm
    for p=1:1:totalm
        %
        gm_mp=zeros(4,4);
        z0=zeros(4,4);
        gf_mp=zeros(4,4);
        um=m_a(m)*pi;
        up=m_a(p)*pi;
        %
        [I1,I2,I3,I4,I5] = BC_I1_5(BC,m_a(m),m_a(p),a);
        %
        %asemble the matrix of gm_mp (symmetric membrane stability matrix)
        gm_mp(1,1)=b*(3*Ty1+Ty2)*I5/12;
        gm_mp(1,3)=b*(Ty1+Ty2)*I5/12;
        gm_mp(3,1)=gm_mp(1,3);
        gm_mp(2,2)=b*a^2*(3*Ty1+Ty2)*I4/12/um/up;
        gm_mp(2,4)=b*a^2*(Ty1+Ty2)*I4/12/um/up;
        gm_mp(4,2)=gm_mp(2,4);
        gm_mp(3,3)=b*(Ty1+3*Ty2)*I5/12;
        gm_mp(4,4)=b*a^2*(Ty1+3*Ty2)*I4/12/um/up;
        %
        %asemble the matrix of gf_mp (symmetric flexural stability matrix)
        gf_mp(1,1)=(10*Ty1+3*Ty2)*b*I5/35;
        gf_mp(1,2)=(15*Ty1+7*Ty2)*b^2*I5/210/2;
        gf_mp(2,1)=gf_mp(1,2);
        gf_mp(1,3)=9*(Ty1+Ty2)*b*I5/140;
        gf_mp(3,1)=gf_mp(1,3);
        gf_mp(1,4)=-(7*Ty1+6*Ty2)*b^2*I5/420;
        gf_mp(4,1)=gf_mp(1,4);
        gf_mp(2,2)=(5*Ty1+3*Ty2)*b^3*I5/2/420;
        gf_mp(2,3)=(6*Ty1+7*Ty2)*b^2*I5/420;
        gf_mp(3,2)=gf_mp(2,3);
        gf_mp(2,4)=-(Ty1+Ty2)*b^3*I5/140/2;
        gf_mp(4,2)=gf_mp(2,4);
        gf_mp(3,3)=(3*Ty1+10*Ty2)*b*I5/35;
        gf_mp(3,4)=-(7*Ty1+15*Ty2)*b^2*I5/420;
        gf_mp(4,3)=gf_mp(3,4);
        gf_mp(4,4)=(3*Ty1+5*Ty2)*b^3*I5/420/2;
        %assemble the membrane and flexural stiffness matrices
        kgmp=[gm_mp  z0
               z0  gf_mp];
        %add it into local geometric stiffness matrix by corresponding to m
        kg(8*(m-1)+1:8*m,8*(p-1)+1:8*p)=kgmp;           
    end
end

 
 
        
 
        
        
 