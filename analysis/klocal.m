function [k]=klocal(Ex,Ey,vx,vy,G,t,a,b,BC,m_a)
%
%Generate element stiffness matrix (k) in local coordinates

% Inputs:
% Ex,Ey,vx,vy,G: material properties
% t: thickness of the strip (element)
% a: length of the strip in longitudinal direction
% b: width of the strip in transverse direction
% BC: ['S-S'] a string specifying boundary conditions to be analyzed:
    %'S-S' simply-pimply supported boundary condition at loaded edges
    %'C-C' clamped-clamped boundary condition at loaded edges
    %'S-C' simply-clamped supported boundary condition at loaded edges
    %'C-F' clamped-free supported boundary condition at loaded edges
    %'C-G' clamped-guided supported boundary condition at loaded edges
% m_a: longitudinal terms (or half-wave numbers) for this length

% Output:
% k: local stiffness matrix, a totalm x totalm matrix of 8 by 8 submatrices.
% k=[kmp]totalm x totalm block matrix
% each kmp is the 8 x 8 submatrix in the DOF order [u1 v1 u2 v2 w1 theta1 w2 theta2]';

% Z. Li June 2008
% modified by Z. Li, Aug. 09, 2009
% modified by Z. Li, June 2010

E1=Ex/(1-vx*vy);
E2=Ey/(1-vx*vy);
Dx=Ex*t^3/(12*(1-vx*vy));
Dy=Ey*t^3/(12*(1-vx*vy));
D1=vx*Ey*t^3/(12*(1-vx*vy));
Dxy=G*t^3/12;
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
        c1=um/a;
        c2=up/a;
        %
        [I1,I2,I3,I4,I5] = BC_I1_5(BC,m_a(m),m_a(p),a);
        %
        %asemble the matrix of Km_mp
        km_mp(1,1)=E1*I1/b+G*b*I5/3;
        km_mp(1,2)=E2*vx*(-1/2/c2)*I3-G*I5/2/c2;
        km_mp(1,3)=-E1*I1/b+G*b*I5/6;
        km_mp(1,4)=E2*vx*(-1/2/c2)*I3+G*I5/2/c2;
        
        km_mp(2,1)=E2*vx*(-1/2/c1)*I2-G*I5/2/c1;
        km_mp(2,2)=E2*b*I4/3/c1/c2+G*I5/b/c1/c2;
        km_mp(2,3)=E2*vx*(1/2/c1)*I2-G*I5/2/c1;
        km_mp(2,4)=E2*b*I4/6/c1/c2-G*I5/b/c1/c2;
        
        km_mp(3,1)=-E1*I1/b+G*b*I5/6;
        km_mp(3,2)=E2*vx*(1/2/c2)*I3-G*I5/2/c2;
        km_mp(3,3)=E1*I1/b+G*b*I5/3;
        km_mp(3,4)=E2*vx*(1/2/c2)*I3+G*I5/2/c2;
        
        km_mp(4,1)=E2*vx*(-1/2/c1)*I2+G*I5/2/c1;
        km_mp(4,2)=E2*b*I4/6/c1/c2-G*I5/b/c1/c2;
        km_mp(4,3)=E2*vx*(1/2/c1)*I2+G*I5/2/c1;
        km_mp(4,4)=E2*b*I4/3/c1/c2+G*I5/b/c1/c2;             
        km_mp=km_mp*t;
        %
        %
        %asemble the matrix of Kf_mp 
        kf_mp(1,1)=(5040*Dx*I1-504*b^2*D1*I2-504*b^2*D1*I3+156*b^4*Dy*I4+2016*b^2*Dxy*I5)/420/b^3;
        kf_mp(1,2)=(2520*b*Dx*I1-462*b^3*D1*I2-42*b^3*D1*I3+22*b^5*Dy*I4+168*b^3*Dxy*I5)/420/b^3;
        kf_mp(1,3)=(-5040*Dx*I1+504*b^2*D1*I2+504*b^2*D1*I3+54*b^4*Dy*I4-2016*b^2*Dxy*I5)/420/b^3;
        kf_mp(1,4)=(2520*b*Dx*I1-42*b^3*D1*I2-42*b^3*D1*I3-13*b^5*Dy*I4+168*b^3*Dxy*I5)/420/b^3;
                
        kf_mp(2,1)=(2520*b*Dx*I1-462*b^3*D1*I3-42*b^3*D1*I2+22*b^5*Dy*I4+168*b^3*Dxy*I5)/420/b^3;
        kf_mp(2,2)=(1680*b^2*Dx*I1-56*b^4*D1*I2-56*b^4*D1*I3+4*b^6*Dy*I4+224*b^4*Dxy*I5)/420/b^3;
        kf_mp(2,3)=(-2520*b*Dx*I1+42*b^3*D1*I2+42*b^3*D1*I3+13*b^5*Dy*I4-168*b^3*Dxy*I5)/420/b^3;
        kf_mp(2,4)=(840*b^2*Dx*I1+14*b^4*D1*I2+14*b^4*D1*I3-3*b^6*Dy*I4-56*b^4*Dxy*I5)/420/b^3;
        
        kf_mp(3,1)=kf_mp(1,3);
        kf_mp(3,2)=kf_mp(2,3);
        kf_mp(3,3)=(5040*Dx*I1-504*b^2*D1*I2-504*b^2*D1*I3+156*b^4*Dy*I4+2016*b^2*Dxy*I5)/420/b^3;
        kf_mp(3,4)=(-2520*b*Dx*I1+462*b^3*D1*I2+42*b^3*D1*I3-22*b^5*Dy*I4-168*b^3*Dxy*I5)/420/b^3;
        
        kf_mp(4,1)=kf_mp(1,4);
        kf_mp(4,2)=kf_mp(2,4);
        kf_mp(4,3)=(-2520*b*Dx*I1+462*b^3*D1*I3+42*b^3*D1*I2-22*b^5*Dy*I4-168*b^3*Dxy*I5)/420/b^3;%not symmetric
        kf_mp(4,4)=(1680*b^2*Dx*I1-56*b^4*D1*I2-56*b^4*D1*I3+4*b^6*Dy*I4+224*b^4*Dxy*I5)/420/b^3;
       
        %assemble the membrane and flexural stiffness matrices      
        kmp=[km_mp  z0
               z0  kf_mp];
        %add it into local element stiffness matrix by corresponding to m
        k(8*(m-1)+1:8*m,8*(p-1)+1:8*p)=kmp;
    end
end

       
    
        