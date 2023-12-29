function [beta,thetaMM,phiPM] = PMMtoBetaThetaPhi(PonPy,M11onM11y,M22onM22y)
%Convert normalized PMM to beta,theta,phi coordinates
%BWS template, 11/12/15
%ST content, 11/12/15

% thetaMM and phiPM are in degree

beta=0;
thetaMM=0;
phiPM=0;

beta=(M11onM11y^2+M22onM22y^2+PonPy^2)^0.5;

thetaMM=atan2(M22onM22y,M11onM11y);

if thetaMM<0
    thetaMM=2*pi+thetaMM;
end

phiPM=acos(PonPy/beta);

thetaMM=thetaMM/pi*180;
phiPM=phiPM/pi*180;

end

