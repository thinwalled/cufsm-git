clear all
close all

load temp
%developing figure
P=0.5
Py=1
M11=0.25
M11y=1
M22=0.75
M22y=1
firstyieldflag=1
fy=50;
inc=1;

if firstyieldflag
    %Generate First Yield surface
    %degree increment for generating first yield surfaces
    %inc=1; %degree
    %let's create a first yield surface for M11-M22 space
    thetaMM=[0:inc:360]';
    phiPM=0*thetaMM+90;
    [betay,PMMymm] = firstyield(node,elem,fy,thetaMM,phiPM);
    %let's create a first yield surface for P-M11 space
    phiPM=[0:inc:360]';
    thetaMM=0*phiPM;
    [betay,PMMypm1] = firstyield(node,elem,fy,thetaMM,phiPM);
    %let's create a first yield surface for P-M22 space
    phiPM=[0:inc:360]';
    thetaMM=0*phiPM+90;
    [betay,PMMypm2] = firstyield(node,elem,fy,thetaMM,phiPM);
end

%M11-M22
subplot(2,2,2)
plot([0 M11/M11y],[0 M22/M22y],'b--',[M11/M11y],[M22/M22y],'b.','MarkerSize',14)
if firstyieldflag
    hold on
    plot(PMMymm(:,2),PMMymm(:,3),'r-')
end
xlabel('M_{11}/M_{11y}')
ylabel('M_{22}/M_{22y}')
xrange=xlim;
xrange=[min([-1,xrange(1)]),max([1,xrange(2)])];
yrange=ylim;
yrange=[min([-1,yrange(1)]),max([1,yrange(2)])];
axis([xrange yrange])
hold on,plot(xrange,[0 0],'k-',[0 0],yrange,'k-','LineWidth',0.1)

%P-M11
subplot(2,2,3)
plot([0 M11/M11y],[0 P/Py],'b--',[M11/M11y],[P/Py],'b.','MarkerSize',14)
if firstyieldflag
    hold on
    plot(PMMypm1(:,2),PMMypm1(:,1),'r-')
end
xlabel('M_{11}/M_{11y}')
ylabel('P/P_y')
xrange=xlim;
xrange=[min([-1,xrange(1)]),max([1,xrange(2)])];
yrange=ylim;
yrange=[min([-1,yrange(1)]),max([1,yrange(2)])];
axis([xrange yrange])
hold on,plot(xrange,[0 0],'k-',[0 0],yrange,'k-','LineWidth',0.1)

%P-M22
subplot(2,2,4)
plot([0 M22/M22y],[0 P/Py],'b--',[M22/M22y],[P/Py],'b.','MarkerSize',14)
if firstyieldflag
    hold on
    plot(PMMypm2(:,3),PMMypm2(:,1),'r-')
end
xlabel('M_{22}/M_{22y}')
ylabel('P/P_y')
xrange=xlim;
xrange=[min([-1,xrange(1)]),max([1,xrange(2)])];
yrange=ylim;
yrange=[min([-1,yrange(1)]),max([1,yrange(2)])];
axis([xrange yrange])
hold on,plot(xrange,[0 0],'k-',[0 0],yrange,'k-','LineWidth',0.1)


