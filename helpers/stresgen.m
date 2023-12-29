function [node]=stresgen(node,P,Mxx,Mzz,M11,M22,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymm)
%BWS
%1998
if unsymm==0
   Ixz=0;
end
stress=zeros(length(node(:,1)),1);
%from P
stressinc=P/A;
if max(isnan(stressinc))
    stressinc=0;
end
stress=stress+stressinc;
%from Mxx Mzz
stressinc=-((Mzz*Ixx+Mxx*Ixz)*(node(:,2)-xcg)-(Mzz*Ixz+Mxx*Izz)*(node(:,3)-zcg))/(Izz*Ixx-Ixz^2);
if max(isnan(stressinc))
    stressinc=0;
end
stress=stress+stressinc;
%or from M11 and M22
th=thetap*pi/180;
prin_coord=inv([cos(th) -sin(th) ; sin(th) cos(th)])*[(node(:,2)-xcg)' ; (node(:,3)-zcg)'];
%M11
stressinc=M11*prin_coord(2,:)'/I11;
if max(isnan(stressinc))
    stressinc=0;
end
stress=stress+stressinc;
%M22
stressinc=-M22*prin_coord(1,:)'/I22;
if max(isnan(stressinc))
    stressinc=0;
end
stress=stress+stressinc;
%assign stress to node variable
node(:,8)=stress;