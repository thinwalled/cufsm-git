function []=strainEpic(prop,node,elem,axesnum,scale,mode,L,BC,m_a)
%BWS
%January 2004, modificiations of stress plot for strain energy plot
%
%Recover the strain energy
[se]=energy_density_recovery(prop,node,elem,mode,L,BC,m_a);
%se = [sem seb] m=membrane SE, b=bending SE
%
axes(axesnum)
cla
%
axis('equal')
axis('off')
%
maxse=max(max(abs(se)));
sescale=.1*(max(max(node(:,2:3))))/maxse*scale;
%
hold on
for i=1:length(elem(:,1))
   nodei = elem(i,2);
   nodej = elem(i,3);
   xi = node(find(node(:,1)==nodei),2);
   zi = node(find(node(:,1)==nodei),3);
   xj = node(find(node(:,1)==nodej),2);
   zj = node(find(node(:,1)==nodej),3);
   %Plot the undeformed geometry with the proper element thickness
   theta = atan2((zj-zi),(xj-xi));
   t=elem(i,4);
   plot( ([xi xj]+[-1 -1]*sin(theta)*t/2),[zi zj]+[1 1]*cos(theta)*t/2 , 'k')
   plot( ([xi xj]+[1 1]*sin(theta)*t/2),[zi zj]+[-1 -1]*cos(theta)*t/2 , 'k')
   plot( ([xi xi]+[-1 1]*sin(theta)*t/2),[zi zi]+[1 -1]*cos(theta)*t/2 , 'k')
   plot( ([xj xj]+[-1 1]*sin(theta)*t/2),[zj zj]+[1 -1]*cos(theta)*t/2 , 'k')
   %Plot the strain energy
   %element membrane strain energy
   sm=sescale*sum(se(i,1)); 
   %vertices for element by element plotting
   xv=[[xi xj]+[-1 -1]*sin(theta)*sm/2 [xj xi]+[1 1]*sin(theta)*sm/2];
   zv=[[zi zj]+[-1 -1]*cos(theta)*sm/2 [zj zi]+[1 1]*cos(theta)*sm/2];
   yv=[0 0 0 0];
   %element total strain energy 
   stot=sescale*sum(se(i,:)); %element total strain energy
   xv2=xv+[[-1 -1]*sin(theta)*stot/2 [1 1]*sin(theta)*stot/2];
   zv2=zv+[[-1 -1]*cos(theta)*stot/2 [1 1]*cos(theta)*stot/2];
   %total (bending actually as membrane goes over the top) 
   h1=patch(xv2,zv2,yv,[0 1 0]);
   %membrane
   h2=patch(xv,zv,yv,[1 1 1]);
end
   %legend
   legend([h1 h2],'SE_{bending}','SE_{membrane}')
