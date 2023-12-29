function [kg]=kglocal_m(a,b,m,Ty1,Ty2,BC)

%assemble local geometric stiffness matrix for a single longitudinal term m

%created on Jul 10, 2009 by Z. Li

%Generate geometric stiffness matrix (kg) in local coordinates
% kg=sparse(zeros(8*m,8*m));
%
kk=m;
nn=m;
gm_mp=zeros(4,4);
z0=zeros(4,4);
gf_mp=zeros(4,4);
um=kk*pi;
up=nn*pi;
%
[I1,I2,I3,I4,I5] = BC_I1_5(BC,kk,nn,a);
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
kg=kgmp;


 
 
        
 
        
        
 