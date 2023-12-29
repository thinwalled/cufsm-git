function [BY,ay,ayc,ayt] = YS_for_DSM_Fiber(TetaMM,PhiPM,B,nodef_c,Fy,A,Ixx,Izz,Sxx,Sz1,Sz2,node_c90,n_elem_cufsm)



Br=B;
TetaMM=TetaMM/180*pi;
PhiPM=PhiPM/180*pi;

xr=Br*cos(TetaMM)*sin(PhiPM);
yr=Br*sin(TetaMM)*sin(PhiPM);
zr=Br*cos(PhiPM);


%% Yield Forces

MxxY=Sxx*Fy;
MzzY=Sz1*Fy;
PY=A*Fy;

%% P and M
PP=zr*PY;
Mxx=xr*MxxY;
Mzz=yr*MzzY;

NN=length(nodef_c);

for i=1:NN

nodef_c(i,8)=PP/A-Mxx*nodef_c(i,3)/Ixx+Mzz*nodef_c(i,2)/Izz;

end

Smaxc=max(nodef_c(:,8));
Smaxt=min(nodef_c(:,8));

ayc=(Fy/Smaxc);
ayt=(Fy/Smaxt);

if abs(ayc)<=abs(ayt)
    ay=ayc;
else
    ay=ayt;
end



BY=abs(ay*Br);
end

