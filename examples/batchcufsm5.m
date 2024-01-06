%Batch code for CUFSM 5
%Sometimes for parameter studies or other situations it is nice to use
%CUFSM without the GUI. This example goes through most of the basic CUFSM
%fucntions but shows how they can be programmed in matlab.
%v3 Ben Schafer; v4 Zhanjie Li, March 2012; v5 Ben Schafer

%clear the workspace (optional)
clear all
close all
clc

%location of cufsm m-files (subroutines)
%(they are located where you unzipped them..)
%note, there is difference of the format between mac/linux and windows
%For mac or linux
location=['/Users/bschafer/Dropbox (CEDJHU)/Ben/CUFSM/cufsm_working/cufsm5/source502']; %change this line to your own path
addpath([location]);
addpath([location,'/abaqusmaker']);
addpath([location,'/analysis']);
addpath([location,'/analysis/cFSM']);
addpath([location,'/cutwp']);
addpath([location,'/helpers']);
addpath([location,'/holehelper']);
addpath([location,'/interface']);
addpath([location,'/plotters']);

% %for windows, something like this         
% location=['C:\zhanjieli\Documents\cufsm5\source502']; %change this line to your own path
% addpath([location,'\abaqusmaker']);
% addpath([location,'\analysis']);
% addpath([location,'\analysis\cFSM']);
% addpath([location,'\cutwp']);
% addpath([location,'\helpers']);
% addpath([location,'\holehelper']);
% addpath([location,'\interface']);
% addpath([location,'\plotters']);

%-----------------------------------------------------------------
%--------------------BASIC GEOMETRY DEFINITION--------------------
%-----------------------------------------------------------------
%Here we will just use the default section from CUFSM, but you could use
%the template to define a section or anything you like, basically all the
%screens in the CUFSM pre-processor are just variables that need to be
%defined.
%

%Material Properties
prop=[100 29500.00 29500.00 0.30 0.30 11346.15];
%
%Nodes
node=[1 5.00 1.00 1 1 1 1 33.33
    2 5.00 0.00 1 1 1 1 50.00
    3 2.50 0.00 1 1 1 1 50.00
    4 0.00 0.00 1 1 1 1 50.00
    5 0.00 3.00 1 1 1 1 16.67
    6 0.00 6.00 1 1 1 1 -16.67
    7 0.00 9.00 1 1 1 1 -50.00
    8 2.50 9.00 1 1 1 1 -50.00
    9 5.00 9.00 1 1 1 1 -50.00
    10 5.00 8.00 1 1 1 1 -33.33];
%
%Elements
elem=[1 1 2 0.100000 100
    2 2 3 0.100000 100
    3 3 4 0.100000 100
    4 4 5 0.100000 100
    5 5 6 0.100000 100
    6 6 7 0.100000 100
    7 7 8 0.100000 100
    8 8 9 0.100000 100
    9 9 10 0.100000 100];

%-----------------------------------------------------------------
%------------TWEAKING MODEL USING OTHER CUFSM FEATURES------------
%-----------------------------------------------------------------
%Features available in the GUI may also be used in these batch programs,
%for instance the mesh in this default file is rather course, let's double
%the number of elements
[node,elem]=doubler(node,elem);
%
%In this example the stresses (last column of nodes) are already defined,
%but it is common to use the properties page to define these values instead
%of entering in the nodal stresses. Right now this problem applies a
%reference bending moment, let's apply a reference compressive load using
%the subroutines normally used on the properties page of CUFSM
%
%first calculate the global properties
[A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,J,Xs,Ys,Cw,B1,B2,w] = cutwp_prop2(node(:,2:3),elem(:,2:4));
thetap=thetap*180/pi; %degrees...
Bx=NaN; By=NaN;
%
%second set the refernce stress
fy=50;
%
%third calculate the P and M associated with the reference stress
unsymmetric=0; %i.e. do a restrained bending calculation
[P,Mxx,Mzz,M11,M22]=yieldMP(node,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymmetric);
%
%fourth apply just the P to the model
node=stresgen(node,P*1,Mxx*0,Mzz*0,M11*0,M22*0,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymmetric);
%

%-----------------------------------------------------------------
%----------------additional input definitions---------------------
%-----------------------------------------------------------------

%Lengths:
%for signiture curve, the length is interpreted as half-wave length the same as older cufsm version (3.x and previous)
%lengths=[1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 20.0 30.0 40.0 50.0 60.0 70.0 80.0 90.0 100.0 200.0 300.0 400.0 500.0 600.0 700.0 800.0 900.0 1000.0 ];
lengths=logspace(0,3,100)';
% %for general boundary conditions, the length is interpreted as physical member length
% lengths=[92 192];

%Boundary conditions: a string specifying boundary conditions to be analyzed
%'S-S' simply-pimply supported boundary condition at loaded edges
%'C-C' clamped-clamped boundary condition at loaded edges
%'S-C' simply-clamped supported boundary condition at loaded edges
%'C-F' clamped-free supported boundary condition at loaded edges
%'C-G' clamped-guided supported boundary condition at loaded edges
BC='S-S';
%note, the signiture curve soultion is only meaningful when BC is S-S. Be sure to set your BC as S-S when performing signiture curve analysis.

%Longitudinal terms in cell: associated with each length
%for signiture curve: longitudinal term is defaultly 1 for each length
for i=1:length(lengths)
    m_all{i}=[1];
