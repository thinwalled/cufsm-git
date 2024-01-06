%BWS
%June 2005
%
clear all
close all
%
Py=14.91;
Pcrl=0.37*Py;
Pcre=0.408*Py;
Pn=4.58;
%
My=1.69;
Mcrl=2.31*My;
Mcre=3.24*My;
Mn=1.69;
%
Pu=2.8;
Mu=0.59;
theta=atan2(Pu/Py,Mu/My);
b=sqrt((Pu/Py)^2+(Mu/My)^2);
by=33/17.7485*b;
bcrl=2.35*b;
bcre=2.21*b;
bn=0.53;%
%
plot(0,Py/Py,'.')
%text(0,Py/Py,'P_y/P_y')
hold on
plot(0,Pcrl/Py,'.')
text(0,Pcrl/Py,'P_{crl}/P_y')
plot(0,Pcre/Py,'.')
text(0,Pcre/Py,'P_{cre}/P_y')
plot(0,Pn/Py,'.')
text(0,Pn/Py,'P_{n}/P_y')
plot(0,0.8*Pn/Py,'.')
text(0,0.8*Pn/Py,'\phiP_{n}/P_y')
%
plot(My/My,0,'.')
%text(My/My,0,'M_y/M_y')
plot(Mcrl/My,0,'.')
text(Mcrl/My,0,'M_{crl}/M_y')
plot(Mcre/My,0,'.')
text(Mcre/My,0,'M_{cre}/M_y')
plot(Mn/My,0,'.')
text(Mn/My,0,'M_{n}/M_y')
plot(0.8*Mn/My,0,'.')
text(0.8*Mn/My,0,'\phiM_{n}/M_y')
%
h2=plot(Mu/My,Pu/Py,'ro');
h1=plot([0 0.8*Mn/My],[0.8*Pn/Py 0],'-')
h3=plot([0 1],[1 0],':')
legend([h3,h1,h2],'yield','interaction diagram \phi=0.8','demand')
%
c=cos(theta);
s=sin(theta);
%plot(b*c,b*s,'.')
plot(bcrl*c,bcrl*s,'.')
text(bcrl*c,bcrl*s,'\beta_{crl}')
plot(bcre*c,bcre*s,'.')
text(bcre*c,bcre*s,'\beta_{cre}')
plot(by*c,by*s,'.')
text(by*c,by*s,'\beta_{y}')
plot(bn*c,bn*s,'.')
text(bn*c,bn*s,'\beta_{n}')
plot(0.8*bn*c,0.8*bn*s,'.')
text(0.8*bn*c,0.8*bn*s,'\phi\beta_{n}')
%
%axis('equal')
axis([0 1 0 1])
xlabel('M/M_y (weak axis)')
ylabel('P/P_y')
%
hold off
