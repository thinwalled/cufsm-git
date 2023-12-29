function []=strespic(node,elem,axesnum,scale)
%BWS
%1998
%node: [node# x z dofx dofz dofy dofrot stress] nnodes x 8;
%elem: [elem# nodei nodej t] nelems x 4;
axes(axesnum)
cla
%
maxstress=max(abs(node(:,8)));
stress=[node(:,1) node(:,8)/maxstress];
maxoffset=scale*1/10*max(max(abs(node(:,2:3))));
for i=1:length(stress(:,1))
   stresscoord(i,1:3)=[node(i,1) node(i,2)+maxoffset*stress(i,2)...
         node(i,3)-maxoffset*stress(i,2)];
end
%
%
%
axis('equal')
axis('off')
%title('Stress Distribution')
hold on
for i=1:length(elem(:,1))
   nodei = elem(i,2);
   nodej = elem(i,3);
   xi = node(find(node(:,1)==nodei),2);
   zi = node(find(node(:,1)==nodei),3);
   xj = node(find(node(:,1)==nodej),2);
   zj = node(find(node(:,1)==nodej),3);
   %snodei = elem(i,2);
   %snodej = elem(i,3);
   sxi = stresscoord(find(node(:,1)==nodei),2);
   szi = stresscoord(find(node(:,1)==nodei),3);
   sxj = stresscoord(find(node(:,1)==nodej),2);
   szj = stresscoord(find(node(:,1)==nodej),3);
   %Plot the undeformed geometry with the proper element thickness
   theta = atan2((zj-zi),(xj-xi));
   t=elem(i,4);
       xpatch=[
        ([xi xj]+[-1 -1]*sin(theta)*t/2)',
        ([xj xi]+[1 1]*sin(theta)*t/2)'];%,
       zpatch=[
        ([zi zj]+[1 1]*cos(theta)*t/2)',
        ([zj zi]+[-1 -1]*cos(theta)*t/2)'];%,
       patch(xpatch,zpatch,'y')
       hold on
       %plot([xi xj],[zi zj],'b.');
   %plot( ([xi xj]+[-1 -1]*sin(theta)*t/2),[zi zj]+[1 1]*cos(theta)*t/2 , 'k')
   %plot( ([xi xj]+[1 1]*sin(theta)*t/2),[zi zj]+[-1 -1]*cos(theta)*t/2 , 'k')
   %plot( ([xi xi]+[-1 1]*sin(theta)*t/2),[zi zi]+[1 -1]*cos(theta)*t/2 , 'k')
   %plot( ([xj xj]+[-1 1]*sin(theta)*t/2),[zj zj]+[1 -1]*cos(theta)*t/2 , 'k')
   %Plot the stress distribution
   if node(nodei,8)>=0
       plot([xi sxi],[zi szi],'r')
   else
       plot([xi sxi],[zi szi],'b')
   end
   if node(nodej,8)>=0
       plot([xj sxj],[zj szj],'r')
   else
       plot([xj sxj],[zj szj],'b')
   end
   plot([sxi sxj],[szi szj],'k')
end
%plot nodes
for i=1:length(node(:,1))
   if node(i,8)>=0
      plot(node(i,2),node(i,3),'r.','markersize',12)
      hold on
   else
      plot(node(i,2),node(i,3),'b.','markersize',12)
      hold on
   end
end

hold off
