%geometry play
clear all
close all
%
c=[0 0
   5 0
   5 -5];
%
p=polyfit(c(1:2,1),c(1:2,2),1);
m1=p(1);, b1=p(2);
p=polyfit(c(2:3,1),c(2:3,2),1);
m2=p(1);, b2=p(2);
%
m3=-1/2*(1/m1+1/m2);
b3=c(2,2)-m3*c(2,1);
%
m4=-1/m1;
%
%b4=3;
%
r=3;
b4=(2*b3*m1+2*m1*b3*m4^2-2*b1*m3+2*b1*m4-2*m4^3*b3-2*b3*m4-2*m4^2*b1*m3+2*m4^3*b1-2*(r^2*m1^2*m4^2+r^2*m1^2*m3^2-2*m4^5*r^2*m3+m4^4*r^2*m3^2-2*m4^5*r^2*m1+m4^6*r^2+m4^4*r^2*m1^2+m4^2*r^2*m1^2*m3^2-2*m4^3*r^2*m1^2*m3-2*m4^3*r^2*m1*m3^2+4*m4^4*r^2*m1*m3-2*r^2*m4^3*m3+r^2*m4^2*m3^2-2*r^2*m1*m4^3-2*r^2*m1^2*m4*m3-2*r^2*m1*m4*m3^2+4*r^2*m1*m4^2*m3+r^2*m4^4)^.5)/(2*(1+m4^2)*(-m3+m1))
xa=(b4-b1)/(m1-m4);
ya=m1*xa+b1;
xc=(b4-b3)/(m3-m4);
yc=m3*xc+b3;
%
m5=-1/m2;
b5=yc-m5*xc;
xb=(b5-b2)/(m2-m5);
yb=m5*xb+b5;
%
%
x=(-10:0.01:10)';
[y1]=polyval([m1 b1],x);
[y2]=polyval([m2 b2],x);
[y3]=polyval([m3 b3],x);
[y4]=polyval([m4 b4],x);
[y5]=polyval([m5 b5],x);
plot(x,[y1 y2 y3 y4 y5],c(:,1),c(:,2),'.',[xa xb xc],[ya yb yc],'ro')
axis('equal')
axis([-10 10 -10 10])


