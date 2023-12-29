function []=crossect(node,elem,axesnum,springs,constraints,flags)
%BWS
%October 2001 (last modified)
%December 2015 springs updated
%December 2015 origin updated to also show axes
%December 2015 added stress distribution into this plot instead of separate
%December 2015 added an additional flag for section property axes
%plots the cross-section
%
%node: [node# x z dofx dofz dofy dofrot stress] nnodes x 8;
%elem: [elem# nodei nodej t mat#] nelems x 4;
%flags:[node# element# mat# stress# stresspic coord constraints springs origin propaxis] 1 means show
nodeflag=flags(1);
elemflag=flags(2);
matflag=flags(3);
stressflag=flags(4);
stresspicflag=flags(5);
coordflag=flags(6); 
constraintsflag=flags(7);
springsflag=flags(8);
originflag=flags(9);
if length(flags)>9 %new since 2015
    propaxisflag=flags(10);
else
    propaxisflag=0;
end
%
%
axes(axesnum)
cla
%
%preparation for stress distribution plotting
if stresspicflag==1
    scale=1;
    maxstress=max(abs(node(:,8)));
    stress=[node(:,1) node(:,8)/maxstress];
    maxoffset=scale*1/10*max(max(abs(node(:,2:3))));
    for i=1:length(stress(:,1))
       stresscoord(i,1:3)=[node(i,1) node(i,2)+maxoffset*stress(i,2)...
             node(i,3)-maxoffset*stress(i,2)];
    end
end%
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
       patch(xpatch,zpatch,'y','FaceAlpha',0.5)
       hold on
       plot([xi xj],[zi zj],'b.','MarkerSize',12);
    %plot( ([xi xj]+[-1 -1]*sin(theta)*t/2),[zi zj]+[1 1]*cos(theta)*t/2 , 'k')
    %plot( ([xi xj]+[1 1]*sin(theta)*t/2),[zi zj]+[-1 -1]*cos(theta)*t/2 , 'k')
    %plot( ([xi xi]+[-1 1]*sin(theta)*t/2),[zi zi]+[1 -1]*cos(theta)*t/2 , 'k')
    %plot( ([xj xj]+[-1 1]*sin(theta)*t/2),[zj zj]+[1 -1]*cos(theta)*t/2 , 'k')
    %
    if stresspicflag==1
        %get the stresses
        sxi = stresscoord(find(node(:,1)==nodei),2);
        szi = stresscoord(find(node(:,1)==nodei),3);
        sxj = stresscoord(find(node(:,1)==nodej),2);
        szj = stresscoord(find(node(:,1)==nodej),3);
        %plot the stresses in pseudo 3D
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
        if stressflag==1 
            thndl=text(sxi,szi,num2str(node(find(node(:,1)==nodei),8)));
            thndl=text(sxj,szj,num2str(node(find(node(:,1)==nodej),8)));            
        end
    end
    %
    %plot the element labels if wanted
    if elemflag==1
        thndl=text((xi+xj)/2,(zi+zj)/2,num2str(elem(i,1)));
    end
    %plot the material labels if wanted
    if matflag==1
        thndl=text((xi+xj)/2,(zi+zj)/2,num2str(elem(i,5)));
    end
    %plot the stress distribution in pseduo3D if wanted
    
end
%
%Plot the node labels if wanted
if nodeflag==1
    thndl=text(node(:,2),node(:,3),num2str(node(:,1)));
end
%
%Plot the stress at the nodes if wanted
if stressflag==1 && stresspicflag~=1
    thndl=text(node(:,2),node(:,3),num2str(node(:,8)));
end
%
%Plot the origin point (and basic x, z axes), if wanted
if originflag==1
    plot(0,0,'ko','MarkerSize',12)
    xmax=max(node(:,2));
    zmax=max(node(:,3));
    ax_len=min(xmax,zmax);
    plot([0 0.2*ax_len],[0 0],'k-'),text(.22*ax_len,0,'x_o','FontSize',12,'Color','k');
    plot([0 0],[0 0.2*ax_len],'k-'),text(0,.22*ax_len,'z_o','FontSize',12,'Color','k');    
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
            if springs(i,3)==0 %spring to ground
                %dof = springs(i,2);
                ku=springs(i,4);
                kv=springs(i,5);
                kw=springs(i,6);
                kq=springs(i,7);
                xi = node(find(node(:,1)==springs(i,2)),2);
                zi = node(find(node(:,1)==springs(i,2)),3);
                if ku~=0 %x direction spring (left-right)
                    plot(xi+springpic(:,1),zi+springpic(:,2),'r')
                end
                if kw~=0 %z (up-down)
                    plot(xi+springpic(:,2),zi+springpic(:,1),'r')
                end
                if kv~=0 %y (in-out)
                    plot(xi,zi,'rs')
                end
                if kq~=0 %theta (rotation)
                    plot(xi+rotspringpic(:,2),zi-rotspringpic(:,1),'r')
                end
            else
                xi = node(find(node(:,1)==springs(i,2)),2);
                zi = node(find(node(:,1)==springs(i,2)),3);
                xj = node(find(node(:,1)==springs(i,3)),2);
                zj = node(find(node(:,1)==springs(i,3)),3);
                if springs(i,9)==1 %discrete spring used dashed line
                    plot(xi,zi,'pg',xj,zj,'pg',[xi xj],[zi zj],'g:')
                else
                    plot(xi,zi,'pg',xj,zj,'pg',[xi xj],[zi zj],'g-')
                end
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
%if stresspicflag==1
%    strespic(node,elem,axesnum,1)
%end


if propaxisflag==1
    %get the properties
    [A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,J,Xs,Ys,Cw,B1,B2,w] = cutwp_prop2(node(:,2:3),elem(:,2:4));
    thetap=thetap*180/pi; %degrees...
    %plot the centroid
    plot(xcg,zcg,'g.')
    text(xcg,zcg,' C')
    %
    %Plot the Global XX and ZZ Axes
    XX=[min(node(:,2))-0.03*(max(node(:,2))-min(node(:,2))) , zcg
        max(node(:,2))+0.03*(max(node(:,2))-min(node(:,2))) , zcg];
    ZZ=[xcg , min(node(:,3)-0.03*(max(node(:,3))-min(node(:,3))))
        xcg , max(node(:,3)+0.03*(max(node(:,3))-min(node(:,3))))];
    plot(XX(:,1),XX(:,2),'g:')
    plot(ZZ(:,1),ZZ(:,2),'g:')
    text(XX(1,1),XX(1,2),'x_c')
    text(XX(2,1),XX(2,2),'x_c')
    text(ZZ(1,1),ZZ(1,2),'z_c')
    text(ZZ(2,1),ZZ(2,2),'z_c')
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
end
%
hold off