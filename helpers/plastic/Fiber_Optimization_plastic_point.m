function [thetaMMf,phiPMf,betaf,fib_c,Fy,PY,MxxY,MzzY,Parf]=Fiber_Optimization_plastic_point(ndata,text)
%%% In the name of Allah
%%% Fiber element Model
%%% March 2013
%%% Shahabeddin Torabian
%%% December 2015

% close all
% clear all

% load('Zsections.mat');
load('SFIA.mat')
% load('Zsections.mat');


Current=pwd;
addpath(genpath(Current));





%% Beta-ThetaMM-PhiPM space (point for re-gridding the point cloud via interpolation)

thetaMM=20;% Only 2 entries as planar shape with 180 deg. deference like two poles

phiPM=75; % PhiPM<90 means compression and PhiPM>90 means Tension


%% Cross Section

% Cross-section can be selected either from SFIA or Zee-section catalog or
% it can be imported from the template.

% mm is the sequential number is the SFIA.mat data base. i.e. mm=83 is
% 600S300-54 (AISI-S200-12 designation)
mm=100;
    

% Cee or Zee: CorZ=1 for Cees and CorZ=2 for Zees
CorZ=1;


% Centerline Dimensions for a general section
% Dim=[h b1 b2 d1 d2 r1 r2 r3 r4 theta1 theta2 theta3 theta4 thickness]
% h, b1, b2, b3, b4 are flat lines
% r1 is the radius of fillet between d1 (lip) and b1 (flange)
% r2 is the radius of fillet between b1 (flange) and h (web)
% r3 is the radius of fillet between h (web)and b2 (flange)
% r4 is the radius of fillet between b2 (flange) and d2 (lip)
% theta1 is the angle between d1 (lip) and b1 (flange)
% theta2 is the angle between b1 (flange) and h (web)
% theta3 is the angle between h (web)and b2 (flange)
% theta4 is the angle between b2 (flange) and d2 (lip)

% Dim=[5.717	2.717	1.3	0.4835	0.4835	0.1132	0.1132	0.1132	0.1132	115	75	50	50	0.0566];


% set r1=r2=r3=r4 for sharp corners or Round_corner=0; for round corners 
% Round_corner=1; 

Round_corner=1;

%% Discritization

% Number of Elements for CUFSM stability analysis
% n_elem_cufsm=[lip(d1) fillet(r1) flange(b1) fillet(r2) web(h) fillet(r3) flange(b2) fillet(r4) lip(d2)];
n_elem_cufsm=[4 4 4 4 8 4 4 4 4];

% Number of Elements and fiber layers for Plastic Surface analysis
% n_elem_cufsm=[lip(d1) fillet(r1) flange(b1) fillet(r2) web(h) fillet(r3) flange(b2) fillet(r4) lip(d2)];
n_elem_plastic=30*[4 4 4 4 16 4 4 4 4];
NL_plastic=15;

%% Material Properties

% Note: Material properties will not change the results when the results
% are normalized to the yield quantities

Fy=50;
Fu=60;
E=29500;
nu=0.3;



%% Import Sections according to SFIA classiffication
% If an SFIA or Zee-section database is being used: uncomment this:

section=text{mm};
[fib_c,nodef_c,node_c,element_c,node_c90,element_c90,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22]=...
    PMM_fiber_node_element_Z_rot(text{mm},n_elem_cufsm,n_elem_plastic,NL_plastic,ndata,text,CorZ,Round_corner);

% If SFIA or Zee-section database are not being used the "Dim" is the
% import parameter
% section='general';
% [fib_c,nodef_c,node_c,element_c,node_c90,element_c90,A,xcg,zcg,Ixx,Izz,Ixz,thetapf,I11,I22]=...
%     PMM_fiber_node_element_Z_rot_general(section,Dim,n_elem_cufsm,n_elem_plastic,NL_plastic,CorZ,Round_corner);



% % Flipping the cross-section if required
% fib_c(:,2)=-fib_c(:,2);
% nodef_c(:,2)=-nodef_c(:,2);
% node_c(:,2)=-node_c(:,2);
% node_c90(:,2)=-node_c90(:,2);

%% Claculatin Section Modulus of the general section

Xmax=abs(max(max(nodef_c(:,2))));
Xmin=abs(min(min(nodef_c(:,2))));
Ymax=abs(max(max(nodef_c(:,3))));
Ymin=abs(min(min(nodef_c(:,3))));

Sxx1=Ixx/Ymax;
Sxx2=Ixx/Ymin;
Sz1=Izz/Xmax;
Sz2=Izz/Xmin;


%% Yield strengths

Sxxm=min(Sxx1,Sxx2);
MxxY=Sxxm*Fy;

Szm=min(Sz1,Sz2);
MzzY=Szm*Fy;

PY=A*Fy;

%% Seacrh 

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

% Par0=[0,0];
k=0;

    function [err]=ErrF(Par)
    [thetaMM0,phiPM0,beta0]=PMM_Dumping_V1(fib_c,Fy,PY,MxxY,MzzY,Par);
%     Par
%     thetaMM0
%     phiPM0
    err	=(abs(thetaMM0-thetaMM))^2+abs((phiPM0-phiPM))

    hold all
    plot(k,err,'+')
    k=k+1;
    end

opts = psoptimset('InitialMeshSize',20,'MeshAccelerator','on','ScaleMesh','on',...
    'TolX',1e-20,'Tolfun',1e-20,'Cache','on','CacheTol',1e-20,'Tolmesh',1e-20);
% opts = psoptimset(opts,'SearchMethod',@positivebasisnp1, ...
%     'PlotFcns',{@psplotbestf, @psplotfuncount});
Parf=patternsearch(@ErrF,[-0.1,thetaMM],[],[],[],[], ...
    [],[],[],opts);

Parf=fminsearch(@ErrF,Parf);


thetaMM
phiPM
[thetaMMf,phiPMf,betaf]=PMM_Dumping_V1(fib_c,Fy,PY,MxxY,MzzY,Parf)

end