%fcFSM testing
%originated from batchcufsm5.m (updated Jan 6, 2024 by Ben Schafer)
	%Batch code for CUFSM 5
	%Sometimes for parameter studies or other situations it is nice to use
	%CUFSM without the GUI. This example goes through most of the basic CUFSM
	%fucntions but shows how they can be programmed in matlab.
	%v3 Ben Schafer; v4 Zhanjie Li, March 2012; v5 Ben Schafer
	%updates on 6 Jan 2024 to work with cufsm on github at that date
%Sheng Jin, 11 Feb 2024 

%clear the workspace (optional)
clear all
close all
clc

%%
%-----------------------------------------------------------------
% Input the example name going to analysis and the buckling mode index going to plot
%-----------------------------------------------------------------
%You need to provide the name of your FSM model data,that should be the name of the folder where your FSM model is stored
%Here are some examples,drag the one you want to the last line of this block, others will be ignored
nameExample='C_120X80X15X1';
nameExample='C_120X80X15X1_B.C.=S-C';
nameExample='C_120X80X15X1_Beam';
nameExample='C_120X80X15X1_m=3';
nameExample='C_120X80X15X1_CurvedConer';
nameExample='C_120X80X15X1_SpringsN5N10_K=5';
nameExample='C_120X80X15X1_SpringsN5N10_K=1e10';
nameExample='Lipped_Channel_with_Curved_Web';
nameExample='C_200X90X20X2_CurvedConer';
nameExample='CircularTube_D100X1';
nameExample='theDefaultSection';

%Please specify the index of the bucklig mode/curve to be plotted (1 for the lowest buckling; 2 and so on for higher buckling modes).
modeindex=1;

%%
%Because the current file (batchcufsm5_fcFSM.m) locates in the dirctrory "%CUFSM path%/examples",
%the paths can then be automatically set as below
[pathCufsmExamples,~,~]=fileparts(mfilename('fullpath'));%the directory of this file, also the "examples" folder of CUFSM
[pathCUFSM,~,~]=fileparts(pathCufsmExamples);%location of cufsm
%paths of CUFSM need to be added to the search path of MATLAB 
%For mac, linux, and windows
addpath([pathCUFSM]);
addpath([pathCUFSM,'/analysis']);
addpath([pathCUFSM,'/analysis/cFSM']);
addpath([pathCUFSM,'/analysis/vectorized']);   
addpath([pathCUFSM,'/analysis/fcFSM']);
addpath([pathCUFSM,'/cutwp']);
addpath([pathCUFSM,'/helpers']);
addpath([pathCUFSM,'/interface']);
addpath([pathCUFSM,'/plotters']);

%Input the model data
currentPath=pwd;
cd([pathCUFSM,'/examples/fcFSM_examples/',nameExample]);
[prop,node,elem,lengths,BC,m_all,springs,constraints,neigs,cornerStrips]=modelData(pathCUFSM);
cd(currentPath);


%cFSM features to utilize constrained finite strip method. We turned off here. This program will test fcFSM
%Use of the cFSM variables are outside the scope of this batchcode example (at least for now)
nnodes = length(node(:,1));
ndof_m= 4*nnodes;
GBTcon.ospace=1;GBTcon.couple=1;GBTcon.orth=2;GBTcon.norm=1; %see strip for possible solutions
[elprop,m_node,m_elem,node_prop,nmno,ncno,nsno,ndm,nlm,DOFperm]=base_properties(node,elem);
ngm=4;nom=2*(length(node(:,1))-1);
GBTcon.local=zeros(1,nlm);
GBTcon.dist=zeros(1,ndm);
GBTcon.glob=zeros(1,ngm); %can be less than 4 for special sections
GBTcon.other=zeros(1,nom);

%% -----------------------------------------------------------------
%---------------RUN THE ANALYSIS (including Modal decomposition and identification)----------------------------------
%-----------------------------------------------------------------
%
[curve,shapes,clas,curveL,shapesL,curveD,shapesD,curveG,shapesG]=stripmain_fcFSM(prop,node,elem,lengths,springs,constraints,GBTcon,BC,m_all,neigs,true,cornerStrips);
%%

%save the solutions that can be loaded and displayed in CUFSM GUI
currentPath=pwd;
cd([pathCUFSM,'/examples/fcFSM_examples/',nameExample]);
save('general - Idt by fcFSM.mat','prop','node','elem','lengths','BC','m_all','springs','constraints','curve','shapes','clas');
temp_fsmSolutions_cuve=curve;
temp_fsmSolutions_shapes=shapes;
curve=curveL;
shapes=shapesL;
save('L - fcFSM.mat','prop','node','elem','lengths','BC','m_all','springs','constraints','curve','shapes');
curve=curveG;
shapes=shapesG;
save('G - fcFSM.mat','prop','node','elem','lengths','BC','m_all','springs','constraints','curve','shapes');
curve=curveD;
shapes=shapesD;
save('D - fcFSM.mat','prop','node','elem','lengths','BC','m_all','springs','constraints','curve','shapes');
cd(currentPath);
curve=temp_fsmSolutions_cuve;
shapes=temp_fsmSolutions_shapes;


