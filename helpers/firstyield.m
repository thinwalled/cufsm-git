function [betay,PMMy] = firstyield(node,elem,fy,thetaMM,phiPM)
%Calculation of first yield point in PMM space
%BWS 13 November 2015
%
%input
%node and elem, standard CUFSM properties
%thetaMM and phiPM as equal n-length column vectors that finding first yield is
%desired for in the PMM space.
%
%output
%betay a column vector to go with thetaMM and phiPM
%PMMy=[P/Py M11/M11y M22/M22y] nx3 array of first yield values 
%
%Determine section properties
[A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,J,Xs,Ys,Cw,B1,B2,w] = cutwp_prop2(node(:,2:3),elem(:,2:4));
thetap=thetap*180/pi; %degrees...
%
%Determine first yield anchor points
[Py,Mxxy,Mzzy,M11y,M22y]=yieldMP(node,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,1);
%
for i=1:length(thetaMM)
    theta=thetaMM(i);
    phi=phiPM(i);
    %Determine reference PMM demands
    beta=1;
    [PonPyref,M11onM11yref,M22onM22yref] = BetaThetaPhitoPMM(beta,theta,phi);
    Pref=PonPyref*Py;
    M11ref=M11onM11yref*M11y;
    M22ref=M22onM22yref*M22y;
    %Determine stress at reference level
    unsymm=1;
    inode=stresgen(node,Pref,0,0,M11ref,M22ref,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymm);
    fmax=max(abs([inode(:,8);0]));
    %Determine PMM demands that create yield at this theta, phi angle
    yPonPy=PonPyref*fy/fmax;
    yM11onM11y=M11onM11yref*fy/fmax;
    yM22onM22y=M22onM22yref*fy/fmax;
    %Determine beta at yield
    betay(i)=sqrt(yPonPy^2+yM11onM11y^2+yM22onM22y^2);
    %PMM at yield in saved form
    PMMy(i,:)=[yPonPy yM11onM11y yM22onM22y];
end


end

