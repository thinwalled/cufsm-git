function []=strainpic(node,elem,axesnum,scale,mode)
%BWS
%1998 modified to plot longitudinal displacements in 2003
%node: [node# x z dofx dofz dofy dofrot stress] nnodes x 8;
%elem: [elem# nodei nodej t] nelems x 4;
%mode: vector of displacements global dof [u1 v1...un vn w1 01...wn 0n]'
%
%v (axial) displacements
disp=mode(2:2:length(node(:,1))*2);
%
axes(axesnum)
cla
%
maxdisp=max(abs(disp));
%whos node disp maxdisp
dispnorm=[node(:,1) disp/maxdisp];
maxoffset=scale*1/10*max(max(abs(node(:,2:3))));
for i=1:length(dispnorm(:,1))
   dispcoord(i,1:3)=[node(i,1) node(i,2)+maxoffset*dispnorm(i,2)...
         node(i,3)-maxoffset*dispnorm(i,2)];
end
%
%
%
for i=1:length(node(:,1))
   if dispnorm(i,2)>=0
      plot(node(i,2),node(i,3),'r.','markersize',12)
      hold on
   else
      plot(node(i,2),node(i,3),'b.','markersize',12)
      hold on
   end
end
axis('equal')
axis('off')
%title('Strain Distribution')
hold on
for i=1:length(elem(:,1))
   nodei = elem(i,2);
   nodej = elem(i,3);
   xi = node(find(node(:,1)==nodei),2);
   zi = node(find(node(:,1)==nodei),3);
   xj = node(find(node(:,1)==nodej),2);
   zj = node(find(node(:,1)==nodej),3);
%   snodei = elem(i,2);
%   snodej = elem(i,3);
   sxi = dispcoord(find(node(:,1)==nodei),2);
   szi = dispcoord(find(node(:,1)==nodei),3);
   sxj = dispcoord(find(node(:,1)==nodej),2);
   szj = dispcoord(find(node(:,1)==nodej),3);
%    plot([xi xj],[zi zj],'k',[sxi sxj],[szi szj],'r',...
%       [xi sxi],[zi szi],'r',[xj sxj],[zj szj],'r')
   %Plot the undeformed geometry with the proper element thickness
   theta = atan2((zj-zi),(xj-xi));
   t=elem(i,4);
   plot( ([xi xj]+[-1 -1]*sin(theta)*t/2),[zi zj]+[1 1]*cos(theta)*t/2 , 'k')
   plot( ([xi xj]+[1 1]*sin(theta)*t/2),[zi zj]+[-1 -1]*cos(theta)*t/2 , 'k')
   plot( ([xi xi]+[-1 1]*sin(theta)*t/2),[zi zi]+[1 -1]*cos(theta)*t/2 , 'k')
   plot( ([xj xj]+[-1 1]*sin(theta)*t/2),[zj zj]+[1 -1]*cos(theta)*t/2 , 'k')
   %Plot the strain distribution
   if dispnorm(i,2)>=0
       plot([xi sxi],[zi szi],'r')
   else
       plot([xi sxi],[zi szi],'b')
   end
   if dispnorm(i,2)>=0
       plot([xj sxj],[zj szj],'r')
   else
       plot([xj sxj],[zj szj],'b')
   end
   plot([sxi sxj],[szi szj],'k')
end
hold off
