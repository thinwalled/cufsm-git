function []=dispshap_absolutescale(undef,node,elem,mode,axesnum,scalem,springs,sizeis)
%BWS
%August 2000 (last modified)
%April 2004 - changed to patch to allow solid plots
%
%node: [node# x z dofx dofz dofy dofrot stress] nnodes x 8;
%elem: [elem# nodei nodej t] nelems x 4;
%mode: vector of displacements global dof [u1 v1...un vn w1 01...wn 0n]'
%
%in order to use this routine completely on its own you can type the following
%figure(1)
%dispshap(1,node,elem,shapes(:,22),gca,1,0)
%this will display the undeformed shape and plot the displaced shape
%of the 22nd mode at a scale of 1. You can look at "curve" to determine
%which mode you want to plot.
%
axes(axesnum)
cla
%
%
%Determine a scaling factor for the displaced shape
dispmax=(max(abs(mode(:,:))));
membersize=max(max(node(:,2:3)))-min(min(node(:,2:3)));
scale=scalem;%*1/5*membersize/dispmax;
%save temp
%
%if undef==1
%   plot(node(:,2),-node(:,3),'b.')
%   axis('equal')
%   axis('off')
%   hold on
%end
%
%
%Generate and plot
nnodes=length(node(:,1));
if undef==1
for i=1:length(elem(:,1))
	%Get element geometry
	nodei = elem(i,2);	nodej = elem(i,3);
	   xi = node(nodei,2);	   xj = node(nodej,2);
	   zi = node(nodei,3);	   zj = node(nodej,3);
    %Plot the undeformed geometry
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
       plot([xi xj],[zi zj],'b.');
end
end
for i=1:length(elem(:,1))
	%Get element geometry
	nodei = elem(i,2);	nodej = elem(i,3);
	   xi = node(nodei,2);	   xj = node(nodej,2);
	   zi = node(nodei,3);	   zj = node(nodej,3);
	%Determine the global element displacements
		%dbar is the nodal displacements for the element in global
		%coordinates. dbar=(u1 v1 u2 v2 w1 o1 w2 o2)';
		dbar(1:2,1)=mode(2*nodei-1:2*nodei);
		dbar(3:4,1)=mode(2*nodej-1:2*nodej);
		dbar(5:6,1)=mode(2*nnodes+2*nodei-1:2*nnodes+2*nodei);
		dbar(7:8,1)=mode(2*nnodes+2*nodej-1:2*nnodes+2*nodej);
	%transform the dbar to local coordinates d
		phi=atan2(-(zj-zi),(xj-xi));
		d=gammait(phi,dbar);
	%Determine the additional displacements in each element
		links=10; %number of additional line segments to define the disp shape
		b=sqrt((xj-xi)^2+(zj-zi)^2);
		dl=shapef(links,d,b);
	%transform the additional displacements into global coordinates
		dlbar=gammait2(phi,dl);
	%Create a vector of undisplaced coordinates "undisp"
		undisp=zeros(2,links+1);
		undisp(:,1)=[xi zi]';
		undisp(:,links+1)=[xj zj]';
		for j=2:links
			undisp(:,j)=[xi+(xj-xi)*(j-1)/links zi+(zj-zi)*(j-1)/links]';
		end
	%Create a vector of displaced coordinates "disp"
		disp=zeros(2,links+1);
		disp(:,1)=[xi+scale*dbar(1) zi+scale*dbar(5)]';
		disp(:,links+1)=[xj+scale*dbar(3) zj+scale*dbar(7)]';
		disp(1,2:links)=undisp(1,2:links)+scale*dlbar(1,:); 
		disp(2,2:links)=undisp(2,2:links)+scale*dlbar(3,:);
    %The angle of each link
        thetalinks=atan2(disp(2,2:links+1)-disp(2,1:links),disp(1,2:links+1)-disp(1,1:links));
        thetalinks=[thetalinks thetalinks(links)];
    %Plot the undeformed geometry
       theta = atan2((zj-zi),(xj-xi));
       t=elem(i,4);
%       if undef==1
%        %plot([xi xj],[zi zj],'k:')
%        %plot( ([xi xj]+[-1 -1]*sin(theta)*t/2),[zi zj]+[1 1]*cos(theta)*t/2 , 'k')
%        %hold on
%        %plot( ([xi xj]+[1 1]*sin(theta)*t/2),[zi zj]+[-1 -1]*cos(theta)*t/2 , 'k')
%        %plot( ([xi xi]+[-1 1]*sin(theta)*t/2),[zi zi]+[1 -1]*cos(theta)*t/2 , 'k')
%        %plot( ([xj xj]+[-1 1]*sin(theta)*t/2),[zj zj]+[1 -1]*cos(theta)*t/2 , 'k')
%        xpatch=[
%         ([xi xj]+[-1 -1]*sin(theta)*t/2)',
%         ([xj xi]+[1 1]*sin(theta)*t/2)'];%,
%         %([xi xi]+[-1 1]*sin(theta)*t/2)',
%         %([xj xj]+[-1 1]*sin(theta)*t/2)'];
%        zpatch=[
%         ([zi zj]+[1 1]*cos(theta)*t/2)',
%         ([zj zi]+[-1 -1]*cos(theta)*t/2)'];%,
%         %([zi zi]+[1 -1]*cos(theta)*t/2)',
%         %([zj zj]+[1 -1]*cos(theta)*t/2)'];
%        patch(xpatch,zpatch,'w')
%        %plot([xi xj],[zi zj],'k')
%       end
   %Now the deformed geometry with the appropriate thickness shown
	  dispout=[disp(1,:)+sin(thetalinks)*t/2 ; disp(2,:)-cos(thetalinks)*t/2];
      dispin= [disp(1,:)-sin(thetalinks)*t/2 ; disp(2,:)+cos(thetalinks)*t/2];
      %plot(dispout(1,:),dispout(2,:),'r');
      %hold on
      %plot(dispin(1,:),dispin(2,:),'r');
      %plot([dispout(1,1) dispin(1,1)],[dispout(2,1) dispin(2,1)],'r')
      %plot([dispout(1,links+1) dispin(1,links+1)],[dispout(2,links+1) dispin(2,links+1)],'r')
      xpatch=[
      (dispout(1,:))',
      (dispin(1,length(dispin):-1:1))'];%,
      %([dispout(1,1) dispin(1,1)])',
      %([dispout(1,links+1) dispin(1,links+1)])'];
      zpatch=[
      (dispout(2,:))',
      (dispin(2,length(dispin):-1:1))'];%,
      %([dispout(2,1) dispin(2,1)])',
      %([dispout(2,links+1) dispin(2,links+1)])'];
      patch(xpatch,zpatch,'r');
      %plot(disp(1,:)-ones(1,links+1)*sin(theta)*t/2 , disp(2,:)+ones(1,links+1)*cos(theta)*t/2,'r','linewidth',1);
      %plot(disp(1,:),disp(2,:),'r','linewidth',1);
  	  %
      hold on
      plot([xi+scale*dbar(1) xj+scale*dbar(3)],[zi+scale*dbar(5) zj+scale*dbar(7)],'b.');
      axis equal
      axis off
      %hold on
end
if undef==1
for i=1:size(node,1)
	dofx=node(i,4);
	dofz=node(i,5);
	dofy=node(i,6);
	dofq=node(i,7);
	if min([dofx dofz dofy dofq])==0
		plot(node(i,2),node(i,3),'sg')
	end
end
end
if undef==1
	if ~isempty(springs)
	for i=1:size(springs,1)
		if springs==0
		else
		   xi = node(find(node(:,1)==springs(i,1)),2);
		   zi = node(find(node(:,1)==springs(i,1)),3);
			plot(xi,zi,'pg')
		end
	end
	end
end
hold off
%
%Use a rigid axis which only allows for "p" pad around original section
% p=0.30;
% xmax=max(node(:,2));
% xmin=min(node(:,2));
% xL=xmax-xmin;
% zmax=max(node(:,3));
% zmin=min(node(:,3));
% zL=zmax-zmin;
% axis([xmin-xL*p xmax+xL*p zmin-zL*p zmax+zL*p]);
%
axis([sizeis]);