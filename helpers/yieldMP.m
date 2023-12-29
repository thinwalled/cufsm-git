function [Py,Mxx_y,Mzz_y,M11_y,M22_y]=yieldMP(node,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,...
                                              I11,I22,unsymm)
%BWS
%August 2000
%[Py,Mxx_y,Mzz_y,M11_y,M22_y]=yieldMP(node,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymm)
%May 2019 trap nan when flat plate or other properites are zero
%
%
%Py
Py=fy*A;
%
%account for the possibility of restrained bending vs. unrestrained bending
if unsymm==0
   Ixz=0;
end
%Mxx_y
%calculate stress at every point based on Mxx=1
Mxx=1;, Mzz=0;
stress=((Mzz*Ixx+Mxx*Ixz)*(node(:,2)-xcg)-(Mzz*Ixz+Mxx*Izz)*(node(:,3)-zcg)) / (Izz*Ixx-Ixz^2); 
factor=fy/max(abs(stress));
Mxx_y=factor*Mxx;
if isnan(Mxx_y)
    Mxx_y=0;
end
%Mzz_y
%calculate stress at every point based on Mxx=1
Mxx=0;, Mzz=1;
stress=((Mzz*Ixx+Mxx*Ixz)*(node(:,2)-xcg)-(Mzz*Ixz+Mxx*Izz)*(node(:,3)-zcg)) / (Izz*Ixx-Ixz^2);
factor=fy/max(abs(stress));
Mzz_y=factor*Mzz;
if isnan(Mzz_y)
    Mzz_y=0;
end
%
%M11_y, M22_y
%transform coordinates of nodes into principal coordinates
th=thetap*pi/180;
prin_coord=inv([cos(th) -sin(th) ; sin(th) cos(th)])*[(node(:,2)-xcg)' ; (node(:,3)-zcg)'];
%
M11=1;
stress=M11*prin_coord(2,:)'/I11;
factor=fy/max(abs(stress));
M11_y=factor*M11;
if isnan(M11_y)
    M11_y=0;
end
%
M22=1;
stress=M22*prin_coord(1,:)'/I22;
factor=fy/max(abs(stress));
M22_y=factor*M22;
if isnan(M22_y)
    M22_y=0;
end

