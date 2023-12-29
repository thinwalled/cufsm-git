%  "Plastic and Yield surfaces" based on the fiber discretization of the 
% template cross sections

% Shahabeddin Torabian 
% December 2015

close all
clear all

% load('Zsections.mat');
load('SFIA.mat')
% load('Zsections.mat');


Current=pwd;
addpath(genpath(Current));


%% Cross Section

% Cross-section can be selected either from SFIA or Zee-section catalog or
% it can be imported from the template.

% mm is the sequential number is the SFIA.mat data base. i.e. mm=83 is
% 600S300-54 (AISI-S200-12 designation)
% mm=83;
    

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

Dim=[5.717	2.717	1.3	0.4835	0.4835	0.1132	0.1132	0.1132	0.1132	115	75	50	50	0.0566];


% set r1=r2=r3=r4 for sharp corners or Round_corner=0; for round corners 
% Round_corner=1; 

Round_corner=1;

%% Discritization

% Number of Elements for CUFSM stability analysis
% n_elem_cufsm=[lip(d1) fillet(r1) flange(b1) fillet(r2) web(h) fillet(r3) flange(b2) fillet(r4) lip(d2)];
n_elem_cufsm=[4 4 4 4 8 4 4 4 4];

% Number of Elements and fiber layers for Plastic Surface analysis
% n_elem_cufsm=[lip(d1) fillet(r1) flange(b1) fillet(r2) web(h) fillet(r3) flange(b2) fillet(r4) lip(d2)];
n_elem_plastic=2*[4 4 4 4 16 4 4 4 4];
NL_plastic=5;

%% Material Properties

% Note: Material properties will not change the results when the results
% are normalized to the yield quantities

Fy=50;
Fu=60;
E=29500;
nu=0.3;



%% Import Sections according to SFIA classiffication
% If an SFIA or Zee-section database is being used: uncomment this:

% section=text{mm};
% [fib_c,nodef_c,node_c,element_c,node_c90,element_c90,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22]=...
%     PMM_fiber_node_element_Z_rot(text{mm},n_elem_cufsm,n_elem_plastic,NL_plastic,ndata,text,CorZ,Round_corner);

% If SFIA or Zee-section database are not being used the "Dim" is the
% import parameter
section='general';
[fib_c,nodef_c,node_c,element_c,node_c90,element_c90,A,xcg,zcg,Ixx,Izz,Ixz,thetapf,I11,I22]=...
    PMM_fiber_node_element_Z_rot_general(section,Dim,n_elem_cufsm,n_elem_plastic,NL_plastic,CorZ,Round_corner);



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


%% Plastic Database
% This section is reproducing a point cloud for the plastic surface based
% on moving the neutral axis over the cross-section (fibers)

Sxxm=min(Sxx1,Sxx2);
MxxY=Sxxm*Fy;

Szm=min(Sz1,Sz2);
MzzY=Szm*Fy;

PY=A*Fy;

% Deg= Angular discritization for moving the neutral axis
Deg=[0:0.1:5 6:87 88:0.1:92 93:177 178:0.1:182 183:267 268:0.1:272 273:354 355:0.1:360];
% Ne= radial discritization for moving the neutral axis
Ne=350;

% Producing a point cloud for the plastic surface and dump that to PMM
% space

[Mxn,Mzn,Pn]=PMM_Dumping(fib_c,Fy,PY,MxxY,MzzY,Ne,Deg);

% Chnaging the PMM coordinate to the polar coordinate to prepare data for
% interpolation

[m,n]=size(Pn);
Inter1=[reshape(Mxn,m*n,1) reshape(Mzn,m*n,1) reshape(Pn,m*n,1)];
Inter=unique(Inter1, 'rows');
[azp,elp,rp] = cart2sph(Inter(:,1),Inter(:,2),Inter(:,3));

%% Beta-ThetaMM-PhiPM space (point for re-gridding the point cloud via interpolation)

TetaMM=0:30:360;% Only 2 entries as planar shape with 180 deg. deference like two poles

