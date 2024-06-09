%generates the local mass matrix

function [mass_local]=mlocal(a,b,density,t,BC,m_a)
%
%Generate mass matrix (m) in local coordinates

% Inputs:
% a: length of the strip in longitudinal direction
% b: width of the strip in transverse directio
% BC: a string specifying boundary conditions to be analyzed:
    %'S-S' simply-pimply supported boundary condition at loaded edges
    %'C-C' clamped-clamped boundary condition at loaded edges
    %'S-C' simply-clamped supported boundary condition at loaded edges
    %'C-F' clamped-free supported boundary condition at loaded edges
    %'C-G' clamped-guided supported boundary condition at loaded edges
% m_a: longitudinal terms (or half-wave numbers) for this length

% Output:
% mass_local: local mass matrix, a totalm x totalm matrix of 8 by 8 submatrices.
% mass_local=[mmp]totalm x totalm block matrix
% each mmp is the 8 x 8 submatrix in the DOF order [u1 v1 u2 v2 w1 theta1
% w2 theta2]';

% Z. Li, June 2008
% modified by Z. Li, Aug. 09, 2009
% modified by Z. Li, June 2010

totalm = length(m_a); %Total number of longitudinal terms m
mass_local=sparse(zeros(8*totalm,8*totalm));
%
for m=1:1:totalm
    for p=1:1:totalm
        %
        mm_mp=zeros(4,4);
        z0=zeros(4,4);
        mf_mp=zeros(4,4);
        um=m_a(m)*pi;
        up=m_a(p)*pi;
        %
        [I1,I2,I3,I4,I5] = BC_I1_5(BC,m_a(m),m_a(p),a);
        %
       %asemble the matrix of gm_mp (symmetric membrane stability matrix)
        mm_mp(1,1)=b*I1/3;
        mm_mp(1,3)=b*I1/6;
        mm_mp(2,2)=b*(a^2)*I5/(3*um*up);
        mm_mp(2,4)=b*(a^2)*I5/(6*um*up);
        mm_mp(3,1)=mm_mp(1,3);
        mm_mp(3,3)=mm_mp(1,1);
        mm_mp(4,2)=mm_mp(2,4);
        mm_mp(4,4)=mm_mp(2,2);

        mm_mp = density*t*mm_mp;
       
        %
        %asemble the matrix of gf_mp (symmetric flexural stability matrix)
        mf_mp(1,1)=13*b*I1/35;
        mf_mp(2,1)=11*t*(b^2)*I1/210;
        mf_mp(2,2)=(b^3)*I1/105;
        mf_mp(3,1)=9*b*I1/70;
        mf_mp(3,2)=13*(b^2)*I1/420;
        mf_mp(3,3)=13*b*I1/35;
        mf_mp(4,1)=-mf_mp(3,2);
        mf_mp(4,2)=-(b^3)*I1/140;
        mf_mp(4,3)=-mf_mp(2,1);
        mf_mp(4,4)=mf_mp(2,2);
        mf_mp(1,2)=mf_mp(2,1);
        mf_mp(1,3)=mf_mp(3,1);
        mf_mp(1,4)=mf_mp(4,1);
        mf_mp(2,3)=mf_mp(3,2);
        mf_mp(2,4)=mf_mp(4,2);
        mf_mp(3,4)=mf_mp(4,3);

        mf_mp = density*t*mf_mp;
        
        %assemble the membrane and flexural stiffness matrices
        mmp=[mm_mp  z0
               z0  mf_mp];
        %add it into local geometric stiffness matrix by corresponding to m
        mass_local(8*(m-1)+1:8*m,8*(p-1)+1:8*p)=mmp;           
    end
end

 
 
        
 
        
        
 