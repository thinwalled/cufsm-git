%BWS
%May 2005
%Post-processing an analysis
%
clear all
close all
%
currentlocation=['c:\ben\cufsm\cufsm_working\cufsm3\source'];
addpath([currentlocation]);
addpath([currentlocation,'\analysis']);
addpath([currentlocation,'\analysis\GBTconstraints']);
addpath([currentlocation,'\helpers']);
addpath([currentlocation,'\interface']);
addpath([currentlocation,'\plotters']);
%
%minimum inputs
load panel_mxbot
Fy=50;
b=9;
length_index_plotted=[8 35]
label=['Panel (AISI 2002 Ex. I-14)'];
%
%Figures
figure(1)
semilogx(curve(:,1),curve(:,2),'k.-')
axis([1 100 0 1])
hold on,plot([b b],[0.8 1],'k:'),hold off
xlabel('half-wavelength (in.)')
ylabel('M_{cr} / M_y ') 
hold on
semilogx(curve(length_index_plotted,1),curve(length_index_plotted,2),'o')
hold off
%embelish the plot a bit with the cross-section
scale=1;
[A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22]=grosprop(node,elem);
unsymm=0;
[Py,Mxx_y,Mzz_y,M11_y,M22_y]=yieldMP(node,Fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymm)
%flags:[node# element# mat# stress# stresspic coord constraints springs origin] 1 means show
flags=[0 0 0 0 0 0 1 1 1]; %these flags control what is plotted, node#, elem#
axesnum=axes('Units','normalized','Position',[0.14 0.65 0.5 0.25],'visible','off');
strespic(node,elem,axesnum,scale)
%crossect(node,elem,axesnum,springs,constraints,flags)
%propplot(node,elem,xcg,zcg,thetap,axesnum)
title(label)
text(1,b/2,['M_y=',num2str(Mxx_y,'%4.2f'),'kip-in.']);
%
%and with the mode shapes
scale=1;
modeindex=1;
undefv=1;
scale=1;
springs=0;
%local
axesshape=axes('Units','normalized','Position',[0.14 0.22 0.5 0.25],'visible','off');
scale=-0.5;
lengthindex=length_index_plotted(1);
dispshap(undefv,node,elem,shapes(:,lengthindex,modeindex),axesshape,scale,springs);
title(['Local M_{cr}/M_y=',num2str(curve(lengthindex,2),'%2.2f')])
%distortional
axesshape=axes('Units','normalized','Position',[0.39 0.08 0.5 0.25],'visible','off');
scale=0.5;
lengthindex=length_index_plotted(2);
dispshap(undefv,node,elem,shapes(:,lengthindex,modeindex),axesshape,scale,springs);
title(['Distortional M_{cr}/M_y=',num2str(curve(lengthindex,2),'%2.2f')])
%LTB
% axesshape=axes('Units','normalized','Position',[0.68 0.2 0.25 0.25],'visible','off');
% scale=-1;
% lengthindex=length_index_plotted(3);
% dispshap(undefv,node,elem,shapes(:,lengthindex,modeindex),axesshape,scale,springs);
% title('Lateral-torsional')
%title(['Lateral-torsional M_{cr}/M_y=',num2str(curve(lengthindex,2),'%2.2f')])


