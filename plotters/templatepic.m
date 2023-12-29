function []=templatepic(node,elem,axesnum,geom,h,b1,d1,q1,b2,d2,q2,r1,r2,r3,r4,t,cz,center)
%BWS
%August 2000
%node: [node# x z dofx dofz dofy dofrot stress] nnodes x 8;
%elem: [elem# nodei nodej t] nelems x 4;
%2015 addition to handle d1=d2=0 track-like cases
%2015 handle outer as well as out to out as inputs
%2015 templatepic was re-written so that it could be an overlay on
%crosssect, this is a bit weird, but essentially hold is on and dimensions
%are added on top of the usual crosssection plot.
%
%if center is not 1 then outer dimensions and inner radii came in and these
%need to be corrected to all centerline for the use of this template
if center==1
else%then we came in with outer
    %label all the outer dimensions and inner radii
    H=h;
    B1=b1;
    D1=d1;
    ri1=r1;
    ri2=r2;
    B2=b2;
    D2=d2;
    ri3=r3;
    ri4=r4;
    %convert angles to radians
    q1=q1*pi/180;
    q2=q2*pi/180;
    [h,b1,d1,q1,b2,d2,q2,r1,r2,r3,r4,t] = template_out_to_in(H,B1,D1,q1,B2,D2,q2,ri1,ri2,ri3,ri4,t);
end
%
%
axes(axesnum)
%cla
hold on
%the plot
%nodes
plot(node(:,2),node(:,3),'b.')
hold on
axis('equal')
axis('off')
%elements
%Don't need to do this anymore
    % for i=1:length(elem(:,1))
    % 	nodei = elem(i,2);
    %    nodej = elem(i,3);
    % 	   xi = node(nodei,2);
    % 	   zi = node(nodei,3);
    % 	   xj = node(nodej,2);
    % 	   zj = node(nodej,3);
    % 	plot([xi xj],[zi zj],'k')
    % end
%plot dimension labels
xgeom=geom(:,2);
zgeom=geom(:,3);
if r1==0&r2==0&r3==0&r4==0
    if d1==0&d2==0
        text((xgeom(1)+xgeom(2))/2,(zgeom(1)+zgeom(2))/2,['b_1=',num2str(b1)],'FontSize',12)
        text((xgeom(2)+xgeom(3))/2,(zgeom(2)+zgeom(3))/2,['h=',num2str(h)],'FontSize',12)
        text((xgeom(3)+xgeom(4))/2,(zgeom(3)+zgeom(4))/2,['b_2=',num2str(b2)],'FontSize',12)
        plot(r1+b1,r2,'g.')
        plot(r1,r1,'g.')
        plot(cz*r3,(r1+h),'g.')
        plot(cz*(r3+b2),(r1+h+r3-r4),'g.')
    else
        text((xgeom(1)+xgeom(2))/2,(zgeom(1)+zgeom(2))/2,['d_1=',num2str(d1)],'FontSize',12)
        text((xgeom(2)+xgeom(3))/2,(zgeom(2)+zgeom(3))/2,['b_1=',num2str(b1)],'FontSize',12)
        text((xgeom(3)+xgeom(4))/2,(zgeom(3)+zgeom(4))/2,['h=',num2str(h)],'FontSize',12)
        text((xgeom(4)+xgeom(5))/2,(zgeom(4)+zgeom(5))/2,['b_1=',num2str(b2)],'FontSize',12)
        text((xgeom(5)+xgeom(6))/2,(zgeom(5)+zgeom(6))/2,['d_2=',num2str(d2)],'FontSize',12)
        text(r1+b1,r2,'\theta_1','FontSize',12)
        text(cz*(r3+b2),(r1+h+r3-r4),'\theta_2','FontSize',12)
        plot(r1+b1,r2,'g.')
        plot(r1,r1,'g.')
        plot(cz*r3,(r1+h),'g.')
        plot(cz*(r3+b2),(r1+h+r3-r4),'g.')
    end
else
    if d1==0&d2==0
        text((xgeom(1)+xgeom(2))/2,(zgeom(1)+zgeom(2))/2,['b_1=',num2str(b1)],'FontSize',12)
        text((xgeom(3)+xgeom(4))/2,(zgeom(3)+zgeom(4))/2,['h=',num2str(h)],'FontSize',12)
        text((xgeom(5)+xgeom(6))/2,(zgeom(5)+zgeom(6))/2,['b_2=',num2str(b2)],'FontSize',12)
        text(r1,r1,'r_1','FontSize',12)
        text(cz*r3,(r1+h),'r_3','FontSize',12)
        plot(r1+b1,r2,'g.')
        plot(r1,r1,'g.')
        plot(cz*r3,(r1+h),'g.')
        plot(cz*(r3+b2),(r1+h+r3-r4),'g.')
        plot([xgeom(2) r1 xgeom(3)],[zgeom(2) r1 zgeom(3)],'g:')
        plot([xgeom(4) cz*r3 xgeom(5)],[zgeom(4) r1+h zgeom(5)],'g:')
    else
        text((xgeom(1)+xgeom(2))/2+t,(zgeom(1)+zgeom(2))/2,['d_1=',num2str(d1)],'FontSize',12)
        text((xgeom(3)+xgeom(4))/2,(zgeom(3)+zgeom(4))/2+t,['b_1=',num2str(b1)],'FontSize',12)
        text((xgeom(5)+xgeom(6))/2+t,(zgeom(5)+zgeom(6))/2,['h=',num2str(h)],'FontSize',12)
        text((xgeom(7)+xgeom(8))/2,(zgeom(7)+zgeom(8))/2+t,['b_2=',num2str(b2)],'FontSize',12)
        text((xgeom(9)+xgeom(10))/2+t,(zgeom(9)+zgeom(10))/2,['d_2=',num2str(d2)],'FontSize',12)
        text(r1+b1,r2,'r_2,\theta_1','FontSize',12)
        text(r1,r1,'r_1','FontSize',12)
        text(cz*r3,(r1+h),'r_3','FontSize',12)
        text(cz*(r3+b2),(r1+h+r3-r4),'r_4,\theta_2','FontSize',12)
        plot(r1+b1,r2,'g.')
        plot(r1,r1,'g.')
        plot(cz*r3,(r1+h),'g.')
        plot(cz*(r3+b2),(r1+h+r3-r4),'g.')
        plot([xgeom(2) r1+b1 xgeom(3)],[zgeom(2) r2 zgeom(3)],'g:')
        plot([xgeom(4) r1 xgeom(5)],[zgeom(4) r1 zgeom(5)],'g:')
        plot([xgeom(6) cz*r3 xgeom(7)],[zgeom(6) r1+h zgeom(7)],'g:')
        plot([xgeom(8) cz*(r3+b2) xgeom(9)],[zgeom(8) r1+h+r3-r4 zgeom(9)],'g:')
    end
end
hold off
