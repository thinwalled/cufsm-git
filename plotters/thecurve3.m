function []=thecurve3(curvecell,filenamecell,clascell,filedisplay,minopt,logopt,clasopt,axesnum,xmin,xmax,ymin,ymax,modedisplay,fileindex,modeindex,picpoint)
%BWS
%August 2000
%modified May 2004 to accomodate modal classification plotting as well
% modified by Z. Li 2010
%curve [length loadfactor]
%figurenum is the figure number
%minopt is 1 for label the minima's
%logopt is 1 for make the x axis a log x axis
%maxmode is the maximum mode number to be plotted
%modedisplay
axes(axesnum)
cla
%
% global curve_length clasplot
marker=['.x+*sdv^<'];
%
%fileindex=1;
%modeindex=1;
%If the classification option is on, then start with modal classification
if clasopt
    clas=clascell{fileindex};
%     solutiontype=solutiontypecell{fileindex};
%     if solutiontype==1
        if ~isempty(clas)
            curve=curvecell{fileindex};
            for i=1:max(size(curve));
                curve_length(i,1)=curve{i}(modeindex,1);
                clasplot(i,:)=clas{i}(modeindex,:)*curve{i}(modeindex,2)/100;
            end
            if logopt
                set(gca,'XScale','log')
            else
                set(gca,'XScale','linear')
            end
            hold on
            if length(curve_length)>=2
                hc=area(curve_length,clasplot);
                legend(hc,'global','distortional','local','other','Location','best')
            else
                if logopt==1
                    semilogx(curve_length,clasplot(1),'c.','MarkerSize',20);...
                    semilogx(curve_length,clasplot(2),'r.','MarkerSize',20);
                    semilogx(curve_length,clasplot(3),'m.','MarkerSize',20);
                    semilogx(curve_length,clasplot(4),'b.','MarkerSize',20);
                else
                    plot(curve_length,clasplot(1),'c.','MarkerSize',20);
                    plot(curve_length,clasplot(2),'r.','MarkerSize',20);
                    plot(curve_length,clasplot(3),'m.','MarkerSize',20);
                    plot(curve_length,clasplot(4),'b.','MarkerSize',20);
                end
                legend('global','distortional','local','other','Location','best')
            end
            
            axis([xmin xmax ymin ymax])
            axis tight
            colormap lines(4)%jet
        end
%     end
end
%
for i=1:length(filedisplay)
    curve=[];
    curve=curvecell{filedisplay(i)};
    %     solutiontype=solutiontypecell{filedisplay(i)};
    
    mark=['b',marker(rem(filedisplay(i),10))];
    mark2=[marker(rem(filedisplay(i),10)),':'];
        
    for j=1:max(size(curve));
        curve_sign(j,1)=curve{j}(modedisplay(1),1);
        curve_sign(j,2)=curve{j}(modedisplay(1),2);
        if length(modedisplay)>1
            for mn=2:length(modedisplay)
                templ(j,modedisplay(mn))=curve{j}(modedisplay(mn),1);
                templf(j,modedisplay(mn))=curve{j}(modedisplay(mn),2);
            end
        end
    end
    %

    if logopt==1
        hndlmark(i)=semilogx(curve_sign(:,1),curve_sign(:,2),mark,'MarkerSize',5);hold on
        hndl=semilogx(curve_sign(:,1),curve_sign(:,2),'k',curve_sign(:,1),curve_sign(:,2),mark,'MarkerSize',5);hold on
        if length(modedisplay)>1
            hndlmark(i)=semilogx(curve_sign(:,1),curve_sign(:,2),mark);hold on
            hnd2=semilogx(curve_sign(:,1),curve_sign(:,2),'k',curve_sign(:,1),curve_sign(:,2),mark,templ,templf,mark2);hold on
        end
    else
        hndlmark(i)=plot(curve_sign(:,1),curve_sign(:,2),mark,'MarkerSize',5);hold on
        hndl=plot(curve_sign(:,1),curve_sign(:,2),'k',curve_sign(:,1),curve_sign(:,2),mark);hold on
        if length(modedisplay)>1
            hndlmark(i)=plot(curve_sign(:,1),curve_sign(:,2),mark);hold on
            hnd2=plot(curve_sign(:,1),curve_sign(:,2),'k',curve_sign(:,1),curve_sign(:,2),mark,templ,templf,mark2);hold on
        end
    end


    hold on
    cr=0;
    if minopt==1
        for m=1:length(curve_sign(:,1))-2
            load1=curve_sign(m,2);
            load2=curve_sign(m+1,2);
            load3=curve_sign(m+2,2);
            if (load2<load1)&(load2<=load3)
                cr=cr+1;
                hold on
                hndl2(cr)=plot(curve_sign(m+1,1),curve_sign(m+1,2),'o');
                thndl=text(curve_sign(m+1,1),curve_sign(m+1,2)-(1/20*(ymax-ymin)),...
                    [sprintf('%.1f',curve_sign(m+1,1)),','...
                    ,sprintf('%.2f',curve_sign(m+1,2))]);
                %set(thndl,'Color','White');
            end
        end
    end
    
    %set the callback of curve
    set(hndl,'ButtonDownFcn',[...
        'compareout_cb(26);'])
    if length(modedisplay)>1
        set(hnd2,'ButtonDownFcn',[...
            'compareout_cb(26);'])
    end
    if minopt==1
        if exist('hndl2')==1
            for i=1:cr
                set(hndl2(i),'ButtonDownFcn',[...
                    'compareout_cb(26);'])
            end
        end
    end
    hold on    
    set(hndl,'Linewidth',1);
    if length(modedisplay)>1
        set(hnd2,'Linewidth',1);
    end
%     elseif solutiontype==2
%         for j=1:max(size(curve));
%             for jm=1:length(curve{j}(:,2))
%                 if logopt==1
%                     hndlmark(i)=semilogx(curve{j}(jm,1),curve{j}(jm,2),mark,'MarkerSize',5);hold on
%                 else
%                     hndlmark(i)=plot(curve{j}(jm,1),curve{j}(jm,2),mark,'MarkerSize',5);hold on
%                 end
%             end
%         end
%     end
        % 	axesnum=gca;
    %set(axesnum,'Color','Black','XColor','White','YColor','White');
    axis([xmin xmax ymin ymax]);
    xlabel('length');
    ylabel('load factor');
    %title('BUCKLING CURVE');
    %
    
    %%label curves with small numbers
    %for m=1:length(curve(:,1))
    %	if xmin<curve(m,1,1)&curve(m,1,1)<xmax&ymin<curve(m,2,1)&curve(m,2,1)<ymax
    %	text(curve(m,1,1),curve(m,2,1),[num2str(filedisplay(i))],'FontSize',8)
    %	end
    %end
    
    clear templ templf curve_sign
end %loop on different files

hold off

%Add a legend
if clasopt
%     solutiontype=solutiontypecell{fileindex};
%     if solutiontype==2
%        h=legend(hndlmark,filenamecell{filedisplay});
%     end
    %   	legend(hc,'global','distortional','local','other')
else
    h=legend(hndlmark,filenamecell{filedisplay},'Location','best');
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

