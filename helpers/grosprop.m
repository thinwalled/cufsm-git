function [A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22]=grosprop(node,elem)
%[A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22]=grosprop(node,elem)
%December 8, 1997
%Benjamin Schafer
%Input
%node=[# x z DOFX DOFZ DOFY DOF0 stress]
%elem=[# i j t]
%Ouput
%
A=0;, Ax=0;, Az=0;, Axx=0;, Azz=0;, Axz=0;
Ixx_o=0;, Izz_o=0;, Ixz_o=0;
for k=1:length(elem(:,1))
   ni=elem(k,2);
   nj=elem(k,3);
   t=elem(k,4);
   xi=node(ni,2);
   xj=node(nj,2);
   zi=node(ni,3);
   zj=node(nj,3);
   %
   delx=xj-xi;
   delz=zj-zi;
   theta_xx=pi/2-atan2(delz,delx);
   theta_zz=theta_xx+pi/2;
   xcg_elem=1/2*(xi+xj);
   zcg_elem=1/2*(zi+zj);
   L_elem=sqrt(delx^2+delz^2);
   A_elem=t*L_elem;
   Ixx_elem=1/12*t*L_elem*(t^2*(sin(theta_xx))^2 + L_elem^2*(cos(theta_xx))^2);
   Izz_elem=1/12*t*L_elem*(t^2*(sin(theta_zz))^2 + L_elem^2*(cos(theta_zz))^2);
   Ixz_elem=1/12*t*L_elem*(t^2*sin(theta_xx)*cos(theta_xx) + ...
                           L_elem^2*cos(theta_xx)*sin(theta_xx));
   %
   A=A + A_elem;
   Ax=Ax + A_elem*xcg_elem;
   Az=Az + A_elem*zcg_elem;
   Axx=Axx + A_elem*xcg_elem*xcg_elem;
   Azz=Azz + A_elem*zcg_elem*zcg_elem;
   Axz=Axz + A_elem*xcg_elem*zcg_elem;
   Ixx_o=Ixx_o + Ixx_elem;
   Izz_o=Izz_o + Izz_elem;
   Ixz_o=Ixz_o + Ixz_elem;
   %
end
xcg=Ax/A;
zcg=Az/A;
Ixx=Ixx_o + Azz - A*zcg^2;
Izz=Izz_o + Axx - A*xcg^2;
Ixz=Ixz_o + Axz - A*xcg*zcg;
thetap=180/pi*1/2*atan2(-2*Ixz,Ixx-Izz);
I11=1/2*(Ixx+Izz) + sqrt( (1/2*(Ixx-Izz))^2 + Ixz^2 );
I22=1/2*(Ixx+Izz) - sqrt( (1/2*(Ixx-Izz))^2 + Ixz^2 );
