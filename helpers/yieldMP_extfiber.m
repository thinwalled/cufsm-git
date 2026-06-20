function [Py,Mxx_y,Mzz_y,M11_y,M22_y]=yieldMP_extfiber(node,elem,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,...
                                              I11,I22,unsymm)
%BWS
%June 2026
%yieldMP_extfiber
%[Py,Mxx_y,Mzz_y,M11_y,M22_y]=yieldMP_extfiber(node,elem,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymm)
%Modification of yieldMP so that values are genereated to the extreme fiber
%instead of the centerline. If extreme fiber stress is at Fy, the applied
%stress on the midline will be slightly reduced (compared with original
%yieldMP which used nodal coordinates as extreme fiber locations.)
%Original yieldMP from 
%August 2000
%[Py,Mxx_y,Mzz_y,M11_y,M22_y]=yieldMP(node,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymm)
%May 2019 trap nan when flat plate or other properites are zero
%
%
%%
%Py
Py=fy*A;
%
%%
%account for the possibility of restrained bending vs. unrestrained bending
if unsymm==0
   Ixz=0;
end
%%
%Generate corner x,z locations for all elements
elemcorner = elemcornergen(node,elem);
xcorners=elemcorner(:,5);
zcorners=elemcorner(:,6);
%%
%Mxx_y
%calculate stress at every point based on Mxx=1
Mxx=1;, Mzz=0;
stress=((Mzz*Ixx+Mxx*Ixz)*(node(:,2)-xcg)-(Mzz*Ixz+Mxx*Izz)*(node(:,3)-zcg)) / (Izz*Ixx-Ixz^2); 
%factor=fy/max(abs(stress)); %nodes assumed at extreme fiber
%corner stresses
corner_stress=((Mzz*Ixx+Mxx*Ixz)*(xcorners-xcg)-(Mzz*Ixz+Mxx*Izz)*(zcorners-zcg)) / (Izz*Ixx-Ixz^2); 
factor=fy/max(abs(corner_stress));
Mxx_y=factor*Mxx;
if isnan(Mxx_y)
    Mxx_y=0;
end
%%
%Mzz_y
%calculate stress at every point based on Mzz=1
Mxx=0;, Mzz=1;
stress=((Mzz*Ixx+Mxx*Ixz)*(node(:,2)-xcg)-(Mzz*Ixz+Mxx*Izz)*(node(:,3)-zcg)) / (Izz*Ixx-Ixz^2); 
%factor=fy/max(abs(stress)); %nodes assumed at extreme fiber
%corner stresses
corner_stress=((Mzz*Ixx+Mxx*Ixz)*(xcorners-xcg)-(Mzz*Ixz+Mxx*Izz)*(zcorners-zcg)) / (Izz*Ixx-Ixz^2); 
factor=fy/max(abs(corner_stress));
Mzz_y=factor*Mzz;
if isnan(Mzz_y)
    Mzz_y=0;
end
%
%%
%M11_y, M22_y
%transform coordinates of nodes into principal coordinates
th=thetap*pi/180;
prin_coord=inv([cos(th) -sin(th) ; sin(th) cos(th)])*[(node(:,2)-xcg)' ; (node(:,3)-zcg)'];
%element corners in principal coordinates
prin_coord_corners=inv([cos(th) -sin(th) ; sin(th) cos(th)])*[(xcorners-xcg)' ; (zcorners-zcg)'];
%
%
M11=1;
stress=M11*prin_coord(2,:)'/I11;
corner_stress=M11*prin_coord_corners(2,:)'/I11;
factor=fy/max(abs(corner_stress));
M11_y=factor*M11;
if isnan(M11_y)
    M11_y=0;
end
%
M22=1;
stress=M22*prin_coord(1,:)'/I22;
corner_stress=M22*prin_coord_corners(1,:)'/I22;
factor=fy/max(abs(corner_stress));
M22_y=factor*M22;
if isnan(M22_y)
    M22_y=0;
end

