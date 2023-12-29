function []=thecurve2(curvecell,filenamecell,filedisplay,minopt,logopt,axesnum,xmin,xmax,ymin,ymax,maxmode,picpoint)
%BWS
%August 2000
%curve [length loadfactor]
%figurenum is the figure number
%minopt is 1 for label the minima's
%logopt is 1 for make the x axis a log x axis
%maxmode is the maximum mode number to be plotted
%
axes(axesnum)
cla
%
marker=['.x+*sdv^<'];
%
for i=1:size(filedisplay,2)
	curve=curvecell{filedisplay(i)};
	mark=['b',marker(rem(filedisplay(i),10))];
    mark2=[marker(rem(filedisplay(i),10)),':'];
	%
    %
	if logopt==1
       if maxmode==1
          %hndl=semilogx(curve(:,1),curve(:,2),'k',curve(:,1),curve(:,2),'b.','MarkerSize',5);
          hndl=semilogx(curve(:,1),curve(:,2),'k',curve(:,1),curve(:,2),mark,'MarkerSize',5);
          hold on,hndlmark(i)=semilogx(curve(:,1),curve(:,2),mark,'MarkerSize',5);
       else
          templ(:,2:maxmode)=curve(:,1,2:maxmode);
          templf(:,2:maxmode)=curve(:,2,2:maxmode);
          hndl=semilogx(curve(:,1,1),curve(:,2,1),'k',curve(:,1,1),curve(:,2,1),mark,templ,templf,mark2);
          hold on,hndlmark(i)=semilogx(curve(:,1,1),curve(:,2,1),mark);
		end      
	else
       if maxmode==1
          hndl=plot(curve(:,1),curve(:,2),'k',curve(:,1),curve(:,2),mark);
          hold on,hndlmark(i)=plot(curve(:,1),curve(:,2),mark,'MarkerSize',5);
       else
          templ(:,2:maxmode)=curve(:,1,2:maxmode);
          templf(:,2:maxmode)=curve(:,2,2:maxmode);
          hndl=plot(curve(:,1,1),curve(:,2,1),'k',curve(:,1,1),curve(:,2,1),mark,templ,templf,mark2); 
          hold on,hndlmark(i)=plot(curve(:,1,1),curve(:,2,1),mark); 
       end
	end
	set(hndl,'Linewidth',1);
	axesnum=gca;
	%set(axesnum,'Color','Black','XColor','White','YColor','White');
	axis([xmin xmax ymin ymax]);
	xlabel('half-wavelength');
	ylabel('load factor');
	%title('BUCKLING CURVE');
	%
	if minopt==1
		for m=1:length(curve(:,1))-2
			load1=curve(m,2);
			load2=curve(m+1,2);
			load3=curve(m+2,2);
			if (load2<load1)&(load2<=load3)
             hold on
             hndl2=plot(curve(m+1,1),curve(m+1,2),'o');
				thndl=text(curve(m+1,1),curve(m+1,2)-(1/20*(ymax-ymin)),...
				[sprintf('%.1f',curve(m+1,1)),','...
                ,sprintf('%.2f',curve(m+1,2))]);
             %set(thndl,'Color','White');
			end
		end
	end
	
	hold on
    %%label curves with small numbers
    %for m=1:length(curve(:,1))
	%	if xmin<curve(m,1,1)&curve(m,1,1)<xmax&ymin<curve(m,2,1)&curve(m,2,1)<ymax
	%	text(curve(m,1,1),curve(m,2,1),[num2str(filedisplay(i))],'FontSize',8)
    %	end
    %end
	
	clear templ templf
end %loop on different files

hold off

%Add a legend
legend(hndlmark,filenamecell{filedisplay});


%Plot the current picked point
if isempty(picpoint) %there is a current picture point
	else
	hold on
	plot(picpoint(1),picpoint(2),'ro')
	hold off
end