PhiPM=0:30:180; % PhiPM<90 means compression and PhiPM>90 means Tension
B=5; % Arbitary number
BP(length(TetaMM)*length(TetaMM))=0;
BY(length(TetaMM)*length(TetaMM))=0;
ay(length(TetaMM)*length(TetaMM))=0;
ayc(length(TetaMM)*length(TetaMM))=0;
ayt(length(TetaMM)*length(TetaMM))=0;

k=1;
for i=1:length(TetaMM)
      for j=1:length(PhiPM)


%% Yield Surface based on the fiber discritization

[BY(k),ay(k),ayc(k),ayt(k)]= YS_for_DSM_Fiber_g(TetaMM(i),PhiPM(j),B,nodef_c,Fy,A,Ixx,Izz,Sxx1,Sxx2,Sz1,Sz2,node_c90,n_elem_cufsm);

%% Plastic Surface on the fiber discritization (interpolation)

if TetaMM(i)>=180;
az=TetaMM(i)-360;
else
az=TetaMM(i);
end
el=90-PhiPM(j);

if PhiPM(j)==180||PhiPM(j)==0
BP(k)=BY(k);
else
BP(k)=PMM_point_finder(azp,elp,rp,az,el);
end

k=k+1;
  
      end
end


% Writing results to Yield and Plastic vectors:
% ThetaMM PhiPM Beta ...


[Yield] = B2xyzr(BY,TetaMM,PhiPM);
[Plastic] = B2xyzr(BP,TetaMM,PhiPM);

Yield(:,1:2)=round(Yield(:,1:2)*10000)/10000;
Plastic(:,1:2)=round(Plastic(:,1:2)*10000)/10000;


%% regridding data to for 3D plots

azz=TetaMM;
ell=PhiPM;
[azi,eli] = meshgrid(azz,ell);

 LP=length(PhiPM);
 
riY(length(ell),length(azz))=0;
riP(length(ell),length(azz))=0;
for i=1:length(ell)
    for j=1:length(azz)
        
% Yield surface (polar coordinate system)
riY(i,j)=Yield(and(Yield(:,1)==azi(i,j),Yield(:,2)==eli(i,j)),3);

% Plastic surface (polar coordinate system)
riP(i,j)=Plastic(and(Plastic(:,1)==azi(i,j),Plastic(:,2)==eli(i,j)),3);

    end
end


% Converting to Cartesian coordinate system


% Yield surface
[XY,YY,ZY] = sph2cart(azi/180*pi,(90-eli)/180*pi,riY);

% Plastic surface
[XP,YP,ZP] = sph2cart(azi/180*pi,(90-eli)/180*pi,riP);


%%plots
fig1=figure (1);
hold all;
width=6; %inches
height=6; %inches
left=1; %inch from the left edge of the screen
bottom=1; %inch from the bottom of the screen 


SY=surf(XY,YY,ZY,'EdgeColor','none','FaceColor',[0,0,1],'FaceLighting','phong','FaceAlpha', 1);
SP=surf(XP,YP,ZP,'EdgeColor','none','FaceColor',[1,0,0],'FaceLighting','phong','FaceAlpha', 1);

alpha (SY,0.60);
alpha(SP,0.30);

xlim([-1,2]);
ylim([-2,2]);
camlight right

% axis tight;
% axis equal;
camlight left
grid on;
view(110,30)
% axis equal

xlabel('M_1/M_{1y} (Major)','fontsize',8,'fontweight','b','color','black','FontName','Times');
ylabel('M_2/M_{2y} (Minor)','fontsize',8,'fontweight','b','color','black','FontName','Times');
zlabel('P/P_y','fontsize',8,'fontweight','b','color','black','FontName','Times');

% title('Strength Surface  AISI S100-12','fontsize',10,'fontweight','b','color','black','FontName','Times');

set(fig1,'Units','Inches','Position',[left bottom width height]);
set(fig1,'PaperPosition',[0 0 width height]);
set(gca,'XGrid','on','YGrid','on');
set(gca,'fontsize',10,'FontName','Times','linewidth',0.75);
filename='Fig_3D_P_Y_Surfaces';
print('-depsc','-loose','-tiff','-r300',filename)
savefig(fig1,filename) 



%% Save data
 C=clock;
 DT=strrep(num2str(C(1:5)),' ','');

 
save ([section,'_','Y_P','_',DT,'.mat']);
