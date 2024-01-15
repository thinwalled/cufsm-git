function [k]=klocal_vec(Ex,Ey,vx,vy,G,t,a,b,BC,m_a)
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
% modified by Sheng Jin, Jan. 2024. Vectorized

E1=Ex/(1-vx*vy);
E2=Ey/(1-vx*vy);
Dx=Ex*t^3/(12*(1-vx*vy));
Dy=Ey*t^3/(12*(1-vx*vy));
D1=vx*Ey*t^3/(12*(1-vx*vy));
Dxy=G*t^3/12;
%
totalm = length(m_a); %Total number of longitudinal terms m
%


% According  to the original program, um changes with m, while m's value is the same in a row of the stiffness matrix
% After vectorizing, um will be a vector consists of all the m values.
% um is a column vector, so that when it is dot producted to a matrix, all the elements of a same row in the matrix will be multipled by a same number.
% Based on the same reason, up is constructed as a row vector
um=reshape(m_a.*pi,[totalm,1]);
up=reshape(m_a.*pi,[1,totalm]);

c1=um./a; %c1 is a column vector
c2=up./a; %c2 is a row vector

%I1, I2, I3, I4, I5 are all totalm X totalm matrices
[I1,I2,I3,I4,I5] = BC_I1_5_vec(BC,m_a,a);




%k=sparse(zeros(8*totalm,8*totalm));
k=zeros(8*totalm,8*totalm);

%vector used to locat the origin point
listLoc0=0:8:totalm*8-1;

%asemble the matrix of Km_mp

k(listLoc0+1,listLoc0+1)=E1/b*t.*I1+G*b*t/3.*I5;
k(listLoc0+1,listLoc0+2)=-E2*vx*t/2./c2.*I3-G*t/2./c2.*I5;
k(listLoc0+1,listLoc0+3)=-E1*t/b.*I1+G*b*t/6.*I5;
k(listLoc0+1,listLoc0+4)=-E2*vx*t/2./c2.*I3+G*t/2./c2.*I5;
k(listLoc0+2,listLoc0+1)=-E2*vx*t/2./c1.*I2-G*t/2./c1.*I5;
k(listLoc0+2,listLoc0+2)=(E2*b*t/3./c1.*I4+G*t/b./c1.*I5)./c2;
k(listLoc0+2,listLoc0+3)=E2*vx*t/2./c1.*I2-G*t/2./c1.*I5;
k(listLoc0+2,listLoc0+4)=(E2*b*t/6./c1.*I4-G*t/b./c1.*I5)./c2;
k(listLoc0+3,listLoc0+1)=-E1*t/b.*I1+G*b*t/6.*I5;
k(listLoc0+3,listLoc0+2)=E2*vx*t/2./c2.*I3-G*t/2./c2.*I5;
k(listLoc0+3,listLoc0+3)=E1*t/b.*I1+G*b*t/3.*I5;
k(listLoc0+3,listLoc0+4)=E2*vx*t/2./c2.*I3+G*t/2./c2.*I5;
k(listLoc0+4,listLoc0+1)=-E2*vx*t/2./c1.*I2+G*t/2./c1.*I5;
k(listLoc0+4,listLoc0+2)=(E2*b*t/6./c1.*I4-G*t/b./c1.*I5)./c2;
k(listLoc0+4,listLoc0+3)=E2*vx*t/2./c1.*I2+G*t/2./c1.*I5;
k(listLoc0+4,listLoc0+4)=(E2*b*t/3./c1.*I4+G*t/b./c1.*I5)./c2;


%asemble the matrix of Kf_mp
bbb420=b^3*420;
kf_mp13=(-5040*Dx.*I1+504*b^2*D1.*I2+504*b^2*D1.*I3+54*b^4*Dy.*I4-2016*b^2*Dxy.*I5)./bbb420;
kf_mp14=(2520*b*Dx.*I1-42*b^3*D1.*I2-42*b^3*D1.*I3-13*b^5*Dy.*I4+168*b^3*Dxy.*I5)./bbb420;
kf_mp23=(-2520*b*Dx.*I1+42*b^3*D1.*I2+42*b^3*D1.*I3+13*b^5*Dy.*I4-168*b^3*Dxy.*I5)./bbb420;
kf_mp24=(840*b^2*Dx.*I1+14*b^4*D1.*I2+14*b^4*D1.*I3-3*b^6*Dy.*I4-56*b^4*Dxy.*I5)./bbb420;


k(listLoc0+5,listLoc0+5)=(5040*Dx.*I1-504*b^2*D1.*I2-504*b^2*D1.*I3+156*b^4*Dy.*I4+2016*b^2*Dxy.*I5)./bbb420;
k(listLoc0+5,listLoc0+6)=(2520*b*Dx.*I1-462*b^3*D1.*I2-42*b^3*D1.*I3+22*b^5*Dy.*I4+168*b^3*Dxy.*I5)./bbb420;
k(listLoc0+5,listLoc0+7)=kf_mp13;
k(listLoc0+5,listLoc0+8)=kf_mp14;

k(listLoc0+6,listLoc0+5)=(2520*b*Dx.*I1-462*b^3*D1.*I3-42*b^3*D1.*I2+22*b^5*Dy.*I4+168*b^3*Dxy.*I5)./bbb420;
k(listLoc0+6,listLoc0+6)=(1680*b^2*Dx.*I1-56*b^4*D1.*I2-56*b^4*D1.*I3+4*b^6*Dy.*I4+224*b^4*Dxy.*I5)./bbb420;
k(listLoc0+6,listLoc0+7)=kf_mp23;
k(listLoc0+6,listLoc0+8)=kf_mp24;

k(listLoc0+7,listLoc0+5)=kf_mp13;
k(listLoc0+7,listLoc0+6)=kf_mp23;
k(listLoc0+7,listLoc0+7)=(5040*Dx.*I1-504*b^2*D1.*I2-504*b^2*D1.*I3+156*b^4*Dy.*I4+2016*b^2*Dxy.*I5)./bbb420;
k(listLoc0+7,listLoc0+8)=(-2520*b*Dx.*I1+462*b^3*D1.*I2+42*b^3*D1.*I3-22*b^5*Dy.*I4-168*b^3*Dxy.*I5)./bbb420;

k(listLoc0+8,listLoc0+5)=kf_mp14;
k(listLoc0+8,listLoc0+6)=kf_mp24;
k(listLoc0+8,listLoc0+7)=(-2520*b*Dx.*I1+462*b^3*D1.*I3+42*b^3*D1.*I2-22*b^5*Dy.*I4-168*b^3*Dxy.*I5)./bbb420;
k(listLoc0+8,listLoc0+8)=(1680*b^2*Dx.*I1-56*b^4*D1.*I2-56*b^4*D1.*I3+4*b^6*Dy.*I4+224*b^4*Dxy.*I5)./bbb420;


k=sparse(k);
    
        