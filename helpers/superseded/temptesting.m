%temptesting
load tempztest
[A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,J,Xs,Ys,Cw,B1,B2,w] = cutwp_prop2(node(:,2:3),elem(:,2:4));
thetap=thetap*180/pi; %degrees...
restrained=1;
Mxx=0;
Mzz=1;
[M11,M22]=MxxtoM11(Mxx,Mzz,Ixx,Izz,Ixz,thetap,I11,I22,restrained);
M11
M22
