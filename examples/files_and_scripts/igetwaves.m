%igetwaves.m
%supplementary plot to explain half-wavelength
close all
%
L=1000;
x=(0:0.01:200)';
wL=5;
xL=(0:0.01:wL);
wD=24.8;
xD=(0:0.01:wD);
wG=200;
aL1=sin(pi*xL/wL);
aL2=sin(pi*x/wL);
aD1=sin(pi*xD/wD);
aD2=sin(pi*x/wD);
aG=sin(pi*x/wG);
subplot(3,1,1)
plot(x,aL2,':',xL,aL1) 
axis('off')
subplot(3,1,2)
plot(x,aD2,':',xD,aD1) 
axis('off')
subplot(3,1,3)
plot(x,[aG]) 
axis('off')
