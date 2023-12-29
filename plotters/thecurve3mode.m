function []=thecurve3mode(curvecell,filenamecell,clascell,filedisplay,minopt,logopt,clasopt,axesnum,xmin,xmax,ymin,ymax,fileindex,lengthindex,picpoint)
%BWS
%August 2000
%modified May 2004 to accomodate modal classification plotting as well
%curve [length loadfactor]
%figurenum is the figure number
%minopt is 1 for label the minima's
%logopt is 1 for make the x axis a log x axis
%maxmode is the maximum mode number to be plotted
%

axes(axesnum)
cla
%
marker=['.x+*sdv^<>'];
%

% hold off

%If the classification option is on, then start with modal classification
if clasopt
    clas=clascell{fileindex};
    if ~isempty(clas)
        curve=curvecell{fileindex};
        for i=1:length(curve{lengthindex}(:,2))
            clasplot(i,:)=clas{lengthindex}(i,:)*curve{lengthindex}(i,2)/100;
        end
%         if logopt
%             set(gca,'XScale','log')
%         else
            set(gca,'XScale','linear')
%         end
        hold on
        hc=bar([1:length(curve{lengthindex}(:,2))],clasplot,1,'stacked');
        hlegend=legend(hc,'global','distortional','local','other');
        set(hlegend,'Location','best');
%         axis tight
        colormap lines(4)%jet
        axis([xmin xmax ymin ymax])
    end
end
%
filenumbers=1;
for i=1:size(filedisplay,2)
    curve=curvecell{filedisplay(i)};    
    mark=['b',marker(rem(filenumbers,10))];
%     if logopt==1
%         %hndl=semilogx(curve(:,1),curve(:,2),'k',curve(:,1),curve(:,2),'b.','MarkerSize',5);
%         hndl=semilogx([1:length(curve{lengthindex}(:,2))],curve{lengthindex}(:,2),'k',[1:length(curve{lengthindex}(:,2))],curve{lengthindex}(:,2),mark,'MarkerSize',5);
%         hold on,hndlmark(filenumbers)=semilogx([1:length(curve{lengthindex}(:,2))],curve{lengthindex}(:,2),mark,'MarkerSize',5);
%     else
        hndl=plot([1:length(curve{lengthindex}(:,2))],curve{lengthindex}(:,2),'k',[1:length(curve{lengthindex}(:,2))],curve{lengthindex}(:,2),mark);
        hold on,hndlmark(filenumbers)=plot([1:length(curve{lengthindex}(:,2))],curve{lengthindex}(:,2),mark,'MarkerSize',5);
%     end
    legendname{filenumbers}=[filenamecell{i},', at length = ',num2str(curve{lengthindex}(1,1))];
    
    filenumbers=filenumbers+1;
    set(hndl,'Linewidth',1);
    % 	axesnum=gca;
    %set(axesnum,'Color','Black','XColor','White','YColor','White');
    axis([xmin xmax ymin ymax]);
    % 	xlabel('half-wavelength');
    xlabel('mode number');
    ylabel('load factor');
    %title('BUCKLING CURVE');
    %
    if minopt==1
    end
    
    hold on

end %loop on different files

hold off

%Add a legend
if clasopt
    %   	legend(hc,'global','distortional','local','other')
else
    h=legend(hndlmark,legendname{[1:filenumbers-1]});
    set(h,'Location','best');
    %don't use latex in the legend so underscores are written ok
    releasestring=version('-release');
    release=str2num(releasestring);
    if release>13
        set(h,'Interpreter','none')
    end
end


%Plot the current picked point
if isempty(picpoint) %there is a current picture point
else
    hold on
    plot(picpoint(1),picpoint(2),'r.','MarkerSize',20)
    hold off
end

