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
load hat_P
Fy=50;
b=4.5;
length_index_plotted=[13 25 29]
label=['Hat section (AISI 2002 Ex. I-13)'];
%
%Figures
figure(1)
semilogx(curve(:,1),curve(:,2),'k.-')
hold on,semilogx(curve(:,1,2),curve(:,2,2),'k.:')
axis([1 1000 0 3.5])
hold on,plot([b b],[2.5 3.0],'k:'),hold off
xlabel('half-wavelength (in.)')
ylabel('P_{cr} / P_y ') 
hold on
semilogx(curve(length_index_plotted(1),1),curve(length_index_plotted(1),2),'o')
semilogx(curve(length_index_plotted(2),1,2),curve(length_index_plotted(2),2,2),'o')
semilogx(curve(length_index_plotted(3),1,2),curve(length_index_plotted(3),2,2),'o')
hold off
%embelish the plot a bit with the cross-section
scale=1;
[A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22]=grosprop(node,elem);
unsymm=0;
[Py,Mxx_y,Mzz_y,M11_y,M22_y]=yieldMP(node,Fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymm)
%flags:[node# element# mat# stress# stresspic coord constraints springs origin] 1 means show
flags=[0 0 0 0 0 0 1 1 1]; %these flags control what is plotted, node#, elem#
axesnum=axes('Units','normalized','Position',[0.6 0.6 0.25 0.25],'visible','off');
strespic(node,elem,axesnum,scale)
%crossect(node,elem,axesnum,springs,constraints,flags)
%propplot(node,elem,xcg,zcg,thetap,axesnum)
title(label)
text(b/2,1.5,['P_y=',num2str(Py,'%4.2f'),'kips']);
%
%and with the mode shapes
scale=1;
modeindex=1;
undefv=1;
scale=1;
springs=0;
%local
axesshape=axes('Units','normalized','Position',[0.15 0.4 0.2 0.2],'visible','off');
scale=1;
lengthindex=length_index_plotted(1);
dispshap(undefv,node,elem,shapes(:,lengthindex,modeindex),axesshape,scale,springs);
title(['Local P_{cr}/P_y=',num2str(curve(lengthindex,2),'%2.2f')])
%Distortional deom mode 2
modeindex=2;
axesshape=axes('Units','normalized','Position',[0.3 0.1 0.2 0.2],'visible','off');
scale=1;
lengthindex=length_index_plotted(2);
dispshap(undefv,node,elem,shapes(:,lengthindex,modeindex),axesshape,scale,springs);
title(['Flexural-torsional'])
title(['Distortional P_{cr}/P_y=',num2str(curve(lengthindex,2,2),'%2.2f')])
%Flexural (mode 2)
modeindex=2;
axesshape=axes('Units','normalized','Position',[0.7 0.15 0.2 0.2],'visible','off');
scale=1;
lengthindex=length_index_plotted(3);
dispshap(undefv,node,elem,shapes(:,lengthindex,modeindex),axesshape,scale,springs);
title('Flexural')
%title(['Lateral-torsional M_{cr}/M_y=',num2str(curve(lengthindex,2),'%2.2f')])


