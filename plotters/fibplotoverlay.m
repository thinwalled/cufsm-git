function [ ] = fibplotoverlay(node,elem,nfiber,fib)
%
%BWS March 2016
%plotter provides an overlay on top of crosssect with fiber locations

%Plot the elements
for i=1:length(elem(:,1))
    nf=nfiber(i);
	nodei = elem(i,2);
    nodej = elem(i,3);
	   xi = node(find(node(:,1)==nodei),2);
	   zi = node(find(node(:,1)==nodei),3);
	   xj = node(find(node(:,1)==nodej),2);
	   zj = node(find(node(:,1)==nodej),3);
    theta = atan2((zj-zi),(xj-xi));
    t=elem(i,4);
    for j=1:nf
       xpatch=[
        ([xi xj]+[-1 -1]*sin(theta)*t/2 + 2*(j-1)/nf*[1 1]*sin(theta)*t/2)',
        ([xj xi]+[-1 -1]*sin(theta)*t/2 + 2*(j)/nf*[1 1]*sin(theta)*t/2)'];%,
       zpatch=[
        ([zi zj]+[1 1]*cos(theta)*t/2 + 2*(j-1)/nf*[-1 -1]*cos(theta)*t/2)',
        ([zj zi]+[1 1]*cos(theta)*t/2 + 2*(j)/nf*[-1 -1]*cos(theta)*t/2)'];%,
       patch(xpatch,zpatch,'c','FaceAlpha',0.2)
       hold on
    end
end




hold on

plot (fib(:,2),fib(:,3),'k.');

hold off

end

