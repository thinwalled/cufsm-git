function [dy,ngm]=yDOFs(node,elem,m_node,nmno,ndm,Ryd,Rud)

% this routine creates y-DOFs of main nodes for global buckling and
% distortional buckling, however:
%    only involves single half-wave number m
%
%assumptions
%   GBT-like assumptions are used
%   the cross-section must not be closed and must not contain closed parts

%input data
%   node, elem - same as elsewhere throughout this program
%   m_node [main nodes] - nodes of 'meta' cross-section
%   nmno,ncno,nsno - number of main nodes, corner nodes and sub-nodes, respectively
%   ndm,nlm - number of distortional and local buckling modes, respectively
%   Ryd, Rud - constraint matrices
%
%output data
%   dy - y-DOFs of main nodes for global buckling and distortional buckling
%   (each column corresponds to a certain mode)
%
%
% S. Adany, Mar 10, 2004, modified Aug 29, 2006
% Z. Li, Dec 22, 2009

%cross-sectional properties
[A,xcg,zcg,Ix,Iy,Ixy,thetap,I1,I2,J,xs,ys,Cw,B1,B2,w] = cutwp_prop2(node(:,2:3),elem(:,2:4));
%

%coord. transform. to the principal axes
th=thetap;
rot=[cos(th) -sin(th)
     sin(th)  cos(th)];
CG=[xcg,zcg]*rot;

%
%
%CALCULATION FOR GLOBAL AND DISTORTIONAL BUCKLING MODES
%
%to create y-DOFs of main nodes for global buckling
for i=1:nmno
    XZi=[m_node(i,2),m_node(i,3)]*rot;
    dy(i,1)=1;
    dy(i,2)=XZi(2)-CG(2);
    dy(i,3)=XZi(1)-CG(1);
    dy(i,4)=w(m_node(i,4));
end
% for i=1:4
%     dy(:,i) = dy(:,i)/norm(dy(:,i));
% end
%
%to count the nr of existing global modes
ngm=4;
ind=zeros(1,4)+1;
for i=1:4
    if isempty(find(dy(:,i)))
        ind(i)=0;
        ngm=ngm-1;
    end
end
%
%to eliminate zero columns from dy
sdy=dy;
dy=[];
k=0;
for i=1:4
    if ind(i)==1
        k=k+1;
        dy(:,k)=sdy(:,i);
    end
end
%
%to create y-DOFs of main nodes for distortional buckling
%
if ndm>0
    % junk=null((Ryd*dy(:,1:(ngm+1)))');
    % junk3=junk'*Ryd*junk;
    %
    %
    ch=chol(Ryd);
    junk=null((ch*dy(:,1:(ngm)))');
    junk2=ch\junk;
    
    jjunk1=null(junk2');
    jjunk2=null(Rud');
    nj1=length(jjunk1(1,:));
    nj2=length(jjunk2(1,:));
    jjunk3=jjunk1;
    jjunk3(:,(nj1+1):(nj1+nj2))=jjunk2;
    jjunk4=null(jjunk3');
    
    % dy(:,(ngm+2):(ngm+1+ndm))=jjunk4;
    
    junk3=jjunk4'*Ryd*jjunk4;
    % junk3=junk2'*junk2;
    % 
    [V,D]=eig(junk3);
    % D=diag(D);
    % [D,index]=sort(D);
    % V=V(:,index);
    dy(:,(ngm+1):(ngm+ndm))=jjunk4*V;
end