%%
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
%2D buckled shape at a selected index into lengths
%inputs required for buckled shape in 2D
undef=1; %plot undeformed
%node
%elem
lengthindex=20;
mode=shapes{lengthindex}(:,modeindex);
axes2dshapelarge=figure('Name',nameExample);
scale=1;
%springs
m_a=m_all{lengthindex}(1);
%BC
SurfPos=1/2;
dispshap(undef,node,elem,mode,axes2dshapelarge,scale,springs,m_a,BC,SurfPos);
title(['Length=',num2str(lengths(lengthindex)),' LF=',num2str(curve{lengthindex}(modeindex,2))]);

%%
%Buckling curves
%inputs required for the general plotter from the GUI
iCell=0;
curvecell={};
clascell={};
if size(curve{1},1)>=modeindex
	iCell=iCell+1;
	curvecell{iCell}=curve; %GUI expects to get a cell...,
	filenamecell{iCell}=['Batch CUFSM5'];
	clascell{iCell}=clas;
end
if size(curveL{1},1)>=modeindex
	iCell=iCell+1;
	curvecell{iCell}=curveL;
	filenamecell{iCell}=['L - fcFSM'];
end
if size(curveD{1},1)>=modeindex
	iCell=iCell+1;
	curvecell{iCell}=curveD;
	filenamecell{iCell}=['D - fcFSM'];
end
if size(curveG{1},1)>=modeindex
	iCell=iCell+1;
	curvecell{iCell}=curveG;
	filenamecell{iCell}=['G - fcFSM'];
end

filedisplay=1:iCell;
minopt=1; %show min
logopt=1; %semilogx
clasopt=0; %classification stuff off
axescurve=figure('Name',[nameExample, ', Mode #', num2str(modeindex)]);
xmin=min(lengths)*10/11;
xmax=max(lengths)*11/10;
ymin=0;
    for j=1:max(size(curve))
        curve_sign(j,1)=curve{j}(modeindex,1);
        curve_sign(j,2)=curve{j}(modeindex,2);
    end
ymax=min([max(curve_sign(:,2)),3*median(curve_sign(:,2))]);
modedisplay=modeindex;
fileindex=1;
lengthindex=20;
picpoint=[curve{lengthindex}(modeindex,1) curve{lengthindex}(modeindex,2)];
%call the plotter
thecurve3(curvecell,filenamecell,clascell,filedisplay,minopt,logopt,clasopt,axescurve,xmin,xmax,ymin,ymax,modedisplay,fileindex,modeindex,picpoint)

%%
%classification plot
subfig=figure;
name=['Modal Classification Participation Plot: ',nameExample,', Mode #', num2str(modeindex)];
set(subfig,'Name',name,'NumberTitle','off');
set(subfig,'position',[100 100 600 400])%
%top plot, normal halfwavelength plot
axestop=subplot(2,1,1);
xmin=min(lengths)*10/11;
xmax=max(lengths)*11/10;
ymin=0;
for j=1:max(size(curve))
	curve_sign(j,1)=curve{j}(modeindex,1);
	curve_sign(j,2)=curve{j}(modeindex,2);
end
ymax=min([max(curve_sign(:,2)),3*median(curve_sign(:,2))]);

curvecell{1}=curve; %GUI expects to get a cell...,
filenamecell{1}=['Batch CUFSM5'];
filedisplay=1;
minopt=1; %show min
logopt=1; %semilogx
clasopt=1; %classification stuff on
modedisplay=modeindex;
fileindex=1;

picpoint=[curve{lengthindex}(modeindex,1) curve{lengthindex}(modeindex,2)];
thecurve3(curvecell,filenamecell,clascell,filedisplay,minopt,logopt,clasopt,axestop,xmin,xmax,ymin,ymax,modedisplay,fileindex,modeindex,picpoint);
%bottom plot, classification breakdown plot
axesbot=subplot(2,1,2);
classifycurve(curvecell,filenamecell,clascell,filedisplay,axesbot,logopt,xmin,xmax,ymin,ymax,fileindex,modeindex)
label=['Batch fcFSM -  G, D, L strain energy portions and calculation errors (other)'];
label_title=uicontrol(subfig,...
	'Style','text','units','normalized',...
    'Position',[0.01 0.945 .98 .045],...
	'String',label);