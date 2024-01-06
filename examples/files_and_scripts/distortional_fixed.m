%June 6 2005
% Digitization of Figure 3.10 in Hancock Murray Ellifritt
%
clear all
close all
%
data=[
    1	1.606060606
2	1.212121212
3	1.151515152
4	1.106060606
5	1.060606061];
h1=plot(data(:,1),data(:,2),'o')
xlabel('number of distortional half-waves along the length (\lambda)')
ylabel('boost from fixed ends: (P_{crd} FIX)/(P_{crd} PIN)')
%
xfit=1:0.1:5;
yfit=1+.6./xfit.^1.5;
%
hold on
h2=plot(xfit,yfit,':')
hold off
%
legend([h1 h2],'data from Fig. 3.10 Hancock et al.','simplified curve fit')
%
text(1.5,1.3,'(P_{crd} FIX)/(P_{crd} PIN) = 1 + 0.6/\lambda^{1.5}')