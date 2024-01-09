function [kg]=kglocal_vec(a,b,Ty1,Ty2,BC,m_a)
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
% vectorized by Sheng Jin, Jan. 2024

totalm = length(m_a); %Total number of longitudinal terms m

% According  to the original program, um changes with m, while m's value is the same in a row of the stiffness matrix
% After vectorizing, um will be a vector consists of all the m values.
% In the dot product between um and a matrix, there should be a product between an element of um and a row of the matrix.
% Thus, um is constructed as a column vector
% Based on the same reason, up is constructed as a row vector
um=reshape(m_a.*pi,[totalm,1]);
up=reshape(m_a.*pi,[1,totalm]);

%I1, I2, I3, I4, I5 are all totalm-row totalm-column matrix
[~,~,~,I4,I5] = BC_I1_5_vec(BC,m_a,a);

%

%kg=sparse(zeros(8*totalm,8*totalm));
kg=zeros(8*totalm,8*totalm);

%location vector of the Original points
listLoc0=0:8:(totalm*8-1);

%asemble the matrix of gm_mp (symmetric membrane stability matrix)
gm_mp13=b*(Ty1+Ty2)/12.*I5;
gm_mp24=b*a^2*(Ty1+Ty2)/12./um.*I4./up;

kg(listLoc0+1,listLoc0+1)=b*(3*Ty1+Ty2)/12.*I5;
kg(listLoc0+1,listLoc0+3)=gm_mp13;
kg(listLoc0+3,listLoc0+1)=gm_mp13;
kg(listLoc0+2,listLoc0+2)=b*a^2*(3*Ty1+Ty2)/12./um.*I4./up;
kg(listLoc0+2,listLoc0+4)=gm_mp24;
kg(listLoc0+4,listLoc0+2)=gm_mp24;
kg(listLoc0+3,listLoc0+3)=b*(Ty1+3*Ty2)/12.*I5;
kg(listLoc0+4,listLoc0+4)=b*a^2*(Ty1+3*Ty2)/12./um.*I4./up;

%asemble the matrix of gf_mp (symmetric flexural stability matrix)
gf_mp12=(15*Ty1+7*Ty2)*b^2/420.*I5;
gf_mp13=9*(Ty1+Ty2)*b/140.*I5;
gf_mp14=-(7*Ty1+6*Ty2)*b^2/420.*I5;
gf_mp23=(6*Ty1+7*Ty2)*b^2/420.*I5;
gf_mp24=-(Ty1+Ty2)*b^3/280.*I5;
gf_mp34=-(7*Ty1+15*Ty2)*b^2/420.*I5;

kg(listLoc0+5,listLoc0+5)=(10*Ty1+3*Ty2)*b/35.*I5;
kg(listLoc0+5,listLoc0+6)=gf_mp12;
kg(listLoc0+6,listLoc0+5)=gf_mp12;
kg(listLoc0+5,listLoc0+7)=gf_mp13;
kg(listLoc0+7,listLoc0+5)=gf_mp13;
kg(listLoc0+5,listLoc0+8)=gf_mp14;
kg(listLoc0+8,listLoc0+5)=gf_mp14;
kg(listLoc0+6,listLoc0+6)=(5*Ty1+3*Ty2)*b^3/840.*I5;
kg(listLoc0+6,listLoc0+7)=gf_mp23;
kg(listLoc0+7,listLoc0+6)=gf_mp23;
kg(listLoc0+6,listLoc0+8)=gf_mp24;
kg(listLoc0+8,listLoc0+6)=gf_mp24;
kg(listLoc0+7,listLoc0+7)=(3*Ty1+10*Ty2)*b/35.*I5;
kg(listLoc0+7,listLoc0+8)=gf_mp34;
kg(listLoc0+8,listLoc0+7)=gf_mp34;
kg(listLoc0+8,listLoc0+8)=(3*Ty1+5*Ty2)*b^3/840.*I5;

kg=sparse(kg);