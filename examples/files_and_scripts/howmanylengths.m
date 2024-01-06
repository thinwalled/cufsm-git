%How many lengths...?
%example showing the influence of length on the solution
%
%
load cwlip_mx
%
close all
figure(1)
%subplot(2,1,1)
i=(1:7:length(curve(:,2)));
semilogx(curve(i,1),curve(i,2),'.-',curve(:,1),curve(:,2),':')
legend('curve with too few lengths','more exact curve')
%plot(curve(i,1),curve(i,2),'.-',curve(:,1),curve(:,2),':')
axis([0 1000 0 2])
legend('curve with too few lengths','more exact curve')
xlabel('half-wavelength (in.)')
ylabel('M_{cr}/M_{y}')


