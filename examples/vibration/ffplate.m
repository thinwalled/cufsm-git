%BWS
%2024 05 30 - 2024 06 09
%Vibraton of simply-supported (SS) plate by FSM
%Based on CUFSM additions by Rajshri Kumar

%Clear the workspace
clear all
close all
clc

%Set the path
%run cufsm5 that will set the path, easier than adding separate code here
%or, use
%addpath(genpath('pathtocufsm')) %that gets the main and adds
%subdirectories where 'pathtocufsm' is your path to where cufsm is
%installed.

%basic problem dimensions for a x b x t isotropic steel plate in kip, in.;
%initial problem based on work with FastFloor Commerical project, see
%steeli.org for more information
a=40*12; %in.
b=5*12; %in.
t=3/8; %in.
E=29000; %ksi
v=0.3;
rhos=490/1000/12^3; %kip/in^3
g=386.4; %in/s^2
rho=rhos/g; %kip-s^2/in^4

%convert into FSM inputs
prop=[100 E E v v E/(2*(1+v)) rho]; %note only the addition of rho is unique to vibration
node=[1 0 0       0 0 1 1 0.0   %set the first node as pinned in x-z, aslo applied stress is zero
      2 b/4 0     1 1 1 1 0.0
      3 b/2 0     1 1 1 1 0.0
      4 3*b/4 0   1 1 1 1 0.0
      5 b 0       0 0 1 1 0.0]; %do again for the last node
elem=[1 1 2 t 100
      2 2 3 t 100
      3 3 4 t 100
      4 4 5 t 100];
lengths=a;
springs=0;
constraints=0;
GBTcon=0;
BC='S-S';
for i=1:length(lengths)
    m_all{i}=[1 2 3 4 5 6 7 8 9 10];
end
neigs=30;

%call the solver
[curve,shapes]=stripmain_vib(prop,node,elem,lengths,springs,constraints,GBTcon,BC,m_all,neigs);

%save the results
save ffplate1

%%
%plot a mode with frequency using the 3D plotter
lengthindex=1;
modeindex=2;
%plotting using CUFSM's 3D plotter
h1=figure(1)
axes3dshape=gca(h1);
scale_3D=3; %scale
Item3D=1; %Item3D: objects to be plotted: 1 - Deformed shape only, 2 - Undeformed shape only, 3 - Deformed shape & undeformed mesh
Data3D=1; %	%1: Vector sum of Displacement, 2: X-Component of displacement, 3: Y-Component of displacement, 4: Z-Component of displacement, 5: Y-Component of Normal Strain, 6: In-strip-plane of Shear Strain, 7: No Color
ifSurface=1; %1: surface, 2: mesh, 3: curved lines(nodal lines and specific crose-section lines)
ifColorBar=0;
SurfPos=.5; %y/L length for any 2D plots
mode=shapes{lengthindex}(:,modeindex);
dispshp2(lengths(lengthindex),node,elem,mode,axes3dshape,scale_3D,m_all{lengthindex},BC,1,Item3D,Data3D,ifSurface,ifColorBar,SurfPos);
title(['mode=',int2str(modeindex),' f=',num2str(curve{lengthindex}(modeindex,2)),'Hz']);
