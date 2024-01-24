function [kglobal,kgglobal]=trans_vec(x1,z1,x2,z2,k,kg,m_a)
%
% Transfer the local stiffness into global stiffness
% Modefied by Sheng Jin, Jan. 2024

totalm = length(m_a); %Total number of longitudinal terms m
dz=z2-z1;
dx=x2-x1;
b=sqrt(dx^2+dz^2);
sinAlpha=dz/b;
cosAlpha=dx/b;

%
%t_Mat=[cosAlpha	0		0		0	sinAlpha	0		0		0
% 			0		1		0		0		0		0		0		0
% 			0		0	cosAlpha	0		0		0	sinAlpha	0
% 			0		0		0		1		0		0		0		0
% 		-sinAlpha	0		0		0	cosAlpha	0		0		0
% 			0		0		0		0		0		1		0		0
% 		    0		0	-sinAlpha	0		0		0	cosAlpha	0
% 			0		0		0		0		0		0		0		1	];
% 
% %extend to multi-m
% T_Mat=repmat(sparse(t_Mat),totalm,totalm);
T_Mat=eye(8*totalm);
T_Mat(sub2ind([totalm*8,totalm*8],1:2:totalm*8,1:2:totalm*8))=cosAlpha;
T_Mat(sub2ind([totalm*8,totalm*8],(1:8:totalm*8)+[4;6],(1:8:totalm*8)+[0;2]))=-sinAlpha;
T_Mat(sub2ind([totalm*8,totalm*8],(1:8:totalm*8)+[0;2],(1:8:totalm*8)+[4;6]))=sinAlpha;
T_Mat=sparse(T_Mat);
%
kglobal=T_Mat'*k*T_Mat;
kgglobal=T_Mat'*kg*T_Mat;

