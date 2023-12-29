function [M11,M22]=MxxtoM11(Mxx,Mzz,Ixx,Izz,Ixz,thetap,I11,I22,restrained)
%BWS 2015
%Convert Mxx and Mzz to M11 and M22 depending on whether or not the section
%is under restrained bending or unrestrained bending. In restrained bending
%the Mxx moment only creates moment about z, so M11 and M22 have to be
%found so that this remains the case. In unrestrained bending M11 and M22
%are simply the transformation.
%May 2019 add isnan checks
%
%
%initialize
M11=0;
M22=0;
%principal angle and transformation matrix
th=thetap*pi/180;
Gi=inv([cos(th) -sin(th) ; sin(th) cos(th)]); %some extra formalism here
Gi11=Gi(1,1);
Gi21=Gi(2,1);
Gi12=Gi(1,2);
Gi22=Gi(2,2);
%
%if restrained
if restrained
%     %From Mzz
%     M11z=-Mzz*(I11/Izz)*(Gi21-Gi11*Gi22/Gi12)^(-1);
%     M22z=M11z*(I22/I11)*(Gi22/Gi12);
%     %From Mxx
%     M11x=Mxx*(I11/Ixx)*(Gi22-Gi12*Gi21/Gi11)^(-1);
%     M22x=+M11x*(I22/I11)*(Gi21/Gi11);
    %From Mzz
    M22z=Mzz*I22/Izz*(sin(th)^2/cos(th)+cos(th))^-1;
    M11z=M22z*I11/I22*sin(th)/cos(th);
    %From Mxx
    M11x=Mxx*I11/Ixx*(cos(th)+sin(th)^2/cos(th))^-1;;
    M22x=-M11x*I22/I11*sin(th)/cos(th);
    %sum
    M11=M11z+M11x;
    M22=M22z+M22x;
else %unrestrained 
    M11=Gi11*Mxx+Gi12*Mzz;
    M22=Gi21*Mxx+Gi22*Mzz;
end
if isnan(M11)
    M11=0;
end
if isnan(M22)
    M22=0;
end