end
%for general boundary conditions
% multiple longitudinal terms are defined
% the longitudinal terms for each length can be different
% for each length, longitudinal terms are not necessarily consecutive as shown here
% (always recommend) the recommended longitudinal terms can be defined by calling:
% [m_all]=m_recommend(prop,node,elem,lengths);
% careful here, you likely want m's around L/Lcre, L/Lcrd, L/Lcrl.. maybe be
% quite high in terms of m, and usually much less terms than brute force..
% for i=1:length(lengths)
%     m_all{i}=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
% end

%In this case we have no springs
%if any, springs should be defined in this format (kflag: 1 or 0):
%springs=[node# dof stiffness kflag
%          ...  ...    ...     ... ];
springs=0;

%In this case we have no constraint
% if any, constraint should be defined in this format:
% constraints=[node#e DOFe coeff. noder#k DOFk
%               ...   ...   ...    ...    ... ];
constraints=0;

%set the eigenmode you want to output, optional
neigs=10; %GUI default is 20


%cFSM features to utilize constrained finite strip method. We turned off here.
%Use of the cFSM variables are outside the scope of this batchcode example (at least for now)
%however, the following template for cFSM is ready to use with modification.
nnodes = length(node(:,1));
ndof_m= 4*nnodes;
GBTcon.ospace=1;GBTcon.couple=1;GBTcon.orth=2;GBTcon.norm=1; %see strip for possible solutions
[elprop,m_node,m_elem,node_prop,nmno,ncno,nsno,ndm,nlm,DOFperm]=base_properties(node,elem);
ngm=4;nom=2*(length(node(:,1))-1);
GBTcon.local=zeros(1,nlm);
GBTcon.dist=zeros(1,ndm);
GBTcon.glob=zeros(1,ngm); %can be less than 4 for special sections
GBTcon.other=zeros(1,nom);
%to turn on any cFSM classification use 1's on the GBTcon vectors defined
%above. Leave off unless you want it.
%for example say you wanted distortional only->GBTcon.dist=ones(1,ndm);


%-----------------------------------------------------------------
%---------------RUN THE ANALYSIS----------------------------------
%-----------------------------------------------------------------
%
[curve,shapes]=strip(prop,node,elem,lengths,springs,constraints,GBTcon,BC,m_all,neigs);
%

%-----------------------------------------------------------------
%---------------Modal identification------------------------------
%-----------------------------------------------------------------
% although cFSM feature is not explained in this batch code, the interface
% of how to call them is provided. I provide clas (set as 0) here for the
% later use in plot.
%
% GBTcon.norm=1;
% %norm:
% %   method=1=vector norm
% %   method=2=strain energy norm
% %   method=3=work norm
% clas=classify(prop,node,elem,lengths,shapes,GBTcon,BC,m_all);
clas=0;


%for example you could save the filename and look at the results in the GUI
save batchcufsm5results

%Hopefully it is obvious that all of the above could be put in a loop. One
%of the dimensions could be a variable and then all of the preceding steps
%could go inside a looop - in the preceding only the use of CUFSM in batch
%mode is demonstrated.

%
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%
%
%-----------------------------------------------------------------
%-------------POST PROCESSING EXAMPLES----------------------------
%-----------------------------------------------------------------
%Traditional post-processing can be done within the GUI, but perhaps in
%some circumstances it is desirable to do some post-processing here. If you
%were really doing a parameter study you would likely want to make your own
%plots and not used canned stuff from CUFSM but here I at least show how
%you would used the canned CUFSM stuff in case you would want to.
%note, the major thing is you need to understand how the results are
%stored, particularly curve and shapes.
%curve: buckling curve (load factor) for each length
%curve{l} = [ length mode#1
%             length mode#2
%             ...    ...
%             length mode#]
%for curve, inside each cell that corresponds a length, the length in matrix is the
%same
%shapes = mode shapes for each length
%shapes{l} = mode, mode is a matrix, each column corresponds to a mode.
%
%%
%Buckling halfwavelenth plot from a signature analysis
%inputs required for the general plotter from the GUI
curvecell{1}=curve; %GUI expects to get a cell...,
filenamecell{1}=['Batch CUFSM5'];
clascell{1}=clas;
filedisplay=1;
minopt=1; %show min
logopt=1; %semilogx
clasopt=0; %classification stuff off
axescurve=figure(1);
xmin=min(lengths)*10/11;
xmax=max(lengths)*11/10;
modeindex=1;
ymin=0;
    for j=1:max(size(curve));
        curve_sign(j,1)=curve{j}(modeindex,1);
        curve_sign(j,2)=curve{j}(modeindex,2);
    end
ymax=min([max(curve_sign(:,2)),3*median(curve_sign(:,2))]);
modedisplay=1;
fileindex=1;
lengthindex=20;
picpoint=[curve{lengthindex}(modeindex,1) curve{lengthindex}(modeindex,2)];
%call the plotter
thecurve3(curvecell,filenamecell,clascell,filedisplay,minopt,logopt,clasopt,axescurve,xmin,xmax,ymin,ymax,modedisplay,fileindex,modeindex,picpoint)

%%
%2D buckled shape at a selected index into lengths
%inputs required for buckled shape in 2D
undef=1; %plot undeformed
%node
%elem
mode=shapes{lengthindex}(:,modeindex);
axes2dshapelarge=figure(2);
scale=1;
%springs
m_a=1;
%BC
SurfPos=1/2;
dispshap(undef,node,elem,mode,axes2dshapelarge,scale,springs,m_a,BC,SurfPos);
title(['Length=',num2str(lengths(lengthindex)),' LF=',num2str(curve{lengthindex}(1,2))]);