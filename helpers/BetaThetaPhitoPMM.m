function [PonPy,M11onM11y,M22onM22y] = BetaThetaPhitoPMM(beta,thetaMM,phiPM)
%Convert normalized PMM to beta,theta,phi coordinates
%BWS template, 11/12/15
%ST content, 11/12/15
PonPy=0;
M11onM11y=0;
M22onM22y=0;

thetaMM=thetaMM/180*pi;
phiPM=phiPM/180*pi;

M11onM11y=beta*sin(phiPM)*cos(thetaMM);
M22onM22y=beta*sin(phiPM)*sin(thetaMM);
PonPy=beta*cos(phiPM);

end

