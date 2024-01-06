%BWS
%5 August 2004
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
load Cwlip_P_pinned_corners
pinned_curve=curve;
load Cwlip_P
Fy=55;
b=9;
length_index_plotted=[38 43 47]
label=['C-section with lip'];
%
%Figures
figure(1)
plot(curve(:,1),curve(:,2),'k.-')
axis([6 60 0 0.4])
hold on,plot(pinned_curve(:,1),pinned_curve(:,2),':')
%hold on,plot([b b],[0.1 0.2],'k:'),hold off
hold on,plot([28.52 28.52],[0.2 0.3],'k:'),hold off
text(29,0.3,['L_{crd} by manual solutions'])
hold on,plot([24.8 24.8],[0.2 0.35],'k:'),hold off
text(25,0.35,['L_{crd} for beam by FSM'])
xlabel('half-wavelength (in.)')
ylabel('P_{cr} / P_y ') 
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
axesnum=axes('Units','normalized','Position',[0.68 0.6 0.2 0.2],'visible','off');
strespic(node,elem,axesnum,scale)
%crossect(node,elem,axesnum,springs,constraints,flags)
%propplot(node,elem,xcg,zcg,thetap,axesnum)
title(label)
text(1.5,b/2,['P_y=',num2str(Py,'%4.1f'),'kips']);
%
%and with the mode shapes
scale=1;
modeindex=1;
undefv=1;
scale=1;
springs=0;
%
%first plotted mode
axesshape=axes('Units','normalized','Position',[0.2 0.13 0.25 0.35],'visible','off');
scale=2;
lengthindex=length_index_plotted(1);
dispshap(undefv,node,elem,shapes(:,lengthindex,modeindex),axesshape,scale,springs);
%title(['L=',num2str(curve(lengthindex,1),'%2.1f'),' P_{cr}/P_y=',num2str(curve(lengthindex,2),'%2.2f')])
%second plotted mode
axesshape=axes('Units','normalized','Position',[0.4 0.13 0.25 0.35],'visible','off');
scale=-2;
lengthindex=length_index_plotted(2);
dispshap(undefv,node,elem,shapes(:,lengthindex,modeindex),axesshape,scale,springs);
%title(['Distortional P_{cr}/P_y=',num2str(curve(lengthindex,2),'%2.2f')])
%title(['L=',num2str(curve(lengthindex,1),'%2.1f'),' P_{cr}/P_y=',num2str(curve(lengthindex,2),'%2.2f')])
%third plotted mode
axesshape=axes('Units','normalized','Position',[0.6 0.13 0.25 0.35],'visible','off');
scale=-2;
lengthindex=length_index_plotted(3);
dispshap(undefv,node,elem,shapes(:,lengthindex,modeindex),axesshape,scale,springs);
%title(['L=',num2str(curve(lengthindex,1),'%2.1f'),' P_{cr}/P_y=',num2str(curve(lengthindex,2),'%2.2f')])
%title('Flexural')
%title(['Lateral-torsional M_{cr}/M_y=',num2str(curve(lengthindex,2),'%2.2f')])


