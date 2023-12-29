function [node]=stresgen(node,P,Mxx,Mzz,M11,M22,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymm)
%BWS
%1998
if unsymm==0
   Ixz=0;
end
stress=zeros(length(node(:,1)),1);
stress=stress+P/A;
stress=stress-((Mzz*Ixx+Mxx*Ixz)*(node(:,2)-xcg)-(Mzz*Ixz+Mxx*Izz)*(node(:,3)-zcg))/(Izz*Ixx-Ixz^2);
th=thetap*pi/180;
prin_coord=inv([cos(th) -sin(th) ; sin(th) cos(th)])*[(node(:,2)-xcg)' ; (node(:,3)-zcg)'];
stress=stress-M11*prin_coord(2,:)'/I11;
stress=stress-M22*prin_coord(1,:)'/I22;
node(:,8)=stress;