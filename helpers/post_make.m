%BWS
%19 October 2001
%a tool for making summary plots of finite strip analyses
%
clear all
close all
%
%
filename=['defaultC.mat'];
%
%
eval(['load ',filename])
%
%BEGIN BY PLOTTING THE BUCKLING CURVE
fig=figure(1);
set(fig,'Units','inches')
set(fig,'position',[1.0 1.0 6.00 4.00])%
axescurve=axes('Units','normalized','Position',[0.1 0.15 0.8 0.75],'Box','on','XTickLabel','','YTickLabel','');
xmin=0;
ymin=0;
xmax=max(curve(:,1));
ymax=max(curve(:,2));
minopt=1;
logopt=1;
maxmode=1;
lengthindex=1;
modeindex=1;
picpoint=[lengths(lengthindex) curve(lengthindex,2,modeindex)]; 
thecurve(curve,minopt,logopt,axescurve,xmin,xmax,ymin,ymax,maxmode,picpoint)
xlabel('half-wavelength (in.)')
ylabel('M_{cr}/M_y')
title('Buckling results')
%
%NOW PLOT A MODE SHAPE
select_length=5;
position=[0.1 0.1 0.2 0.2]; %normalized units left,bottom,width,height
%
modeindex=1;
lengthindex=lengths==select_length;
undef=1;
scalem=1;
mode=shapes(:,lengthindex,modeindex);
axesnum=axes('Units','normalized','Position',position,'visible','off');
dispshap(undef,node,elem,mode,axesnum,scalem,springs)
