function []=propplot(node,elem,xcg,zcg,thetap,axesnum)
%BWS
%October 2001 (last modified)
%
axes(axesnum)
cla
%
%
%
%
%plot the nodes
plot(node(:,2),node(:,3),'b.')
axis('equal')
axis('off')
hold on
%
%plot the elements
for i=1:length(elem(:,1))
   %Get element geometry
	nodei = elem(i,2);	nodej = elem(i,3);
	   xi = node(nodei,2);	   xj = node(nodej,2);
	   zi = node(nodei,3);	   zj = node(nodej,3);
       theta = atan2((zj-zi),(xj-xi));
       t=elem(i,4);
       %plot the cross-section with appropriate thickness shown
       xpatch=[
        ([xi xj]+[-1 -1]*sin(theta)*t/2)',
        ([xj xi]+[1 1]*sin(theta)*t/2)'];%,
       zpatch=[
        ([zi zj]+[1 1]*cos(theta)*t/2)',
        ([zj zi]+[-1 -1]*cos(theta)*t/2)'];%,
       patch(xpatch,zpatch,'y')
       hold on
       plot([xi xj],[zi zj],'b.');
       %plot( ([xi xj]+[-1 -1]*sin(theta)*t/2),[zi zj]+[1 1]*cos(theta)*t/2 , 'k')
       %plot( ([xi xj]+[1 1]*sin(theta)*t/2),[zi zj]+[-1 -1]*cos(theta)*t/2 , 'k')
       %plot( ([xi xi]+[-1 1]*sin(theta)*t/2),[zi zi]+[1 -1]*cos(theta)*t/2 , 'k')
       %plot( ([xj xj]+[-1 1]*sin(theta)*t/2),[zj zj]+[1 -1]*cos(theta)*t/2 , 'k')
end
%
%plot the origin
plot(0,0,'w.')
text(0,0,' O')
plot([0 min(1/4*max(node(:,3)),1/4*max(node(:,2)))],[0 0],'w:')
plot([0 0],[0 min(1/4*max(node(:,3)),1/4*max(node(:,2)))],'w:')
%plot the centroid
plot(xcg,zcg,'g.')
text(xcg,zcg,' C')
%
%Plot the Global XX and ZZ Axes
XX=[min(node(:,2))-0.1*(max(node(:,2))-min(node(:,2))) , zcg
    max(node(:,2))+0.1*(max(node(:,2))-min(node(:,2))) , zcg];
ZZ=[xcg , min(node(:,3)-0.1*(max(node(:,3))-min(node(:,3))))
    xcg , max(node(:,3)+0.1*(max(node(:,3))-min(node(:,3))))];
plot(XX(:,1),XX(:,2),'g:')
plot(ZZ(:,1),ZZ(:,2),'g:')
text(XX(1,1),XX(1,2),'x')
text(XX(2,1),XX(2,2),'x')
text(ZZ(1,1),ZZ(1,2),'z')
text(ZZ(2,1),ZZ(2,2),'z')
%
%Plot the principal axis
%make the centroid 0,0 temporarily
XX_11=XX-[xcg zcg ; xcg zcg];
ZZ_22=ZZ-[xcg zcg ; xcg zcg];
%find the minimum arm length
arm=0.75*min(abs([XX_11(1,1);XX_11(2,1);ZZ_22(1,2);ZZ_22(2,2)]));
%set the lengths to the minimum length
XX_11=[-arm 0 ; arm 0];
ZZ_22=[0 -arm ; 0 arm];
%rotate
dx=arm-arm*cos(thetap*pi/180);
dz=arm*sin(thetap*pi/180);
XX_11=XX_11+[ dx -dz ; -dx  dz ];
ZZ_22=ZZ_22+[ dz  dx ; -dz -dx ];
%center at cg
XX_11=XX_11+[xcg zcg ; xcg zcg];
ZZ_22=ZZ_22+[xcg zcg ; xcg zcg];
%plot
plot(XX_11(:,1),XX_11(:,2),'r:')
plot(ZZ_22(:,1),ZZ_22(:,2),'r:')
text(XX_11(1,1),XX_11(1,2),'1')
text(XX_11(2,1),XX_11(2,2),'1')
text(ZZ_22(1,1),ZZ_22(1,2),'2')
text(ZZ_22(2,1),ZZ_22(2,2),'2')
hold off