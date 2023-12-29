function [thetaMM,phiPM,beta]=PMM_Dumping_V1(fib_c,Fy,PY,MxxY,MzzY,Par)

%%% Plastic moment @ an arbitrary neutral axis
%%% March 2013
%%% Shahabeddin Torabian
%%% Version 1 December 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

e=Par(1);
alpha=Par(2)/180*pi;
NF=length(fib_c);

Mx=0;
Mz=0;
P=0;

for i=1:NF
    
      CL=fib_c(i,3)*cos(alpha)-fib_c(i,2)*sin(alpha)-e;
      
    if CL>0
        fib_c(i,5)=-fib_c(i,4)*Fy;
    elseif CL<0
        fib_c(i,5)=+fib_c(i,4)*Fy;
    else 
        fib_c(i,5)=0;
    end
    
    Mx=Mx-fib_c(i,5)*fib_c(i,3);
    Mz=Mz+fib_c(i,5)*fib_c(i,2);
    P=P+fib_c(i,5);

end  

M11onM11y=Mx/MxxY;
M22onM22y=Mz/MzzY;
PonPy=P/PY;


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




