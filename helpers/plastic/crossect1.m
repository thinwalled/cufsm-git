function []=crossect1(node,elem,axesnum,springs,constraints,flags)
%BWS
%October 2001 (last modified)
%plots the cross-section
%
%node: [node# x z dofx dofz dofy dofrot stress] nnodes x 8;
%elem: [elem# nodei nodej t mat#] nelems x 4;
%flags:[node# element# mat# stress# stresspic coord constraints springs origin] 1 means show
nodeflag=flags(1);
elemflag=flags(2);
matflag=flags(3);
stressflag=flags(4);
stresspicflag=flags(5);
coordflag=flags(6); 
constraintsflag=flags(7);
springsflag=flags(8);
originflag=flags(9);
%
%
% axes(axesnum)
cla
%
%Plot the nodes
plot(node(:,2),node(:,3),'b.')
hold on
axis('equal')
axis('off')
%
%
%Plot the elements
for i=1:length(elem(:,1))
	nodei = elem(i,2);
    nodej = elem(i,3);
	   xi = node(find(node(:,1)==nodei),2);
	   zi = node(find(node(:,1)==nodei),3);
	   xj = node(find(node(:,1)==nodej),2);
	   zj = node(find(node(:,1)==nodej),3);
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
    %plot( ([xi xj]+[-1 -1]*sin(theta)*t/2),[zi zj]+[1 1]*cos(theta)*t/2 , 'k')
    %plot( ([xi xj]+[1 1]*sin(theta)*t/2),[zi zj]+[-1 -1]*cos(theta)*t/2 , 'k')
    %plot( ([xi xi]+[-1 1]*sin(theta)*t/2),[zi zi]+[1 -1]*cos(theta)*t/2 , 'k')
    %plot( ([xj xj]+[-1 1]*sin(theta)*t/2),[zj zj]+[1 -1]*cos(theta)*t/2 , 'k')
    %plot the element labels if wanted
    if elemflag==1
        thndl=text((xi+xj)/2,(zi+zj)/2,num2str(elem(i,1)));
    end
    %plot the material labels if wanted
    if matflag==1
        thndl=text((xi+xj)/2,(zi+zj)/2,num2str(elem(i,5)));
    end
end
%
%Plot the node labels if wanted
if nodeflag==1
    thndl=text(node(:,2),node(:,3),num2str(node(:,1)));
end
%
%Plot the stress at the nodes if wanted
if stressflag==1
    thndl=text(node(:,2),node(:,3),num2str(node(:,8)));
end
%
%Plot the origin point, if wanted
if originflag==1
    plot(0,0,'g.')
end
%
%Plot the boundary condition and equation constraints, if wanted
if constraintsflag==1
    for i=1:size(node,1)
	    dofx=node(i,4);
    	dofz=node(i,5);
    	dofy=node(i,6);
    	dofq=node(i,7);
    	if min([dofx dofz dofy dofq])==0
    		plot(node(i,2),node(i,3),'sg')
    	end
    end
    if constraints==0
    else
        for i=1:size(constraints(:,1))
            nodee=constraints(i,1); %eliminated node
            nodek=constraints(i,4); %kept node
            plot(node(nodee,2),node(nodee,3),'xg')
            plot(node(nodek,2),node(nodek,3),'hg')
        end
    end
end
%
%Plot the springs, if wanted
springscale=0.05*max(max(abs(node(:,2:3)))); % x% of the largest dimension
springpic=[0 0
    4.5 0
    5 -4
    6 4
    7 -4
    8 4
    8.5 0
    12 0
    12 4
    12 -4]; %picture of an x direction oriented spring
springpic=springpic/max(max(abs(springpic)))*springscale;
%
%rotational spring picture
theta=(0:pi/20:8*pi);
r=theta/(8*pi);
[x,y]=pol2cart(theta,r);
gx=[1 2 2 2];
gy=[0 0 1 -1];
x=[x gx];
y=[y gy];
rotspringpic=[x' y'];
% rotspringpic=[-5 0
%     0 0 
%     .5 2.5
%     2 4
%     4.1 5.1
%     7 6
%     9.5 5.5
%     11.75 3.75
%     12.5 2
%     14 0
%     13.5 -2.5
%     13 -4.5
%     10 -5.5
%     7 -6
%     4.5 -5.5
%     2.5 -4.5
%     1.9 -1
%     2 1
%     3 2.5
%     5 3.9
%     7 4.1
%     9.5 3.5
%     10.5 1.5
%     11 -1
%     10 -3
%     7 -3.5
%     5.5 -3
%     5 -1.2
%     5.5 1
%     6 2
%     8 1.5
%     8.5 0
%     18 0
%     18 -5
%     18 5];
rotspringpic=rotspringpic/max(max(abs(rotspringpic)))*springscale;
%
if springsflag==1
    if ~isempty(springs)
    for i=1:size(springs,1)
    	if springs==0
    	else
    	    dof = springs(i,2);
            xi = node(find(node(:,1)==springs(i,1)),2);
    	    zi = node(find(node(:,1)==springs(i,1)),3);
            if dof==1 %x direction spring (left-right)
                plot(xi+springpic(:,1),zi+springpic(:,2),'r')
            elseif dof==2 %z (up-down)
                plot(xi+springpic(:,2),zi+springpic(:,1),'r')
            elseif dof==3 %y (in-out)
                plot(xi,zi,'rs')
            elseif dof==4 %theta (rotation)
                plot(xi+rotspringpic(:,2),zi-rotspringpic(:,1),'r')
            end
       	end
    end
    end
end
%
%Plot the nodal coordinates, if wanted
if coordflag==1
     thndl=text(node(:,2),node(:,3),num2str([node(:,2:3)],'%7.2f,%7.2f'));
end
%
%Plot a picture of the stress distribution, if wanted
%This plot overrides all other plotting options
if stresspicflag==1
    strespic(node,elem,axesnum,1)
end
%
hold off