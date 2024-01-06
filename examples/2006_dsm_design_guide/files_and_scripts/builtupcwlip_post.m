%BWS
%June 2005
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
%
%minimum inputs
load cwlip_Pstress
cwlip=curve;
load builtupcwlip_Pstress_warpfix
Fy=55;
b=9;
length_index_plotted=[42]
label=['Built-up C-section'];
%
%Figures
figure(1)
h1=semilogx(curve(:,1),curve(:,2),'k.-');
hold on,h2=semilogx(curve(30:52,1,2),curve(30:52,2,2),':');,hold off
hold on,h3=semilogx(curve(30:52,1,3),curve(30:52,2,3),'p-');,hold off
hold on,h4=semilogx(cwlip(:,1),cwlip(:,2),'g:');,hold off
axis([5 1000 0 40])
hold on,plot([lengths(42) lengths(42)],[0 40],'k'),hold off
%hold on,h2=semilogx(L,Spec,'b-');,hold off
%hold on,h3=semilogx(L,FSMfit,'g:');,hold off
xlabel('half-wavelength (in.)')
ylabel('f_{cr}') 
%legend([h1,h2,h3],'FSM analysis','Specification Equations','2 pt. fit to FSM')
hold on
semilogx(curve(length_index_plotted,1),curve(length_index_plotted,2),'o')
semilogx(curve(length_index_plotted,1,2),curve(length_index_plotted,2,2),'o')
semilogx(curve(length_index_plotted,1,3),curve(length_index_plotted,2,3),'o')
hold off
%embelish the plot a bit with the cross-section
scale=1;
[A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22]=grosprop(node,elem);
unsymm=0;
[Py,Mxx_y,Mzz_y,M11_y,M22_y]=yieldMP(node,Fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymm)
%flags:[node# element# mat# stress# stresspic coord constraints springs origin] 1 means show
flags=[0 0 0 0 0 0 1 1 1]; %these flags control what is plotted, node#, elem#
axesnum=axes('Units','normalized','Position',[0.15 0.6 0.2 0.2],'visible','off');
strespic(node,elem,axesnum,scale)
%crossect(node,elem,axesnum,springs,constraints,flags)
%propplot(node,elem,xcg,zcg,thetap,axesnum)
title(label)
%text(1.5,b/2,['P_y=',num2str(Py,'%4.2f'),'kips']);
%
%and with the mode shapes
scale=1;
modeindex=1;
undefv=1;
scale=1;
springs=0;
%mode 1
axesshape=axes('Units','normalized','Position',[0.44 0.13 0.20 0.20],'visible','off');
scale=1;
lengthindex=length_index_plotted(1);
dispshap(undefv,node,elem,shapes(:,lengthindex,modeindex),axesshape,scale,springs);
title('flexural (weak)')
%title(['mode 1 Local P_{cr}/P_y=',num2str(curve(lengthindex,2),'%2.2f')])
%mode2
modeindex=2;
axesshape=axes('Units','normalized','Position',[0.48 0.53 0.25 0.25],'visible','off');
scale=1;
lengthindex=length_index_plotted(1);
dispshap(undefv,node,elem,shapes(:,lengthindex,modeindex),axesshape,scale,springs);
title('torsional')
%title(['Distortional P_{cr}/P_y=',num2str(curve(lengthindex,2),'%2.2f')])
%mode 3
modeindex=3;
axesshape=axes('Units','normalized','Position',[0.69 0.55 0.3 0.3],'visible','off');
scale=1;
lengthindex=length_index_plotted(1);
dispshap(undefv,node,elem,shapes(:,lengthindex,modeindex),axesshape,scale,springs);
title('flexural (strong)')
%title(['Lateral-torsional M_{cr}/M_y=',num2str(curve(lengthindex,2),'%2.2f')])


