function [P,M11,M22,B,err] = stress_to_action(node,xcg,zcg,thetap,A,I11,I22,w,Cw)
%BWS 8 December 2015, Convert stresses to actions as close as possible
%{s}=[G]{f}, {f}=pinv([G]){s}
%
%determine principal coordinates
th=thetap*pi/180;
prin_coord=inv([cos(th) -sin(th) ; sin(th) cos(th)])*[(node(:,2)-xcg)' ; (node(:,3)-zcg)'];
%
%stress
s=node(:,8);
nn=length(s);
%axial
G(:,1)=ones(nn,1)/A;
%11 bending
G(:,2)=prin_coord(2,:)'/I11;
%22 bending
G(:,3)=prin_coord(1,:)'/-I22;
%bimoment
G(:,4)=w/Cw;
%
%solution
%f=pinv(G)*s;
f=G\s
P=f(1);
M11=f(2);
M22=f(3);
B=f(4);
%
%error
err=norm(G*f-s);

end

